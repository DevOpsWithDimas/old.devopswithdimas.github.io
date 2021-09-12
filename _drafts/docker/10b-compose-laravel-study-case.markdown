---
layout: post
title: "Study Kasus: Laravel deployment using compose file"
lang: docker
categories:
- DevOps
- Docker
- Compose
- Study-Cases
refs: 
- https://docs.docker.com/
youtube: 
comments: true
image_path: /resources/posts/docker/10b-compose-laravel
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas deployment untuk laravel menggunakan compose file berdasarkan [artikel berikut]({% post_url docker/07-study-cases/2021-07-26-08m-build-laravel-using-db %}). Adapun yang akan kita bahas kali ini yaitu:

1. Development on local environment using compose file
2. Development on docker environment using compose file
3. Deployment using compose file

## Dev on local env using compose file

Untuk development pada local environment pada dasarnya kita perlu install 

1. PHP 8.0
2. PHP Extension
3. NodeJS
4. MySQL Database

Jadi biasanya untuk bahasa pemograman kita intall di host kita sedangkan untuk service seperti database kita jalankan di docker, Maka berikut adalah configuration `docker-compose.yaml`

{% gist page.gist "10b-deps.docker-compose.yaml" %}

Kemudian kita sesuaikan `.env` file untuk variable berikut dengan docker compose yang kita define.

{% highlight .env %}
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=example_laravel
DB_USERNAME=example_laravel
DB_PASSWORD=example_laravel
{% endhighlight %}

Kemudian kita bisa normal menjalan laravel dengan perintah `php artisan serve`

## Dev on docker env using compose file

Untuk development di docker environment, pertama kita siapkan dulu environment dengan meng-update `Dockerfile` seperti berikut:

{% gist page.gist "10b-dockerfile" %}

Kemudian kita update juga file `.docker/apache2-foreground` 

{% gist page.gist "10b-apache2-foreground" %}

Dan kita buat juga file `docker-compose.yaml` serta `docker-compose.override.yaml` seperti berikut:

{% gist page.gist "10b-docker-env.docker-compose.yaml" %}

{% gist page.gist "10b-docker-env.docker-compose.override.yaml" %}

Lalu kita buat file `.docker/laramix-entrypoint` seperti berikut:

{% gist page.gist "10b-laramix-entrypoint" %}

Yang terakhir berikut adalah file `.docker/.env` seperti berikut:

{% gist page.gist "10b-dotenv" %}

Jika kita jalankan maka hasilnya seperti berikut:

```powershell
➜ docker git:(compose/laravel) docker-compose --env-file .\.docker\.env.example config
services:
  laramix:
    command:
    - .docker/laramix-entrypoint
    image: node:14.15-alpine3.13
    profiles:
    - dev
    volumes:
    - C:\Users\dimasm93\Workspaces\udemy\docker:/var/www/php:rw
    working_dir: /var/www/php
  laravel:
    build:
      context: C:\Users\dimasm93\Workspaces\udemy\docker
      dockerfile: Dockerfile
      target: php_laravel
    depends_on:
      mysql:
        condition: service_started
    environment:
      APP_DEBUG: "true"
      APP_ENV: local
      APP_URL: '""'
      DB_CONNECTION: mysql
      DB_DATABASE: laravel_app
      DB_HOST: mysql
      DB_PASSWORD: laravel_app
      DB_PORT: '3306'
      DB_USERNAME: laravel_app
      LOG_LEVEL: debug
    image: dimmaryanto93/laravel8-apps:latest
    ports:
    - published: 8000
      target: 80
    volumes:
    - C:\Users\dimasm93\Workspaces\udemy\docker:/var/www/php:rw
  mysql:
    environment:
      MYSQL_DATABASE: laravel_app
      MYSQL_PASSWORD: laravel_app
      MYSQL_ROOT_PASSWORD: secretPasswd
      MYSQL_USER: laravel_app
    image: mysql:5.7
    ports:
    - published: 3306
      target: 3306
    volumes:
    - db_data:/var/lib/mysql:rw
  phpmyadmin:
    depends_on:
      mysql:
        condition: service_started
    environment:
      MYSQL_ROOT_PASSWORD: secretPasswd
      PMA_HOST: mysql
    image: phpmyadmin
    ports:
    - published: 33306
      target: 80
    profiles:
    - debug
version: '3.9'
volumes:
  db_data: {}

➜ docker git:(compose/laravel) docker-compose --env-file .\.docker\.env.example -p dev --profile debug up -d
Creating network "dev_default" with the default driver
Creating volume "dev_db_data" with default driver
Creating dev_mysql_1 ... done
Creating dev_laravel_1 ... done
Creating dev_phpmyadmin_1 ... done

➜ docker git:(compose/laravel) docker-compose --env-file .\.docker\.env.example -p dev --profile debug ps
      Name                    Command               State                 Ports
---------------------------------------------------------------------------------------------
dev_laramix_1      docker-entrypoint.sh .dock ...   Exit 0
dev_laravel_1      docker-php-entrypoint .doc ...   Up       0.0.0.0:8000->80/tcp,:::8000->80
                                                             /tcp
dev_mysql_1        docker-entrypoint.sh mysqld      Up       0.0.0.0:3306->3306/tcp,:::3306->
                                                             3306/tcp, 33060/tcp
dev_phpmyadmin_1   /docker-entrypoint.sh apac ...   Up       0.0.0.0:33306->80/tcp,:::33306->
                                                             80/tcp

➜ docker git:(compose/laravel) docker-compose --env-file .\.docker\.env.example -p dev up laramix
laramix_1     |
laramix_1     |    Laravel Mix v6.0.27
laramix_1     |
laramix_1     |
laramix_1     | ✔ Compiled Successfully in 4211ms
laramix_1     | ┌───────────────────────────────────┬──────────┐
laramix_1     | │                              File │ Size     │
laramix_1     | ├───────────────────────────────────┼──────────┤
laramix_1     | │                        /js/app.js │ 1.45 MiB │
laramix_1     | │                       css/app.css │ 243 KiB  │
laramix_1     | │  …b43027f47b20503057dfbbaa9401fef │ 162 KiB  │
laramix_1     | │  …1e38fd9e0e74ba58f7a2b77ef29fdd3 │ 434 KiB  │
laramix_1     | │  …e59d2330b4c6deb84b340635ed36249 │ 162 KiB  │
laramix_1     | │  …0fd1704ea223900efa9fd4e869efb08 │ 75.4 KiB │
laramix_1     | │  …691f37e57f04c152e2315ab7dbad881 │ 95.7 KiB │
laramix_1     | └───────────────────────────────────┴──────────┘
laramix_1     | ✔ Mix: Compiled successfully in 4.36s
laramix_1     | webpack compiled successfully
dev_laramix_1 exited with code 0

➜ docker-compose --env-file .\.docker\.env.example -p dev exec laravel php artisan migrate
Migration table created successfully.
Migrating: 2014_10_12_000000_create_users_table
Migrated:  2014_10_12_000000_create_users_table (54.60ms)
Migrating: 2014_10_12_100000_create_password_resets_table
Migrated:  2014_10_12_100000_create_password_resets_table (29.31ms)
Migrating: 2019_08_19_000000_create_failed_jobs_table
Migrated:  2019_08_19_000000_create_failed_jobs_table (33.95ms)
Migrating: 2021_08_09_164144_create_mahasiswa_table
Migrated:  2021_08_09_164144_create_mahasiswa_table (63.05ms)
```

Sekarang kita coba access, maka hasilnya seperti berikut:

![docker-env]({{ page.image_path | prepend: site.baseurl }}/02a-phpmyadmin.png)

![docker-env.app]({{ page.image_path | prepend: site.baseurl }}/02b-laravel-app.png)
