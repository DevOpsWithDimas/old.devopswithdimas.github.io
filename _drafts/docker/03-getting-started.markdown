---
layout: post
title: "Getting Started with Docker"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/
youtube: 
comments: true
image_path: /resources/posts/docker/05-getting-started
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


## Docker Image

Docker images adalah ibaratnya installer aplikasi, aplikasi yang akan kita install kita harus pull dulu dari [docker-hub](https://hub.docker.com/) konsep nya sama seperti git jadi kita pull, contohnya kalo kita mau install postgresql dalam **docker container** jadi kita pull dulu coba ke docker hub kemudian cara official repository untuk postgresql atau kita juga bisa menggunakan yang unofficial repository. bedanya klo yang official ada mark **official** atau di urlnya seperti berikut [official postgres](https://hub.docker.com/_/postgres/) repository tapi sebelum itu kita harus login dulu klo belum punya akun daftar aja gratis kok dan tidak butuh kartu kredit :)

```git
docker pull postgres
```

Setelah tadi kita pull maka daftar aplikasi yang telah siap digunakan atau di pasang di **Docker container** seperti berikut:

```bash
docker image ls
## output
# REPOSITORY                     TAG                 IMAGE ID            CREATED             SIZE
# mysql                          5.7                 563a026a1511        2 weeks ago         372MB
# postgres                       9.6                 0178d5af9576        4 weeks ago         229MB
# microsoft/mssql-server-linux   2017-latest         e254a7681c2f        5 weeks ago         1.44GB
```

<br/>

## Docker Container

Docker container, itu ibaratnya applikasi yang telah terinstall dari **Docker image**. Misalnya kita mau install postgresql, kita bisa baca2 dokumentasinya dulu properties apa aja yang harus di pasang contohnya seperti berikut:

```bash
docker container run \
    --name postgres_db \
    -p 5432:5432 \
    -v /var/lib/postgresql/data \
    -e POSTGRES_PASSWORD=postgres \
    -e POSTGRES_DB=data_db \
    -d \
    postgres:9.6
```

Artinya dari perintah tersebut:

- service_name : `postgres_db` untuk argument `--name postgres_db`
- port yang di expose : `5432` untuk argument `-p 5432:5432`
- password untuk user postgres : `postgres` untuk argument `-e POSTGRES_PASSWORD=postgres`
- database name : `data_db` untuk argument `-e POSTGRES_DB=data_db`
- postgresql version : `9.6` 
- jalankan di background, untuk argument `-d`

Nah sekarang kita bisa check containernya apakah udah run dengan cara perintah berikut:

```bash
docker container ls
## output console
#CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
#b91d16813041        postgres:9.6        "docker-entrypoint.s…"   2 minutes ago       Up 45 seconds       0.0.0.0:5432->5432/tcp   postgres_db
```

Setelah itu kita bisa connect ke postgresql dalam docker container, caranya sama seperti biasa:

```bash
docker exec -it <container-name> psql -U postgres data_db
```

Hanya bedanya kita tidak menggunakan database yang di install di host kita. Nah mungkin dari temen-teman buat apa nanti datanya hilang donk. Eitssss tenang klo datanya mau di keep ada fiturnya kok namanya **docker volume** nanti akan saya jelaskan yang pasti ini akan memudahkan developer dalam develop app apalagi untuk barang branded seperti Oracle Database, Centos os, JBoss eap dan masih banyak lagi.

