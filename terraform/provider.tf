terraform {
  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.30.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.30.0"
    }
    acme = {
      source  = "vancluever/acme"
      version = "2.11.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "= 4.0.4"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "azurerm" {
   subscription_id = "cd1d4043-8b05-4dcf-a85b-130720c09010"
   tenant_id       = "901cb4ca-b862-4029-9306-e5cd0f6d9f86"
  features {}
  skip_provider_registration = true
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

provider "tls" {
}

provider "helm" {
  kubernetes {
    #config_path            = "~/.kube/config"
    host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  }
}

provider "kubectl" {
  #config_path            = "~/.kube/config"
  host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  load_config_file       = false
}
