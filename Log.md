# Постановка задачи

## Требования к разделу Логи:

1. Создать ВМ и развернуть на нем Elasticsearch.

2. На каждую ВМ установить Filebeat и настроить их на отправку логов access.log и error.log в Elasticsearch.

3. Создать ВМ и развернуть на нем Kibana, подлкюченный в Elasticsearch.

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