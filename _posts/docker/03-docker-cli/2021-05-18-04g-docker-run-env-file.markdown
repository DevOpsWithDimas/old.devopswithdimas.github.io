---
layout: post
title: "Run a Container using Environtment File"
date: 2021-05-18T22:07:38+07:00
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/compose/env-file/
- https://en.wikipedia.org/wiki/Environment_variable
youtube: rwZ5to3_u_Q
comments: true
image_path: /resources/posts/docker/04h-docker-run-env-file
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Environment Variables pada Docker diantaranya:

1. What is Environtment Variable
2. Create Docker Container using Env Variables
3. Using Env Files for Create Docker Containers

## What is Environtment Variable

An environment variable is a dynamic-named value that can affect the way running processes will behave on a computer. They are part of the environment in which a process runs. For example, a running process can query the value of the TEMP environment variable to discover a suitable location to store temporary files, or the HOME or USERPROFILE variable to find the directory structure owned by the user running the process.

## Create Docker Container using Env Variables

Untuk menggunakan Environtment Variable. Kita harus check di dokumentasi docker image yang akan kita gunakan apakah menyediakan Environtment Variable atau tidak. Misalnya sebagai contoh kita lihat ke dokumentasi docker image [postgres](https://hub.docker.com/_/postgres). Di dokumentasi tersebut kita di sediakan beberapa variable contohnya `POSTGRES_PASSWORD`, `POSTGRES_USER`, `POSTGRES_DB` dan lain-lain. 

Nah untuk cara menggunakannya. Kita bisa menggunakan perintah berikut untuk membuat containernya:

For Bash Script:

{% gist page.gist "04g-docker-env-var-args.bash" %}

For Powershell Script:

{% gist page.gist "04g-docker-env-var-args.ps1" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜  docker container run `
--name postgres_env `
-e POSTGRES_USER=root `
-e POSTGRES_DB=example_db `
-e POSTGRES_PASSWORD=password `
-d `
postgres:12.6
a2a1dad25d91c8ed594b47a532c21aeecbe4bca00e3f4a4cc9aea29eee6a04fb

➜  docker container ls
CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS          PORTS      NAMES
a2a1dad25d91   postgres:12.6   "docker-entrypoint.s…"   14 seconds ago   Up 13 seconds   5432/tcp   postgres_env

➜  docker container inspect postgres_env
[ "POSTGRES_USER=root",
  "POSTGRES_DB=example_db",
  "POSTGRES_PASSWORD=password",
  "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/postgresql/12/bin",
  "GOSU_VERSION=1.12",
  "LANG=en_US.utf8",
  "PG_MAJOR=12",
  "PG_VERSION=12.6-1.pgdg100+1",
  "PGDATA=/var/lib/postgresql/data"
]

➜ 04g-env ✗  docker exec -it postgres_env psql -U root example_db -W
Password: #input password then enter, that will login to postgres db

psql (12.6 (Debian 12.6-1.pgdg100+1))
Type "help" for help.

example_db=# \l
                              List of databases
    Name    | Owner | Encoding |  Collate   |   Ctype    | Access privileges
------------+-------+----------+------------+------------+-------------------
 example_db | root  | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres   | root  | UTF8     | en_US.utf8 | en_US.utf8 |
 template0  | root  | UTF8     | en_US.utf8 | en_US.utf8 | =c/root          +
            |       |          |            |            | root=CTc/root
 template1  | root  | UTF8     | en_US.utf8 | en_US.utf8 | =c/root          +
            |       |          |            |            | root=CTc/root
(4 rows)

example_db=#
```

Jadi dengan Env Variable, tersebut kita meng-override variable default yang ada pada docker image tersebut

## Using Env Files for Create Docker Containers

Selain menggunakan parameter arguments `-e` atau `--env` kita juga menyimpanya dengan menggunakan file, Orang-orang sering mengebutunya Env-File dengan menggunakan format `VAR=VALUE`. Berikut adalah basic rules untuk menulis file `env`:

1. Nama file, biasanya menggunakan `.env`, `.env.prod`, `.env.dev` dan lain-lain.
2. Lines beginning with # are processed as comments and ignored.
3. Blank lines are ignored.
4. There is no special handling of quotation marks. This means that they are part of the VAL.

Berikut adalah contohnya, berdasarkan container yang telah kita buat sebelumnya:

{% gist page.gist "04g-.env" %}

Kemudian untuk menjalankan containernya, kita bisa menggunakan perintah berikut:

{% gist page.gist "04g-docker-env-file.bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ 04g-env  ls
    Directory: C:\Users\dimasm93\Workspaces\Example\docker\04-docker-cli\04g-env
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         5/18/2021   8:17 PM             75 .env

➜ 04g-env  cat .env
POSTGRES_PASSWORD=password
POSTGRES_USER=root
POSTGRES_DB=example_db

➜ 04g-env  docker run --name postgres_envfile --env-file .env -d postgres:12.6
c3a464b6722a9cab79abf1ceff5fe2ed7d35c9b527fc8319f50202899aa7cdd0

➜ 04g-env  docker container inspect postgres_envfile
[
    "POSTGRES_PASSWORD=password",
    "POSTGRES_USER=root",
    "POSTGRES_DB=example_db",
    "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/postgresql/12/bin",
    "GOSU_VERSION=1.12",
    "LANG=en_US.utf8",
    "PG_MAJOR=12",
    "PG_VERSION=12.6-1.pgdg100+1",
    "PGDATA=/var/lib/postgresql/data"
]
```

Jadi kesimpulanya, Dengan menggunakan Environtment Variable. Kita bisa meng-override nilai default-nya kemudian di digunakan untuk tujuan tertentu. 