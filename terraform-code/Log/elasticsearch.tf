# ElasticSearch-сервер

resource "yandex_compute_instance" "vm-5" {
  # Основные параметры
  name = "elasticsearch"
  hostname    = "elasticsearch"
  platform_id = "standard-v2"  # Intel Ice Lake
  zone     = "ru-central1-b"

  # Прерываемая машина
  scheduling_policy {
    preemptible = true
  }

  # Ресурсы
  resources {
    cores         = 2
    core_fraction = 50
    memory        = 4
  }

  # Загрузочный диск
  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-5.id
  }

  # Сетевые параметры
  network_interface {
    subnet_id = yandex_vpc_subnet.private-subnet-1.id
    nat       = false
    security_group_ids = [yandex_vpc_security_group.elasticsearch_sg.id] # Применение Security Group (elasticsearch_sg) для Elasticsearch-сервера
  }

  # Добавление моего SSH ключа для подключения
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}