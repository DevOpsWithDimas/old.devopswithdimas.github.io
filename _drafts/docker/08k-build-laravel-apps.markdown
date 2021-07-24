---
layout: post
title: "Study Kasus: Build Docker image for Laravel Framework"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/
- https://laravel.com/docs/8.x#installation-via-composer
- https://laravel.com/docs/8.x/deployment
youtube: 
comments: true
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

Setelah kita configure engine PHP nya, selanjutnya kita install untuk package managernya yaitu menggunakan [Composer](https://getcomposer.org/doc/00-intro.md#system-requirements) dan NodeJS serta NPM. Setelah kita install selantutnya kita buat project dengan menggunakan perintah seperti berikut:

{% highlight bash %}
composer create-project laravel/laravel docker-laravel && \
cd docker-laravel && \
npm install && \
composer install
{% endhighlight %}

Setelah itu kita bisa config dulu system Laravelnya seperti 

1. `Copy .env.example` menjadi `.env` menggunakan perintah berikut: `php -r "file_exists('.env') || copy('.env.example', '.env');"`
2. Set `APP_KEY` dengan `php artisan package:discover --ansi && php artisan key:generate --ansi`
3. Set `APP_URL` dengan empty string seperti berikut `APP_URL=""`

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