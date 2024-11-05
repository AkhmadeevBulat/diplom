# Kibana-сервер

resource "yandex_compute_instance" "vm-6" {
  # Основные параметры
  name = "kibana"
  hostname    = "kibana"
  platform_id = "standard-v2"  # Intel Ice Lake
  zone     = "ru-central1-a"

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
    disk_id = yandex_compute_disk.boot-disk-6.id
  }

  # Сетевые параметры
  network_interface {
    subnet_id = yandex_vpc_subnet.public-subnet.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.kibana_sg.id] # Применение Security Group (kibana_sg) для Kibana-сервера
  }

  # Добавление моего SSH ключа для подключения
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}