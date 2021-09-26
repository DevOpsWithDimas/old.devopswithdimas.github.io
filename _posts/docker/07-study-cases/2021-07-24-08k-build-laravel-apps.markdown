---
layout: post
title: "Build Docker image for Laravel Framework"
date: 2021-07-24T20:42:46+07:00
lang: docker
categories:
- DevOps
- Docker
- Dockerfile
- Study-Cases
refs: 
- https://docs.docker.com/
- https://laravel.com/docs/8.x#installation-via-composer
- https://laravel.com/docs/8.x/deployment
youtube: ebk3yh4Lt8s
comments: true
catalog_key: study-cases-dockerfile
image_path: /resources/posts/docker/08k-laravel-apps
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas Build docker image untuk PHP Framework yang paling popular yaitu [Laravel v8.x](https://laravel.com/). Supaya pembahasannya tidak terlalu panjang kita bagi menjadi beberapa section diantaranya:

1. Setup SDK Local environment
2. Deployment using Apache2/Httpd
3. Build & Running docker image
4. Cleanup

## Setup SDK Local environment

Untuk meng-setup Software Development project Laravel sebetulnya ada banyak cara seperti yang di [Official Documentation Laravel](https://laravel.com/docs/8.x) Seperti contohnya 

1. Within WSL2
2. Docker
3. Sail Service
4. Composer
5. Laravel Installer 

Klo saya sendiri lebih sering menggunakan [Composer](https://laravel.com/docs/8.x#installation-via-composer). Sebelum kita membuat project Laravel dengan Composer kita harus configure dulu PHP environtmennya seperti 

1. PHP >= 7.3
2. BCMath PHP Extension
3. Ctype PHP Extension
4. Fileinfo PHP Extension
5. JSON PHP Extension
6. Mbstring PHP Extension
6. OpenSSL PHP Extension
7. PDO PHP Extension
8. Tokenizer PHP Extension
9. XML PHP Extension
10. [mcrypt PHP Extension](https://pecl.php.net/package/mcrypt)

Setelah kita configure engine PHP nya, selanjutnya kita install untuk package managernya yaitu menggunakan [Composer](https://getcomposer.org/doc/00-intro.md#system-requirements), Selantutnya kita buat project dengan menggunakan perintah seperti berikut:

{% highlight bash %}
composer create-project laravel/laravel docker-laravel && \
cd docker-laravel && \
composer install
{% endhighlight %}

Setelah itu kita bisa config dulu system Laravelnya seperti 

1. `Copy .env.example` menjadi `.env` menggunakan perintah berikut: `php -r "file_exists('.env') || copy('.env.example', '.env');"`
2. Set `APP_KEY` dengan `php artisan package:discover --ansi && php artisan key:generate --ansi`

Kemudian kita bisa jalankan sebagai development mode yaitu menggunakan perintah seperti berikut

{% highlight bash %}
php artisan serve
{% endhighlight %}

Jika di jalankan, maka hasilnya seperti berikut:

```powershell
➜ docker-laravel  php artisan serve
Starting Laravel development server: http://127.0.0.1:8000
[Sat Jul 24 11:33:08 2021] PHP 8.0.7 Development Server (http://127.0.0.1:8000) started
```

Kemudian kita akses di browser dengan url di atas, hasilnya seperti berikut:

![laravel-artisan-serve]({{ page.image_path | prepend: site.baseurl }}/laravel-artisan-serve.png)

## Deployment using Apache2/Httpd

Ok setelah kita membuat project kemudian kita menjalankan development mode, sekarang kita akan deploy ke Server (Production Mode). Untuk deploy production mode ada beberapa cara yaitu

1. Nginx ([PHP-FPM](https://www.php.net/manual/en/install.fpm.php))
2. Httpd/Apache2

Jadi kali ini kita akan menggunakan Web Server Httpd/Apache dan OS Ubuntu Server. Langsung aja berikut yang harus kita install di server

{% highlight bash %}
## install software dependency
apt update && apt -y upgrade && \
apt install -y software-properties-common \
    apache2 \
    curl \
    git \
    libicu-dev \
    libpq-dev \
    libmcrypt-dev \
    openssl \
    unzip \
    vim \
    zip \
    zlib1g-dev \
    libpng-dev \
    libzip-dev 

## install php 8.x
export PHP_VERSION=8.0

add-apt-repository -y ppa:ondrej/php && \
apt update && \
apt install -y php${PHP_VERSION} \
    php${PHP_VERSION}-cli \
    libapache2-mod-php${PHP_VERSION} && \
systemctl restart apache2.service

## install php-extension required by laravel
apt install -y php${PHP_VERSION}-mcrypt \
    php${PHP_VERSION}-fileinfo \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-exif \
    php${PHP_VERSION}-pdo \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-dom

## enable rewrite apache2
a2enmod rewrite

## install composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

## allow write folder / file to /var/www/php
mkdir -p /var/www/php && \
chmod -R 777 /var/www/php
{% endhighlight %}

Setelah kita install, sekarang kita upload source-codenya ke server menggunakan tools seperti `scp` atau `git`. Berikut perintahnya:

```bash
scp -r * username@your-server.hostname:/var/www/php && \
scp env.example username@your-server.hostname:/var/www/php

```

Setelah itu kita edit apache2 confignya pada file `/etc/apache2/sites-enabled/000-default.conf` untuk mengarahkan ROOT Document ke `/var/www/php/public` seperti berikut:

```conf
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/php/public

        <Directory /var/www/php/public>
            Options Indexes FollowSymLinks
            AllowOverride All
            Require all granted
        </Directory>

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

Kemudian kita restart server apache2 dengan perintah seperti berikut:

{% highlight bash %}
systemctl restart apache2
{% endhighlight %}

Kemudian kita build sourcenya menjadi production mode sesuai dengan arahan dari [official website](https://laravel.com/docs/8.x/deployment#optimization) nya. seperti berikut

{% highlight bash %}
## build .env
php -r "file_exists('.env') || copy('.env.example', '.env');" && \
sed -i "s|APP_DEBUG=true|APP_DEBUG=false|g" .env && \
sed -i "s|APP_URL=http://localhost|APP_URL=""|g" .env && \
sed -i "s|APP_ENV=local|APP_ENV=production|g" .env

## install production mode
composer install --optimize-autoloader --no-dev && \
php artisan package:discover --ansi && \
php artisan key:generate --ansi && \
php artisan optimize

{% endhighlight %}

Sekarang kita coba access menggunakan browser ke [http://your-server.hostname](http://localhost) maka hasilnya seperti berikut:

![laravel-apache2-prod]({{ page.image_path | prepend: site.baseurl }}/laravel-apache2-prod.png)

## Build & Running docker image

Ok setelah kita mencoba manual deployment menggunakan Apache2 di Ubuntu Server, sekarang kita buat Docker imagenya. Seperti biasanya untuk membuat docker image kita pilih dulu base image yang mau digunakan, jadi karena kita menggunakan Apache2 untuk web-servernya dan versi PHP 8 maka kita pilih `php:8.0-apache` jadi berikut adalah Dockerfile

{% gist page.gist "08k-dockerfile" %}

Serta berikut file `.dockerignore` nya:

{% gist page.gist "08k-dockerignore" %}

Jika di jalankan maka outputnya seperti berikut:

```powershell
➜ docker-laravel git:(master) docker build -t dimmaryanto93/docker-laravel:2021.07.24.19.43-release .
[+] Building 13.2s (14/14) FINISHED
 => [internal] load build definition from Dockerfile                                   0.0s
 => => transferring dockerfile: 1.49kB                                                 0.0s
 => [internal] load .dockerignore                                                      0.0s
 => => transferring context: 35B                                                       0.0s
 => [internal] load metadata for docker.io/library/php:8.0-apache                      3.2s
 => [php_laravel 1/4] FROM docker.io/library/php:8.0-apache@sha256:bc3bf769aff70e8f81  0.0s
 => [internal] load build context                                                      0.0s
 => => transferring context: 19.75kB                                                   0.0s
 => CACHED [php_laravel 2/4] RUN apt-get update && apt-get install -y   curl   git     0.0s
 => CACHED [php_laravel 3/4] RUN pecl install mcrypt-1.0.4 &&   docker-php-ext-instal  0.0s
 => CACHED [php_laravel 4/4] RUN curl -sS https://getcomposer.org/installer | php --   0.0s
 => CACHED [executeable 1/5] WORKDIR /var/www/php                                      0.0s
 => [executeable 2/5] RUN sed -i "s|DocumentRoot /var/www/html|DocumentRoot /var/www/" 0.2s
 => [executeable 3/5] COPY . .                                                         0.1s
 => [executeable 4/5] RUN mkdir -p public/storage && chmod -R 777 storage/* && chmod   0.2s
 => [executeable 5/5] RUN php -r "file_exists('.env') || copy('.env.example', '.env')" 9.0s
 => exporting to image                                                                 0.4s
 => => exporting layers                                                                0.4s
 => => writing image sha256:14d3276fc4f91d338994fc50c50261df00593d12688ea43ded32afab6  0.0s
 => => naming to docker.io/dimmaryanto93/docker-laravel:2021.07.24.19.43-release
```

Sekarang jika kita jalankan containernya dengan perintah seperti berikut:

{% highlight bash %}
docker container run --name apache-laravel -p 80:80 -d dimmaryanto93/docker-laravel:2021.07.24.19.43-release
{% endhighlight %}

Maka hasilnya seperti berikut:

![laravel-docker]({{ page.image_path | prepend: site.baseurl }}/laravel-docker.png)

## Cleanup

Seperti biasa setelah kita mencoba schenario studi kasus tersebut. sekarang kita bersih-bersih dulu ya berikut perintahnya:

For Bash script:

{% gist page.gist "08k-cleanup.bash" %}

For Powershell script:

{% gist page.gist "08k-cleanup.ps1" %}