# Исправления в соответствии с замечаниями проверяющего эксперта

Было выполнено:

* Отобразить только финальные версии Terraform и Ansible кода;

* Убрал абсолютный путь с файла [provider.tf](terraform-project/provider.tf) и использовал для чувствительных переменных новые файлы - [variables.tf](terraform-project/variables.tf) и [terraform.tfvars](terraform-project/terraform.tfvars_demonstration) (демонстративный)

* Добавил новый файл [servers.tf](terraform-project/servers.tf), в котором описаны все мои ВМ;

* Использовал ```for_each```;

* Добавил автоматический (```dynamic```) Target Group. Теперь все машины, начинающийся с ```web```, будут попадать туда;

* Создал один единый для всех ВЕБ-серверов шаблон;

* Реализовал разными способами автоматическую установку Elasticsearch, Kibana и Filebeat;

* Реализовал создание ```Snapshot'ов``` по расписанию каждый день в 5 утра и с временем жизни в 7 дней;

* Скорректировал оформление дипломной работы.