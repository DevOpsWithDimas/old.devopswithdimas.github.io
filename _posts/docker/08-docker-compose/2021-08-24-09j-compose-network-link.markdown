---
layout: post
title: "Network links in Compose file"
date: 2021-08-24T03:58:47+07:00
lang: docker
categories:
- DevOps
- Docker
- Compose
- Network
refs: 
- https://docs.docker.com/compose/networking/
- https://docs.docker.com/compose/compose-file/compose-file-v3/#links
youtube: 
comments: true
image_path: /resources/posts/docker/09j-compose-network-link
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas legacy network di docker yaitu menggunakan links pada compose file.

Links allow you to define extra aliases by which a service is reachable from another service. They are not required to enable services to communicate - by default, any service can reach any other service at that service’s name. In the following example, `db` is reachable from `web` at the hostnames `db` and `database`:

{% gist page.gist "09j-link.docker-compose.yaml" %}

Sekarang kita coba jalankan maka hasilnya seperti berikut:

```powershell
➜ docker  docker-compose -f .\09-docker-compose\network\link.docker-compose.yaml -p link up -d
Creating network "link_default" with the default driver
Creating volume "link_mysql_data" with default driver
Creating link_mysql_1 ... done
Creating link_wordpress_1 ... done

➜ docker  docker-compose -f .\09-docker-compose\network\link.docker-compose.yaml -p link ps
      Name                    Command               State                  Ports
------------------------------------------------------------------------------------------------
link_mysql_1       docker-entrypoint.sh mysqld      Up      3306/tcp, 33060/tcp
link_wordpress_1   docker-entrypoint.sh apach ...   Up      0.0.0.0:8080->80/tcp,:::8080->80/tcp

➜ docker  docker-compose -f .\09-docker-compose\network\link.docker-compose.yaml -p link logs wordpress
Attaching to link_wordpress_1
wordpress_1  | WordPress not found in /var/www/html - copying now...
wordpress_1  | Complete! WordPress has been successfully copied to /var/www/html
wordpress_1  | No 'wp-config.php' found in /var/www/html, but 'WORDPRESS_...' variables supplied; copying
 'wp-config-docker.php' (WORDPRESS_DB_HOST WORDPRESS_DB_NAME WORDPRESS_DB_PASSWORD WORDPRESS_DB_USER)
wordpress_1  | AH00558: apache2: Could not reliably determine the server's fully qualified domain name, u
sing 172.20.0.3. Set the 'ServerName' directive globally to suppress this message
wordpress_1  | AH00558: apache2: Could not reliably determine the server's fully qualified domain name, u
sing 172.20.0.3. Set the 'ServerName' directive globally to suppress this message
wordpress_1  | [Mon Aug 23 20:35:12.754365 2021] [mpm_prefork:notice] [pid 1] AH00163: Apache/2.4.48 (Deb
ian) PHP/7.4.22 configured -- resuming normal operations
wordpress_1  | [Mon Aug 23 20:35:12.754459 2021] [core:notice] [pid 1] AH00094: Command line: 'apache2 -D
 FOREGROUND'

➜ docker  docker network ls -f name=link*
NETWORK ID     NAME           DRIVER    SCOPE
f93145728402   link_default   bridge    local

➜ docker  docker container inspect $(docker-compose -f .\09-docker-compose\network\link.docker-compose.yaml -p link ps -q) -f '{%raw%}{{.Name}} => {{json .NetworkSettings.Networks.link_default.Links}}{%endraw%}'
/link_mysql_1 => null
/link_wordpress_1 => 
["link_mysql_1:db",
 "link_mysql_1:link_mysql_1",
 "link_mysql_1:mysql_1"]

➜ docker  docker container inspect $(docker-compose -f .\09-docker-compose\network\link.docker-compose.yaml -p link ps -q) -f '{%raw%}{{.Name}} => {{json .Config.Env}}{%endraw%}'
/link_mysql_1 => 
["MYSQL_DATABASE=wordpress_db",
 "MYSQL_USER=wordpress_user",
 "MYSQL_PASSWORD=wordpress_user",
 "MYSQL_ROOT_PASSWORD=secretPassword"]
/link_wordpress_1 => 
[ "WORDPRESS_DB_HOST=db", 
  "WORDPRESS_DB_USER=wordpress_user", 
  "WORDPRESS_DB_PASSWORD=wordpress_user",
  "WORDPRESS_DB_NAME=wordpress_db"]

➜ docker  docker container inspect $(docker-compose -f .\09-docker-compose\network\link.docker-compose.yaml -p link ps -q) -f '{%raw%}{{.Name}} => {{json .NetworkSettings.Networks.link_default.Aliases}}{%endraw%}'
/link_mysql_1 => ["6db651322822","mysql"]
/link_wordpress_1 => ["wordpress","9a45840e15e0"]

➜ docker ✗  docker-compose -f .\09-docker-compose\network\link.docker-compose.yaml -p link exec mysql mysql -u wordpress_user --database wordpress_db -p

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 19
Server version: 5.7.35 MySQL Community Server (GPL)

Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show tables;
+------------------------+
| Tables_in_wordpress_db |
+------------------------+
| wp_commentmeta         |
| wp_comments            |
| wp_links               |
| wp_options             |
| wp_postmeta            |
| wp_posts               |
| wp_term_relationships  |
| wp_term_taxonomy       |
| wp_termmeta            |
| wp_terms               |
| wp_usermeta            |
| wp_users               |
+------------------------+
12 rows in set (0.00 sec)

mysql> select * from wp_users;
+----+------------+------------------------------------+---------------+-----------------------------+-----------------------+---------------------+---------------------+-------------+--------------+
| ID | user_login | user_pass                          | user_nicename | user_email                  | user_url              | user_registered     | user_activation_key | user_status | display_name |
+----+------------+------------------------------------+---------------+-----------------------------+-----------------------+---------------------+---------------------+-------------+--------------+
|  1 | dimasm93   | $P$BJ61phmiwXQ7dOBacO08nuvIPyFftS1 | dimasm93      | software.dimas_m@icloud.com | http://localhost:8080 | 2021-08-23 20:50:46 |                     |           0 | dimasm93     |
+----+------------+------------------------------------+---------------+-----------------------------+-----------------------+---------------------+---------------------+-------------+--------------+
1 row in set (0.00 sec)
```

Sekarang coba buka alamat [http://localhost:8080](http://localhost:8080) maka hasilnya seperti berikut:

![wordpress-db]({{ page.image_path | prepend: site.baseurl }}/01-wordpress-install.png)