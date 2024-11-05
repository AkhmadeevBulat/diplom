# Zabbix-сервер

resource "yandex_compute_instance" "vm-4" {
  # Основные параметры
  name = "zabbix"
  hostname    = "zabbix"
  platform_id = "standard-v2"  # Intel Ice Lake
  zone     = "ru-central1-a"

  # Прерываемая машина
  scheduling_policy {
    preemptible = true
  }

  # Ресурсы
  resources {
    cores         = 2
    core_fraction = 100
    memory        = 8
  }

  # Загрузочный диск
  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-4.id
  }

  # Сетевые параметры
  network_interface {
    subnet_id = yandex_vpc_subnet.public-subnet.id
    nat       = true
    # nat_ip_address     = yandex_vpc_address.addr-zabbix.external_ipv4_address[0].address  # Привязка статического IP
    security_group_ids = [yandex_vpc_security_group.zabbix_sg.id] # Применение Security Group (zabbix_sg) для Zabbix-сервера
  }

  # Добавление моего SSH ключа для подключения
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}