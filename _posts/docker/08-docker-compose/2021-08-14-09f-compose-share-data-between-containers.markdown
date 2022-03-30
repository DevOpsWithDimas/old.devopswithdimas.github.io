---
layout: post
title: "Share data between Containers in Compose"
date: 2021-08-14T19:43:31+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Compose
- Volume
refs: 
- https://docs.docker.com/storage/volumes/
youtube: cAwtgQ4P5X0
comments: true
catalog_key: docker-compose
image_path: /resources/posts/docker/09f-compose-advanced-volume
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini kita akan membahas tentang share volume between containers 

Temen-temen masih ingat khan [materi sebelumnya]({% post_url docker/05-docker-volume/2021-06-05-06c-share-data-among-containers %}) untuk share data between container??

Jadi di materi tersebut kita membuat local volume (named volume) kemudian di terapkan pada beberapa container sekaligus dan juga memiliki mounting point yang sama pada containernya seperti berikut:

{% gist page.gist "06c-share-local-volume.bash" %}

Terlihat pada volume `public_html` digunakan pada kedua container tersebut yaitu `local_webapp` dan `local_webapp2`, Nah sekarang kita akan buat menggunakan compose file seperti berikut:

{% gist page.gist "09f-data-container.docker-compose.yaml" %}

Sekarang kalo kita jalankan menggunakan perintah seperti berikut:

{% highlight bash %}
docker-compose -f data-container.docker-compose.yaml up -d
{% endhighlight %}

Maka hasilnya seperti berikut:

```powershell
➜ share-container  docker-compose -f .\09f-data-container.docker-compose.yaml up -d
share-container_nginx1_1 is up-to-date
share-container_nginx2_1 is up-to-date

➜ share-container  docker-compose -f .\09f-data-container.docker-compose.yaml ps
          Name                        Command               State                  Ports
--------------------------------------------------------------------------------------------------------
share-container_nginx1_1   /docker-entrypoint.sh ngin ...   Up      0.0.0.0:8081->80/tcp,:::8081->80/tcp
share-container_nginx2_1   /docker-entrypoint.sh ngin ...   Up      0.0.0.0:8082->80/tcp,:::8082->80/tcp

➜ share-container  docker volume ls
DRIVER    VOLUME NAME
local     share-container_public_html

➜ share-container  docker-compose -f .\09f-data-container.docker-compose.yaml exec nginx1 bash
## modif file
root@58dc3fa56b5e:/# echo "<html><head><title>Belajar html</title><head></html>" > /usr/share/nginx/html/index.html
root@58dc3fa56b5e:/# exit

## check content between container has been changed
➜ share-container  docker-compose -f .\09f-data-container.docker-compose.yaml exec nginx1 cat /usr/share/nginx/html/index.html
<html><head><title>Belajar html</title><head></html>

➜ share-container  docker-compose -f .\09f-data-container.docker-compose.yaml exec nginx2 cat /usr/share/nginx/html/index.html
<html><head><title>Belajar html</title><head></html>
```