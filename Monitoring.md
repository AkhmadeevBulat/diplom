# Постановка задачи

## Требования к разделу Мониторинг:

1. Создать ВМ и развернуть на нем Zabbix.

2. На каждую ВМ установить Zabbix Agent.

3. Настроить агенты на отправление метрик в Zabbix.

4. Настроить дешборды с отображением метрик, минимальный набор — по принципу USE (Utilization, Saturation, Errors) для CPU, RAM, диски, сеть, http запросов к веб-серверам.

5. Добавить необходимые tresholds на соответствующие графики.

# Выполнение раздела Мониторинг

Для удобства я разделил код Terraform и Ansible по разделам, чтобы можно было увидеть прогресс из раздела в раздел. В данном случае, для раздела ```"Мониторинг"``` - ```terraform-code/Monitoring/``` и ```ansible-code/Monitoring```.

Для удобства я также разделил код Terraform и Ansible на состовляющее, чтобы можно было легко и удобно править код. Объяснение в самом коде.

> ВАЖНО! Было принято решение, что я больше не буду показывать полный вывод терминала после выполнения команд, так как демонстрация работы уже занимает большое количество пространтсва в документе.

## Terraform

Код Terraform на момент выполнения раздела Мониторинг:

* **[provider.tf](terraform-code/Monitoring/provider.tf)** - Настройки провайдера;

* **[boot-disk.tf](terraform-code/Monitoring/boot-disk.tf)** - Настройки загрузочных дисков;

* **[network.tf](terraform-code/Monitoring/network.tf)** - Настройки сети;

* **[interfaces.tf](terraform-code/Monitoring/interfaces.tf)** - Настройки подключенных интерфесов;

* **[firewall.tf](terraform-code/Monitoring/firewall.tf)** - Настройки группы безопасности

* **[bastion.tf](terraform-code/Monitoring/bastion.tf)** - Настройки Бастион - сервера

* **[web-1.tf](terraform-code/Monitoring/web-1.tf)** - Настройки WEB - сервера 1

* **[web-2.tf](terraform-code/Monitoring/web-2.tf)** - Настройки WEB - сервера 2

* **[app-load-balancer.tf](terraform-code/Monitoring/app-load-balancer.tf)** - Настройки Application Load Balancer'а

* **[zabbix.tf](terraform-code/Monitoring/zabbix.tf)** - Настройки Zabbix - сервера

Из изменений в коде Terraform на момент выполнения раздела Мониторинг:

* В ```boot-disk.tf``` - Был добавлен новый диск для сервера Zabbix

* В ```interfaces.tf``` - Был добавлен интерфейс для сервера Zabbix

* В ```firewall.tf``` - Были добавлены новые правила для Zabbix и скорректированы правила для остальных машин

* В ```app-load-balancer.tf``` - Былы добавлены новые ```target group```, ```backend group```, ```HTTP route``` и ```прослушиватель``` для сервера Zabbix

* Был создан новый файл ```zabbix.tf```, который описывает настройки Zabbix сервера

## Ansible

Код Ansible на момент выполнения раздела Мониторинг:

* **[inventory_file](ansible-code/Monitoring/inventory_file)** - Настройка подключения по группам хостов или по отдельным хостам

* **[add_new_user.yml](ansible-code/Monitoring/add_new_user.yml)** - Playbook для добавления нового пользователя (Этот пользователь будет использоваться для подключения проверяющим экспертом)

* **[setup_nginx_for_web-1.yml](ansible-code/Monitoring/setup_nginx_for_web-1.yml)** - Playbook для установки NGINX в web-1

* **[setup_nginx_for_web-2.yml](ansible-code/Monitoring/setup_nginx_for_web-2.yml)** - Playbook для установки NGINX в web-2

* **[web1_template.html.j2](ansible-code/Monitoring/web1_template.html.j2)** - Шаблон для web-1

* **[web2_template.html.j2](ansible-code/Monitoring/web2_template.html.j2)** - Шаблон для web-2

* **[docker-compose-zabbix.yml](ansible-code/Monitoring/docker-compose-zabbix.yml)** - docker compose файл для установки PostgreSQL, Zabbix Server и Zabbix WEB

* **[setup_zabbix_agents.yml](ansible-code/Monitoring/setup_zabbix_agents.yml)** - Playbook для установки Zabbix Agent

* **[setup_zabbix_server.yml](ansible-code/Monitoring/setup_zabbix_server.yml)** - Playbook для установки Zabbix Server

# Равертывание

После выполнения Terraform и Ansible кода:

1. Была развернута виртуальная машина Zabbix:

![alt text](<images/Снимок экрана 2024-10-28 в 14.23.03.png>)

2. Был добавлен слушатель на порту 8080 для Zabbix сервера:

![alt text](<images/Снимок экрана 2024-10-28 в 14.27.52.png>)

3. Были добавлены правла для входящих и исходящих подключений:

![alt text](<images/Снимок экрана 2024-10-28 в 14.28.50.png>)

4. На всех машинах установлен Zabbix Agent подключенный к Zabbix серверу:

![alt text](<images/Снимок экрана 2024-10-28 в 14.30.06.png>)

![alt text](<images/Снимок экрана 2024-10-28 в 14.30.52.png>)

![alt text](<images/Снимок экрана 2024-10-28 в 14.31.26.png>)

5. На машине Zabbix сервера был установлен, с помощью Ansible, docker и развернут docker compose файл:

![alt text](<images/Снимок экрана 2024-10-28 в 14.33.55.png>)

![alt text](<images/Снимок экрана 2024-10-28 в 14.34.48.png>)

# Настройка Zabbix сервера, дашбордов и трешхолдов

После развертывания Zabbix сервер стал доступен:

![alt text](<images/Снимок экрана 2024-10-28 в 14.46.48.png>)

1. Были добавлены узлы сети:

![alt text](<images/Снимок экрана 2024-10-28 в 14.55.48.png>)

2. Был добавлен триггер для шаблона ```Nginx by Zabbix agent```:

![alt text](<images/Снимок экрана 2024-10-28 в 14.58.41.png>)

3. Была добавлена группа пользователей ```Telegram_group```:

![alt text](<images/Снимок экрана 2024-10-28 в 14.59.56.png>)

4. Был добавлен пользователь ```Telegram_alert``` для оповещения в телеграм группу:

![alt text](<images/Снимок экрана 2024-10-28 в 15.01.02.png>)

5. Активирован способ оповещения:

![alt text](<images/Снимок экрана 2024-10-28 в 15.02.16.png>)

6. Добавлена карта сетей:

![alt text](<images/Снимок экрана 2024-10-28 в 15.03.18.png>)

7. Были добавлены панели для узлов сети:

![alt text](<images/Снимок экрана 2024-10-28 в 15.04.20.png>)

8. Краткий показ панелей (Полностью можно будет посмотреть - [Данные для подключения](DataForAccessingServices.md)):

![alt text](<images/Снимок экрана 2024-10-28 в 15.05.03.png>)

![alt text](<images/Снимок экрана 2024-10-28 в 15.05.24.png>)

9. Создан Телеграм канал для получаения оповещений:

![alt text](<images/Снимок экрана 2024-10-28 в 15.10.20.png>)

С дашбордами, трешхолдами и Telegram группой можно будет ознакомиться - [Данные для подключения](DataForAccessingServices.md)

### Следующий раздел: [Логи](Log.md)

### Предыдущий раздел: [Сайт](Site.md)

### [Главная](README.md)