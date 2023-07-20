<?php

return [
    'hosts' => [
        [
            'host'            => env('ELASTICSEARCH_HOST', 'localhost'),
            'port'            => env('ELASTICSEARCH_PORT', 9200),
            'scheme'          => env('ELASTICSEARCH_SCHEME', 'http'),
            'user'            => env('ELASTICSEARCH_USER', null),
            'pass'            => env('ELASTICSEARCH_PASS', null),
        ]
    ]
];
