
#PROMETHEUS
# resource "helm_release" "kube-prometheus-stack" {
#  name              = "kube-prometheus-stack"
#  repository        = "https://prometheus-community.github.io/helm-charts"
#  chart             = "kube-prometheus-stack"
#  version           = "45.10.1"
#  namespace         = "kubi-tools"
#  create_namespace  = true

#  values = [
#    file("../helm/values/prometheus.yml")
#  ]
# }

# CERT MANAGER LETSENCRYPT
resource "helm_release" "cert_manager" {
  name              = "cert-manager"
  repository        = "https://charts.jetstack.io"
  chart             = "cert-manager"
  version           = "v1.11.1"
  namespace         = "kubi-tools"
  create_namespace  = true

  values = [
    file("../helm/values/cert-manager.yml")
  ]
}


resource "helm_release" "mysql" {
  name              = "mysql"
  repository        = "https://charts.bitnami.com/bitnami"
  chart             = "mysql"
  namespace         = "applications"
  create_namespace  = true

  values = [
    file("../helm/values/mysql.yml")
  ]
}

resource "helm_release" "rabbitmq" {
  name              = "rabbitmq"
  repository        = "https://charts.bitnami.com/bitnami"
  chart             = "rabbitmq"
  namespace         = "applications"
  create_namespace  = true

  values = [
    file("../helm/values/rabbitmq.yml")
  ]
}


