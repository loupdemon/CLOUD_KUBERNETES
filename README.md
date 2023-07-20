## I. Terraform

##### init terraform ######
```
cd terraform && terraform init
```

##### plan terraform ######
```
terraform plan -out plan.tfplan
```

This command will apply the terraform plan and create the infrastructure. But it won't be enough to have a working cluster. We need to install the ingress controller, the cert-manager and some other stuff.

##### apply terraform ######
```
terraform apply plan.tfplan -auto-approve
```

##### get kubeconfig ######
```
# This command wil help to use OpenLens to connect to the cluster
# az = azure cli
az aks get-credentials --resource-group rg-kubi --name aks-kubi
```

##### destroy terraform ######
```
terraform destroy -auto-approve
```

##### connect to the aks ######
```
az aks get-credentials --resource-group rg-kubi --name aks-kubi
```

## II. Activate AGIC ######

To have more information about the AGIC, please check the following link : 

>https://learn.microsoft.com/fr-fr/azure/application-gateway/tutorial-ingress-controller-add-on-existing?toc=https%3A%2F%2Flearn.microsoft.com%2Ffr-fr%2Fazure%2Faks%2Ftoc.json&bc=https%3A%2F%2Flearn.microsoft.com%2Ffr-fr%2Fazure%2Fbread%2Ftoc.json#enable-the-agic-add-on-in-existing-aks-cluster-through-azure-portal

```
az aks enable-addons -n aks-kubi -g rg-kubi  --subscription "394e6431-b5e0-4004-b173-bc15e0379ebf" -a ingress-appgw --appgw-id "/subscriptions/394e6431-b5e0-4004-b173-bc15e0379ebf/resourceGroups/rg-kubi/providers/Microsoft.Network/applicationGateways/agic-appgw"
```

## III. Install some Helm

##### install angular ######
```
helm install angular -n applications --create-namespace ./values/angularjs
```

##### install laravel ######
```
helm install laravel -n applications --create-namespace ./values/laravel
```

##### install elasticsearch ######
```
helm install elasticsearch -n applications --create-namespace ./values/elasticsearch
```

##### install indexer ######
```
helm install indexer -n applications --create-namespace ./values/indexer
```

##### install reporting ######
```
helm install reporting -n applications --create-namespace ./values/reporting
```

##### Do not forget to change the  Domaine IP (DNS) in the Host ######

##### Add contributor access to appgw check agic logs

#### Find all instructions and Technical specifications in our report Doc/rapport.pdf
