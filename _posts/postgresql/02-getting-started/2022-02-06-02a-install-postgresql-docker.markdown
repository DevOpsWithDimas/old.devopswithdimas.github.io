---
layout: post
title: "Install PostgreSQL using Docker"
date: 2022-02-06T10:25:40+07:00
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
- getting-started
refs: 
- https://hub.docker.com/_/postgres
youtube: 
image_path: /resources/posts/postgresql/02a-install-postgres-docker
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

## Using `pgAdmin4` web based

Untuk text editor seperti `pgadmin4` kita bisa menggunakan versi Desktop atau juga kita bisa menggunakan version web yang kita pasang dalam docker, sepertinya temen-temen liat pada script `docker-compose.yaml` sebelumnya seperti berikut:

{% highlight yaml %}
pgadmin4:
  image: ${PRIVATE_REPOSITORY}dpage/pgadmin4
  profiles:
    - debug
  environment:
    - PGADMIN_DEFAULT_PASSWORD=${POSTGRES_PASSWORD}
    - PGADMIN_DEFAULT_EMAIL=${POSTGRES_USER}@example.com
  ports:
    - 55432:80
  volumes:
    - pg_admin_data:/var/lib/pgadmin
  depends_on:
    - postgres
{% endhighlight %}

Untuk meng-aktifikan container `pgadmin4` tersebut, kita perlu menggunakan profile `debug` dengan perintah seperti berikut:

{% highlight docker %}
docker-compose -f docker-compose.yaml --env-file .env --profile debug up -d
{% endhighlight %}

Jika sudah, kita bisa akses dengan alamat [localhost:55432](http://localhost:55432) seperti berikut:

![pgadmin4]({{ page.image_path | prepend: site.baseurl }}/01-pgadmin4-web.png)

Sekarang kita akan buat connection ke PostgreSQL server di Docker, Kita klik kanan di Menu **Servers** -> **Create** -> **Server** kemudian kita input connection name contohnya: `postgresql` dan kemudian kita ke tab **Connection** seperti berikut:

![new connection]({{ page.image_path | prepend: site.baseurl }}/02-pgadmin4-connection.png)

Berikut properties:

| Property    | Value       | Description     |
| :---        | :---        | :---            |
| `Host`      | `postgres`  | Karena kita menggunakan container, kita tidak bisa menggunakan `localhost` karena docker memiliki ip yang berbeda setiap container |
| `Database`  | `postgres`  | Sesuaikan dengan .env yang telah kita buat |
| `Username`  | `postgres`  | Sesuaikan dengan .env yang telah kita buat |
| `Password`  | `password`  | Sesuaikan dengan .env yang telah kita buat |

Jika sudah, kita klik **Save**, maka jika success hasilnya seperti berikut:

![admin4 connected]({{ page.image_path | prepend: site.baseurl }}/03-connected.png)

## Migrate schema using flyway

Untuk belajar, kita membutuhkan user & database/schema untuk mencoba feature dari PostgreSQL. Sekarang kita akan buat user & database di Docker melalui `psql`

{% highlight docker %}
docker-compose \
  -f docker-compose.yaml \
  --env-file .env \
  exec postgres \
  psql -U postgres -W 
{% endhighlight %}

Kemudian kita buat schema dengan perintah seperti berikut:

{% gist page.gist "02a-create-user-schema.sql" %}

Setelah kita buat schema, user dan database, kita download [file ini]({{ site.baseurl }}/resources/downloads/file/postgresql/psql-schema.sql) simpan dalam folder `db/migration` dan jalankan migrationnya dengan perintah

{% highlight docker %}
docker-compose \
-f docker-compose.yaml \
--env-file .env \
--profile migrate up -d
{% endhighlight %}

Jika sudah sekarang kita bisa check dengan perintah berikut:

{% highlight docker %}
docker-compose \
-f docker-compose.yaml \
--env-file .env \
exec postgres psql -U hr -W -c "\dt"
{% endhighlight %}

Jika dijalankan hasilnya seperti berikut:

```powershell
➜ postgresql git:(master) docker-compose -f docker-compose.yml --env-file .env exec postgres psql -U hr -W -c "\dt"
Password:
                  List of relations
  Schema  |         Name          | Type  |  Owner
----------+-----------------------+-------+----------
 hr       | countries             | table | hr
 hr       | departments           | table | hr
 hr       | employees             | table | hr
 hr       | flyway_schema_history | table | hr
 hr       | job_history           | table | hr
 hr       | jobs                  | table | hr
 hr       | locations             | table | hr
 hr       | regions               | table | hr
(8 rows)
```