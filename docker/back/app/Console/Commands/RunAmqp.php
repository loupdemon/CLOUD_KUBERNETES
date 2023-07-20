<?php

namespace App\Console\Commands;

use App\Exceptions\InvalidAMQPMessageException;
use App\Jobs\IngestDataJob;
use Bschmitt\Amqp\Amqp;
use Bschmitt\Amqp\Consumer;
use Exception;
use Illuminate\Foundation\Bus\DispatchesJobs;
use PhpAmqpLib\Message\AMQPMessage;
use Psr\Log\LoggerInterface;
use Illuminate\Console\Command;

class RunAmqp extends Command
{
    use DispatchesJobs;

    protected $signature = 'healthplace:rabbitmq:consume';

    protected $description = 'Runs a AMQP consumer that defers work to the Laravel queue worker';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return mixed
     */
    public function handle(Amqp $consumer, LoggerInterface $logger)
    {
        $logger->info('Listening for messages...');

        $consumer->consume(
            env('RABBITMQ_QUEUE'),
            function (AMQPMessage $message, Consumer $resolver) use ($logger): void {
                $logger->info('Consuming message...');
                try {
                    $payload = json_decode($message->getBody(), true, 512);
                    $this->validateMessage($payload);
                    $logger->info('Message received', $payload);
                    $this->dispatch(new IngestDataJob($payload['message']));
                    $logger->info('Message handled.');
                    $resolver->acknowledge($message);
                } catch (InvalidAMQPMessageException $exception) {
                    $logger->error('Message failed validation.');
                    $resolver->reject($message);
                } catch (Exception $exception) {
                    $logger->error('Message is not valid JSON.');
                    $resolver->reject($message);
                }
            },
            [
                'routing' => ['ingest.pending'],
                'timeout' => 5,
                'vhost' => '/',
                'exchange' => env('RABBITMQ_EXCHANGE_NAME'),
                'exchange_type' => env('RABBITMQ_EXCHANGE_TYPE'),
            ]
        );

        $logger->info('Consumer exited.');

        return true;
    }

    private function validateMessage(array $payload): void
    {
        if (!is_string($payload['filepath'] ?? null)) {
            throw new InvalidAMQPMessageException('The [filepath] property must be a string.');
        }
    }
}
