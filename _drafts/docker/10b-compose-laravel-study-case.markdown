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

## Deployment using compose file

Untuk deployment menggunakan docker compose, ada beberapa hal yang harus kita ubah yaitu

1. Remove mount-bind, copy your source-code to Docker Image
2. Use diffrent port bind, or expose port only you need
3. Use difreent environment, such as strong password for credential database, reduce verbose logging, etc
4. Spesify network for isolate environment

Berikut implementasinya, buat file baru dengan nama `docker-compose.production.yaml` seperti berikut:

{% gist page.gist "10b-docker-env.docker-compose.production.yaml" %}

Kemudian kita buat file config untuk nginx dengan nama `.docker/default.template.conf` seperti berikut:

{% gist page.gist "10b-nginx-conf.default-template.conf" %}

Dan yang terakhir buat file baru untuk `.docker/Dockerfile-nginx` seperti berikut:

{% gist page.gist "10b-dockerfile-nginx" %}

Sekarang kita bisa jalankan dengan perintah:

{% highlight bash %}
docker-compose -f docker-compose.yaml -f docker-compose.production.yaml up -d --build
{% endhighlight %}

Seperti berikut:

```powershell
➜ docker git:(compose/laravel) docker-compose -p prod --env-file .\.docker\.env.example `
>> -f docker-compose.yaml -f .\docker-compose.production.yaml `
>> up -d --build
Building laravel
[+] Building 53.7s (24/24) FINISHED
 => [internal] load build definition from Dockerfile                                    0.0s
 => => transferring dockerfile: 2.19kB                                                  0.0s
 => [internal] load .dockerignore                                                       0.0s
 => => transferring context: 35B                                                        0.0s
 => [internal] load metadata for docker.io/library/php:8.0-apache                       1.3s
 => [internal] load metadata for docker.io/library/node:14.15-alpine3.13                0.0s
 => [php_laravel 1/7] FROM docker.io/library/php:8.0-apache@sha256:4334b8e1e1e8bb02a66  0.0s
 => [laramix_build 1/4] FROM docker.io/library/node:14.15-alpine3.13                    0.0s
 => [internal] load build context                                                       0.0s
 => => transferring context: 9.52kB                                                     0.0s
 => CACHED [laramix_build 2/4] WORKDIR /var/www/php                                     0.0s
 => [laramix_build 3/4] COPY . .                                                        0.1s
 => CACHED [php_laravel 2/7] RUN apt-get update && apt-get install -y   curl   git   l  0.0s
 => CACHED [php_laravel 3/7] RUN pecl install mcrypt-1.0.4 &&   docker-php-ext-install  0.0s
 => CACHED [php_laravel 4/7] RUN curl -sS https://getcomposer.org/installer | php -- -  0.0s
 => CACHED [php_laravel 5/7] RUN sed -i "s|DocumentRoot /var/www/html|DocumentRoot /va  0.0s
 => CACHED [php_laravel 6/7] WORKDIR /var/www/php                                       0.0s
 => CACHED [php_laravel 7/7] COPY .docker/apache2-foreground apache2-foreground         0.0s
 => CACHED [executeable 1/7] WORKDIR /var/www/php                                       0.0s
 => [executeable 2/7] COPY . .                                                          0.1s
 => [laramix_build 4/4] RUN npm install -q &&     npm run-script prod                  43.6s
 => [executeable 3/7] COPY --from=laramix_build /var/www/php/public/css public/css      0.0s
 => [executeable 4/7] COPY --from=laramix_build /var/www/php/public/fonts public/fonts  0.1s
 => [executeable 5/7] COPY --from=laramix_build /var/www/php/public/js public/js        0.1s
 => [executeable 6/7] RUN mkdir -p public/storage &&     chmod -R 777 storage/* &&      0.2s
 => [executeable 7/7] RUN php -r "file_exists('.env') || copy('.env.example', '.env');  7.8s
 => exporting to image                                                                  0.5s
 => => exporting layers                                                                 0.4s
 => => writing image sha256:a2a2f2988c744c06f6290083c5f0ddc43de8f80fa47d2dc546d3703819  0.0s
 => => naming to docker.io/dimmaryanto93/laravel8-apps:latest                           0.0s
Building proxy
[+] Building 13.8s (8/8) FINISHED
 => [internal] load build definition from Dockerfile-nginx                              0.0s
 => => transferring dockerfile: 233B                                                    0.0s
 => [internal] load .dockerignore                                                       0.0s
 => => transferring context: 2B                                                         0.0s
 => [internal] load metadata for docker.io/library/nginx:mainline                       4.0s
 => [auth] library/nginx:pull token for registry-1.docker.io                            0.0s
 => [internal] load build context                                                       0.0s
 => => transferring context: 349B                                                       0.0s
 => [1/2] FROM docker.io/library/nginx:mainline@sha256:853b221d3341add7aaadf5f81dd088e  9.5s
 => => resolve docker.io/library/nginx:mainline@sha256:853b221d3341add7aaadf5f81dd088e  0.0s
 => => sha256:09f31c94adc624db7764fc3b46eb26c110c49056e18573e8d81f8cf9afb5 891B / 891B  1.2s
 => => sha256:853b221d3341add7aaadf5f81dd088ea943ab9c918766e295321294b 1.86kB / 1.86kB  0.0s
 => => sha256:6fe11397c34b973f3c957f0da22b09b7f11a4802e1db47aef54c29e2 1.57kB / 1.57kB  0.0s
 => => sha256:ad4c705f24d392b982b2f0747704b1c5162e45674294d5640cca7076 7.73kB / 7.73kB  0.0s
 => => sha256:e0ad2c0621bc497b97748af8ca5767c8e7528f6d3fe9118fdb4d5d 26.64MB / 26.64MB  8.3s
 => => sha256:9e56c3e0e6b7d4a8cc1719050e6573d2da2703b9d20097a3522b890e0ecf 602B / 602B  1.8s
 => => sha256:32b26e9cdb837f314a3de1e50ba33e841eff1638c93e244b57304caf91b0 665B / 665B  1.6s
 => => sha256:20ab512bbb071cf0ca402b08d84c317f21cb888e49d6ffca7f851f1d 1.39kB / 1.39kB  2.0s
 => => extracting sha256:e0ad2c0621bc497b97748af8ca5767c8e7528f6d3fe9118fdb4d5d11faf49  0.7s
 => => extracting sha256:9e56c3e0e6b7d4a8cc1719050e6573d2da2703b9d20097a3522b890e0ecf9  0.0s
 => => extracting sha256:09f31c94adc624db7764fc3b46eb26c110c49056e18573e8d81f8cf9afb5a  0.0s
 => => extracting sha256:32b26e9cdb837f314a3de1e50ba33e841eff1638c93e244b57304caf91b0f  0.0s
 => => extracting sha256:20ab512bbb071cf0ca402b08d84c317f21cb888e49d6ffca7f851f1db3438  0.0s
 => [2/2] COPY default.template.conf /etc/nginx/templates/default.conf.template         0.1s
 => exporting to image                                                                  0.0s
 => => exporting layers                                                                 0.0s
 => => writing image sha256:e22b93854b3606a54ff9d4c1472d5bee631953bfe3c18a36d9b91d4073  0.0s
 => => naming to docker.io/library/nginx:mainline                                       0.0s
Creating prod_mysql_1 ... done
Creating prod_laravel_1 ... done
Creating prod_laravel_2 ... done
Creating prod_laravel_3 ... done
Creating prod_proxy_1   ... done

➜ docker git:(compose/laravel) docker-compose -p prod --env-file .\.docker\.env.example `
>> -f docker-compose.yaml -f .\docker-compose.production.yaml `
>> exec laravel php artisan migrate
**************************************
*     Application In Production!     *
**************************************

 Do you really wish to run this command? (yes/no) [no]:
 > y

Migration table created successfully.
Migrating: 2014_10_12_000000_create_users_table
Migrated:  2014_10_12_000000_create_users_table (32.25ms)
Migrating: 2014_10_12_100000_create_password_resets_table
Migrated:  2014_10_12_100000_create_password_resets_table (30.17ms)
Migrating: 2019_08_19_000000_create_failed_jobs_table
Migrated:  2019_08_19_000000_create_failed_jobs_table (34.39ms)
Migrating: 2021_08_09_164144_create_mahasiswa_table
Migrated:  2021_08_09_164144_create_mahasiswa_table (64.72ms)

➜ docker git:(compose/laravel) docker-compose -p prod --env-file .\.docker\.env.example `
>> -f docker-compose.yaml -f .\docker-compose.production.yaml `
>> ps
     Name                   Command               State                Ports
------------------------------------------------------------------------------------------
prod_laravel_1   docker-php-entrypoint .doc ...   Up      80/tcp
prod_laravel_2   docker-php-entrypoint .doc ...   Up      80/tcp
prod_laravel_3   docker-php-entrypoint .doc ...   Up      80/tcp
prod_mysql_1     docker-entrypoint.sh mysqld      Up      3306/tcp, 33060/tcp
prod_proxy_1     /docker-entrypoint.sh ngin ...   Up      0.0.0.0:80->80/tcp,:::80->80/tcp
```