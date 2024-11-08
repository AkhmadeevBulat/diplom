# Security Group для Kibana-сервера

resource "yandex_vpc_security_group" "kibana_sg" {
  name        = "kibana_sg"
  network_id  = yandex_vpc_network.network-1.id
  description = "Firewall для Kibana-серверов"

  ingress {
    description      = "Разрешить входящий трафик TCP по порту 5601"
    protocol         = "TCP"
    port            = 5601
    v4_cidr_blocks   = ["10.0.0.0/8"]
  }

  ingress {
    description      = "Разрешить входящий трафик TCP по порту 10050 для PrivateNetwork"
    protocol         = "TCP"
    port            = 10050
    v4_cidr_blocks   = ["10.0.0.0/8"]
  }

  ingress {
    description      = "Разрешить входящий трафик TCP по порту 22 от PrivateNetwork"
    protocol         = "TCP"
    port            = 22
    v4_cidr_blocks   = ["10.0.0.0/8"]
  }

  ingress {
    description      = "Разрешить входящий трафик ICMP"
    protocol         = "ICMP"
    port            = -1
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }

  egress {
    description      = "Разрешить исходящий трафик ICMP"
    protocol         = "ICMP"
    port            = -1
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }

  egress {
    description      = "Разрешить полный исходящий трафик TCP"
    protocol         = "TCP"
    port            = -1
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }
}

# Security Group для ElasticSearch-сервера

resource "yandex_vpc_security_group" "elasticsearch_sg" {
  name        = "elasticsearch_sg"
  network_id  = yandex_vpc_network.network-1.id
  description = "Firewall для elasticsearch-сервера"
 
  ingress {
    description      = "Разрешить входящий трафик TCP по порту 9200 для PrivateNetwork"
    protocol         = "TCP"
    port            = 9200
    v4_cidr_blocks   = ["10.0.0.0/8"]
  }

  ingress {
    description      = "Разрешить входящий трафик TCP по порту 9300 для PrivateNetwork"
    protocol         = "TCP"
    port            = 9300
    v4_cidr_blocks   = ["10.0.0.0/8"]
  }

  egress {
    description      = "Разрешить исходящий трафик TCP по порту 9300 для PrivateNetwork"
    protocol         = "TCP"
    port            = 9300
    v4_cidr_blocks   = ["10.0.0.0/8"]
  }

  ingress {
    description      = "Разрешить входящий трафик TCP по порту 10050 для PrivateNetwork"
    protocol         = "TCP"
    port            = 10050
    v4_cidr_blocks   = ["10.0.0.0/8"]
  }

  ingress {
    description      = "Разрешить входящий трафик TCP по порту 22 от PrivateNetwork"
    protocol         = "TCP"
    port            = 22
    v4_cidr_blocks   = ["10.0.0.0/8"]
  }

  ingress {
    description      = "Разрешить входящий трафик ICMP"
    protocol         = "ICMP"
    port            = -1
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }

  egress {
    description      = "Разрешить исходящий трафик ICMP"
    protocol         = "ICMP"
    port            = -1
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }

  egress {
    description      = "Разрешить полный исходящий трафик TCP"
    protocol         = "TCP"
    port            = -1
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }
}

# Security Group для Zabbix-сервера

resource "yandex_vpc_security_group" "zabbix_sg" {
  name        = "zabbix_sg"
  network_id  = yandex_vpc_network.network-1.id
  description = "Firewall для Zabbix-сервероа"

  ingress {
    description      = "Разрешить входящий трафик TCP по порту 8080"
    protocol         = "TCP"
    port            = 8080
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Разрешить входящий трафик TCP по порту 443"
    protocol         = "TCP"
    port            = 443
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Разрешить входящий трафик TCP по порту 22"
    protocol         = "TCP"
    port            = 22
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Разрешить входящий трафик TCP по порту 10050 для PrivateNetwork"
    protocol         = "TCP"
    port            = 10050
    v4_cidr_blocks   = ["10.0.0.0/8", "172.18.0.0/16"]
  }

  ingress {
    description      = "Разрешить входящий трафик TCP по порту 10051 для PrivateNetwork"
    protocol         = "TCP"
    port            = 10051
    v4_cidr_blocks   = ["10.0.0.0/8", "172.18.0.0/16"]
  }

  ingress {
    description      = "Разрешить входящий трафик TCP по порту 10052 для PrivateNetwork"
    protocol         = "TCP"
    port            = 10052
    v4_cidr_blocks   = ["10.0.0.0/8", "172.18.0.0/16"]
  }

  ingress {
    description      = "Разрешить входящий трафик TCP по порту 10053 для PrivateNetwork"
    protocol         = "TCP"
    port            = 10053
    v4_cidr_blocks   = ["10.0.0.0/8", "172.18.0.0/16"]
  }

  ingress {
    description      = "Разрешить входящий трафик ICMP"
    protocol         = "ICMP"
    port            = -1
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }

  egress {
    description      = "Разрешить исходящий трафик ICMP"
    protocol         = "ICMP"
    port            = -1
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }

  egress {
    description      = "Разрешить полный исходящий трафик TCP"
    protocol         = "TCP"
    port            = -1
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }
}

# Security Group для Web-серверов

resource "yandex_vpc_security_group" "web_sg" {
  name        = "web_sg"
  network_id  = yandex_vpc_network.network-1.id
  description = "Firewall для WEB-серверов"

  ingress {
    description      = "Разрешить входящий трафик TCP по порту 80"
    protocol         = "TCP"
    port            = 80
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Разрешить входящий трафик TCP по порту 443"
    protocol         = "TCP"
    port            = 443
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Разрешить входящий трафик TCP по порту 22 от PrivateNetwork"
    protocol         = "TCP"
    port            = 22
    v4_cidr_blocks   = ["10.0.0.0/8"]
  }

  ingress {
    description      = "Разрешить входящий трафик TCP по порту 10050 для PrivateNetwork"
    protocol         = "TCP"
    port            = 10050
    v4_cidr_blocks   = ["10.0.0.0/8"]
  }

  ingress {
    description      = "Разрешить входящий трафик ICMP"
    protocol         = "ICMP"
    port            = -1
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }

  egress {
    description      = "Разрешить исходящий трафик ICMP"
    protocol         = "ICMP"
    port            = -1
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }

  egress {
    description      = "Разрешить полный исходящий трафик TCP"
    protocol         = "TCP"
    port            = -1
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }
}

# Security Group для Бастион-сервера

resource "yandex_vpc_security_group" "bastion_sg" {
  name        = "bastion_sg"
  network_id  = yandex_vpc_network.network-1.id
  description = "Firewall для Bastion-сервера."

  ingress {
    description      = "Разрешить входящий трафик TCP по порту 22"
    protocol         = "TCP"
    port            = 22
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Разрешить входящий трафик TCP по порту 10050 для PrivateNetwork"
    protocol         = "TCP"
    port            = 10050
    v4_cidr_blocks   = ["10.0.0.0/8"]
  }

  ingress {
    description      = "Разрешить входящий трафик ICMP"
    protocol         = "ICMP"
    port            = -1
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }

  egress {
    description      = "Разрешить исходящий трафик ICMP"
    protocol         = "ICMP"
    port            = -1
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }

  egress {
    description      = "Разрешить полный исходящий трафик TCP"
    protocol         = "TCP"
    port            = -1
    v4_cidr_blocks   = ["0.0.0.0/0"]
  }
}
