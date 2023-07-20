# CLO-902

## Instructions

### Requirements

- Docker
- Kubernetes
- Minikube
- Kubectl
- Helm
- VirtualBox
- Git

### Where to find images ?

> https://hub.docker.com/r/duramana/

Before to use images from docker hub in K8s, you need to pull them locally, and
test all of them. Make sure that they are working fine.

## 1. Frontend - AngularJS

### 1.1. To test on local

```bash
# to test on local
docker pull duramana/angularjs:v2
docker run -p 80:80 duramana/angularjs:v2

# on Browser to use localhost:80
```

### 1.2. To create Deployment and Service in K8s

Create K8s deployment and service from this image.

```bash
kubectl create -f deployment-angularjs.yaml

# create service
kubectl create -f service-angularjs.yaml
```

## 2. RabbitMQ - Datastore

### 2.1. To test on local

```bash
# to test on local
docker pull duramana/rabbitmq:v1
docker run -p 15672:15672 duramana/rabbitmq:v1
```

# On browser use : localhost:15672

### 2.2. To create Deployment and Service in K8s

Create K8s deployment and service from this image.

* [ ]   TODO : to create deployment.yaml file and test it. on local with minikube

```bash
kubectl create -f deployment-rabbitmq.yaml

## 3. MySQL - Database

### 3.1. To test on local

```bash
# to test on local
docker pull mysql:latest
docker run --name database -e MYSQL_ROOT_PASSWORD=password -d mysql:latest
```

### 3.2. To create Deployment and Service in K8s

* [ ]   TODO : to create deployment.yaml file and test it. on local with minikube

```bash
kubectl create -f deployment-database.yaml
```

## 4. BackEnd - Database

### 3.1. To test on local

```bash
# to test on local
docker pull duramana/laravel:v1
docker pull duramana/api:v1
docker run --name laravel duramana/laravel:v1
docker run --name api -v /host/path/nginx.conf:/etc/nginx/nginx.conf:ro -d duramana/api:v1
```
NB : without nginx.conf, the container will not start.

### 3.2. To create Deployment and Service type LoadBalancer in K8s

* [ ]   TODO : to create deployment.yaml file and test it. on local with minikube

```bash
kubectl create -f deployment-backend.yaml
kubectl create -f loadbalancer-backend.yaml
```

# Test Docker Compose file en local

```bash
# to test on local
make run

# to stop containers
make down

# to remove containers, images and volumes
# Documentation : https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes
make remove
```

Once the containers are running, to activate Laravel's migrations, you need to
do this command :

```bash
docker exec -it laravel bash

# then inside the container
php artisan migrate:fresh --seed
```

On the Browser, use : _localhost:8080_, and all will be green

