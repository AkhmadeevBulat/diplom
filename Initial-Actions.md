# Установка Terraform и Ansible

Операционная система на локальной машине - ```macOS```.

Архитектура на локальной машине - ```ARM64```

## Установка Terraform

Для установки ```Terraform``` на операуионную систему ```macOS``` на архитектуре ```ARM64``` нужно скачать установочный файл под arm чипы, либо использовать пакетный менеджер ```brew```. 

По ссылке [Terraform](https://developer.hashicorp.com/terraform/install?product_intent=terraform) можно либо скачать этот установочный файл, либо скопировать команду для пакетного менеджера ```brew```, который позволить установить Terraform.

В моем случае я использовал пакетный менеджер ```brew```. Команда:

```
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

После установки можно проверить корректность установки приложения командой ```terraform -v```.

Вывод терминала:

```
bulatahmadeev@MBP-Bulat ~ % terraform -v

Terraform v1.9.6
on darwin_arm64
```

## Установка Ansible

Для установки ```Ansible``` на операуионную систему ```macOS``` на архитектуре ```ARM64``` нужно использовать пакетный менеджер ```brew```. 

Команда: ```brew install ansible```

После установки можно проверить корректность установки приложения командой ```ansible --version```.

Вывод терминала:

```
bulatahmadeev@MBP-Bulat ~ % ansible --version

ansible [core 2.17.4]
  config file = None
  configured module search path = ['/Users/bulatahmadeev/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /opt/homebrew/Cellar/ansible/10.4.0/libexec/lib/python3.12/site-packages/ansible
  ansible collection location = /Users/bulatahmadeev/.ansible/collections:/usr/share/ansible/collections
  executable location = /opt/homebrew/bin/ansible
  python version = 3.12.6 (main, Sep  6 2024, 19:03:47) [Clang 15.0.0 (clang-1500.3.9.4)] (/opt/homebrew/Cellar/ansible/10.4.0/libexec/bin/python)
  jinja version = 3.1.4
  libyaml = True
```

# Установка и инициализация Yandex Cloud CLI

Команда: ```brew install --cask yandex-cloud-cli```.

Проверка (Вывод терминала):

```
bulatahmadeev@MBP-Bulat ~ % yc --version
Yandex Cloud CLI 0.133.0 darwin/arm64
```

После установки необходимо выполнить инциализацию командой: ```yc init```. После того, как команда была введена в терминале приложение попросить перейти по ссылке для получения OAuth-токена. Далее необходимо выбрать свой аккаунт, а после Yandex Cloud выдаст OAuth-токен (Пример: y0_sdnfjenoewokmkfeffmjdkkv).

Далее приложение попросить выбрать облоко и каталог. В моем случае облоко - ```cloud-bulat-axxxmadeev-netology```, а каталог - ```default```.

Далее приложение попроситвыбрать зону. В моем случае сейчас это ```ru-central1-a```.

### Создание статического ключа для Terraform

Командой ```yc iam service-account create --name terraform-sa --description "Terraform for Netology"``` создал сервисный аккаунт и статический ключ API.

Вывод терминала:

```
bulatahmadeev@MBP-Bulat ~ % yc iam service-account create --name terraform-sa --description "Terraformfor Netology"

done (2s)
id: <id>
folder_id: <folder_id>
created_at: "2024-09-26T16:24:52.855782926Z"
name: terraform-sa
description: Terraformfor Netology
```

Указал для него роль командой:

```
yc resource-manager folder add-access-binding <folder_id> \
    --role editor \
    --subject serviceAccount:<id>
```

Вывод терминала:

```
bulatahmadeev@MBP-Bulat ~ % yc resource-manager folder add-access-binding <folder_id> \
    --role editor \
    --subject serviceAccount:<id>

done (3s)
effective_deltas:
  - action: ADD
    access_binding:
      role_id: editor
      subject:
        id: <id>
        type: serviceAccount
```

Создал IAM-токен для сервисного аккаунта командой: ```yc iam key create --service-account-id <id> --output key.json```. После этого создаться файл key.json, который будет использоваться Terraform для аутентификации в Yandex Cloud, в домашнем каталоге пользователя.

Вывод терминала:

```
bulatahmadeev@MBP-Bulat ~ % cat key.json 
{
   "id": "(Изменено)",
   "service_account_id": "(Изменено)",
   "created_at": "2024-09-26T16:32:33.105422124Z",
   "key_algorithm": "RSA_2048",
   "public_key": "-----BEGIN PUBLIC KEY-----(Изменено)-----END PRIVATE KEY-----\n"
}
```

# Настройка Terraform для работы с Yandex Cloud

В первую очередь я создал папку ```terraform-project```. В ней создал файл ```main.tf```.

Содержимое файла ```main.tf```:

```
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.84"
    }
  }
}

provider "yandex" {
  service_account_key_file = "/Users/bulatahmadeev/key.json"
  cloud_id                 = "(Изменено)"
  folder_id                = "(Изменено)"
  zone                     = "ru-central1-a"
}

resource "yandex_compute_instance" "vm-1" {
  name        = "test-vm"
  platform_id = "standard-v1"  # Тип платформы
  
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "(Изменено)"
    }
  }

  network_interface {
    subnet_id = "(Изменено)"
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
```

В этом файле описывается:

* Какой будет использоваться провайдер;

* Ключ для сервисного аккаунта;

* ID облака, каталога, образа (в данном случае я использовал образ от Yandex Cloud) и подсети;

* Имя машины;

* Сколько ядер и ОЗУ;

* Используемый SSH ключ.

Далее выполнил инициализацию командой ```terraform init```.

Вывод терминала:

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

 Далее выполнил проверку конфигурации командой ```terraform plan```.

 Вывод терминала:

 ```
 bulatahmadeev@MBP-Bulat terraform-project % terraform plan


Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.vm-1 will be created
  + resource "yandex_compute_instance" "vm-1" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + maintenance_grace_period  = (known after apply)
      + maintenance_policy        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa (Изменено) bulatahmadeev@MBP-Bulat.local
            EOT
        }
      + name                      = "test-vm"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8tvc3529h2cpjvpkr5"
              + name        = (known after apply)
              + size        = (known after apply)
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
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
          + subnet_id          = "(Изменено)"
        }

      + placement_policy (known after apply)

      + resources {
          + core_fraction = 100
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
 ```

 Далее принимаю конфигурации командой ```terraforn apply```.

 Вывод терминала:

 ```
Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

yandex_compute_instance.vm-1: Creating...
yandex_compute_instance.vm-1: Still creating... [10s elapsed]
yandex_compute_instance.vm-1: Still creating... [20s elapsed]
yandex_compute_instance.vm-1: Still creating... [30s elapsed]
yandex_compute_instance.vm-1: Still creating... [40s elapsed]
yandex_compute_instance.vm-1: Creation complete after 43s [id=(Изменено)]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
 ```

Можно увидеть, что машина создалась в Yandex Cloud:

![alt text](<images/Снимок экрана 2024-09-28 в 21.56.31.png>)

На этом настройка и тестирование Terraform завершено. Теперь можно удалить ресурсы командой ```terraform destroy```.

Вывод терминала:

```
Plan: 0 to add, 0 to change, 1 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

yandex_compute_instance.vm-1: Destroying... [id=fhmtnqfhpp0lcuf96q2p]
yandex_compute_instance.vm-1: Still destroying... [id=fhmtnqfhpp0lcuf96q2p, 10s elapsed]
yandex_compute_instance.vm-1: Still destroying... [id=fhmtnqfhpp0lcuf96q2p, 20s elapsed]
yandex_compute_instance.vm-1: Still destroying... [id=fhmtnqfhpp0lcuf96q2p, 30s elapsed]
yandex_compute_instance.vm-1: Still destroying... [id=fhmtnqfhpp0lcuf96q2p, 40s elapsed]
yandex_compute_instance.vm-1: Still destroying... [id=fhmtnqfhpp0lcuf96q2p, 50s elapsed]
yandex_compute_instance.vm-1: Still destroying... [id=fhmtnqfhpp0lcuf96q2p, 1m0s elapsed]
yandex_compute_instance.vm-1: Still destroying... [id=fhmtnqfhpp0lcuf96q2p, 1m10s elapsed]
yandex_compute_instance.vm-1: Destruction complete after 1m18s

Destroy complete! Resources: 1 destroyed.
```

### Следующий раздел: [Сайт](Site.md)

### [Главная](README.md)