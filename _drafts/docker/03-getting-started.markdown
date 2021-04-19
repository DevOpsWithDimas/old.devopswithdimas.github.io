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

Hai semuanya, sekarang saatnya kita mulai belajar perintah-perintah docker. Basicly kita akan membahas yang paling penting yaitu 

1. Pull image from registry
2. Show list of docker image
3. Running docker image
4. Accessing container
5. View logs
6. Cleanup

## Pulling image from registry

{% gist page.gist "03-docker-pull-image.bash" %}

Setelah kita pull image dari public registry, maka image docker akan di simpan di local pc kita, untuk mengetahui image apa saja yang telah kita pull berikut adalah perintahnya:

{% gist page.gist "03-docker-list-images.bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```bash
## output
# REPOSITORY                     TAG                 IMAGE ID            CREATED             SIZE
# mysql                          5.7                 563a026a1511        2 weeks ago         372MB
# postgres                       9.6                 0178d5af9576        4 weeks ago         229MB
# microsoft/mssql-server-linux   2017-latest         e254a7681c2f        5 weeks ago         1.44GB
```

## Running docker image

Untuk menjalankan docker image, kita menggunakan perintah seperti berikut:

{% gist page.gist "03-docker-run-image.bash" %}

Artinya dari perintah tersebut:

1. Service_name : `postgres_db` untuk argument `--name postgres_db`
2. Port yang di expose : `5432` untuk argument `-p 5432:5432`
3. Password untuk user postgres : `postgres` untuk argument `-e POSTGRES_PASSWORD=postgres`
4. Database name : `data_db` untuk argument `-e POSTGRES_DB=data_db`
5. Jalankan di background, untuk argument `-d`
6. Argument `-v /var/lib/postgresql/data` artinya lokasi tersebut akan di simpan dalam suatu volume

## Accessing container

Nah sekarang kita bisa check containernya apakah udah run dengan cara perintah berikut:

{% gist page.gist "03-docker-list-container.bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```bash
## output console
#CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
#b91d16813041        postgres:9.6        "docker-entrypoint.s…"   2 minutes ago       Up 45 seconds       0.0.0.0:5432->5432/tcp   postgres_db
```

Setelah itu kita bisa connect ke postgresql dalam docker container, dengan menggunakan perintah berikut:

{% gist page.gist "03-docker-exec.bash" %}

## View logs container

Selain itu, kita juga bisa lihat lognya bila terjadi error pada container yang sedang dijalankan tiba2 mati, dengan menggunakan perintah berikut:

{% gist page.gist "03-docker-logs.bash" %}

## Cleanup

Jika kita sudah selesai, kita bisa cleanup mulai dari container, images, volume, network yang digunakan dengan perintah seperti berikut:

{% gist page.gist "03-docker-prune.bash" %}
