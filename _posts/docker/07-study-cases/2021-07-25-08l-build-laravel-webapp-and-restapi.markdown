---
layout: post
title: "Laravel - Using Frontend & Rest API"
date: 2021-07-25T10:38:36+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Dockerfile
- Study-Cases
refs: 
- https://docs.docker.com/
- https://laravel.com/docs/8.x/eloquent-resources#introduction
- https://laravel.com/docs/8.x/mix
youtube: u4fk0ZudaAw
comments: true
catalog_key: study-cases-dockerfile
image_path: /resources/posts/docker/08l-laravel-webapp-restapi
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, di materi study kasus kali ini kita akan membahas menggunakan Frontend / Webapp atau API Resources (Rest API) dengan Laravel, diantaranya yaitu

1. Using static Resource API
2. Create Sample Frontend
3. Deploy Production Mode
4. Build & Run Docker images
5. Cleanup

Ok langsung aja kita ke pembahasan yang pertama

## Using static Resource API

Untuk membuat Resource API di Laravel kita buat controllernya dulu dengan menggunakan perintah:

{% highlight bash %}
php artisan make:controller MahasiswaController
{% endhighlight %}

Kemudian kita edit file `app/Http/Controllers/MahasiswaController.php` seperti berikut:

{% gist page.gist "08l-MahasiswaController.php" %}

Lalu kita tambahkan juga Endpoint/Route API di `routes/api.php` seperti berikut:

{% gist page.gist "08l-routes-api.php" %}

Untuk melakukan testing Rest API nya kita buat file Request Http atau menggunakan Postman request seperti berikut:

{% gist page.gist "08l-mahasiswa-controller.http" %}

Dan yang terakhir buat environtment juga supaya memudahkan untuk menjalankan di berbagai environment seperti berikut:

{% gist page.gist "08l-http-client.env.json" %}

Nah sekarang kita coba jalankan dulu untuk Development mode yaitu menggunakan perintah:

{% highlight bash %}
php artisan serve
{% endhighlight %}

Sekarang kita jalankan Http Requestnya menggunakan env `dev` yaitu `localhost:8000` untuk `get Mahasiswa list` dan `get mahasiswa id` maka hasilnya seperti berikut:

1. Get Mahasiswa list
    ![api-dev-mahasiswa-list]({{ page.image_path | prepend: site.baseurl }}/api-dev-mahasiswa-list.png)

2. Get Mahasiswa id
    ![api-dev-mahasiswa-id]({{ page.image_path | prepend: site.baseurl }}/api-dev-mahasiswa-id.png)

## Create Sample Frontend Apps

Untuk membuat frontend application di Laravel kita bisa include CSS dan JS menggunakan Laravel Mix. Laravel Mix is a package developed by Laracasts creator Jeffrey Way, provides a fluent API for defining webpack build steps for your Laravel application using several common CSS and JavaScript pre-processors. 

Sebagai contoh kita akan menginstall package `bootstrap`, `font-awesome`, `jquery`, `jquery-datatables` menggunakan perintah berikut:

{% highlight bash %}
npm install && \
npm install --save @popperjs/core bootstrap datatables.net datatables.net-bs5 font-awesome jquery
{% endhighlight %}

Kemudian kita bundle `js`, `css` libraries dari folder `node_modules` menggunakan `webpack.mix.js` dengan meng-import nya di folder `resources/{js,css}` seperti berikut:

1. Import js dengan edit file `resources/js/app.js` seperti berikut:

    {% gist page.gist "08l-resources-js-app.js" %}

2. Import css file dengan edit file `resources/css/app.css` seperti berikut:

    {% gist page.gist "08l-resources-css-app.css" %}

3. Kemudian kita edit file `resources/view/welcome.blade.php` seperti berikut:

    {% gist page.gist "08l-welcome.blade.php" %}

Setelah itu kita compile file js, css nya dengan menggunakan perintah:

{% highlight bash %}
npm run-script dev
{% endhighlight %}

Dan kita coba jalankan PHP development mode menggunakan perintah seperti berikut:

{% highlight bash %}
php artisan serve
{% endhighlight %}

Sekarang kita coba access browsernya, maka hasilnya seperti berikut:

![laravel-jquery-datatables]({{ page.image_path | prepend: site.baseurl }}/laravel-jquery-datatables.png)

## Deploy Production Mode

Ok sekarang kita update deployment ke server production untuk tambahan feature Frontend dan Rest API. Tpi sebelum itu karena kita menggunakan NPM untuk menginstall depedencynya. jadi kita perlu install NodeJS dulu di Server dengan menggunakan perintah berikut:

{% highlight bash %}
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

## install node version 14.15
nvm install 14.15

## set default node 14.15
nvm use 14.15

## install dependency dengan npm
npm install

## compile prod
npm run-script prod
{% endhighlight %}

Kemudian kita upload source-code terbaru dengan menggunakan perintah `scp` seperti berikut:

{% highlight bash %}
scp -r * username@your-server.hostname:/var/www/php
{% endhighlight %}

Setelah kita upload, sekarang kita install dependencynya menggunakan perintah seperti berikut:

{% highlight bash %}
## install dependency dengan npm
npm install

## compile production mode
npm run-script prod

## remove dependency node_modules
rm -rf node_modules

## optimaze build
php artisan optimize

## restart server apache
systemctl restart apache2
{% endhighlight %}

Sekarang kita coba access menggunakan browser, maka hasilnya seperti berikut:

![laravel-prod-deploy]({{ page.image_path | prepend: site.baseurl }}/laravel-prod-deploy.png)

## Build & Run Docker images

Setelah kita memahami manual deploymentnya ke production server, sekarang kita build docker imagenya. Untuk membuild docker image brati kita memiliki 2 environment yaitu `php` dan `node` nah jadi bagaimana solusinya

1. Build custome image (include `node` dan `php-apache` )
2. multiple stage

Klo saya sendiri lebih sering menggunakan multiple stage, karena dari project tersebut tidak membutuhkan dependency `node` atau hanya sebagai compiler saja. Ok langsung ja kita edit file `Dockerfile`nya seperti berikut:

{% gist page.gist "08l-dockerfile" %}

Kemudian coba build dengan menggunakan perintah:

{% highlight bash %}
docker build -t dimmaryanto93/docker-laravel:2021.07.25.10.30-release .
{% endhighlight %}

Jika dijalankan outputnya seperti berikut:

```powershell
➜ docker-laravel git:(master) docker build -t dimmaryanto93/docker-laravel:2021.07.25.10.30-release .
[+] Building 46.2s (25/25) FINISHED
 => [internal] load build definition from Dockerfile                                                               0.0s
 => => transferring dockerfile: 32B                                                                                0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 35B                                                                                   0.0s
 => [internal] load metadata for docker.io/library/node:14.15-alpine3.13                                           4.8s
 => [internal] load metadata for docker.io/library/php:8.0-apache                                                  4.7s
 => [auth] library/php:pull token for registry-1.docker.io                                                         0.0s
 => [auth] library/node:pull token for registry-1.docker.io                                                        0.0s
 => [php_laravel 1/4] FROM docker.io/library/php:8.0-apache@sha256:bc3bf769aff70e8f8183f087d9d855b492826aa94052c1  0.0s
 => [internal] load build context                                                                                  0.1s
 => => transferring context: 42.85kB                                                                               0.0s
 => [frontend_builder 1/4] FROM docker.io/library/node:14.15-alpine3.13@sha256:03b86ea1f9071a99ee3de468659c9af95c  0.0s
 => CACHED [php_laravel 2/4] RUN apt-get update && apt-get install -y   curl   git   libicu-dev   libpq-dev   lib  0.0s
 => CACHED [php_laravel 3/4] RUN pecl install mcrypt-1.0.4 &&   docker-php-ext-install fileinfo exif pcntl bcmath  0.0s
 => CACHED [php_laravel 4/4] RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --fi  0.0s
 => CACHED [stage-2 1/9] WORKDIR /var/www/php                                                                      0.0s
 => CACHED [stage-2 2/9] RUN sed -i "s|DocumentRoot /var/www/html|DocumentRoot /var/www/php/public|g" /etc/apache  0.0s
 => [stage-2 3/9] COPY . .                                                                                         0.1s
 => CACHED [frontend_builder 2/4] WORKDIR /var/www/php                                                             0.0s
 => [frontend_builder 3/4] COPY . .                                                                                0.1s
 => [frontend_builder 4/4] RUN npm install -q && npm run-script prod                                              33.9s
 => [stage-2 4/9] COPY --from=frontend_builder /var/www/php/public/css public/css                                  0.0s
 => [stage-2 5/9] COPY --from=frontend_builder /var/www/php/public/images public/images                            0.1s
 => [stage-2 6/9] COPY --from=frontend_builder /var/www/php/public/fonts public/fonts                              0.1s
 => [stage-2 7/9] COPY --from=frontend_builder /var/www/php/public/js public/js                                    0.0s
 => [stage-2 8/9] RUN mkdir -p public/storage && chmod -R 777 storage/* && chmod -R 777 public/storage             0.3s
 => [stage-2 9/9] RUN php -r "file_exists('.env') || copy('.env.example', '.env');" &&     composer install --no-  6.4s
 => exporting to image                                                                                             0.5s
 => => exporting layers                                                                                            0.4s
 => => writing image sha256:495c681e18799790d476208b34c8318a766ca773a81441dbec6a2967adc0b3b4                       0.0s
 => => naming to docker.io/dimmaryanto93/docker-laravel:2021.07.25.10.30-release
```

Selanjutnya kita bisa coba jalankan containernya dengan perintah seperti berikut:

{% highlight bash %}
docker run --name apache-laravel -p 80:80 -d dimmaryanto93/docker-laravel:2021.07.25.10.30-release
{% endhighlight %}

Maka hasilnya seperti berikut:

![laravel-docker-deploy]({{ page.image_path | prepend: site.baseurl }}/laravel-docker-deploy.png)

## Cleanup

Seperti biasa setelah kita mencoba schenario studi kasus tersebut. sekarang kita bersih-bersih dulu ya berikut perintahnya:

For Bash script:

{% gist page.gist "08k-cleanup.bash" %}

For Powershell script:

{% gist page.gist "08k-cleanup.ps1" %}