<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Product;
use Elasticsearch\ClientBuilder;
use Illuminate\Support\Facades\Log;

class ProductController extends Controller
{
    private $elasticsearch;

    public function __construct()
    {
        $this->elasticsearch = ClientBuilder::create()
            ->setHosts([env('ELASTICSEARCH_URI')])
            ->setBasicAuthentication(env('ELASTICSEARCH_USER'), env('ELASTICSEARCH_PASS'))
//            ->setSSLCert(env('ELASTICSEARCH_SSL_CERT'))
            ->build();
    }

    public function search(Request $request)
    {
        $query = $request->query('q');
        $products = [];

        // Added code to avoid error when no query is passed
        $products_count = Product::count();
        if ($products_count == 0) {
            return response()->json($products);
        }

        try {
            $params = [
                'index' => 'product',
                'type'  => 'create',
                'body'  => [
                    'query' => [
                        'query_string' => [
                            'query' => '*' . $query . '*',
                            "fields" => ["name", "description"]
                        ]
                    ]
                ]
            ];

            $results = $this->elasticsearch->search($params);

            foreach ($results['hits']['hits'] as $product) {
                $products[] = $product['_source'];
            }
        } catch (\Exception $e) {
            Log::error($e);
            dd($e);
            abort(500);
        }

        return response()->json($products);
    }

    public function create(Request $request)
    {
        $input = $request->validate([
            'name' => 'required|string|min:1|max:255',
            'description' => 'required|string|min:1',
            'image' => 'required|string|url',
        ]);

        try {
            $product = Product::create($input);

            $params = [
                'index' => 'product',
                'type'  => 'create',
                'id'    => $product->id,
                'body'  => [
                    'id' => $product->id, // TODO: to remove this field, it's only for testing
                    'name' => $product->name,
                    'description' => $product->description,
                    'image' => $product->image,
                ],
            ];

            $this->elasticsearch->index($params);
        } catch (\Exception $e) {
            Log::error("Cannot create product");
            Log::error($e);
            abort(500);
        }

        // RabbitMQ - publish message
        \Amqp::publish(
            'product.event',
            json_encode(
                [
                    'event_type' => 'create',
                    'product' => $product->toArray(),
                ]
            ),
            [
                'queue' => env('RABBITMQ_QUEUE'),
                'exchange_type' => env('RABBITMQ_EXCHANGE_TYPE'),
                'exchange' => env('RABBITMQ_EXCHANGE_NAME'),
                'exchange_durable' => env('RABBITMQ_QUEUE_DURABLE'),
                'routing' => env('RABBITMQ_ROUTING_KEY'),
            ]
        );

        return response()->json(['status' => 'ok', 'product' => $product]);
    }

    public function delete(Request $request, $id)
    {
        try {
            $product = Product::findOrFail($id);
            $product->delete();

            $params = [
                'index' => 'product',
                'id'    => $id,
            ];

            $this->elasticsearch->delete($params);
        } catch (\Exception $e) {
            Log::error("Cannot delete product");
            Log::error($e);
            abort(500);
        }

        // TODO : to fix this code
//        $amqpChannel = $this->rabbitmqConnection->channel();
//        $amqpChannel->exchange_declare(
//            'product.event', 'direct', false, false, false
//        );
//
//        $amqpBody = [
//            'event_type' => 'delete',
//            'product_id' => $id,
//        ];
//        $message = new AMQPMessage(json_encode($amqpBody));
//
//        $amqpChannel->basic_publish($message, 'product.event', 'routing-key');
//        $amqpChannel->close();
//        $this->rabbitmqConnection->close();

        return response()->json('ok');
    }
}
