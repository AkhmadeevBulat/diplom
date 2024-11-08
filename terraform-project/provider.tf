# Провайдер

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone                  = "ru-central1-a"
  service_account_key_file = var.service_account_key_file
  cloud_id               = var.cloud_id
  folder_id              = var.folder_id
}
