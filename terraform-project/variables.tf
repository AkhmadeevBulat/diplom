# /*----------------------------------------------------------------------------------*/
# /*                            Переменные для provider.tf                            */
# /*----------------------------------------------------------------------------------*/

variable "service_account_key_file" {
  description = "Путь к файлу ключа сервисного аккаунта"
  type        = string
  sensitive   = true  # Чтобы Terraform не выводил значение при применении
}

variable "cloud_id" {
  description = "ID облака Yandex Cloud"
  type        = string
  sensitive   = true  # Чтобы Terraform не выводил значение при применении
}

variable "folder_id" {
  description = "ID папки Yandex Cloud"
  type        = string
  sensitive   = true  # Чтобы Terraform не выводил значение при применении
}

# /*----------------------------------------------------------------------------------*/
# /*                            Переменные для servers.tf                             */
# /*----------------------------------------------------------------------------------*/

# Функция для упрощения ссылок на имя security group
locals {
  security_group_mapping = {
    "bastion_sg"        = yandex_vpc_security_group.bastion_sg.id
    "web_sg"            = yandex_vpc_security_group.web_sg.id
    "zabbix_sg"         = yandex_vpc_security_group.zabbix_sg.id
    "elasticsearch_sg"  = yandex_vpc_security_group.elasticsearch_sg.id
    "kibana_sg"         = yandex_vpc_security_group.kibana_sg.id
  }
}

# Функция для упрощения ссылок на имя subnet
locals {
  subnet_mapping = {
    "public-subnet"  = yandex_vpc_subnet.public-subnet.id
    "private-subnet-1" = yandex_vpc_subnet.private-subnet-1.id
    "private-subnet-2" = yandex_vpc_subnet.private-subnet-2.id
  }
}

variable "servers" {
  description = "Шаблон конфигураций для всех серверов"
  type = map(object({
    name                = string
    hostname            = string
    platform_id         = string
    zone                = string
    cores               = number
    core_fraction       = number
    memory              = number
    image_id            = string
    subnet_id           = string
    preemptible         = bool
    nat                 = bool
    security_group_ids  = list(string)
  }))
  default = {
    "bastion" = {
      name                = "bastion"
      hostname            = "bastion"
      platform_id         = "standard-v2"
      zone                = "ru-central1-a"
      cores               = 2
      core_fraction       = 5
      memory              = 1
      image_id            = "fd8tvc3529h2cpjvpkr5"
      subnet_id           = "public-subnet"
      preemptible         = false
      nat                 = true
      security_group_ids  = ["bastion_sg"]
    },
    "web-1" = {
      name                = "web-1"
      hostname            = "web-1"
      platform_id         = "standard-v2"
      zone                = "ru-central1-b"
      cores               = 2
      core_fraction       = 20
      memory              = 2
      image_id            = "fd8tvc3529h2cpjvpkr5"
      subnet_id           = "private-subnet-1"
      preemptible         = false
      nat                 = false
      security_group_ids  = ["web_sg"]
    },
    "web-2" = {
      name                = "web-2"
      hostname            = "web-2"
      platform_id         = "standard-v2"
      zone                = "ru-central1-d"
      cores               = 2
      core_fraction       = 20
      memory              = 2
      image_id            = "fd8tvc3529h2cpjvpkr5"
      subnet_id           = "private-subnet-2"
      preemptible         = false
      nat                 = false
      security_group_ids  = ["web_sg"]
    },
    "zabbix" = {
      name                = "zabbix"
      hostname            = "zabbix"
      platform_id         = "standard-v2"
      zone                = "ru-central1-a"
      cores               = 2
      core_fraction       = 100
      memory              = 8
      image_id            = "fd8tvc3529h2cpjvpkr5"
      subnet_id           = "public-subnet"
      preemptible         = false
      nat                 = true
      security_group_ids  = ["zabbix_sg"]
    },
    "elasticsearch" = {
      name                = "elasticsearch"
      hostname            = "elasticsearch"
      platform_id         = "standard-v2"
      zone                = "ru-central1-b"
      cores               = 2
      core_fraction       = 50
      memory              = 4
      image_id            = "fd8tvc3529h2cpjvpkr5"
      subnet_id           = "private-subnet-1"
      preemptible         = false
      nat                 = false
      security_group_ids  = ["elasticsearch_sg"]
    },
    "kibana" = {
      name                = "kibana"
      hostname            = "kibana"
      platform_id         = "standard-v2"
      zone                = "ru-central1-a"
      cores               = 2
      core_fraction       = 50
      memory              = 4
      image_id            = "fd8tvc3529h2cpjvpkr5"
      subnet_id           = "public-subnet"
      preemptible         = false
      nat                 = true
      security_group_ids  = ["kibana_sg"]
    }
  }
}
