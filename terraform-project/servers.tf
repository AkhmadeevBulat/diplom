# /*----------------------------------------------------------------------------------*/
# /*                            Создание виртуальных машин                            */
# /*----------------------------------------------------------------------------------*/

resource "yandex_compute_instance" "server" {
  for_each = var.servers  # Прохожусь по каждому серверу

  name        = each.value.name  # Имя машины
  hostname    = each.value.hostname  # Hostname
  platform_id = each.value.platform_id  # Платформа процессора
  zone        = each.value.zone  # Зона сети
  allow_stopping_for_update = true

  # Прерываемая машина
  scheduling_policy {
    preemptible = each.value.preemptible
  }

  # Ресурсы
  resources {
    cores         = each.value.cores  # Кол-во ядер
    core_fraction = each.value.core_fraction  # Процент работы процессора
    memory        = each.value.memory  # Кол-во ОЗУ
  }

  # Загрузочный диск
  boot_disk {
    initialize_params {
      image_id = each.value.image_id
    }
  }

  # Сетевые параметры
  network_interface {
    # Привязываю подсеть
    subnet_id = local.subnet_mapping[each.value.subnet_id]
    # Публичный IP адрес
    nat       = each.value.nat
    # Привязываю статический IP адрес ВМ'е Bastion
    nat_ip_address = each.key == "bastion" ? yandex_vpc_address.bastion-static-ip.external_ipv4_address[0].address : null
    # Привязываю правильные группы безопасности через локальную переменную
    security_group_ids = [for sg in each.value.security_group_ids : local.security_group_mapping[sg]]
  }

  # Добавление SSH ключа
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"  # Мой SSH ключ
  }
}

# /*----------------------------------------------------------------------------------*/
# /*                          Интерфейсы для виртуальных машин                        */
# /*----------------------------------------------------------------------------------*/

# Статический IP для бастион-сервера

resource "yandex_vpc_address" "bastion-static-ip" {
 name = "bastion-static-ip"
 folder_id = var.folder_id
 external_ipv4_address {
   zone_id = "ru-central1-a"
 }
}

# Внутренние и внешние IP адреса
output "internal_ip_address_vm_bastion" {
  value = yandex_compute_instance.server["bastion"].network_interface[0].ip_address
}

output "external_ip_address_vm_bastion" {
  value = yandex_compute_instance.server["bastion"].network_interface[0].nat_ip_address
}

output "internal_ip_address_vm_web_1" {
  value = yandex_compute_instance.server["web-1"].network_interface[0].ip_address
}

output "internal_ip_address_vm_web_2" {
  value = yandex_compute_instance.server["web-2"].network_interface[0].ip_address
}

output "internal_ip_address_vm_zabbix" {
  value = yandex_compute_instance.server["zabbix"].network_interface[0].ip_address
}

output "external_ip_address_vm_zabbix" {
  value = yandex_compute_instance.server["zabbix"].network_interface[0].nat_ip_address
}

output "internal_ip_address_vm_elasticsearch" {
  value = yandex_compute_instance.server["elasticsearch"].network_interface[0].ip_address
}

output "internal_ip_address_vm_kibana" {
  value = yandex_compute_instance.server["kibana"].network_interface[0].ip_address
}

output "external_ip_address_vm_kibana" {
  value = yandex_compute_instance.server["kibana"].network_interface[0].nat_ip_address
}

# /*----------------------------------------------------------------------------------*/
# /*              Резервное копирование виртуальных машин (snapshot)                  */
# /*----------------------------------------------------------------------------------*/

# /*         Резервное копирование виртуальных машин (snapshot) - один раз            */

# Я попробовал сделать для теста снапшот один раз

# resource "yandex_compute_snapshot" "snapshots" {
#   for_each = var.servers
#   name           = "${each.value.name}-snapshot"
#   source_disk_id = yandex_compute_instance.server[each.key].boot_disk[0].disk_id
#   folder_id  = var.folder_id
#   description = "Ручной snapshot ${each.value.name}"
# }

/*      Резервное копирование виртуальных машин (snapshot) - по расписанию            */

resource "yandex_compute_snapshot_schedule" "snapshot-schedule-default" {
  name = "snapshot-schedule-default"

  schedule_policy {
    expression = "0 5 * * *"  # Каждый день в 5 утра
  }

  retention_period = "168h0m0s"  # Время жизни снимка - 7 дней - 168 часов

  snapshot_spec {
    description = "Snapshot по расписанию"
  }

  disk_ids = [for instance in yandex_compute_instance.server : instance.boot_disk[0].disk_id]  # Все диски
}


