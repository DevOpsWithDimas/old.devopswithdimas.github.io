---
layout: post
title: "Using Docker on Jetbraint IDE"
lang: docker
categories:
- DevOps
- Docker
- Context
- Dashboard
refs: 
- https://www.jetbrains.com/help/idea/docker.html
youtube: 
comments: true
catalog_key: docker-context
image_path: /resources/posts/docker/11e-docker-jetbraint
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


Hai semuanya, di materi kali ini kita akan membahas tentang Manage service dan application pada Docker menggunakan IntelliJ IDEA. Diantaranya yang akan kita bahas yaitu

1. Introduction
2. Enable Docker support to IntelliJ IDEA
3. Managing images
    - Configure docker registires
    - Pull image from docker registry
    - Push image to docker registry
4. Running containers
    - Run from docker image
    - Run from Dockerfile
    - Run via Docker compose
5. Interation to container
    - view logs
    - view stats
    - execute command
6. Scale a service

Ok langsung aja kita ke pembahasan yang pertama

## Introduction

Jetbraint [IntelliJ IDEA](https://www.jetbrains.com/idea/) adalah salah satu Integrated Development Environment (IDE) favorite saya selama ini, biasanya saya gunakan untuk Coding, Database, dan lain-lain.

## Enable Docker support to IntelliI IDEA

Untuk meng-aktifkan Docker support di IntelliJ IDEA kita perlu install plugin [docker](https://plugins.jetbrains.com/plugin/7724-docker?_ga=2.204595344.1667072148.1636275769-1635107743.1636275769) dari marketplace Jetbraint, by default jika temen-temen menggunakan Ultimate Edition plugin docker tersebut sudah ter-install di IntelliJ IDEA, sedangkan untuk community edition temen-temen perlu install secara manual di **Menu -> Settings -> Plugins -> Marketplace** seperti berikut

![marketplace-docker]({{ page.image_path | prepend: site.baseurl }}/01-marketplace-docker.png)

Setelah ter-install, kita akan configure supaya docker dan IntelliJ IDEA terintegrasi, kita masuk ke **Menu -> Settings -> Build, Execution, dan Deployment -> Docker** seperti berikut:

![marketplace-docker]({{ page.image_path | prepend: site.baseurl }}/02-jetbraint-docker-settings.png)

Jika di IDEA temen-temen belum ada konfigurasi tersebut, bisa klik `+` untuk menambahkan Docker server baru, Kemudian konfigurasi sesuai dengen kebutuhan contohnya connection lewat ssh, atau lewat tcp dan lain-lain. Jika sudah OK nanti di bawah akan ada connection statusnya seperti gambar tersebut `Connection successful` dan yang terkahir kita bisa `Apply` konfigurasinya. Maka jika buka tab `Services` hasilnya seperti berikut:

![jetbraint-services]({{ page.image_path | prepend: site.baseurl }}/03-jetbraint-services-docker.png)