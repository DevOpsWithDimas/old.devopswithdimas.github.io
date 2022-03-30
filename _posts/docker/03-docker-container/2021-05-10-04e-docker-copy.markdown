---
layout: post
title: "Copying files/content between container and filesystem"
date: 2021-05-10T06:21:24+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Container
refs: 
- https://docs.docker.com/engine/reference/commandline/cp/
youtube: MTX6Z0fUBEM
comments: true
catalog_key: docker-container
image_path: /resources/posts/docker/04e-docker-cp
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


Hai semuanya, di materi kali ini kita akan membahas cara meng-Copy files/contents dari atau ke container dengan menggunakan perintah `docker cp`. Berikut adalah dokumentasinya:

{% gist page.gist "04e-docker-cp-help.bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Try the new cross-platform PowerShell https://aka.ms/pscore6

➜ ~  docker cp -h
Flag shorthand -h has been deprecated, please use --help

Usage:  docker cp [OPTIONS] CONTAINER:SRC_PATH DEST_PATH|-
        docker cp [OPTIONS] SRC_PATH|- CONTAINER:DEST_PATH

Copy files/folders between a container and the local filesystem

Use '-' as the source to read a tar archive from stdin
and extract it to a directory destination in a container.
Use '-' as the destination to stream a tar archive of a
container source to stdout.

Options:
  -a, --archive       Archive mode (copy all uid/gid information)
  -L, --follow-link   Always follow symbol link in SRC_PATH
```

## Copying contents into container

Sepertinya kita ketahui bersama, container adalah running image as isolation network & volume. Jadi kita tidak bisa akses secara langsung datanya, jika temen-temen mau akses kita bisa meng-copy content yang kita punya ke dalam container yang sedang berjalan. Sebagai contoh coba jalankan container nginx seperti berikut:

{% gist page.gist "04e-init-nginx.bash" %}

Kemudian kita siapkan juga filenya yang akan kita copy, contohnya seperti berikut:

{% gist page.gist "04e-nginx-halo.html" %}

Sekarang kita copy filenya ke dalam container dengan perintah seperti berikut:

{% gist page.gist "04e-copy-to-container.bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ nginx  ls
    Directory: C:\Users\dimasm93\Workspaces\Example\docker\nginx

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         5/10/2021   5:07 AM            218 belajar-docker.html

➜ nginx  docker cp .\belajar-docker.html webapp:/usr/share/nginx/html/belajar.html

➜ nginx  docker exec webapp ls /usr/share/nginx/html
50x.html
belajar.html
index.html
```

Atau klo kita coba akses melalui browser dengan url [localhost/belajar.html](http://localhost/belajar.html), Hasilnya seperti berikut:

![copy-to-container]({{ page.image_path | prepend: site.baseurl }}/copy-to-container.png)

## Copying contents from inside container to filesystem

Sekarang kita akan melakukan copy file sebaliknya yaitu dari dalam suatu container ke local filesystem kita. contohnya saya mau copy semua configurasi nginx pada folder `/etc/nginx` seperti berikut

```powershell
➜ nginx ✗  docker exec -it webapp bash

root@4a652f595022:/# ls /etc/nginx/
conf.d/         koi-win         nginx.conf      win-utf
fastcgi_params  mime.types      scgi_params
koi-utf         modules/        uwsgi_params
```

Berikut adalah perintahnya:

{% gist page.gist "04e-copy-from-container.bash" %}

Jika dijalankan hasilnya seperti berikut:

```powershell
➜ nginx  docker cp webapp:/etc/nginx/ .

➜ nginx  ls
    Directory: C:\Users\dimasm93\Workspaces\Example\docker\nginx

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         4/14/2021   2:20 AM                nginx
-a----         5/10/2021   5:07 AM            218 belajar-docker.html


➜ nginx  ls .\nginx\
    Directory: C:\Users\dimasm93\Workspaces\Example\docker\nginx\nginx

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         5/10/2021   4:59 AM                conf.d
-a----         4/13/2021  10:13 PM           1007 fastcgi_params
-a----         4/13/2021  10:13 PM           2837 koi-utf
-a----         4/13/2021  10:13 PM           2223 koi-win
-a----         4/13/2021  10:13 PM           5231 mime.types
-a---l         5/10/2021   5:32 AM              0 modules
-a----         4/13/2021  10:40 PM            643 nginx.conf
-a----         4/13/2021  10:13 PM            636 scgi_params
-a----         4/13/2021  10:13 PM            664 uwsgi_params
-a----         4/13/2021  10:13 PM           3610 win-utf
```

## Cleanup

Nah sekarang kita bersihkan-bersih dulu ya. berikut perintahnya:

{% gist page.gist "04e-cleanup.bash" %}