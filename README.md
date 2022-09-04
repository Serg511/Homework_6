## Homework_6 - реализация кластера postgreSQL с помощью patroni 

Данный Terraform-стенд развертывает следующую конфигурацию:
* 2 виртуальные машины с Nginx, Keepalived
* 3 виртуальные машины с Nginx, PHP-FPM, WordPress
* 3 виртуальные машины для кластера PostgreSQL, etcd, haproxy, Keepalived
* 1 виртуальная машина с iscsi

### Используемые инструменты:

* Git
* Ansible
* Terraform

### Описание файлов Terraform:

* .terraformrc - конфигурация Terraform CLI
* main.tf - описание провайдера
* balancers.tf - описание виртуальных машин для Nginx, Keepalived
* web.tf - описание виртуальных машин для Nginx, PHP-FPM, WordPress
* db.tf - описание виртуальных машин для кластера PostgreSQL, etcd, haproxy, Keepalived
* iscsi.tf - описание виртуальной машины с iscsi
* vpc.tf - описание сетевых настроек
* outputs.tf - вывод IP-адресов созданных виртуальных машин, создание файла инвентаря Ansible, файлов hosts, конфигурационного файла Nginx
* hosts.tpl - шаблон для формирования файла hosts
* inventory.tpl - шаблон для формирования файла инвентаря Ansible
* load_balancer.conf.tpl - шаблон для формирования конфигурационного файла балансировщика в Nginx
* meta.txt - пользовательские метаданные
* terraform.tfvars - значения переменных
* variables.tf - описание типов переменных

### Описание ролей Ansible:

* config-gfs2 - роль для настройки GFS2
* iscsi-client - роль для установки и настройки инициатора iscsi
* iscsi-target - роль для установки и настройки таргета iscsi
* load_balancer -роль для установки и настройки Nginx, Keepalived  
* db - роль для установки и настройки кластера PostgreSQL, etcd, haproxy, Keepalived
* pacemaker - роль для установки и настройки pacemaker
* tune-cluster - роль для создания ресурсов в Pacemaker
* web - роль для установки и настройки Nginx, PHP-FPM
* wp - роль для установки и настройки WordPress

### Порядок запуска:

1. Скопировать данный репозиторий ```git clone <this repo>```
2. Сгенерировать открытый и закрытый ключ для доступа к виртуальной машине ```ssh-keygen``` 
3. Отредактировать файлы ```meta.txt``` и ```terraform.tfvars```
4. Перейти в каталог terraform и последовательно выполнить команды ```terraform init``` ```terraform plan``` ```terraform apply```
5. Перейти в каталог ansible и выполнить команду ```ansible-playbook main.yml```

### Результаты:

1. Просмотр статуса нод кластера etcd ```etcdctl member list```
```js
    5c4b4710adfad5f: name=etcd0 peerURLs=http://db-0:2380 clientURLs=http://db-0:2379 isLeader=true
    5e350f69b446401a: name=etcd1 peerURLs=http://db-1:2380 clientURLs=http://db-1:2379 isLeader=false
    8905def4afd3f723: name=etcd2 peerURLs=http://db-2:2380 clientURLs=http://db-2:2379 isLeader=false
```
2. Просмотр статуса нод кластера PostgreSQL ```patronictl -c /etc/patroni.yml list```
```js
    + Cluster: postgres (7139595961761737702) -----------+
    | Member | Host | Role    | State   | TL | Lag in MB |
    +--------+------+---------+---------+----+-----------+
    | db-0   | db-0 | Leader  | running |  1 |           |
    | db-1   | db-1 | Replica | running |  1 |         0 |
    | db-2   | db-2 | Replica | running |  1 |         0 |
    +--------+------+---------+---------+----+-----------+
```
