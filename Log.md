# Постановка задачи

## Требования к разделу Логи:

1. Создать ВМ и развернуть на нем Elasticsearch.

2. На каждую ВМ установить Filebeat и настроить их на отправку логов access.log и error.log в Elasticsearch.

3. Создать ВМ и развернуть на нем Kibana, подлкюченный в Elasticsearch.

# Выполнение раздела Логи

Для удобства я разделил код Terraform и Ansible по разделам, чтобы можно было увидеть прогресс из раздела в раздел. В данном случае, для раздела ```"Логи"``` - ```terraform-code/Log/``` и ```ansible-code/Log```.

Для удобства я также разделил код Terraform и Ansible на состовляющее, чтобы можно было легко и удобно править код. Объяснение в самом коде.

## Terraform

Код Terraform на момент выполнения раздела Логи:

* **[provider.tf](terraform-code/Log/provider.tf)** - Настройки провайдера;

* **[boot-disk.tf](terraform-code/Log/boot-disk.tf)** - Настройки загрузочных дисков;

* **[network.tf](terraform-code/Log/network.tf)** - Настройки сети;

* **[interfaces.tf](terraform-code/Log/interfaces.tf)** - Настройки подключенных интерфесов;

* **[firewall.tf](terraform-code/Log/firewall.tf)** - Настройки группы безопасности;

* **[bastion.tf](terraform-code/Log/bastion.tf)** - Настройки Бастион - сервера;

* **[web-1.tf](terraform-code/Log/web-1.tf)** - Настройки WEB - сервера 1;

* **[web-2.tf](terraform-code/Log/web-2.tf)** - Настройки WEB - сервера 2;

* **[app-load-balancer.tf](terraform-code/Log/app-load-balancer.tf)** - Настройки Application Load Balancer'а;

* **[zabbix.tf](terraform-code/Log/zabbix.tf)** - Настройки Zabbix - сервера;

* **[elasticsearch.tf](terraform-code/Log/elasticsearch.tf)** - Настройки Elasticsearch - сервера;

* **[kibana.tf](terraform-code/Log/kibana.tf)** - Настройки Kibana - сервера;

Из изменений в коде Terraform на момент выполнения раздела Логи:

* В ```boot-disk.tf``` - Были добавлены новые диски для серверов Elasticsearch и Kibana;

* В ```interfaces.tf``` - Были добавлены интерфейсы для серверов Elasticsearch и Kibana;

* В ```firewall.tf``` - Были добавлены новые правила для Elasticsearch и Kibana и скорректированы правила для остальных машин;

* В ```app-load-balancer.tf``` - Былы добавлены новые ```target group```, ```backend group```, ```HTTP route``` и ```прослушиватель``` для серверов Elasticsearch и Kibana;

* Были созданы новые файлы ```kibana.tf``` и ```elasticsearch.tf```, которые описывают настройки Elasticsearch и Kibana серверов.

## Ansible

Код Ansible на момент выполнения раздела Логи:

* **[inventory_file](ansible-code/Log/inventory_file)** - Настройка подключения по группам хостов или по отдельным хостам;

* **[add_new_user.yml](ansible-code/Log/add_new_user.yml)** - Playbook для добавления нового пользователя (Этот пользователь будет использоваться для подключения проверяющим экспертом);

* **[setup_nginx_for_web-1.yml](ansible-code/Log/setup_nginx_for_web-1.yml)** - Playbook для установки NGINX в web-1;

* **[setup_nginx_for_web-2.yml](ansible-code/Log/setup_nginx_for_web-2.yml)** - Playbook для установки NGINX в web-2;

* **[web1_template.html.j2](ansible-code/Log/web1_template.html.j2)** - Шаблон для web-1;

* **[web2_template.html.j2](ansible-code/Log/web2_template.html.j2)** - Шаблон для web-2;

* **[docker-compose-zabbix.yml](ansible-code/Log/docker-compose-zabbix.yml)** - docker compose файл для установки PostgreSQL, Zabbix Server и Zabbix WEB;

* **[setup_zabbix_agents.yml](ansible-code/Log/setup_zabbix_agents.yml)** - Playbook для установки Zabbix Agent;

* **[setup_zabbix_server.yml](ansible-code/Log/setup_zabbix_server.yml)** - Playbook для установки Zabbix Server;

* **[setup_elasticsearch-local.yml](ansible-code/Log/setup_elasticsearch-local.yml)** - Playbook для установки Elasticsearch Server;

* **[setup_kibana-local.yml](ansible-code/Log/setup_kibana-local.yml)** - Playbook для установки Kibana Server;

* **[setup_filebeat-local.yml](ansible-code/Log/setup_filebeat-local.yml)** - Playbook для установки Filebeat Server.

# Равертывание

После выполнения Terraform кода, Ansible кода и настройки файлов конфигураций:

1. Были развернуты ВМ Elasticsearch и Kibana:

![alt text](<images/Снимок экрана 2024-11-05 в 20.05.06.png>)

2. Был добавлен слушатель на порту 5601 для Kibana сервера:

![alt text](<images/Снимок экрана 2024-11-05 в 20.06.23.png>)

3. Были добавлены правла для входящих и исходящих подключений:

![alt text](<images/Снимок экрана 2024-11-05 в 20.07.17.png>)

![alt text](<images/Снимок экрана 2024-11-05 в 20.07.36.png>)

4. Kibana интерфейс:

![alt text](<images/Снимок экрана 2024-11-05 в 20.09.23.png>)

На 4-ом скриншоте видно, что от filebeat'ов, развернутых на ВЕБ-серверах, есть метрики, которые присылаются на Elasticsearch, а Kibana их выводит на ВЕБ-интерфейс.

### Следующий раздел: [Данные для подключения](DataForAccessingServices.md)

### Предыдущий раздел: [Мониторинг](Monitoring.md)

### [Главная](README.md)