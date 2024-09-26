# Дипломная работа по профессии «Системный администратор»


### Студент: Булат Ахмадеев

### Проверяющий эксперт: Кирилл Попов

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


