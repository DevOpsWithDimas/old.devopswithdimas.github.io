---
layout: post
title: "Pipeline: Laravel deploy with Gitlab CI"
lang: docker
categories:
- DevOps
- Docker
- ci
- Study-Cases
- Gitlab-CI
refs: 
- https://docs.gitlab.com/ee/ci/examples/deployment/composer-npm-deploy.html
youtube: 
comments: true
catalog_key: study-cases-docker-ci
image_path: /resources/posts/docker/12g-pipeline-laravel
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, di materi study kasus kali ini kita akan membahas Pipeline untuk Laravel application berdasarkan source-code [berikut]({% post_url docker/09-study-cases/2021-09-27-10e-httpd-ssl-docker %}). Seperti biasa karena pembahasan kali akan lumayan panjang kita bagi-bagi menjadi beberapa bagian, Diantaranya

1. Introduction to workflow deployment
2. Build custome image to test, and build Laravel application
3. Write unit/integration testing locally
4. Pipeline unit/integration testing with Gitlab CI
5. Add local caching/proxy to build with Gitlab CI
6. Build source-code to site resources with Gitlab CI
7. Build docker image with Gitlab CI
8. Test run containers

Ok langsung kita ke pembahasan yang pertama yaitu

## Introduction to workflow deployment

Berdasarkan materi-materi sebelumnya, kita sudah bisa membuat CI Pipeline untuk berbagai macam bahasa pemograman mulai dari JavaEE, PHP, Springboot dan Angular. 

Untuk Laravel sendiri kita membutuhkan cara yang sedikit berbeda karena membutuhkan environment dan dependencies specific berdasarkan project yang telah kita buat untuk melakukan seperti Test, dan build source-code menjadi artifact.

Basicly secara workflow kita akan membuat

1. `Dockerfile-ci`, untuk based image melakukan test, build laravel aplikasi
2. Build frontend (Laravel mix) using [node](https://hub.docker.com/_/node) docker image
3. `Dockerfile-run`, untuk serve content Laravel Application

## Build custome image to test, and build Laravel apps

Sebetulnya kita bisa menggunakan `Dockerfile` yang telah kita buat pada materi [sebelumnya]({% post_url docker/07-study-cases/2021-07-26-08m-build-laravel-using-db %}), pada file tersebut terdiri dari `3 stage` yaitu

1. Custome environment php dengan apache
2. Build frontend
3. Serve laravel application dengan menggunakan image based pada stage pertama.

Hanya saja jika kita menggunakan configurasi seperti itu, component di dalamnya tidak bisa reusable seperti contohnya jika kita mau test aplikasi sebelum di build jadi docker image. Maka dari itu kita akan split menjadi 3 step tadi, Sekarang tahap pertama ini kita akan membuat CI Pipeline untuk 

1. Build custome image, yang berfungsi untuk envinment Laravel Aplikasi itu sendiri misalnya run PHPUnit Test, DB Migration ataupun build source-code
2. Build frontend (Laravel MIX)

Ok pertama kita buat file `Dockerfile` baru dengan nama `Dockerfile-ci` seperti berikut:

{% gist page.gist "12g-dockerfile-ci" %}

Dan yang terakhir, kita buat file baru dengan nama `.gitlab-ci.yml` seperti berikut:

{% gist page.gist "12g-gitlab-ci.custom-image.yml" %}

Jika sudah kita bisa, commit dan push ke repository gitlabnya. Kemudian kita bisa check pipelinenya seperti berikut:

![build-env-laravel-pipeline]({{ page.image_path | prepend: site.baseurl }}/01-build-laravel-env-pipeline.png)

Jadi pada pipeline `build:docker:php-laravel` kita bisa build everytime kita update file `Dockerfile-ci` dan `.gitlab-ci.yml`. Jika sudah selesai hasilnya seperti berikut:

![build-env-laravel-job-detail]({{ page.image_path | prepend: site.baseurl }}/02-build-laravel-env-job-detail.png)

Dan berikut adalah docker image pada Nexus OSS:

![docker-image-php-laravel]({{ page.image_path | prepend: site.baseurl }}/03-docker-image-php-laravel.png)

Sedangkan untuk pipeline `build:mix:production` kita perlu membuat tag dengan surfix `xx.xx.xx.xx-release` contohnya seperti berikut:

![build-laravel-mix-pipeline]({{ page.image_path | prepend: site.baseurl }}/04-build-laravel-mix-pipeline.png)

Dan jika sudah selesai, kita bisa lihat job detailnya seperti berikut:

![build-laravel-mix-job-detail]({{ page.image_path | prepend: site.baseurl }}/05-build-laravel-mix-job-detail.png)


## Write unit/integration testing locally

