# Dockers
run:
	echo "Running docker-compose"
	cd docker && \
	docker-compose up --build

run_d:
	echo "Running docker-compose in detached mode"
	cd docker && \
	docker-compose up --build -d

down:
	echo "Stopping docker-compose"
	cd docker && \
	docker-compose down

down_v:
	echo "Stopping docker-compose and removing volumes"
	cd docker && \
	docker-compose down -v

remove:
	echo "Removing all containers"
	sh docker/removealldocker.sh

# Pre-requisite : Have to add helm repos :
# helm repo add wso2 https://helm.wso2.com, doc : https://artifacthub.io/packages/helm/wso2/mysql
# helm repo add bitnami https://charts.bitnami.com/bitnami
preinstall:
	echo "Installing pre-requisites"
	cd terraform && \
	terraform init && \
	terraform plan

helm_install:
	echo "Installing helm charts"
	cd terraform && \
	terraform apply -auto-approve && \

	cd ./helm/ && \
	helm install angularjs -n applications --create-namespace angularjs/ && \
	helm install laravel -n applications --create-namespace laravel/ && \
	helm install elasticsearch -n applications --create-namespace elasticsearch/ && \
	helm install reporting -n applications --create-namespace reporting/ && \
 	helm install indexer -n applications --create-namespace indexer/

helm_upgrade:
	echo "Upgrading helm charts"
	cd ./helm/ && \
	helm upgrade angularjs -n applications --create-namespace angularjs/ && \
	helm upgrade elasticsearch -n applications --create-namespace elasticsearch/ && \
	helm upgrade rabbitmq -n applications --create-namespace -f values/rabbitmq.yaml bitnami/rabbitmq && \
	helm upgrade mysql -n applications --create-namespace -f values/mysql.yaml bitnami/mysql && \
	helm upgrade cert-manager -n applications --create-namespace -f values/cert-manager.yaml jetstack/cert-manager && \
	helm upgrade laravel -n applications --create-namespace laravel/ && \
    helm upgrade reporting -n applications --create-namespace reporting/ && \
 	helm upgrade indexer -n applications --create-namespace indexer/

helm_uninstalled:
	echo "Uninstalling helm charts"
	cd ./helm/ && \
	helm uninstall angularjs -n applications --create-namespace && \
	helm uninstall rabbitmq -n applications --create-namespace && \
	helm uninstall mysql -n applications --create-namespace && \
	helm uninstall elasticsearch -n applications --create-namespace && \
	helm uninstall laravel -n applications --create-namespace && \
	helm uninstall reporting -n applications --create-namespace && \
	helm uninstall indexer -n applications --create-namespace

helm_delete:
	echo "Deleting helm charts"
	helm delete angularjs -n applications --create-namespace && \
	helm delete rabbitmq -n applications --create-namespace && \
	helm delete mysql -n applications --create-namespace && \
	helm delete elasticsearch -n applications --create-namespace && \
	helm delete laravel -n applications --create-namespace && \
    helm delete reporting -n applications --create-namespace && \
	helm delete indexer -n applications --create-namespace
