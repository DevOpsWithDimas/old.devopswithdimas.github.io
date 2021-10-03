---
layout: post
title: "Deploy httpd with ssl/https on docker"
date: 2021-09-27T15:44:07+07:00
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
catalog_key: study-cases-compose-files
image_path: /resources/posts/docker/10e-httpd-ssl-docker
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


Hai semuanya, di video study kasus kali ini kita akan membahas tentang Configure ssl/https pada httpd berdasarkan study kasus [sebelumnya]({% post_url docker/09-study-cases/2021-09-12-10b-compose-laravel-study-case %}). Diantaranya yang akan kita bahas yaitu

1. Setup ssl/https as reverse proxy
2. Setup ssh/https direct from docker to host

Ok langsung aja kita ke pembahas yang pertama

## Setup ssl/https as reverse proxy

