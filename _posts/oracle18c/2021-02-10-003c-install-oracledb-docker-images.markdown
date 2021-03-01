---
layout: post
title: "Install Oracle 18c XE dengan Docker"
date: 2021-02-10T15:08:43+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
- https://docs.oracle.com/en/bigdata/index.html
- https://github.com/oracle/docker-images/tree/main/OracleDatabase
youtube: 
comments: true
image_path: /resources/posts/oracle12c/003c-install-docker
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: 
- name: "Docker Image Builder"
  url: https://github.com/oracle/docker-images/archive/main.zip
---

## Preparation

Sekarang kita download docker image buildenya [disini](https://github.com/oracle/docker-images/archive/main.zip) kemudian buka Command Promnt atau Terminal kemudian arahkan ke folder `OracleDatabase/SingleInstance/dockerfiles`.

Kemudian masukin installer `oracle-database-xe-18c.x.x.rpm` ke folder `18.4.0` seperti berikut:

![installer]({{ page.image_path | prepend: site.baseurl }}/installer-oracle.png)

Kemudian kita build, image dockernya.

## Build Oracle Image Docker

coba jalankan perintah berikut:

{% terminal %}
$ ./buildContainerImage.sh -v 18.4.0 -x -i

Building image 'oracle/database:18.4.0-xe' ...
#2 [internal] load .dockerignore
#2 sha256:82c746726f1c3ea1b1f2e1582360b55313692a0bc3b3b749ad8e9fadf198036f
#2 transferring context: 2B done
#2 DONE 0.1s

#1 [internal] load build definition from Dockerfile.xe
#1 sha256:97f13e81257f4107ada6ffc127c5c0519cf403dddb4f578d12129d4a82018bc8
#1 transferring dockerfile: 3.16kB 0.0s done
#1 DONE 0.1s

#3 [internal] load metadata for docker.io/library/oraclelinux:7-slim
#3 sha256:87ecd7bcbbc3ba1f1518cb46893e8d1a9cd73f72ecadc1fda045f513522c16a6
#3 ...

#4 [auth] library/oraclelinux:pull token for registry-1.docker.io
#4 sha256:b97bed7dd9338edaee0fa2fa232d9d2acabe1e5eb0165838fcc89586908b18f0
#4 DONE 0.0s

#6 [internal] load build context
#6 sha256:d6ad5790856ea2704309b6a60611a585ac4862bec70bae379918ccf696a15850
#6 transferring context: 9.51kB 0.0s done
#6 DONE 0.0s

#5 [1/3] FROM docker.io/library/oraclelinux:7-slim@sha256:e90d869670d820efcc73570ddda8bb038f6942758bf691f289a91cb6bf975108
#5 DONE 16.5s

#7 [2/3] COPY checkSpace.sh runOracle.sh setPassword.sh checkDBStatus.sh oracle-xe-18c.conf /install/
#7 sha256:bc6b273f62fac5d4c10c0eeaff4d78dd4b9d5cc1ef67df7ca95dedbdc0d65e08
#7 DONE 0.4s

#8 [3/3] RUN chmod ug+x /install/*.sh &&     sync &&     /install/checkSpace.sh &&     cd /install &&     yum -y install openssl oracle-database-preinstall-18c &&     sed -i -e 's/\(oracle\s\+hard\s\+nofile\)/# \1/' /etc/security/limits.d/oracle-database-preinstall-18c.conf &&     yum -y localinstall https://download.oracle.com/otn-pub/otn_software/db-express/oracle-database-xe-18c-1.0-1.x86_64.rpm &&     rm -rf /var/cache/yum &&     rm -rf /var/tmp/yum-* &&     mkdir -p /opt/oracle/scripts/setup &&     mkdir /opt/oracle/scripts/startup &&     ln -s /opt/oracle/scripts /docker-entrypoint-initdb.d &&     mkdir -p /opt/oracle/oradata /home/oracle &&     chown -R oracle:oinstall /opt/oracle /home/oracle &&     mv /install/runOracle.sh /opt/oracle/ &&     mv /install/setPassword.sh /opt/oracle/ &&     mv /install/checkDBStatus.sh /opt/oracle/ &&     mv /install/oracle-xe-18c.conf /etc/sysconfig/ &&     ln -s /opt/oracle/setPassword.sh / &&     cd $HOME &&     rm -rf /install &&     chmod ug+x /opt/oracle/*.sh
#8 sha256:f7a79590a8560b519d96fcebcf075095035959a0cca37cdd076ec92a62f898da
#8 0.324 Loaded plugins: ovl

#8 17.74 Dependencies Resolved
#8 17.76
#8 17.76 ================================================================================
#8 17.76  Package                 Arch   Version                        Repository  Size
#8 17.76 ================================================================================
#8 17.76 Installing:
#8 17.76  openssl                 x86_64 1:1.0.2k-21.el7_9              ol7_latest 493 k
#8 17.76  oracle-database-preinstall-18c
#8 17.76                          x86_64 1.0-1.el7                      ol7_latest  18 k
#8 17.76
#8 17.76 Transaction Summary
#8 17.76 ================================================================================
#8 17.76 Install  2 Packages (+114 Dependent packages)
#8 17.76 Upgrade             (   5 Dependent packages)

#8 974.0 Dependencies Resolved
#8 974.0
#8 974.0 ================================================================================
#8 974.0  Package          Arch   Version     Repository                            Size
#8 974.0 ================================================================================
#8 974.0 Installing:
#8 974.0  oracle-database-xe-18c
#8 974.0                   x86_64 1.0-1       /oracle-database-xe-18c-1.0-1.x86_64 5.2 G
#8 974.0 Installing for dependencies:
#8 974.0  file             x86_64 5.11-37.el7 ol7_latest                            56 k
#8 974.0
#8 974.0 Transaction Summary
#8 974.0 ================================================================================
#8 974.0 Install  1 Package (+1 Dependent package)

#8 1135.8 Complete!
#8 DONE 1137.1s

#9 exporting to image
#9 sha256:e8c613e07b0b7ff33893b694f7759a10d42e180f2b4dc349fb57dc6b71dcab00
#9 exporting layers
#9 exporting layers 19.7s done
#9 writing image sha256:cbc35939ffbe7c89ee17a86463372e1c89a3fa57a2e8e16179fc2b28cff00dcc done
#9 naming to docker.io/oracle/database:18.4.0-xe done
#9 DONE 19.7s


  Oracle Database container image for 'xe' version 18.4.0 is ready to be extended:

    --> oracle/database:18.4.0-xe

  Build completed in 1181 seconds.
{% endterminal %}


Setelah itu coba check image docker menggunakan perintah

{% terminal %}
$ docker images

REPOSITORY                                    TAG         IMAGE ID       CREATED              SIZE
oracle/database                               18.4.0-xe   cbc35939ffbe   About a minute ago   6.03GB
{% endterminal %}

## Running Docker container Oracle 18c XE

Setelah itu kita bisa jalankan containernya dengan menggunakan `docker-compose`, buat file `docker-compose.yaml` seperti berikut:

{% gist page.gist "docker-compose.yaml" %}

Kemudian coba jalankan perintah berikut:

{% terminal %}
$ docker-compose -p bootcamp-oracle up -d

Creating network "bootcamp-oracle_oracle-network" with the default driver
Creating volume "bootcamp-oracle_oracle-data" with default driver
Creating bootcamp-oracle_oracle_1 ... done
{% endterminal %}

Untuk meriksa lognya, jalankan perintah berikut:

{% terminal %}
$ docker-compose -p bootcamp-oracle logs --follow oracle

oracle_1  | ORACLE PASSWORD FOR SYS AND SYSTEM: passwordnyaOracle18c
oracle_1  | Specify a password to be used for database accounts. Oracle recommends that the password entered should be at least 8 characters in length, contain at least 1 uppercase character, 1 lower case character and 1 digit [0-9]. Note that the same password will be used for SYS, SYSTEM and PDBADMIN accounts:
oracle_1  | Confirm the password:
oracle_1  | Configuring Oracle Listener.
oracle_1  | Listener configuration succeeded.
oracle_1  | Configuring Oracle Database XE.
oracle_1  | Enter SYS user password:
oracle_1  |**********************
oracle_1  | Enter SYSTEM user password:
oracle_1  |***********************
oracle_1  | Enter PDBADMIN User Password:
oracle_1  | *********************
oracle_1  | Prepare for db operation
oracle_1  | Copying database files
oracle_1  | Creating and starting Oracle instance
oracle_1  | Completing Database Creation
oracle_1  | Creating Pluggable Databases
oracle_1  | Executing Post Configuration Actions
oracle_1  | Running Custom Scripts
oracle_1  | 100% complete
oracle_1  | Database creation complete. For details check the logfiles at:
oracle_1  |  /opt/oracle/cfgtoollogs/dbca/XE.
oracle_1  | Database Information:
oracle_1  | Global Database Name:XE
oracle_1  | System Identifier(SID):XE
oracle_1  | Look at the log file "/opt/oracle/cfgtoollogs/dbca/XE/XE.log" for further details.
oracle_1  |
oracle_1  | Connect to Oracle Database using one of the connect strings:
oracle_1  |      Pluggable database: ff7991c715f3/XEPDB1
oracle_1  |      Multitenant container database: ff7991c715f3
oracle_1  | Use https://localhost:5500/em to access Oracle Enterprise Manager for Oracle Database XE
oracle_1  | The Oracle base remains unchanged with value /opt/oracle
oracle_1  | #########################
oracle_1  | DATABASE IS READY TO USE!
oracle_1  | #########################
oracle_1  | The following output is now a tail of the alert.log:
oracle_1  | 2021-02-10T07:45:09.996180+00:00
oracle_1  | XEPDB1(3):Resize operation completed for file# 10, old size 358400K, new size 368640K
oracle_1  | 2021-02-10T07:45:11.808457+00:00
oracle_1  | XEPDB1(3):CREATE SMALLFILE TABLESPACE "USERS" LOGGING  DATAFILE  '/opt/oracle/oradata/XE/XEPDB1/users01.dbf' SIZE 5M REUSE AUTOEXTEND ON NEXT  1280K MAXSIZE UNLIMITED  EXTENT MANAGEMENT LOCAL  SEGMENT SPACE MANAGEMENT  AUTO
oracle_1  | XEPDB1(3):Completed: CREATE SMALLFILE TABLESPACE "USERS" LOGGING  DATAFILE  '/opt/oracle/oradata/XE/XEPDB1/users01.dbf' SIZE 5M REUSE AUTOEXTEND ON NEXT  1280K MAXSIZE UNLIMITED  EXTENT MANAGEMENT LOCAL  SEGMENT SPACE MANAGEMENT  AUTO
oracle_1  | XEPDB1(3):ALTER DATABASE DEFAULT TABLESPACE "USERS"
oracle_1  | XEPDB1(3):Completed: ALTER DATABASE DEFAULT TABLESPACE "USERS"
oracle_1  | 2021-02-10T07:45:12.886261+00:00
oracle_1  | ALTER PLUGGABLE DATABASE XEPDB1 SAVE STATE
oracle_1  | Completed: ALTER PLUGGABLE DATABASE XEPDB1 SAVE STATE
{% endterminal %}

## Test connection dengan sql/plus

Untuk menggunakan sql/plus kita bisa menggunakan perintah berikut:

{% highlight bash %}
docker-compose -p bootcamp-oracle exec sqlplus system@XE
{% endhighlight %}

input passwordnya: `passwordnyaOracle18c`

maka outputnya seperti berikut:

![connected]({{ page.image_path | prepend: site.baseurl }}/sqlplus-connected.png)