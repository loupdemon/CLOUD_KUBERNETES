resource "kubectl_manifest" "letsencrypt-issuers" {
    yaml_body = file("../manifests/letsencrypt-clusterissuer.yml")

    depends_on = [
      helm_release.cert_manager
    ]
}

resource "kubectl_manifest" "storage-classses" {
    yaml_body = file("../manifests/storage-classes.yml")
}
