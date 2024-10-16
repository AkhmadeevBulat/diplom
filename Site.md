# Постановка задачи

## Требования к инфраструктуре (Всего проекта):

1. Для развёртки инфраструктуры используйть Terraform и Ansible.

2. Не использовать для ansible inventory ip-адреса! Вместо этого использовать fqdn имена виртуальных машин в зоне ".ru-central1.internal".

3. Использовать по-возможности минимальные конфигурации ВМ.

## Требования к разделу Сайт:

1. Создать две ВМ (WEB-сервера) в разных зонах.

2. Установить, если это нужно, NGINX на эти WEB-сервера.

3. WEB-сервера не должны обладать внешним IP-адресом и находится во внутренней сети.

4. Доступ по SSH к WEB-серверам должно происходить только через Бастион-сервер.

5. Доступ по порту HTTP к WEB-серверам должно происходить через балансировщик Yandex Cloud.

## Требования к сети (Всего проекта):

1. Нужно развернуть только один VPC.

2. Сервера WEB, ElasticSearch должны находится в приватной сети.

3. Сервера Zabbix, Kibana, Application Load Balancer и Бастион должны находится в публичной сети.

4. Настроить Security Groups для всех сервисовна входящий трафик к нужныи портам.

5. Исходящий доступ в интернет для ВМ внутренней сети осуществляется через NAT-шлюз.

# Выполнение раздела Сайт

Из предыдущего раздела ([Первоначальное действие](Initial-Actions.md)) рабочая станция стала готова для развертывания инфраструктуры в Yandex Cloud.

## Развертывание инфраструктуры

Для удобства я разделил код Terraform и Ansible по разделам, чтобы можно было увидеть прогресс из раздела в раздел. В данном случае, для раздела ```"Сайт"``` - ```terraform-code/Site/``` и ```ansible-code/Site```.

Для удобства я также разделил код Terraform и Ansible на состовляющее, чтобы можно было легко и удобно править код. Объяснение в самом коде.

Код Terraform:

* **[provider.tf](terraform-code/Site/provider.tf)** - Настройки провайдера;

* **[boot-disk.tf](terraform-code/Site/boot-disk.tf)** - Настройки загрузочных дисков;

* **[network.tf](terraform-code/Site/network.tf)** - Настройки сети;

* **[interfaces.tf](terraform-code/Site/interfaces.tf)** - Настройки подключенных интерфесов;

* **[firewall.tf](terraform-code/Site/firewall.tf)** - Настройки группы безопасности

* **[bastion.tf](terraform-code/Site/bastion.tf)** - Настройки Бастион - сервера

* **[web-1.tf](terraform-code/Site/web-1.tf)** - Настройки WEB - сервера 1

* **[web-2.tf](terraform-code/Site/web-2.tf)** - Настройки WEB - сервера 2

* **[app-load-balancer.tf](terraform-project/app-load-balancer.tf)** - Настройки Application Load Balancer'а

Вывод команды ```terraform init```:

```
bulatahmadeev@MBP-Bulat terraform-project % terraform init
Initializing the backend...
Initializing provider plugins...
- Reusing previous version of yandex-cloud/yandex from the dependency lock file
- Using previously-installed yandex-cloud/yandex v0.129.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Вывод команды ```terraform plan```:

```
bulatahmadeev@MBP-Bulat terraform-project % terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_disk.boot-disk-1 will be created
  + resource "yandex_compute_disk" "boot-disk-1" {
      + block_size  = 4096
      + created_at  = (known after apply)
      + folder_id   = (known after apply)
      + id          = (known after apply)
      + image_id    = "fd8tvc3529h2cpjvpkr5"
      + name        = "boot-disk-1"
      + product_ids = (known after apply)
      + size        = 10
      + status      = (known after apply)
      + type        = "network-hdd"
      + zone        = "ru-central1-a"

      + disk_placement_policy (known after apply)
    }

  # yandex_compute_disk.boot-disk-2 will be created
  + resource "yandex_compute_disk" "boot-disk-2" {
      + block_size  = 4096
      + created_at  = (known after apply)
      + folder_id   = (known after apply)
      + id          = (known after apply)
      + image_id    = "fd8tvc3529h2cpjvpkr5"
      + name        = "boot-disk-2"
      + product_ids = (known after apply)
      + size        = 10
      + status      = (known after apply)
      + type        = "network-hdd"
      + zone        = "ru-central1-b"

      + disk_placement_policy (known after apply)
    }

  # yandex_compute_disk.boot-disk-3 will be created
  + resource "yandex_compute_disk" "boot-disk-3" {
      + block_size  = 4096
      + created_at  = (known after apply)
      + folder_id   = (known after apply)
      + id          = (known after apply)
      + image_id    = "fd8tvc3529h2cpjvpkr5"
      + name        = "boot-disk-3"
      + product_ids = (known after apply)
      + size        = 10
      + status      = (known after apply)
      + type        = "network-hdd"
      + zone        = "ru-central1-d"

      + disk_placement_policy (known after apply)
    }

  # yandex_compute_instance.vm-1 will be created
  + resource "yandex_compute_instance" "vm-1" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hostname                  = "bastion"
      + id                        = (known after apply)
      + maintenance_grace_period  = (known after apply)
      + maintenance_policy        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa (Изменено)bulatahmadeev@MBP-Bulat.local
            EOT
        }
      + name                      = "bastion"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params (known after apply)
        }

      + metadata_options (known after apply)

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy (known after apply)

      + resources {
          + core_fraction = 5
          + cores         = 2
          + memory        = 1
        }

      + scheduling_policy {
          + preemptible = true
        }
    }

  # yandex_compute_instance.vm-2 will be created
  + resource "yandex_compute_instance" "vm-2" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hostname                  = "web-1"
      + id                        = (known after apply)
      + maintenance_grace_period  = (known after apply)
      + maintenance_policy        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa (Изменено) bulatahmadeev@MBP-Bulat.local
            EOT
        }
      + name                      = "web-1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-b"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params (known after apply)
        }

      + metadata_options (known after apply)

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = false
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy (known after apply)

      + resources {
          + core_fraction = 20
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = true
        }
    }

  # yandex_compute_instance.vm-3 will be created
  + resource "yandex_compute_instance" "vm-3" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hostname                  = "web-2"
      + id                        = (known after apply)
      + maintenance_grace_period  = (known after apply)
      + maintenance_policy        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa (Изменено) bulatahmadeev@MBP-Bulat.local
            EOT
        }
      + name                      = "web-2"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-d"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params (known after apply)
        }

      + metadata_options (known after apply)

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = false
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy (known after apply)

      + resources {
          + core_fraction = 20
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = true
        }
    }

  # yandex_vpc_gateway.internet_gateway will be created
  + resource "yandex_vpc_gateway" "internet_gateway" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + name       = "internet-gateway"
    }

  # yandex_vpc_gateway.nat_gateway will be created
  + resource "yandex_vpc_gateway" "nat_gateway" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + name       = "nat-gateway"

      + shared_egress_gateway {}
    }

  # yandex_vpc_network.network-1 will be created
  + resource "yandex_vpc_network" "network-1" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "network-1"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_route_table.private_rt will be created
  + resource "yandex_vpc_route_table" "private_rt" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + name       = "private-route-table"
      + network_id = (known after apply)

      + static_route {
          + destination_prefix = "0.0.0.0/0"
          + gateway_id         = (known after apply)
            # (1 unchanged attribute hidden)
        }
    }

  # yandex_vpc_route_table.public_rt will be created
  + resource "yandex_vpc_route_table" "public_rt" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + name       = "public-route-table"
      + network_id = (known after apply)

      + static_route {
          + destination_prefix = "0.0.0.0/0"
          + gateway_id         = (known after apply)
            # (1 unchanged attribute hidden)
        }
    }

  # yandex_vpc_security_group.bastion_sg will be created
  + resource "yandex_vpc_security_group" "bastion_sg" {
      + created_at  = (known after apply)
      + description = "Security group for bastion server. Allows SSH (22) from any."
      + folder_id   = (known after apply)
      + id          = (known after apply)
      + labels      = (known after apply)
      + name        = "bastion-security-group"
      + network_id  = (known after apply)
      + status      = (known after apply)

      + egress {
          + description       = "Allow all outgoing traffic"
          + from_port         = -1
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = -1
          + protocol          = "TCP"
          + to_port           = -1
          + v4_cidr_blocks    = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }

      + ingress {
          + description       = "Allow SSH"
          + from_port         = -1
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = 22
          + protocol          = "TCP"
          + to_port           = -1
          + v4_cidr_blocks    = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }
    }

  # yandex_vpc_security_group.web_sg will be created
  + resource "yandex_vpc_security_group" "web_sg" {
      + created_at  = (known after apply)
      + description = "Security group for web servers. Allows HTTP (80), HTTPS (443), and SSH (22) from bastion."
      + folder_id   = (known after apply)
      + id          = (known after apply)
      + labels      = (known after apply)
      + name        = "web-security-group"
      + network_id  = (known after apply)
      + status      = (known after apply)

      + egress {
          + description       = "Allow all outgoing traffic"
          + from_port         = -1
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = -1
          + protocol          = "TCP"
          + to_port           = -1
          + v4_cidr_blocks    = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }

      + ingress {
          + description       = "Allow HTTP"
          + from_port         = -1
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = 80
          + protocol          = "TCP"
          + to_port           = -1
          + v4_cidr_blocks    = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }
      + ingress {
          + description       = "Allow HTTPS"
          + from_port         = -1
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = 443
          + protocol          = "TCP"
          + to_port           = -1
          + v4_cidr_blocks    = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }
      + ingress {
          + description       = "Allow SSH from bastion"
          + from_port         = -1
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = 22
          + protocol          = "TCP"
          + to_port           = -1
          + v4_cidr_blocks    = (known after apply)
          + v6_cidr_blocks    = []
            # (2 unchanged attributes hidden)
        }
    }

  # yandex_vpc_subnet.private-subnet-1 will be created
  + resource "yandex_vpc_subnet" "private-subnet-1" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "private-subnet-1"
      + network_id     = (known after apply)
      + route_table_id = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.2.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-b"
    }

  # yandex_vpc_subnet.private-subnet-2 will be created
  + resource "yandex_vpc_subnet" "private-subnet-2" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "private-subnet-2"
      + network_id     = (known after apply)
      + route_table_id = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.3.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-d"
    }

  # yandex_vpc_subnet.public-subnet will be created
  + resource "yandex_vpc_subnet" "public-subnet" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "public-subnet"
      + network_id     = (known after apply)
      + route_table_id = (known after apply)
      + v4_cidr_blocks = [
          + "10.0.1.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 16 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_vm_1 = (known after apply)
  + internal_ip_address_vm_1 = (known after apply)
  + internal_ip_address_vm_2 = (known after apply)
  + internal_ip_address_vm_3 = (known after apply)

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

Вывод команды ```terraform apply```:

```
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

yandex_vpc_gateway.nat_gateway: Creating...
yandex_compute_disk.boot-disk-1: Creating...
yandex_compute_disk.boot-disk-2: Creating...
yandex_vpc_network.network-1: Creating...
yandex_compute_disk.boot-disk-3: Creating...
yandex_vpc_gateway.internet_gateway: Creating...
yandex_vpc_gateway.internet_gateway: Creation complete after 2s [id=enpkq1qpd5gr8udtl6k6]
yandex_vpc_gateway.nat_gateway: Creation complete after 3s [id=enpkq129lm085han42oa]
yandex_vpc_network.network-1: Creation complete after 4s [id=enpkavko5p24362qmi7n]
yandex_vpc_route_table.public_rt: Creating...
yandex_vpc_route_table.private_rt: Creating...
yandex_vpc_security_group.bastion_sg: Creating...
yandex_vpc_route_table.private_rt: Creation complete after 1s [id=enpm6shic2brouutluol]
yandex_vpc_subnet.private-subnet-2: Creating...
yandex_vpc_subnet.private-subnet-1: Creating...
yandex_vpc_route_table.public_rt: Creation complete after 2s [id=enp9g774aa3h1ahu99os]
yandex_vpc_subnet.public-subnet: Creating...
yandex_vpc_subnet.private-subnet-2: Creation complete after 2s [id=fl8dr6qr2p0d0bfh619a]
yandex_vpc_security_group.bastion_sg: Creation complete after 3s [id=enp7m86r579j4ptg9plk]
yandex_vpc_subnet.private-subnet-1: Creation complete after 2s [id=e2lsc92iq9pcgrfveub2]
yandex_vpc_subnet.public-subnet: Creation complete after 2s [id=e9bc7f6c8o93i7cjgffk]
yandex_compute_disk.boot-disk-2: Creation complete after 8s [id=epdomkfpejmofqg844n8]
yandex_compute_disk.boot-disk-1: Still creating... [10s elapsed]
yandex_compute_disk.boot-disk-3: Still creating... [10s elapsed]
yandex_compute_disk.boot-disk-3: Creation complete after 14s [id=fv4506mlkjovn5933d9q]
yandex_compute_disk.boot-disk-1: Creation complete after 15s [id=fhmvp1ijcs45vpa5l9sr]
yandex_compute_instance.vm-1: Creating...
yandex_compute_instance.vm-1: Still creating... [10s elapsed]
yandex_compute_instance.vm-1: Still creating... [20s elapsed]
yandex_compute_instance.vm-1: Still creating... [30s elapsed]
yandex_compute_instance.vm-1: Creation complete after 36s [id=fhmlci9jr6eoe4oec5qc]
yandex_vpc_security_group.web_sg: Creating...
yandex_vpc_security_group.web_sg: Creation complete after 9s [id=enp2ie7ck1ce0jc2spl3]
yandex_compute_instance.vm-3: Creating...
yandex_compute_instance.vm-2: Creating...
yandex_compute_instance.vm-2: Still creating... [10s elapsed]
yandex_compute_instance.vm-3: Still creating... [10s elapsed]
yandex_compute_instance.vm-3: Still creating... [20s elapsed]
yandex_compute_instance.vm-2: Still creating... [20s elapsed]
yandex_compute_instance.vm-2: Creation complete after 26s [id=epdbhghptkh850shgilc]
yandex_compute_instance.vm-3: Creation complete after 28s [id=fv424odhkep2kedrde1d]

Apply complete! Resources: 16 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_vm_1 = "89.169.154.248"
internal_ip_address_vm_1 = "10.0.1.31"
internal_ip_address_vm_2 = "10.0.2.31"
internal_ip_address_vm_3 = "10.0.3.3"
```

После развертывания инфраструктуры terraform'ом, он сразу же выдает такие выходные данные как IP-адреса:

```
external_ip_address_vm_1 = "89.169.154.248"  # Внешний IP-адрес Бастион - сервера 
internal_ip_address_vm_1 = "10.0.1.31"  #   # Внутренний IP-адрес Бастион - сервера 
internal_ip_address_vm_2 = "10.0.2.31"  #   # Внутренний IP-адрес WEB - сервера 1
internal_ip_address_vm_3 = "10.0.3.3"  #   # Внутренний IP-адрес WEB - сервера 2
```

> Важно: Если использовать загрузочные образы от Yandex Cloud'а, то в данном случае логин по умолчанию будет - ubuntu. А доступ предоставляется только по SSH ключу, представленный в коде Terraform в блоке ```METADATA```.

## Тестовое подключение по SSH через Бастион - сервер

Из вывода команды ```ssh ubuntu@89.169.154.248``` видно, что доступ к бастион - серверу есть:

```
bulatahmadeev@MBP-Bulat terraform-project % ssh ubuntu@89.169.154.248
The authenticity of host '89.169.154.248 (89.169.154.248)' can't be established.
ED25519 key fingerprint is SHA256:YeGTMZYT3sDB5Y+WKdkvYqCR9yENk4p1w8297fiPIns.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '89.169.154.248' (ED25519) to the list of known hosts.
Welcome to Ubuntu 24.04.1 LTS (GNU/Linux 6.8.0-45-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Wed Oct  2 06:31:16 AM UTC 2024

  System load:  0.0               Processes:             136
  Usage of /:   28.6% of 9.76GB   Users logged in:       0
  Memory usage: 22%               IPv4 address for eth0: 10.0.1.21
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

18 updates can be applied immediately.
7 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@bastion:~$ 
```

Ниже покажу что доступ по SSH к WEB - серверам через Бастион - сервер и по FGDN - имени также имеется:

```
bulatahmadeev@MBP-Bulat terraform-project % ssh -J ubuntu@89.169.154.248 ubuntu@web-1
The authenticity of host 'web-1 (<no hostip for proxy command>)' can't be established.
ED25519 key fingerprint is SHA256:2QjDlGBzw5pDTqGBLhk8VD6Ty3EeMa3xlJoqPzW4wmM.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'web-1' (ED25519) to the list of known hosts.
Welcome to Ubuntu 24.04.1 LTS (GNU/Linux 6.8.0-45-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Wed Oct  2 06:46:19 AM UTC 2024

  System load:  0.0               Processes:             135
  Usage of /:   28.5% of 9.76GB   Users logged in:       0
  Memory usage: 9%                IPv4 address for eth0: 10.0.2.31
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

18 updates can be applied immediately.
7 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@web-1:~$ 





bulatahmadeev@MBP-Bulat terraform-project % ssh -J ubuntu@89.169.154.248 ubuntu@web-2
The authenticity of host 'web-2 (<no hostip for proxy command>)' can't be established.
ED25519 key fingerprint is SHA256:jH0iFJB6IvdkqO4v/HcYFcP/f2WZDqEA6j7y1HBMrJo.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'web-2' (ED25519) to the list of known hosts.
Welcome to Ubuntu 24.04.1 LTS (GNU/Linux 6.8.0-45-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Wed Oct  2 06:46:41 AM UTC 2024

  System load:  0.0               Processes:             133
  Usage of /:   28.4% of 9.76GB   Users logged in:       0
  Memory usage: 10%               IPv4 address for eth0: 10.0.3.33
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

18 updates can be applied immediately.
7 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@web-2:~$ 
```

Чтобы легче было взаимодействовать с сервисами за бастион - сервером, я настраиваю свой config файл для SSH подключений

```~/.ssh/config```:
```
# Для Нетологии
Host bastion
    HostName 89.169.154.248
    User ubuntu
    IdentityFile ~/.ssh/id_rsa

Host web-1
    HostName web-1
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
    ProxyJump bastion

Host web-2
    HostName web-2
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
    ProxyJump bastion
```

Проверка подключения:

```
bulatahmadeev@MBP-Bulat ~ % ssh web-1
Welcome to Ubuntu 24.04.1 LTS (GNU/Linux 6.8.0-45-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Sat Oct  5 06:36:33 PM UTC 2024

  System load:  0.6               Processes:             142
  Usage of /:   28.4% of 9.76GB   Users logged in:       0
  Memory usage: 11%               IPv4 address for eth0: 10.0.2.11
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

18 updates can be applied immediately.
7 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@web-1:~$
```

### Ниже показываю созданную инфраструктуру в Yandex Cloud.

> ВАЖНО! IP - адреса могут различаться в картинках и в тексте, так как я создавал несколько раз машины.

![alt text](<images/Снимок экрана 2024-10-02 в 19.12.07.png>)

![alt text](<images/Снимок экрана 2024-10-02 в 19.12.52.png>)

![alt text](<images/Снимок экрана 2024-10-02 в 19.13.36.png>)

![alt text](<images/Снимок экрана 2024-10-02 в 19.14.07.png>)

![alt text](<images/Снимок экрана 2024-10-02 в 19.14.40.png>)

![alt text](<images/Снимок экрана 2024-10-02 в 19.15.02.png>)

![alt text](<images/Снимок экрана 2024-10-02 в 19.15.30.png>)

Чуть позже добавил Application Load Balancer через Terraform:

![alt text](<images/Снимок экрана 2024-10-11 в 20.29.02.png>)

## Настройка NGINX с помощью Ansible

Код Ansible:

* **[inventory_file](ansible-code/Site/inventory_file)** - Настройка подключения по группам хостов или по отдельным хостам

* **[add_new_user.yml](ansible-code/Site/add_new_user.yml)** - Playbook для добавления нового пользователя (Этот пользователь будет использоваться для подключения проверяющим экспертом)

* **[setup_nginx_for_web-1.yml](ansible-code/Site/setup_nginx_for_web-1.yml)** - Playbook для установки NGINX в web-1

* **[setup_nginx_for_web-2.yml](ansible-code/Site/setup_nginx_for_web-2.yml)** - Playbook для установки NGINX в web-2

* **[web1_template.html.j2](ansible-code/Site/web1_template.html.j2)** - Шаблон для web-1

* **[web2_template.html.j2](ansible-code/Site/web2_template.html.j2)** - Шаблон для web-2

Вывод работы Playbook'ов:

```
bulatahmadeev@MBP-Bulat ansible-project % ansible-playbook -i inventory_file add_new_user.yml
[WARNING]: Invalid characters were found in group names but not replaced, use -vvvv to see details
[WARNING]: Found both group and host with same name: web-2
[WARNING]: Found both group and host with same name: web-1
[WARNING]: Found both group and host with same name: bastion

PLAY [Add audit_user with sudo privileges and set SSH key] ******************************************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************************************************************************************************************************************************
[WARNING]: Platform linux on host bastion is using the discovered Python interpreter at /usr/bin/python3.12, but future installation of another Python interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-core/2.17/reference_appendices/interpreter_discovery.html for more
information.
ok: [bastion]
[WARNING]: Platform linux on host web-2 is using the discovered Python interpreter at /usr/bin/python3.12, but future installation of another Python interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-core/2.17/reference_appendices/interpreter_discovery.html for more information.
ok: [web-2]
[WARNING]: Platform linux on host web-1 is using the discovered Python interpreter at /usr/bin/python3.12, but future installation of another Python interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-core/2.17/reference_appendices/interpreter_discovery.html for more information.
ok: [web-1]

TASK [Ensure the user audit_user exists] ************************************************************************************************************************************************************************************************************************************************************************************
changed: [bastion]
changed: [web-1]
changed: [web-2]

TASK [Set authorized key for the user audit_user] ***************************************************************************************************************************************************************************************************************************************************************************
changed: [bastion]
changed: [web-1]
changed: [web-2]

PLAY RECAP ******************************************************************************************************************************************************************************************************************************************************************************************************************
bastion                    : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
web-1                      : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
web-2                      : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

bulatahmadeev@MBP-Bulat ansible-project % ansible-playbook -i inventory_file setup_nginx_for_web-1.yml setup_nginx_for_web-2.yml 
[WARNING]: Invalid characters were found in group names but not replaced, use -vvvv to see details
[WARNING]: Found both group and host with same name: bastion
[WARNING]: Found both group and host with same name: web-1
[WARNING]: Found both group and host with same name: web-2

PLAY [Setup user and deploy web pages with NGINX on Ubuntu] *****************************************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************************************************************************************************************************************************
[WARNING]: Platform linux on host web-1 is using the discovered Python interpreter at /usr/bin/python3.12, but future installation of another Python interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-core/2.17/reference_appendices/interpreter_discovery.html for more information.
ok: [web-1]

TASK [Update apt package index] *********************************************************************************************************************************************************************************************************************************************************************************************
changed: [web-1]

TASK [Install NGINX] ********************************************************************************************************************************************************************************************************************************************************************************************************
changed: [web-1]

TASK [Start and enable NGINX service] ***************************************************************************************************************************************************************************************************************************************************************************************
ok: [web-1]

TASK [Create web page for web-1] ********************************************************************************************************************************************************************************************************************************************************************************************
changed: [web-1]

PLAY RECAP ******************************************************************************************************************************************************************************************************************************************************************************************************************
web-1                      : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   


PLAY [Setup user and deploy web pages with NGINX on Ubuntu] *****************************************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************************************************************************************************************************************************
[WARNING]: Platform linux on host web-2 is using the discovered Python interpreter at /usr/bin/python3.12, but future installation of another Python interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-core/2.17/reference_appendices/interpreter_discovery.html for more information.
ok: [web-2]

TASK [Update apt package index] *********************************************************************************************************************************************************************************************************************************************************************************************
changed: [web-2]

TASK [Install NGINX] ********************************************************************************************************************************************************************************************************************************************************************************************************
changed: [web-2]

TASK [Start and enable NGINX service] ***************************************************************************************************************************************************************************************************************************************************************************************
ok: [web-2]

TASK [Create web page for web-2] ********************************************************************************************************************************************************************************************************************************************************************************************
changed: [web-2]

PLAY RECAP ******************************************************************************************************************************************************************************************************************************************************************************************************************
web-1                      : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
web-2                      : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

Для начала проверил подключение с помощью нового пользователя ```audit_user```.

Для удобства тестов я изменил свой ```config``` файл в ```.ssh```:

```
# Для Нетологии
Host bastion
    HostName 89.169.154.248
    User ubuntu
    IdentityFile ~/.ssh/id_rsa

Host web-1
    HostName web-1
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
    ProxyJump bastion

Host web-2
    HostName web-2
    User ubuntu
    IdentityFile ~/.ssh/id_rsa
    ProxyJump bastion

Host bastion-audit
    HostName 89.169.154.248
    User audit_user
    IdentityFile ~/.ssh/diplom-netology

Host web-1-audit
    HostName web-1
    User audit_user
    IdentityFile ~/.ssh/diplom-netology
    ProxyJump bastion

Host web-2-audit
    HostName web-2
    User audit_user
    IdentityFile ~/.ssh/diplom-netology
    ProxyJump bastion
```

Вывод терминала:

```
bulatahmadeev@MBP-Bulat ~ % ssh bastion-audit
Welcome to Ubuntu 24.04.1 LTS (GNU/Linux 6.8.0-45-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Wed Oct 16 07:43:26 PM UTC 2024

  System load:  0.0               Processes:             134
  Usage of /:   28.8% of 9.76GB   Users logged in:       0
  Memory usage: 24%               IPv4 address for eth0: 10.0.1.31
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

15 updates can be applied immediately.
1 of these updates is a standard security update.
To see these additional updates run: apt list --upgradable

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


*** System restart required ***
Last login: Wed Oct 16 19:19:55 2024 from 79.132.138.157
audit_user@bastion:~$ exit
logout
Connection to 89.169.154.248 closed.
bulatahmadeev@MBP-Bulat ~ % ssh web-1-audit  
Welcome to Ubuntu 24.04.1 LTS (GNU/Linux 6.8.0-45-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Wed Oct 16 07:43:38 PM UTC 2024

  System load:  0.08              Processes:             138
  Usage of /:   28.8% of 9.76GB   Users logged in:       0
  Memory usage: 16%               IPv4 address for eth0: 10.0.2.31
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

14 updates can be applied immediately.
1 of these updates is a standard security update.
To see these additional updates run: apt list --upgradable

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


*** System restart required ***
Last login: Wed Oct 16 19:16:58 2024 from 10.0.1.31
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

audit_user@web-1:~$ ^C
audit_user@web-1:~$ exit
logout
Connection to web-1 closed.
bulatahmadeev@MBP-Bulat ~ % ssh web-2-audit
Welcome to Ubuntu 24.04.1 LTS (GNU/Linux 6.8.0-45-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Wed Oct 16 07:43:46 PM UTC 2024

  System load:  0.0               Processes:             140
  Usage of /:   28.8% of 9.76GB   Users logged in:       0
  Memory usage: 17%               IPv4 address for eth0: 10.0.3.3
  Swap usage:   0%

 * Strictly confined Kubernetes makes edge and IoT secure. Learn how MicroK8s
   just raised the bar for easy, resilient and secure K8s cluster deployment.

   https://ubuntu.com/engage/secure-kubernetes-at-the-edge

Expanded Security Maintenance for Applications is not enabled.

14 updates can be applied immediately.
1 of these updates is a standard security update.
To see these additional updates run: apt list --upgradable

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


*** System restart required ***
Last login: Wed Oct 16 19:16:58 2024 from 10.0.1.31
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

audit_user@web-2:~$ exit
logout
Connection to web-2 closed.
```

Далее я проверил с помощью ```curl -v 51.250.38.56```:

```
bulatahmadeev@MBP-Bulat ansible-project % curl -v 51.250.38.56
*   Trying 51.250.38.56:80...
* Connected to 51.250.38.56 (51.250.38.56) port 80
> GET / HTTP/1.1
> Host: 51.250.38.56
> User-Agent: curl/8.7.1
> Accept: */*
> 
* Request completely sent off
< HTTP/1.1 200 OK
< server: ycalb
< date: Wed, 16 Oct 2024 19:51:22 GMT
< content-type: text/html
< content-length: 119
< last-modified: Wed, 16 Oct 2024 19:30:04 GMT
< etag: "6710143c-77"
< accept-ranges: bytes
< 
<html>
<head><title>Web-2 Page</title></head>
<body>
<h1>Host: web-2</h1>
<p>Internal IP: 10.0.3.3</p>
</body>
</html>
* Connection #0 to host 51.250.38.56 left intact
bulatahmadeev@MBP-Bulat ansible-project % curl -v 51.250.38.56
*   Trying 51.250.38.56:80...
* Connected to 51.250.38.56 (51.250.38.56) port 80
> GET / HTTP/1.1
> Host: 51.250.38.56
> User-Agent: curl/8.7.1
> Accept: */*
> 
* Request completely sent off
< HTTP/1.1 200 OK
< server: ycalb
< date: Wed, 16 Oct 2024 19:51:27 GMT
< content-type: text/html
< content-length: 120
< last-modified: Wed, 16 Oct 2024 19:29:34 GMT
< etag: "6710141e-78"
< accept-ranges: bytes
< 
<html>
<head><title>Web-1 Page</title></head>
<body>
<h1>Host: web-1</h1>
<p>Internal IP: 10.0.2.31</p>
</body>
</html>
* Connection #0 to host 51.250.38.56 left intact
```

В браузере:

![alt text](<images/Снимок экрана 2024-10-16 в 22.31.32.png>)

![alt text](<images/Снимок экрана 2024-10-16 в 22.31.41.png>)

### Следующий раздел: [Мониторинг](Monitoring.md)

### Предыдущий раздел: [Первоначальное действие](Initial-Actions.md)

### [Главная](README.md)