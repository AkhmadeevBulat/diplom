# Сеть VPC network-1

resource "yandex_vpc_network" "network-1" {
  name = "network-1"
}

# Публичная подсеть (public-subnet)

resource "yandex_vpc_subnet" "public-subnet" {
  name           = "public-subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["10.0.1.0/24"]

  # Указываем маршрутную таблицу для публичной подсети
  route_table_id = yandex_vpc_route_table.public_rt.id
}

# Приватная подсеть (private-subnet-1)

resource "yandex_vpc_subnet" "private-subnet-1" {
  name           = "private-subnet-1"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["10.0.2.0/24"]

  route_table_id = yandex_vpc_route_table.private_rt.id
}

# Приватная подсеть (private-subnet-2)

resource "yandex_vpc_subnet" "private-subnet-2" {
  name           = "private-subnet-2"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["10.0.3.0/24"]

  route_table_id = yandex_vpc_route_table.private_rt.id
}

# Интернет-шлюз для публичной подсети
resource "yandex_vpc_gateway" "internet_gateway" {
  name = "internet-gateway"
}

# NAT-шлюз для приватных подсетей
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "nat-gateway"
  shared_egress_gateway {}
}

# Маршрутная таблица для публичной подсети (выход в интернет напрямую)

resource "yandex_vpc_route_table" "public_rt" {
  name       = "public-route-table"
  network_id = yandex_vpc_network.network-1.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.internet_gateway.id
  }
}

# Маршрутная таблица для приватных подсетей (выход в интернет через NAT)

resource "yandex_vpc_route_table" "private_rt" {
  name       = "private-route-table"
  network_id = yandex_vpc_network.network-1.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}
