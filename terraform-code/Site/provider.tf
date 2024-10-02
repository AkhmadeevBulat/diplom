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
  zone = "ru-central1-a"
  service_account_key_file = "(Изменено)"
  cloud_id                 = "(Изменено)"
  folder_id                = "(Изменено)"
}