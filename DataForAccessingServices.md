# Следующие данные нужны для проверки моей работы (Если потребуется)

> Виртуальные машины переведены в статус непрерываемых.

## SSH Подключения

Ко всем ВМ доступ реализовано по SSH ключу: [SSH ключ - ```diplom-netology```](SSH-Key/diplom-netology)

Для удобства проверяющего эксперта, я подготовил ```config``` для SSH подключений:

```
Host bastion-audit
    HostName 51.250.5.238
    User audit_user
    IdentityFile ~/.ssh/diplom-netology

Host web-1-audit
    HostName web-1
    User audit_user
    IdentityFile ~/.ssh/diplom-netology
    ProxyJump bastion-audit

Host web-2-audit
    HostName web-2
    User audit_user
    IdentityFile ~/.ssh/diplom-netology
    ProxyJump bastion-audit

Host zabbix-audit
    Hostname zabbix
    User audit_user
    IdentityFile ~/.ssh/diplom-netology
    ProxyJump bastion-audit

Host elasticsearch-audit
    Hostname elasticsearch
    User audit_user
    IdentityFile ~/.ssh/diplom-netology
    ProxyJump bastion-audit

Host kibana-audit
    Hostname kibana
    User audit_user
    IdentityFile ~/.ssh/diplom-netology
    ProxyJump bastion-audit
```

### Bastion сервер

IP: ```51.250.5.238```

Логин: ```audit_user```

### Web-1 сервер

IP: ```web-1``` (Прыжок через Bastion-сервер)

Логин: ```audit_user```

### Web-2 сервер

IP: ```web-2``` (Прыжок через Bastion-сервер)

Логин: ```audit_user```

### Zabbix сервер

IP: ```zabbix``` (Прыжок через Bastion-сервер)

Логин: ```audit_user```

### Elasticsearch сервер

IP: ```elasticsearch``` (Прыжок через Bastion-сервер)

Логин: ```audit_user```

### Kibana сервер

IP: ```kibana``` (Прыжок через Bastion-сервер)

Логин: ```audit_user```

## Доступ к WEB-ресурсам

### WEB - страницы серверов web-1 и web-2 доступпны по адресу: ```http://51.250.38.56:80```.

### WEB - страница Zabbix сервера доступна по адресу: ```http://51.250.38.56:8080```.

Логин: ```Admin```

Пароль: ```xonda4-kizher-bemkaP```

Ссылка для доступа в телеграм канал (В который приходит Alert'ы от Zabbix): ```https://t.me/+2yeObuZ44j1kODgy```

### WEB - страница Kibana сервера доступна по адресу: ```http://51.250.38.56:5601```.

Логин: ```elastic```

Пароль: ```xd5=BSKQt_vIX9dc0bw7```

