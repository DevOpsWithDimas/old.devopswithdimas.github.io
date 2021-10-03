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
- https://id.wikipedia.org/wiki/Transport_Layer_Security
youtube: 
comments: true
catalog_key: study-cases-compose-files
image_path: /resources/posts/docker/10e-httpd-ssl
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---


Hai semuanya, di video study kasus kali ini kita akan membahas tentang Configure ssl/https pada httpd berdasarkan study kasus [sebelumnya]({% post_url docker/09-study-cases/2021-09-12-10b-compose-laravel-study-case %}). 

Untuk deployment Laravel application paling commons di production adalah menggunakan [SSL/TLS (Secure Sockets Layer / Transport Layer Security)](https://id.wikipedia.org/wiki/Transport_Layer_Security) Certificate atau dengan katalain menggunakan [https (Hypertext Transfer Protocol Secure)](https://id.wikipedia.org/wiki/HTTPS) yang khusus menangani web aplication.

Ada banyak cara untuk deployment Laravel Application di production menggunakan https, Diantaranya yang akan kita bahas yaitu

1. SSL/https as reverse proxy
2. SSL/https direct from docker to host

Ok langsung ja kita ke pembahasan yang pertama yaitu

## Setup ssl/https as reverse proxy

Untuk setup ssh/https sebagai reverse proxy di [httpd/apache2](https://httpd.apache.org/) yang perlu kita siapkan, environment seperti berikut:

1. VM reverse-proxy
2. VM worker 1, 2, 3, n

Jadi kalau kita gambarkan seperti berikut arsitekturnya:

![ssl-reverse-proxy-arch]({{ page.image_path | prepend: site.baseurl }}/ssl-reverse-proxy.png)

Untuk membuat arsitektur seperti berikut, 

Kita perlu siapkan dulu service `laravel` dan `database` menggunakan compose file seperti berikut. Simpan dengan nama `docker-compose.reverse-proxy.yaml`:

{% gist page.gist "10e-proxy.docker-compose.reverse-proxy.yaml" %}

Setelah itu kita bisa jalankan dengan perintah `docker-compose up -d` seperti berikut:

{% highlight bash %}
docker-compose -p reverse-proxy \
-f docker-compose.yaml \
-f docker-compose.reverse-proxy.yaml \
--env-file .env \
up -d
{% endhighlight %}

Setelah semua servicenya running, kita bisa setup httpsnya yang kita install menggunakan `apache2` di Linux VM dengan perintahnya seperti berikut:

{% highlight bash %}

{% endhighlight %}