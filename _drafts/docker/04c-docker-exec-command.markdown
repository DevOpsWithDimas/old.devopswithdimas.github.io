---
layout: post
title: "Run a command in a running container"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/engine/reference/commandline/exec/
youtube: 
comments: true
image_path: /resources/posts/docker/06e-docker-exec-command
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini kita akam membahas tentang perintah `docker exec`. Diataranya:

1. Start bash session
2. Run Interactive command
3. Working with option args
4. Run External program provided by image

<!--more-->

Ok, pertama kita lihat dulu dokumentasinya dengan menggunakan perintah:

{% gist page.gist "04c-docker-exec-help.bash" %}

Seperti berikut:

```powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Try the new cross-platform PowerShell https://aka.ms/pscore6

Loading personal and system profiles took 711ms.
➜ ~  docker exec -h
Flag shorthand -h has been deprecated, please use --help

Usage:  docker exec [OPTIONS] CONTAINER COMMAND [ARG...]

Run a command in a running container

Options:
  -d, --detach               Detached mode: run command in the background
      --detach-keys string   Override the key sequence for detaching a
                             container
  -e, --env list             Set environment variables
      --env-file list        Read in a file of environment variables
  -i, --interactive          Keep STDIN open even if not attached
      --privileged           Give extended privileges to the command
  -t, --tty                  Allocate a pseudo-TTY
  -u, --user string          Username or UID (format:
                             <name|uid>[:<group|gid>])
  -w, --workdir string       Working directory inside the container
```

## Start bash session

Kita bisa jalankan dulu containernya, dengan perintah seperti berikut:

{% highlight powershell %}
docker run --name ubuntu_bash -d -i -t ubuntu:21.04
{% endhighlight %}

Berikut hasilnya:

```powershell
➜ ~  docker run --name ubuntu_bash -d -i -t ubuntu:21.04
51416e0e051f719667d3596596574338ff2badbec340ca346672761422f2a1d7

➜ ~  docker container ls
CONTAINER ID   IMAGE          COMMAND       CREATED        STATUS         PORTS     NAMES
51416e0e051f   ubuntu:21.04   "/bin/bash"   1 second ago   Up 3 seconds             ubuntu_bash
```

Sekarang kita coba jalankan perintah untuk membuat file sebagai contoh seperti berikut:

{% gist page.gist "04c-docker-exec-touch-exist.bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ ~ ✗  docker exec ubuntu_bash bash -c "mkdir -p /contoh && echo 'Halo saya Dimas Maryanto, sedang belajar docker' > /contoh/test.txt"

➜ ~ ✗  docker exec ubuntu_bash ls -a /contoh
.
..
test.txt
```

## Run Interactive command

Atau kita juga bisa login ke dalam containernya dengan perintah berikut:

{% gist page.gist "04c-docker-exec-ubuntu-bash.bash" %}

Maka hasilnya seperti berikut:

```powershell
➜ ~  docker exec -it ubuntu_bash bash
root@51416e0e051f:/# ls contoh/
test.txt

root@51416e0e051f:/# cat /contoh/test.txt
Halo saya Dimas Maryanto, sedang belajar docker
```

## Working with option args

Option argument, ini sangat berguna contohnya 

1. `--workdir` untuk menentukan lokasi ketika command di execute
2. `--user` untuk menetukan siapa yang mengexecute

Sebagai contoh seperti berikut implementasinya:

{% gist page.gist "04c-docker-exec-option-args.bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker exec -i -t -w /contoh -u root ubuntu_bash bash

root@51416e0e051f:/contoh# pwd
/contoh

root@51416e0e051f:/contoh# cat test.txt
Halo saya Dimas Maryanto, sedang belajar docker

root@51416e0e051f:/contoh#
```

Contoh lainnya, kita coba start container nginx seperti berikut:

{% highlight powershell %}
docker run -d --name webapp nginx
{% endhighlight %}

Kemudian kita coba jalankan perintah berikut:

{% gist page.gist "04c-docker-exec-normal-user-args.bash" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker exec -it -u www-data -w /usr/share/nginx webapp bash

www-data@71a009a4f00c:/usr/share/nginx$ pwd
/usr/share/nginx

www-data@9dc0cbceed40:/usr/share/nginx$ ls html/
50x.html  index.html
```

## Run External program provided by image

Sekarang kita akan mencoba, menjalankan program/aplikasi contohnya jika menggunakan container maka kita akan mengakses database dengan editor commandline seperti berikut:

Sekarnag kita start dulu, container `postgres:9.6` seperti berikut:

{% highlight powershell %}
docker run --name postgres_db -it -u postgres -d -e POSTGRES_PASSWORD=passwordnya postgres:9.6
{% endhighlight %}

Kemudian kita coba login, ke dalam database dengan user `postgres` dan menggunakan editor `psql`

{% gist page.gist "04c-docker-exec-psql.bash" %}

Jika kita coba jalankan, maka hasilnya seperti berikut:

```powershell
➜ ~  docker exec -u postgres -it postgres_db psql
psql (9.6.21)
Type "help" for help.

postgres=#
```

Jika kita coba menggunakan user lain, seperti berikut hasilnya:

```powershell
➜ ~ ✗ docker exec -u root -it postgres_db psql
psql: FATAL:  role "root" does not exist
```

Atau juga kita bisa menggunakan user default wichis `root`, yang memparsing user pada user database seperti berikut:

```powershell
➜ ~  docker exec -it postgres_db psql -U postgres postgres
psql (9.6.21)
Type "help" for help.

postgres=#
```

## Cleanup

Sekarang kita stop semua service yang jalan, dengan perintah seperti berikut:

{% gist page.gist "04c-docker-exec-cleanup.bash" %}