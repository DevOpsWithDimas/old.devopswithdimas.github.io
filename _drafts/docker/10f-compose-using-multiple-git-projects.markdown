---
layout: post
title: "Compose file for multiple git projects"
date: 2021-09-28T14:44:07+07:00
lang: docker
categories:
- DevOps
- Docker
- Compose
- Study-Cases
refs: 
- https://docs.docker.com/
- https://git-scm.com/book/en/v2/Git-Tools-Submodules
youtube: 
comments: true
catalog_key: study-cases-compose-files
image_path: /resources/posts/docker/10e-compose-using-multiple-git-projects
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, pada materi study kasus kali ini kita akan membahas tentang Multiple git project dalam menggunakan docker compose. Diantaranya kita akan bahas

1. Introduction
2. Solution 1 (Using separate compose file per project)
3. Solution 2 (Include all compose files)
4. Solution 3 (Centralize compose file)

Ok langsung aja kita ke pembahasan yang pertama

## Introduction

Jaman sekarang itu hampir semua aplikasi menggunakan arsitektur micro-services, artinya semua service di pecah-pecah menjadi beberapa module. Dengan begitu biasanya setiap module akan di buatkan project gitnya seperti

1. backend
    1. backend-1
    2. backend-2
    3. backend-n
2. api-gateway
3. frontend
4. mobile-android
5. mobile-ios

Yang jadi pertanyaan sebagai seorang DevOps bagaimana kita deploy jika kita menggunakan compose file?

Nah buat temen-temen mau meng-deploy microservices dengan arsitketurnya seperti study kasus sebelumnya yaitu

1. [spring-boot (backend)]({% post_url docker/09-study-cases/2021-09-14-10c-compose-springboot-study-case %})
2. [Angular (frontend)]({% post_url docker/09-study-cases/2021-09-26-10d-compose-angular-study-case %})

Tapi sebelum itu saya mau import dulu project `angular` dan `spring-boot` menggunakan `git submodule` dengan perintah seperti berikut:

{% highlight bash %}
git submodule add --force --name frontend \
-b compose/angular \
git@repository.dimas-maryanto.com:youtube/devops/docker.git frontend;

git submodule add --force --name backend \
-b compose/spring-boot \
git@repository.dimas-maryanto.com:youtube/devops/docker.git backend;
{% endhighlight %}

Maka sekarang kita punya struktur directory seperti berikut:

```powershell
C:\USERS\DIMASM93\WORKSPACES\UDEMY\DOCKER
➜ docker git:(compose/multiple-projects) tree .
Folder PATH listing

C:\USERS\DIMASM93\WORKSPACES\UDEMY\DOCKER
├───.idea
├───backend
└───frontend
```


## Solusi 1 (Using separate compose file per project)

Nah kita bisa jalankan masing-masing servicenya per compose file (`1` service/project `1` compose file), klo saya gambarkan structur filenya seperti berikut:

```powershell
➜ docker git:(compose/run-per-project) tree .
Folder PATH listing

C:\USERS\DIMASM93\WORKSPACES\UDEMY\DOCKER
├───backend (spring-boot)
│   ├───docker-compose.yaml
│   └───docker-compose.production.yaml
└───frontend (angular)
    ├───docker-compose.yaml
    └───docker-compose.production.yaml
```

Sekarang kita buat saja compose file baru dengan nama `docker-compose.per-project.yaml` untuk backend (spring-boot) seperti berikut:

{% gist page.gist "10f-spring-boot.docker-compose.per-project.yaml" %}

Dan setelah itu kita juga buat compose file baru untuk frontend (angular) seperti berikut:

{% gist page.gist "10f-angular.docker-compose.per-project.yaml" %}

Jadi disini karena service `angular` membutuhkan service `spring-boot` tetapi kita tidak mendefined secara bersaama (berbeda path compose file). jadi solusinya adalah menggunakan network binding host yaitu ip-address host dan ini tidak **bisa menggunakan** `localhost` atau `127.0.0.1`. Sebagai contoh disini ip address yang saya terpakan adalah 

```powershell
➜ docker git:(compose/run-per-project)  ipconfig.exe

Ethernet adapter Ethernet:

   Connection-specific DNS Suffix  . :
   Link-local IPv6 Address . . . . . : fe80::cc00:7233:e9c8:356c%21
   IPv4 Address. . . . . . . . . . . : 192.168.88.252
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : 192.168.88.1
```

Jadi kita perlu rubah untuk environment variable `BACKEND_HOST=<your-network-ip>` menjadi `BACKEND_HOST=192.168.88.252`. Sekarang klo kita coba jalankan menggunakan perintah seperti berikut:

{% highlight bash %}
docker-compose --project-directory backend \
-f backend/docker-compose.yaml \
-f backend/docker-compose.per-project.yaml up -d build-jar && \
docker-compose --project-directory backend \
-f backend/docker-compose.yaml \
-f backend/docker-compose.per-project.yaml up -d --build && \
docker-compose --project-directory frontend \
-f frontend/docker-compose.per-project.yaml up -d --build
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ docker git:(compose/run-per-project) docker-compose --project-directory backend -f backend\docker-compose.yaml -f backend\docker-compose.per-project.yaml up -d build-jar
[+] Running 2/2
 - Network backend_default        Created                                   0.0s
 - Container backend-build-jar-1  Starte...                                 1.4s

➜ docker git:(compose/run-per-project) docker-compose --project-directory backend -f backend\docker-compose.yaml -f backend\docker-compose.per-project.yaml up -d --build
[+] Running 2/2
 - Container backend-postgres-1     Runni...                                0.0s
 - Container backend-spring-boot-1  Ru...                                   0.0s

➜ docker git:(compose/run-per-project) docker-compose --project-directory backend -f backend\docker-compose.yaml -f backend\docker-compose.per-project.yaml ps
NAME                    COMMAND                  SERVICE             STATUS              PORTS
backend-build-jar-1     "/usr/local/bin/mvn-…"   build-jar           exited (0)  
backend-postgres-1      "docker-entrypoint.s…"   postgres            running             0.0.0.0:55432->5432/tcp
backend-spring-boot-1   "java -jar -Djava.se…"   spring-boot         running (healthy)   0.0.0.0:8080->8080/tcp

➜ docker git:(compose/run-per-project) docker-compose --project-directory frontend -f frontend\docker-compose.per-project.yaml up -d
[+] Running 1/0
 - Container frontend-angular-1  Running                                    0.0s

➜ docker git:(compose/run-per-project) docker-compose --project-directory frontend -f frontend\docker-compose.per-project.yaml ps
NAME                 COMMAND                  SERVICE             STATUS              PORTS
frontend-angular-1   "/docker-entrypoint.…"   angular             running (healthy)   0.0.0.0:80->80/tcp
```
