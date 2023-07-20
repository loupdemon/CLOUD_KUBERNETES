<?php

return [

    'use' => 'production',

    'properties' => [

        'production' => [
            'host'                => env('RABBITMQ_HOST', 'localhost'),
            'port'                => env('RABBITMQ_PORT', 5672),
            'username'            => env('RABBITMQ_DEFAULT_USER', 'guest'),
            'password'            => env('RABBITMQ_DEFAULT_PASS', 'guest'),
            'vhost'               => env('RABBITMQ_DEFAULT_VHOST', '/'),
            'exchange'            => env('RABBITMQ_EXCHANGE_NAME', 'default'),
            'duration'            => env('RABBITMQ_EXCHANGE_DURABLE', false),
            'exchange_type'       => env('RABBITMQ_EXCHANGE_TYPE', 'topic'),
            'consumer_tag'        => env('RABBITMQ_CONSUMER_TAG', 'consumer'),
            'ssl_options'         => [], // See https://secure.php.net/manual/en/context.ssl.php
            'connect_options'     => [], // See https://github.com/php-amqplib/php-amqplib/blob/master/PhpAmqpLib/Connection/AMQPSSLConnection.php
            'queue_properties'    => ['x-ha-policy' => ['S', 'all']],
            'exchange_properties' => [],
            'timeout'             => env('RABBITMQ_TIMEOUT', 60)
        ],

    ],

];
