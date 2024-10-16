# Security Group для Web-серверов

resource "yandex_vpc_security_group" "web_sg" {
  name        = "web-security-group"
  network_id  = yandex_vpc_network.network-1.id
  description = "Security group for web servers. Allows HTTP (80), HTTPS (443), and SSH (22) from bastion."

  # Разрешаем входящие подключения по HTTP (порт 80)

  ingress {
    description      = "Allow HTTP"
    protocol         = "TCP"
    port            = 80
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }

  # Разрешаем входящие подключения по HTTPS (порт 443)

  ingress {
    description      = "Allow HTTPS"
    protocol         = "TCP"
    port            = 443
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }

  # Разрешаем доступ по SSH (порт 22) только с IP-адреса бастион-сервера

  ingress {
    description      = "Allow SSH from bastion"
    protocol         = "TCP"
    port            = 22
    v4_cidr_blocks   = ["${yandex_compute_instance.vm-1.network_interface.0.ip_address}/32"]
  }

  # Разрешаем все исходящие соединения (если нужно)

  egress {
    description      = "Allow all outgoing traffic"
    protocol         = "TCP"
    port            = -1
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }
}

# Security Group для Бастион-сервера

resource "yandex_vpc_security_group" "bastion_sg" {
  name        = "bastion-security-group"
  network_id  = yandex_vpc_network.network-1.id
  description = "Security group for bastion server. Allows SSH (22) from any."

  # Разрешаем доступ по SSH (порт 22)

  ingress {
    description      = "Allow SSH"
    protocol         = "TCP"
    port            = 22
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }

  # Разрешаем все исходящие соединения (если нужно)

  egress {
    description      = "Allow all outgoing traffic"
    protocol         = "TCP"
    port            = -1
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }
}