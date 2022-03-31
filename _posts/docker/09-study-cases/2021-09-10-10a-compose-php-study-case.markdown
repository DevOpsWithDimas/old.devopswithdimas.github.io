---
layout: post
title: "PHP deployment using compose file"
date: 2021-09-10T07:14:36+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Compose
- Study-Cases
refs: 
- https://docs.docker.com/
youtube: BvnCd0tfJWs
comments: true
catalog_key: study-cases-compose-files
image_path: /resources/posts/docker/10a-compose-php-study-case
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya di materi kali ini kita akan membahas study kasus untuk PHP Development & Deployment menggunakan compose file, berdasarkan [materi sebelumnya]({% post_url docker/07-study-cases/2021-07-18-08j-build-php %}). Seperti biasa kita akan bagi menjadi beberapa bagian yaitu

1. PHP Development env
2. PHP Production env

Ok langsung aja kita bahas 

<!--more-->

## PHP development environment

Pada phase development untuk PHP, kita hanya membutuhkan web server seperti apache dan php engine untuk memproses source code PHP. Dalam penerapan di docker compose kita bisa menggunakan image [php:(version)-apache](https://hub.docker.com/_/php) dan mount-bind volume ke project directory source code nya. Seperti berikut:

{% gist page.gist "10a-dev.docker-compose.yaml" %}

## PHP production environment

Untuk phase production pada PHP, kita perlu build docker image dengan mencopy seluruh source-code PHP dengan tujuan non-writeable dan versionning seperti berikut implementasi compose file:

{% gist page.gist "10a-prod.docker-compose.yaml" %}