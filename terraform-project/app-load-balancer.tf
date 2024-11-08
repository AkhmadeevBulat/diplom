
# Target Group

resource "yandex_alb_target_group" "target-group-web" {
  name           = "target-group-web"

  dynamic "target" {
    # Добавляем только те серверы, у которых имя начинается с "web"
    for_each = { for key, server in yandex_compute_instance.server : key => server if startswith(key, "web") }

    content {
      subnet_id = target.value.network_interface[0].subnet_id
      ip_address   = target.value.network_interface[0].ip_address
    }
  }
}

# Target Group ZABBIX

resource "yandex_alb_target_group" "target-group-zabbix" {
  name           = "target-group-zabbix"

  target {
    subnet_id    = yandex_vpc_subnet.public-subnet.id
    ip_address   = yandex_compute_instance.server["zabbix"].network_interface.0.ip_address
  }
}

# Target Group KIBANA

resource "yandex_alb_target_group" "target-group-kibana" {
  name           = "target-group-kibana"

  target {
    subnet_id    = yandex_vpc_subnet.public-subnet.id
    ip_address   = yandex_compute_instance.server["kibana"].network_interface.0.ip_address
  }
}

# Backend Group

resource "yandex_alb_backend_group" "backend-group-web" {
  name = "backend-group-web"

  http_backend {
    name              = "http-backend"
    weight            = 1
    port              = 80
    target_group_ids  = [yandex_alb_target_group.target-group-web.id]  # Привязка к созданной Target Group

    load_balancing_config {
      panic_threshold = 50  # Настройка балансировки нагрузки
    }

    healthcheck {
      timeout   = "1s"    # Максимальное время ожидания ответа от сервера
      interval  = "1s"    # Интервал между проверками

      http_healthcheck {
        path = "/"        # Проверка по корневому пути "/"
        host = "localhost"  # Адрес хоста для healthcheck
      }
    }

    http2 = "false"  # HTTP2 опция, false
  }
}

# Backend Group ZABBIX

resource "yandex_alb_backend_group" "backend_group_zabbix" {
  name = "backend-group-zabbix"

  http_backend {
    name              = "http-backend-zabbix"
    weight            = 1
    port              = 8080
    target_group_ids  = [yandex_alb_target_group.target-group-zabbix.id]  # Привязка к созданной Target Group

    load_balancing_config {
      panic_threshold = 50  # Настройка балансировки нагрузки
    }

    healthcheck {
      timeout   = "1s"    # Максимальное время ожидания ответа от сервера
      interval  = "1s"    # Интервал между проверками

      http_healthcheck {
        path = "/"        # Проверка по корневому пути "/"
        host = "localhost"  # Адрес хоста для healthcheck
      }
    }

    http2 = "false"  # HTTP2 опция, false
  }
}

# Backend Group KIBANA

resource "yandex_alb_backend_group" "backend_group_kibana" {
  name = "backend-group-kibana"

  http_backend {
    name              = "http-backend-kibana"
    weight            = 1
    port              = 5601
    target_group_ids  = [yandex_alb_target_group.target-group-kibana.id]  # Привязка к созданной Target Group

    load_balancing_config {
      panic_threshold = 50  # Настройка балансировки нагрузки
    }

    healthcheck {
      timeout   = "1s"    # Максимальное время ожидания ответа от сервера
      interval  = "1s"    # Интервал между проверками

      http_healthcheck {
        path = "/"        # Проверка по корневому пути "/"
        host = "localhost"  # Адрес хоста для healthcheck
      }
    }

    http2 = "false"  # HTTP2 опция, false
  }
}

# HTTP Router

resource "yandex_alb_http_router" "http-router-web" {
  name          = "http-router-web"
}

resource "yandex_alb_virtual_host" "virtual-host-web" {
  name                    = "virtual-host-web"
  http_router_id          = yandex_alb_http_router.http-router-web.id
  route {
    name                  = "route"
    http_route {
      http_route_action {
        backend_group_id  = yandex_alb_backend_group.backend-group-web.id
        timeout           = "1s"
      }
    }
  }
}

# HTTP Router ZABBIX

resource "yandex_alb_http_router" "http-router-zabbix" {
  name          = "http-router-zabbix"
}

resource "yandex_alb_virtual_host" "virtual-host-zabbix" {
  name                    = "virtual-host-zabbix"
  http_router_id          = yandex_alb_http_router.http-router-zabbix.id
  route {
    name                  = "route-zabbix"
    http_route {
      http_route_action {
        backend_group_id  = yandex_alb_backend_group.backend_group_zabbix.id
        timeout           = "1s"
      }
    }
  }
}

# HTTP Router KIBANA

resource "yandex_alb_http_router" "http-router-kibana" {
  name          = "http-router-kibana"
}

resource "yandex_alb_virtual_host" "virtual-host-kibana" {
  name                    = "virtual-host-kibana"
  http_router_id          = yandex_alb_http_router.http-router-kibana.id
  route {
    name                  = "route-kibana"
    http_route {
      http_route_action {
        backend_group_id  = yandex_alb_backend_group.backend_group_kibana.id
        timeout           = "1s"
      }
    }
  }
}

# Application Load Balancer

resource "yandex_alb_load_balancer" "web_alb" {
  name       = "web-app-load-balancer"
  network_id = yandex_vpc_network.network-1.id

    listener {
    name = "http-listener-web"

    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [80]
    }

    http {
      handler {
        http_router_id = yandex_alb_http_router.http-router-web.id
      }
    }
  }

  listener {
    name = "http-listener-zabbix"

    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [8080]
    }

    http {
      handler {
        http_router_id = yandex_alb_http_router.http-router-zabbix.id
      }
    }
  }

    listener {
    name = "http-listener-kibana"

    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [5601]
    }

    http {
      handler {
        http_router_id = yandex_alb_http_router.http-router-kibana.id
      }
    }
  }

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.public-subnet.id
    }
  }
}
