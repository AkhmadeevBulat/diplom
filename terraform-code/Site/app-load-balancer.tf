
# Target Group

resource "yandex_alb_target_group" "target-group" {
  name           = "target-group"

  target {
    subnet_id    = yandex_vpc_subnet.private-subnet-1.id  # В этой подсети находится WEB-1
    ip_address   = yandex_compute_instance.vm-2.network_interface.0.ip_address  # Интерфейс сервера WEB-1
  }

  target {
    subnet_id    = yandex_vpc_subnet.private-subnet-2.id  # В этой подсети находится WEB-2
    ip_address   = yandex_compute_instance.vm-3.network_interface.0.ip_address  # Интерфейс сервера WEB-2
  }
}


# Backend Group

resource "yandex_alb_backend_group" "backend_group" {
  name = "backend-group"

  http_backend {
    name              = "http-backend"
    weight            = 1
    port              = 80
    target_group_ids  = [yandex_alb_target_group.target-group.id]  # Привязка к созданной Target Group

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

resource "yandex_alb_http_router" "http-router" {
  name          = "http-router"
}

resource "yandex_alb_virtual_host" "virtual-host" {
  name                    = "virtual-host"
  http_router_id          = yandex_alb_http_router.http-router.id  # Привязка к созданному HTTP-роутеру
  route {
    name                  = "route"
    http_route {
      http_route_action {
        backend_group_id  = yandex_alb_backend_group.backend_group.id  # Привязка к созданному Backend-группе
        timeout           = "1s"
      }
    }
  }
}

# Application Load Balancer

resource "yandex_alb_load_balancer" "web_alb" {
  name       = "web-app-load-balancer"
  network_id = yandex_vpc_network.network-1.id  # Привязка к созданной сети

  listener {
    name = "http-listener"

    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [80]  # Слушает на порту 80
    }

    http {
      handler {
        http_router_id = yandex_alb_http_router.http-router.id  # ПРивязка к созданному HTTP-роутеру
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
