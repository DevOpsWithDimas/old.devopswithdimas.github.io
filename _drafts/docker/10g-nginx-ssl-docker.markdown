---
layout: post
title: "Deploy nginx with ssl/https on docker"
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
youtube: 
comments: true
catalog_key: study-cases-compose-files
image_path: /resources/posts/docker/10g-nginx-ssl
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, di video study kasus kali ini kita akan membahas tentang Configure ssl/https pada nginx berdasarkan study kasus [sebelumnya]({% post_url docker/09-study-cases/2021-09-28-10f-compose-using-multiple-git-projects %}). Diantaranya yang akan kita bahas yaitu

1. Setup ssl/https as reverse and balancer
2. Setup ssh/https direct from docker to host

Ok langsung aja kita ke pembahasan yang pertama yaitu

<!--more-->

## Setup ssh/https as reverse proxy

Untuk setup ssl/https sebagai reverse proxy pada [nginx](https://www.nginx.com/) yang kita perlu siapakan, environment seperti berikut:

1. VM reverse-proxy
2. VM Worker 1 ... n

Jadi jika kita gambarkan seperti berikut artistekturnya:

![as-reverse-proxy]({{ page.image_path | prepend: site.baseurl }}/ssl-as-reverse-proxy.png)

Untuk membuat arsitektur tersebut, kita perlu siapkan service `spring-boot`, `postgresql database` dan `angular` menggunakan compose file seperti berikut. 

Buatlah compose file dengan nama `docker-compose.reverse-proxy.yaml`:

{% gist page.gist "10g-proxy.docker-compose.reverse-proxy.yaml" %}