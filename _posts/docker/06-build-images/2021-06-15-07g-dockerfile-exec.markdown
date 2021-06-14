---
layout: post
title: "Basic Dockerfile - Execution Instruction"
date: 2021-06-15T05:56:19+07:00
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/engine/reference/builder/
- https://goinbigdata.com/docker-run-vs-cmd-vs-entrypoint/
youtube: 
comments: true
image_path: /resources/posts/docker/07g-dockerfile-exec
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tantang `Dockerfile` Execute Instruction diantaranya:

1. `RUN` Instruction
2. `CMD` Instruction
3. `ENTRYPOINT` Instruction
3. Cleanup

Ok langsung ja, kita akan membahasnya satu-per-satu. Yang pertama kita bahas dulu `RUN` Instruction 

## `RUN` Instruction

The `RUN` instruction will execute any commands in a new layer on top of the current image and commit the results. The resulting committed image will be used for the next step in the `Dockerfile`. 

Layering `RUN` instructions and generating commits conforms to the core concepts of Docker where commits are cheap and containers can be created from any point in an image’s history, much like source control. The default shell for the shell form can be changed using the `SHELL` command.

In the shell form you can use a `\` (backslash) to continue a single RUN instruction onto the next line. For example, consider these two lines:

{% highlight docker %}
RUN /bin/bash -c 'source $HOME/.bashrc; \
echo $HOME'
{% endhighlight %}

Together they are equivalent to this single line:

{% highlight docker %}
RUN /bin/bash -c 'source $HOME/.bashrc; echo $HOME'
{% endhighlight %}

To use a different shell, other than ‘/bin/sh’, use the exec form passing in the desired shell. For example:

{% highlight docker %}
RUN ["/bin/bash", "-c", "echo hello"]
{% endhighlight %}

Contohnya kita akan menginstall package `postgresql` client dengan menggunakan docker image `centos:7` kemudian kita connect ke container `postgresql-server` seperti berikut

{% gist page.gist "07g-dockerfile-run" %}

Jika dijalankan hasilnya seperti berikut:

```powershell
➜ 07-dockerfile  docker build -t dimmaryanto93/centos:0.6 .
[+] Building 32.8s (6/6) FINISHED
 => [internal] load build definition from Dockerfile                                   0.0s
 => => transferring dockerfile: 292B                                                   0.0s
 => [internal] load .dockerignore                                                      0.0s
 => => transferring context: 34B                                                       0.0s
 => [internal] load metadata for docker.io/library/centos:7                            0.0s
 => CACHED [1/2] FROM docker.io/library/centos:7                                       0.0s
 => [2/2] RUN yum install postgresql -y                                               32.3s
 => exporting to image                                                                 0.4s
 => => exporting layers                                                                0.4s
 => => writing image sha256:be7ae21ccce80c842289628193a6a623a5d9065a253e300ed8975894e  0.0s
 => => naming to docker.io/dimmaryanto93/centos:0.6

 ➜ 07-dockerfile  docker network create postgres_net
2b2b97f520f8686052ff59e3290cc8a99374975bd44aa8c3a90fe8cfb808e3ad

➜ 07-dockerfile  docker run --name postgresdb `
>> -e POSTGRES_PASSWORD=password `
>> --network postgres_net `
>> -d postgres:12.6
22b00018098a1cade9f5f9c358991fd5881161d0ad991a732fa71d75600f623f

➜ 07-dockerfile  docker run -it `
>> --network postgres_net `
>> --rm dimmaryanto93/centos:0.6 `
>> psql -h postgresdb -U postgres -W
Password for user postgres:
psql (9.2.24, server 12.6 (Debian 12.6-1.pgdg100+1))
WARNING: psql version 9.2, server version 12.0.
         Some psql features might not work.
Type "help" for help.

postgres=#
```

## `CMD` Instruction

The main purpose of a `CMD` is to provide defaults for an executing container. which will be executed only when you run container without specifying a command.

The CMD instruction has three forms:

1. `CMD ["executable","param1","param2"]` (exec form, this is the preferred form)
2. `CMD ["param1","param2"]` (as default parameters to ENTRYPOINT)
3. `CMD command param1 param2` (shell form)

There can only be one `CMD` instruction in a `Dockerfile`. If you list more than one `CMD` then only the last `CMD` will take effect. 

Unlike the _shell_ form, the exec form does not invoke a command shell. This means that normal shell processing does not happen. For example, `CMD [ "echo", "$HOME" ]` will not do variable substitution on `$HOME`. If you want shell processing then either use the shell form or execute a shell directly, for example: `CMD [ "sh", "-c", "echo $HOME" ]`

Contoh penggunaanya, masih sama seperti contoh di atas tpi kita tambahkan perintah `CMD` seperti berikut:

{% gist page.gist "07g-dockerfile-cmd" %}

Jika kita jalankan maka hasilnya seperti berikut:

```powershell
➜ 07-dockerfile  docker build -t dimmaryanto93/centos:0.7 .
[+] Building 0.1s (6/6) FINISHED
 => [internal] load build definition from Dockerfile                                   0.0s
 => => transferring dockerfile: 425B                                                   0.0s
 => [internal] load .dockerignore                                                      0.0s
 => => transferring context: 34B                                                       0.0s
 => [internal] load metadata for docker.io/library/centos:7                            0.0s
 => [1/2] FROM docker.io/library/centos:7                                              0.0s
 => CACHED [2/2] RUN yum install postgresql -y                                         0.0s
 => exporting to image                                                                 0.0s
 => => exporting layers                                                                0.0s
 => => writing image sha256:f242bf01507632e8ea60596858789ce69ce237ee361a0410e06df7a1e  0.0s
 => => naming to docker.io/dimmaryanto93/centos:0.7

➜ 07-dockerfile  docker run -it `
>> --network postgres_net `
>> --rm dimmaryanto93/centos:0.7
Password for user postgres:
psql (9.2.24, server 12.6 (Debian 12.6-1.pgdg100+1))
WARNING: psql version 9.2, server version 12.0.
         Some psql features might not work.
Type "help" for help.

postgres=# \q

## CMD will be ignore
➜ 07-dockerfile  docker run -it `
>> --network postgres_net `
>> --rm dimmaryanto93/centos:0.7 bash
[root@98fe1bfd454c /]# psql -h postgresdb -U postgres
Password for user postgres:
psql (9.2.24, server 12.6 (Debian 12.6-1.pgdg100+1))
WARNING: psql version 9.2, server version 12.0.
         Some psql features might not work.
Type "help" for help.

postgres=#
```

## `ENTRYPOINT` Instruction

An ENTRYPOINT allows you to configure a container that will run as an executable. 

The CMD instruction has two forms:

1. `ENTRYPOINT  ["executable","param1","param2"]` (The exec form, which is the preferred form)
3. `ENTRYPOINT command param1 param2` (shell form)

Contoh penggunaanya, masih sama seperti contoh di atas tpi kita tambahkan perintah `ENTRYPOINT` dan hapus perintah `CMD` seperti berikut:

{% gist page.gist "07g-dockerfile-entrypoint" %}

Jika kita jalankan, maka hasilnya seperti berikut:

```powershell
➜ 07-dockerfile  docker build -t dimmaryanto93/centos:0.8 .
[+] Building 0.1s (6/6) FINISHED
 => [internal] load build definition from Dockerfile                                   0.0s
 => => transferring dockerfile: 315B                                                   0.0s
 => [internal] load .dockerignore                                                      0.0s
 => => transferring context: 34B                                                       0.0s
 => [internal] load metadata for docker.io/library/centos:7                            0.0s
 => [1/2] FROM docker.io/library/centos:7                                              0.0s
 => CACHED [2/2] RUN yum install postgresql -y                                         0.0s
 => exporting to image                                                                 0.0s
 => => exporting layers                                                                0.0s
 => => writing image sha256:1ab6d8ba36cea2afc13a3c86e01b5bf623db697ee70a9d39db3dbace8  0.0s
 => => naming to docker.io/dimmaryanto93/centos:0.8                                    0.0s

➜ 07-dockerfile  docker run -it `                                                           
>> --network postgres_net `                                                                 
>> --rm dimmaryanto93/centos:0.8 -h postgresdb -U postgres -W
Password for user postgres:
psql (9.2.24, server 12.6 (Debian 12.6-1.pgdg100+1))                                        
WARNING: psql version 9.2, server version 12.0.                                                      
Some psql features might not work.                                                 
Type "help" for help.                                      
postgres=# \q 

## will call psql
➜ 07-dockerfile  docker run -it `
>> --network postgres_net `
>> --rm dimmaryanto93/centos:0.8
psql: could not connect to server: No such file or directory
        Is the server running locally and accepting
        connections on Unix domain socket "/var/run/postgresql/.s.PGSQL.5432"?

## can't call bash
➜ 07-dockerfile ✗  docker run -it `
>> --network postgres_net `
>> --rm dimmaryanto93/centos:0.8 bash
psql: could not connect to server: No such file or directory
        Is the server running locally and accepting
        connections on Unix domain socket "/var/run/postgresql/.s.PGSQL.5432"?

## override command with --entrypoint
➜ 07-dockerfile  docker run -it `
>> --network postgres_net `
>> --entrypoint /bin/bash `
>> --rm dimmaryanto93/centos:0.8
[root@46ad94c2031b /]#
```

## Cleanup

Seperti biasa, setelah kita mencoba kita bersih-bersih dulu ya, berikut perintahnya:

For Bash script:

{% gist page.gist "07g-cleanup.bash" %}

For Powershell script:

{% gist page.gist "07g-cleanup.ps1" %}