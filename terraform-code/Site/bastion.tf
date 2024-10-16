# Бастион-сервер

resource "yandex_compute_instance" "vm-1" {
  # Основные параметры
  name = "bastion"
  hostname    = "bastion"
  platform_id = "standard-v2"  # Intel Ice Lake
  zone     = "ru-central1-a"

  # Прерываемая машина
  scheduling_policy {
    preemptible = true
  }

  # Ресурсы
  resources {
    cores         = 2
    core_fraction = 5
    memory        = 1
  }

  # Загрузочный диск
  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-1.id
  }

  # Сетевые параметры
  network_interface {
    subnet_id = yandex_vpc_subnet.public-subnet.id
    nat       = true
    nat_ip_address     = yandex_vpc_address.addr.external_ipv4_address[0].address  # Привязка статического IP
    security_group_ids = [yandex_vpc_security_group.bastion_sg.id] # Применение Security Group (bastion_sg) для Бастион-сервера
  }

  # Добавление моего SSH ключа для подключения
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}