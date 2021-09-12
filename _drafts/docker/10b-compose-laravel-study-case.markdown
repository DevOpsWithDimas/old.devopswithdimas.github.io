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
image_path: /resources/posts/docker/10b-compose-laravel-study-case
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