---
layout: post
title: "Install PostgreSQL using Docker"
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: 
- https://hub.docker.com/_/postgres
youtube: 
image_path: /resources/posts/postgresql/02a-install-postgresql-docker
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: getting-started
downloads: 
- name: "schema-hr"
  type: "sql"
  url: /resources/downloads/file/postgresql/psql-schema.sql
- name: "docker-compose"
  type: "yaml"
  url: /resources/downloads/file/postgresql/docker-compose.yaml
---

Hai semuannya, di materi kali ini kita membahas Install PostgreSQL menggunakan Docker, Pembahasannya diantaranya:

1. Install docker
2. Running PostgreSQL in Docker
3. Using `pgAdmin4` web based
4. Migrate schema using flyway

Ok langsung saja kita bahas ke materi yang pertama yaitu

## Install docker

Buat temen-temen yang belum kenal dengan Docker, Docker adalah salah satu teknologi virtualization yang sedang naik daun 3 tahun terakhir karena memudahkan kita untuk melakukan install suatu software/service. Kita juga bisa memanfaatkan docker ini untuk belajar PostgreSQL sebagai Learning environment.

Tahap pertama, yang harus temen-temen lakukan adalah install adalah

1. Install [Docker untuk Windows]({% post_url docker/01-introduction/2021-04-11-02a-install-on-windows10-wls %})
2. Install [Docker untuk linux]({% post_url docker/01-introduction/2021-04-11-02b-install-on-linux-centos %})
3. Install [Docker untuk mac]({% post_url docker/01-introduction/2021-04-13-02c-install-on-mac %})

## Running PostgreSQL in Docker

Untuk menjalakan PostgreSQL di Docker ini sebetulnya sangatlah mudah, kita cukup jalankan perintah:

{% highlight bash %}
docker run -p 5432:5423 \
  -e POSTGRES_PASSWORD=password \
  -d postgres:14.1
{% endhighlight %}

Tetapi kita akan menggunakan docker-compose ya supaya scriptnya tersimpan dengan baik. seperti berikut:

{% gist page.gist "02a-docker-compose.yaml" %}

Kemudian kita buat file `.env` seperti berikut:

{% highlight env %}
PRIVATE_REPOSITORY=docker.io/
POSTGRES_VERSION=14.1-alpine
POSTGRES_PORT=5432
POSTGRES_PASSWORD=password
POSTGRES_USER=postgres
POSTGRES_DB=postgres
{% endhighlight %}

Kemudian kita jalankan dengan perintah

{% highlight docker %}
docker-compose -f docker-compose.yaml --env-file .env up -d
{% endhighlight %}