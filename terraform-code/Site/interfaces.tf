
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