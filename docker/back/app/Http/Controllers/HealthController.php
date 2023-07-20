<?php

namespace App\Http\Controllers;

use App\Jobs\JobClass;
use App\Jobs\ProductJob;
use DB;
use Log;
use Illuminate\Http\Request;
use App\Models\Product;
//use Elasticsearch;
 use Elasticsearch\ClientBuilder;
 use Cviebrock\LaravelElasticsearch\Facade as Elasticsearch;

use Amqp;

class HealthController extends Controller
{
     /** @var \Elasticsearch\Client */
     private $elasticsearch;

     public function __construct(\Elasticsearch\Client $elasticsearch)
     {
         $this->elasticsearch = $elasticsearch;
     }

    public function index() {
        $output = [
            'hostname' => gethostname(),
        ];

        $date_begin = microtime(true);

        // mysql
        try {
            DB::connection()->getPdo();
            $output['mysql'] = 'healthy';

            try {
                $output['products'] = Product::all()->count();
                $output['mysql_migrations'] = 'healthy';
            } catch (\Exception $e) {
                Log::error("Failed to fetch products");
                Log::error($e);
                $output['mysql_migrations'] = 'unhealthy';
            }
        } catch (\Exception $e) {
            Log::error("Failed to connect to database");
            Log::error($e);
            $output['mysql'] = 'unhealthy : ' . $e->getMessage();
        }

        // elasticsearch
        try {
            Elasticsearch::ping();
            $output['elasticsearch'] = 'healthy';
        } catch (\Exception $e) {
            Log::error($e);
            $output['elasticsearch'] = 'unhealthy :' . $e->getMessage();
        }

        // amqp
        try {
            $output['amqp'] = '?';
        } catch (\Exception $e) {
            Log::error($e);
            $output['amqp'] = 'unhealthy : ' . $e->getMessage();
        }

        $date_end = microtime(true);
        $output['response_time_ms'] = round(($date_end - $date_begin) * 1000, 1);

        return response()->json($output);
    }
}

