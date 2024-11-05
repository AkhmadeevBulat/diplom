# Сетевой интерфейс для Zabbix-сервера (Внутренний)

output "internal_ip_address_vm_4" {
  value = yandex_compute_instance.vm-4.network_interface.0.ip_address
}

# Сетевой интерфейс для Zabbix-сервера (Внешний)

output "external_ip_address_vm_4" {
  value = yandex_compute_instance.vm-4.network_interface.0.nat_ip_address
}

# Сетевой интерфейс для Бастион-сервера (Внутренний)

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

# Сетевой интерфейс для Бастион-сервера (Внешний)

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}

# Сетевой интерфейс для WEB-сервера 1 (Внутренний)

output "internal_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.ip_address
}

# Сетевой интерфейс для WEB-сервера 2 (Внутренний)

output "internal_ip_address_vm_3" {
  value = yandex_compute_instance.vm-3.network_interface.0.ip_address
}

# Статический IP для бастион-сервера

resource "yandex_vpc_address" "addr" {
 name = "bastion-static-ip"
 folder_id = "b1ggqllvlgv6k8ck45o1"
 external_ipv4_address {
   zone_id = "ru-central1-a"
 }
}
