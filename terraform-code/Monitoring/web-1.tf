# WEB-сервер - 1

resource "yandex_compute_instance" "vm-2" {
  # Основные параметры
  name = "web-1"
  hostname    = "web-1"
  platform_id = "standard-v2"  # Intel Ice Lake
  zone     = "ru-central1-b"

  # Прерываемая машина
  scheduling_policy {
    preemptible = true
  }

  # Ресурсы
  resources {
    cores         = 2
    core_fraction = 20
    memory        = 2
  }

  # Загрузочный диск
  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-2.id
  }

  # Сетевые параметры
  network_interface {
    subnet_id = yandex_vpc_subnet.private-subnet-1.id
    nat       = false
    security_group_ids = [yandex_vpc_security_group.web_sg.id] # Применение Security Group (web_sg) для Web-серверов
  }

  # Добавление моего SSH ключа для подключения
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}