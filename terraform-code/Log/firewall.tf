# Security Group для Kibana-сервера

resource "yandex_vpc_security_group" "kibana_sg" {
  name        = "kibana-security-group"
  network_id  = yandex_vpc_network.network-1.id
  description = "Security group for kibana server. Allows HTTP (5601), SSH (22) from bastion and ICMP."

  # Разрешаем входящие подключения по HTTP (порт 5601)

  ingress {
    description      = "Allow HTTP"
    protocol         = "TCP"
    port            = 5601
    v4_cidr_blocks   = ["10.0.0.0/8"]
  }

  egress {
    description      = "Allow HTTP"
    protocol         = "TCP"
    port            = 5601
    v4_cidr_blocks   = ["10.0.0.0/8"]
  }

  # Разрешаем доступ по SSH (порт 22) только с IP-адреса бастион-сервера

  ingress {
    description      = "Allow SSH from bastion"
    protocol         = "TCP"
    port            = 22
    v4_cidr_blocks   = ["${yandex_compute_instance.vm-1.network_interface.0.ip_address}/32"]
  }

  # Разрешаем ICMP запросы

  ingress {
    description      = "Allow ICMP from PrivateNetwork"
    protocol         = "ICMP"
    port            = -1
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow ICMP from PrivateNetwork"
    protocol         = "ICMP"
    port            = -1
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

# Security Group для ElasticSearch-сервера

resource "yandex_vpc_security_group" "elasticsearch_sg" {
  name        = "elasticsearch-security-group"
  network_id  = yandex_vpc_network.network-1.id
  description = "Security group for elasticsearch server. Allows HTTP (9200 и 9300), SSH (22) from bastion and ICMP."

  # Разрешаем входящие подключения по HTTP (порт 9200 и 9300)

  ingress {
    description      = "Allow HTTP"
    protocol         = "TCP"
    port            = 9200
    v4_cidr_blocks   = ["10.0.0.0/8"]
  }

  ingress {
    description      = "Allow HTTP"
    protocol         = "TCP"
    port            = 9300
    v4_cidr_blocks   = ["10.0.0.0/8"]
  }

  egress {
    description      = "Allow HTTP"
    protocol         = "TCP"
    port            = 9300
    v4_cidr_blocks   = ["10.0.0.0/8"]
  }

  # Разрешаем доступ по SSH (порт 22) только с IP-адреса бастион-сервера

  ingress {
    description      = "Allow SSH from bastion"
    protocol         = "TCP"
    port            = 22
    v4_cidr_blocks   = ["${yandex_compute_instance.vm-1.network_interface.0.ip_address}/32"]
  }

  # Разрешаем ICMP запросы

  ingress {
    description      = "Allow ICMP from PrivateNetwork"
    protocol         = "ICMP"
    port            = -1
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow ICMP from PrivateNetwork"
    protocol         = "ICMP"
    port            = -1
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

# Security Group для Zabbix-сервера

resource "yandex_vpc_security_group" "zabbix_sg" {
  name        = "zabbix-security-group"
  network_id  = yandex_vpc_network.network-1.id
  description = "Security group for zabbix server. Allows HTTP (80), HTTPS (443), and SSH (22) from bastion."

  # Разрешаем входящие подключения по HTTP (порт 80)

  ingress {
    description      = "Allow HTTP"
    protocol         = "TCP"
    port            = 8080
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

  # Разрешаем входящие подключения по портам 10050 10051 10052 10053 для приватной сети

  ingress {
    description      = "Allow 10050"
    protocol         = "TCP"
    port            = 10050
    v4_cidr_blocks   = ["10.0.0.0/8"]
  }

  ingress {
    description      = "Allow 10051"
    protocol         = "TCP"
    port            = 10051
    v4_cidr_blocks   = ["10.0.0.0/8"]
  }

  ingress {
    description      = "Allow 10052"
    protocol         = "TCP"
    port            = 10052
    v4_cidr_blocks   = ["10.0.0.0/8"]
  }

  ingress {
    description      = "Allow 10053"
    protocol         = "TCP"
    port            = 10053
    v4_cidr_blocks   = ["10.0.0.0/8"]
  }

  # Разрешаем ICMP запросы

  ingress {
    description      = "Allow ICMP from PrivateNetwork"
    protocol         = "ICMP"
    port            = -1
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow ICMP from PrivateNetwork"
    protocol         = "ICMP"
    port            = -1
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

  ingress {
    description      = "Allow 10050"
    protocol         = "TCP"
    port            = 10050
    v4_cidr_blocks   = ["10.0.0.0/8"]
  }

  # Разрешаем ICMP запросы

  ingress {
    description      = "Allow ICMP from PrivateNetwork"
    protocol         = "ICMP"
    port            = -1
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }

    egress {
    description      = "Allow ICMP from PrivateNetwork"
    protocol         = "ICMP"
    port            = -1
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

  ingress {
    description      = "Allow 10050"
    protocol         = "TCP"
    port            = 10050
    v4_cidr_blocks   = ["10.0.0.0/8"]
  }

  # Разрешаем ICMP запросы

  ingress {
    description      = "Allow ICMP from PrivateNetwork"
    protocol         = "ICMP"
    port            = -1
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }

    egress {
    description      = "Allow ICMP from PrivateNetwork"
    protocol         = "ICMP"
    port            = -1
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
