---
layout: post
title: "Management Volume"
date: 2021-06-03T22:11:38+07:00
lang: docker
categories:
- DevOps
- Docker
- Volume
refs: 
- https://docs.docker.com/engine/reference/commandline/volume/
- https://docs.docker.com/engine/reference/commandline/volume_create/
youtube: HcbqwPWUyRs
comments: true
image_path: /resources/posts/docker/06a-management-volume
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


Hai semuanya, di materi kali ini kita akan membahas tentang Management Volume di Docker. Diantaranya

1. List Volume
2. Create Container with explicit volume
3. Inspecting Volume
4. Cleanup

Sebelum itu, kita lihat dulu dokumentasi dari docker volume dengan perintah berikut:

{% gist page.gist "06a-docker-volume-help.bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker volume --help

Usage:  docker volume COMMAND

Manage volumes

Commands:
  create      Create a volume
  inspect     Display detailed information on one or more volumes
  ls          List volumes
  prune       Remove all unused local volumes
  rm          Remove one or more volumes

Run 'docker volume COMMAND --help' for more information on a command.
```

Ok sekarang kita bahas, satu-persatu

## List Volume

Untuk menampilkan daftar volume kita perlu buat dulu container. Jadi setiap membuat container biasanya akan menggunakan volume yang berbeda2, Berikut contohnya:

For Bash script:

{% gist page.gist "06a-docker-container-create.bash" %}

For Powershell:

{% gist page.gist "06a-docker-container-create.ps1" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker container run `
>> --name postgresdb `
>> -e POSTGRES_PASSWORD=password `
>> -d postgres:12.6 | `
>> docker container run `
>> --name webapp `
>> -p 80:80 `
>> -d nginx | `
>> docker container run `
>> -e MYSQL_ROOT_PASSWORD=password `
>> --name mysqldb `
>> -d mysql:5.7

d9e7b6ed7b4878a3afebd41fcf400e17e47b95d7345bf375c8339e8703376053

➜ ~  docker container ls
CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS          PORTS                               NAMES
5394eeae3424   mysql:5.7       "docker-entrypoint.s…"   6 seconds ago    Up 6 seconds    3306/tcp, 33060/tcp                 mysqldb
d9e7b6ed7b48   nginx           "/docker-entrypoint.…"   11 minutes ago   Up 11 minutes   0.0.0.0:80->80/tcp, :::80->80/tcp   webapp
641e76fb0e77   postgres:12.6   "docker-entrypoint.s…"   11 minutes ago   Up 11 minutes   5432/tcp                            postgresdb
```

Untuk menampilkan daftar volume, kita bisa menggunakan perintah seperti berikut:

{% gist page.gist "06a-docker-volume-list.bash" %}

Jika kita jalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker volume ls
DRIVER    VOLUME NAME
local     e8b3d53fb7fd47ea837b3418c7887234d2e733d390b9caf731decfdb4e7a85e1
local     e472af0272368e4b34d84874110e7f595512ec2936e108535bcf14d3e30ebdf7

➜ ~  docker container inspect webapp postgresdb mysqldb -f '{% raw %}{{ .Name }} => {{json .Mounts}}{% endraw %}'
/webapp => []
/postgresdb => [{"Type":"volume","Name":"e8b3d53fb7fd47ea837b3418c7887234d2e733d390b9caf731decfdb4e7a85e1","Source":"/var/lib/docker/volumes/e8b3d53fb7fd47ea837b3418c7887234d2e733d390b9caf731decfdb4e7a85e1/_data","Destination":"/var/lib/postgresql/data","Driver":"local","Mode":"","RW":true,"Propagation":""}]
/mysqldb => [{"Type":"volume","Name":"e472af0272368e4b34d84874110e7f595512ec2936e108535bcf14d3e30ebdf7","Source":"/var/lib/docker/volumes/e472af0272368e4b34d84874110e7f595512ec2936e108535bcf14d3e30ebdf7/_data","Destination":"/var/lib/mysql","Driver":"local","Mode":"","RW":true,"Propagation":""}]
```

## Create Container with explicit volume

Untuk membuat volume, kita bisa menggunakan perintah `create` atau untuk lebih jelasnya kita bisa lihat dokumentasinya dengan perintah seperti berikut

{% gist page.gist "06a-docker-volume-create-help.bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker volume create --help

Usage:  docker volume create [OPTIONS] [VOLUME]

Create a volume

Options:
  -d, --driver string   Specify volume driver name (default "local")
      --label list      Set metadata for a volume
  -o, --opt map         Set driver specific options (default map[])
```

Berikut adalah contoh simple untuk membuat volume:

For Bash script:

{% gist page.gist "06a-docker-volume-create.bash" %}

For Powershell:

{% gist page.gist "06a-docker-volume-create.ps1" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker volume create pgdata_volume `
>> -d local `
>> --label app=database
pgdata_volume

➜ ~  docker volume ls -f label='app=database'
DRIVER    VOLUME NAME
local     pgdata_volume
```

Kemudian untuk menggunakan volume yang telah kita gunakan, kita perlu lihat dulu image yang ingin kita gunakan sebagai contohnya misalnya [postgres](https://hub.docker.com/_/postgres) yang menggunakan volume dan juga berikut adalah dimana lokasi data store `/var/lib/postgresql/data`. Sekarang kita akan membuat containernya dengan volume tersebut.

For Bash script:

{% gist page.gist "06a-docker-container-explicit-volume.bash" %}

For Powershell script:

{% gist page.gist "06a-docker-container-explicit-volume.ps1" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker container run `
>> --name postgresdb-with-volume `
>> -v pgdata_volume:/var/lib/postgresql/data `
>> -e POSTGRES_PASSWORD=password `
>> -d postgres:12.6
b52a32220e8b70fae480b386c1b02dc22ccdb81b5c815f644e77746792ab6b90

➜ ~  docker container ls -f ancestor=postgres:12.6
CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS          PORTS      NAMES
b52a32220e8b   postgres:12.6   "docker-entrypoint.s…"   2 minutes ago    Up 2 minutes    5432/tcp   postgresdb-with-volume
5a6e4fc50231   postgres:12.6   "docker-entrypoint.s…"   22 minutes ago   Up 22 minutes   5432/tcp   postgresdb

➜ ~  docker container inspect postgresdb-with-volume postgresdb -f '{% raw %}{{ .Name }} => {{json .Mounts}}{% endraw %}'
/postgresdb-with-volume => [{"Type":"volume","Name":"pgdata_volume","Source":"/var/lib/docker/volumes/pgdata_volume/_data","Destination":"/var/lib/postgresql/data","Driver":"local","Mode":"z","RW":true,"Propagation":""}]
/postgresdb => [{"Type":"volume","Name":"e8b3d53fb7fd47ea837b3418c7887234d2e733d390b9caf731decfdb4e7a85e1","Source":"e8b3d53fb7fd47ea837b3418c7887234d2e733d390b9caf731decfdb4e7a85e1","Destination":"/var/lib/postgresql/data","Driver":"local","Mode":"z","RW":true,"Propagation":""}]

➜ ~  docker exec -it -u postgres postgresdb-with-volume psql
psql (12.6 (Debian 12.6-1.pgdg100+1))
Type "help" for help.

postgres=# create user exampledb with superuser login password 'password';
CREATE ROLE
postgres=# create database exampledb with owner exampledb;
CREATE DATABASE
postgres=# \c exampledb
You are now connected to database "exampledb" as user "postgres".
exampledb=# \l
                                 List of databases
   Name    |   Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+-----------+----------+------------+------------+-----------------------
 exampledb | exampledb | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | postgres  | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres  | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |           |          |            |            | postgres=CTc/postgres
 template1 | postgres  | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |           |          |            |            | postgres=CTc/postgres
(4 rows)

exampledb=# create table example_table(
exampledb(# id varchar(64) primary key,
exampledb(# nama varchar(100) not null);
CREATE TABLE
exampledb=# insert into example_table values ('01', 'Dimas Maryanto');
INSERT 0 1
exampledb=# select * from example_table;
 id |      nama
----+----------------
 01 | Dimas Maryanto
(1 row)

exampledb=# \q

➜ ~  docker container rm -f postgresdb-with-volume postgresdb2
postgresdb-with-volume
postgresdb2

➜ ~  docker container ls -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

➜ ~  docker volume ls
DRIVER    VOLUME NAME
local     e8b3d53fb7fd47ea837b3418c7887234d2e733d390b9caf731decfdb4e7a85e1
local     pgdata_volume

➜ ~  docker container run `
>> --name postgresdb-with-exist-volume `
>> -v pgdata_volume:/var/lib/postgresql/data `
>> -e POSTGRES_PASSWORD=password `
>> -d postgres:12.6
c07cf3b8f01e90efff50a71650885bd3da6d1cb05a581d7638e03ca79c3591e1

➜ ~  docker container ls
CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS          PORTS      NAMES
c07cf3b8f01e   postgres:12.6   "docker-entrypoint.s…"   11 seconds ago   Up 11 seconds   5432/tcp   postgresdb-with-exist-volume

➜ ~  docker exec -it -u postgres postgresdb-with-exist-volume psql
psql (12.6 (Debian 12.6-1.pgdg100+1))
Type "help" for help.

postgres=# \l
                                 List of databases
   Name    |   Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+-----------+----------+------------+------------+-----------------------
 exampledb | exampledb | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | postgres  | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres  | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |           |          |            |            | postgres=CTc/postgres
 template1 | postgres  | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |           |          |            |            | postgres=CTc/postgres
(4 rows)

postgres=# \c exampledb
You are now connected to database "exampledb" as user "postgres".
exampledb=# \dt
             List of relations
 Schema |     Name      | Type  |  Owner
--------+---------------+-------+----------
 public | example_table | table | postgres
(1 row)

exampledb=# select * from example_table;
 id |      nama
----+----------------
 01 | Dimas Maryanto
(1 row)

exampledb=#
```

## Inspecting Volume

Inspecting object docker volume, kita bisa menggunakan perintah berikut:

{% gist page.gist "06a-inspect-volume.bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker volume inspect pgdata_volume e8b3d53fb7fd4
[
    {
        "CreatedAt": "2021-06-03T14:07:47Z",
        "Driver": "local",
        "Labels": {
            "app": "database"
        },
        "Mountpoint": "/var/lib/docker/volumes/pgdata_volume/_data",
        "Name": "pgdata_volume",
        "Options": {},
        "Scope": "local"
    }
]
```

Nah jika temen-temen menggunakan linux, kita bisa access secara langsung `Mountpont` witchis `/var/lib/docker/volumes/pgdata_volume/_data` tapi jika menggunakan Docker Desktop baik itu di Windows atau Mac itu gak bisa secara langsung ya berikut contohnya:

```bash
[dimasm93@dev01 ~]$ docker info
Client:
 Debug Mode: false

Server:
 Containers: 0
  Running: 0
  Paused: 0
  Stopped: 0
 Images: 6
 Server Version: 19.03.14
 Storage Driver: overlay2
  Backing Filesystem: xfs
  Supports d_type: true
  Native Overlay Diff: true
 Logging Driver: json-file
 Cgroup Driver: cgroupfs
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
 Kernel Version: 4.18.0-240.22.1.el8_3.x86_64
 Operating System: CentOS Linux 8
 OSType: linux
 Architecture: x86_64
 CPUs: 4
 Total Memory: 15.34GiB
 Docker Root Dir: /var/lib/docker
 Registry: https://index.docker.io/v1/
 Labels:
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
 Live Restore Enabled: false

[dimasm93@dev01 ~]$ docker volume create exampledb

[dimasm93@dev01 ~]$ docker run --name postgresdb \
> -v exampledb:/var/lib/postgresql/data \
> -e POSTGRES_PASSWORD=password \
> -d postgres:12.6
dc50ae72c03fb2e536dcc33b5b12b62c1fb9e50616d8dcf981df86929ac06d85

[dimasm93@dev01 ~]$ docker volume ls
DRIVER              VOLUME NAME
local               exampledb

[dimasm93@dev01 ~]$ docker volume inspect exampledb
[
    {
        "CreatedAt": "2021-06-03T21:59:21+07:00",
        "Driver": "local",
        "Labels": {},
        "Mountpoint": "/var/lib/docker/volumes/exampledb/_data",
        "Name": "exampledb",
        "Options": {},
        "Scope": "local"
    }
]

[dimasm93@dev01 ~]$ sudo -i
[root@dev01 ~]# cd /var/lib/docker/volumes/exampledb/_data

[root@dev01 _data]# ll -h
total 60K
drwx------. 5 systemd-coredump input   41 Jun  3 21:59 base
drwx------. 2 systemd-coredump input 4.0K Jun  3 22:00 global
drwx------. 2 systemd-coredump input    6 Jun  3 21:59 pg_commit_ts
drwx------. 2 systemd-coredump input    6 Jun  3 21:59 pg_dynshmem
-rw-------. 1 systemd-coredump input 4.7K Jun  3 21:59 pg_hba.conf
-rw-------. 1 systemd-coredump input 1.6K Jun  3 21:59 pg_ident.conf
drwx------. 4 systemd-coredump input   68 Jun  3 21:59 pg_logical
drwx------. 4 systemd-coredump input   36 Jun  3 21:59 pg_multixact
drwx------. 2 systemd-coredump input   18 Jun  3 21:59 pg_notify
drwx------. 2 systemd-coredump input    6 Jun  3 21:59 pg_replslot
drwx------. 2 systemd-coredump input    6 Jun  3 21:59 pg_serial
drwx------. 2 systemd-coredump input    6 Jun  3 21:59 pg_snapshots
drwx------. 2 systemd-coredump input    6 Jun  3 21:59 pg_stat
drwx------. 2 systemd-coredump input   63 Jun  3 22:01 pg_stat_tmp
drwx------. 2 systemd-coredump input   18 Jun  3 21:59 pg_subtrans
drwx------. 2 systemd-coredump input    6 Jun  3 21:59 pg_tblspc
drwx------. 2 systemd-coredump input    6 Jun  3 21:59 pg_twophase
-rw-------. 1 systemd-coredump input    3 Jun  3 21:59 PG_VERSION
drwx------. 3 systemd-coredump input   60 Jun  3 21:59 pg_wal
drwx------. 2 systemd-coredump input   18 Jun  3 21:59 pg_xact
-rw-------. 1 systemd-coredump input   88 Jun  3 21:59 postgresql.auto.conf
-rw-------. 1 systemd-coredump input  27K Jun  3 21:59 postgresql.conf
-rw-------. 1 systemd-coredump input   36 Jun  3 21:59 postmaster.opts
-rw-------. 1 systemd-coredump input   94 Jun  3 21:59 postmaster.pid
[root@dev01 _data]#
```

## Cleanup

Untuk menghapus suatu volume, kita bisa menggunakan perintah `rm` atau `prune`. Setelah kita mencoba studi kasus diatas kita hapus dulu semua containernya yang sedang berjalan setelah itu kita bisa hapus semua volumenya, Seperti berikut:

For Bash script:

{% gist page.gist "06a-cleanup.bash" %}

For Powershell script:

{% gist page.gist "06a-cleanup.ps1" %}