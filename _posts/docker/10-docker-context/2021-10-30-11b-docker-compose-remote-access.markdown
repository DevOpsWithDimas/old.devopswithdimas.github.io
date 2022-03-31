---
layout: post
title: "Remote deployment using docker-compose"
date: 2021-10-30T15:32:02+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Context
refs: 
- https://www.docker.com/blog/how-to-deploy-on-remote-docker-hosts-with-docker-compose/
youtube: qoiIbmd48GQ
comments: true
catalog_key: docker-context
image_path: /resources/posts/docker/11b-docker-compose-remote-access
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang How to deploy on remote docker using docker-compose. Diantaranya

1. Introduction
2. Remote Using `DOCKER_HOST` Environtment Variable
3. Remote Using `-H` command line option from `docker-compose`
4. Remote Using docker context

Ok langsung aja kita ke pembahasan yang pertama yaitu

<!--more-->

## Introduction

The docker-compose tool is pretty popular for running dockerized applications in a local development environment. All we need to do is write a Compose file containing the configuration for the application’s services and have a running Docker engine for deployment. From here, we can get the application running locally in a few seconds with a single  `docker-compose up` command.

A common usage of Compose is to copy the project source with the `docker-compose.yml`, install `docker-compose` on the target machine where we want to deploy the compose app and finally run it. 

Tapi problem datang ketika kita punya banyak server, 1 sampai 3 server it's ok untuk melakukan copy semua source-code ke target dan run manualy setiap servernya, tpi klo ada 10 atau 100 bahkan 1000 server kita jalankan manual?

Ok jadi kita langung ja bahas permasalahan tersebut dengan beberapa solusi berikut:

## Remote using `DOCKER_HOST` env variable

Ok kita bahas dulu menggunakan `DOCKER_HOST` environtment variable untuk `docker-compose` command. Yang kita perlu siapakan ada server / vm / pc yang bisa di remote menggunakan ssh (OpenSSH Server) dan docker engine. Contohnya disini saya udah install menggunakan OS CentOS 8 dalam sebuah VM dengan ip `192.168.88.11`. 

Pertama kita make sure, user yang kita gunakan bisa menjalankan docker. kita login dengan ssh

{% highlight bash %}
ssh dimasm93@192.168.88.11

docker info
## if can't run properly you need take a look this https://docs.docker.com/engine/install/linux-postinstall/

## to pass password credential to user we use ssh-copy-id
ssh-copy-id dimasm93@192.168.88.11
{% endhighlight %}

jika di jalankan hasilnya seperti berikut:

```powershell
➜ ~  ssh dimasm93@192.168.88.11
dimasm93@192.168.88.11 password:
Activate the web console with: systemctl enable --now cockpit.socket

Last login: Sat Oct 30 13:34:50 2021 from 192.168.88.252
[dimasm93@docker-centos8 ~]$ docker info
Client:
 Context:    default
 Debug Mode: false
 Plugins:
  app: Docker App (Docker Inc., v0.9.1-beta3)
  buildx: Build with BuildKit (Docker Inc., v0.6.3-docker)
  scan: Docker Scan (Docker Inc., v0.9.0)

Server:
 Containers: 0
  Running: 0
  Paused: 0
  Stopped: 0
 Images: 0
 Server Version: 20.10.10
 Kernel Version: 4.18.0-305.19.1.el8_4.x86_64
 Operating System: CentOS Linux 8
 OSType: linux
 Architecture: x86_64
 CPUs: 2
 Total Memory: 3.623GiB
 Name: docker-centos8.udemy.dimas-maryanto.com
 ID: ZWET:4ZXS:QFUF:H56E:6MVB:QBQA:AWAJ:5KHC:CM2X:67C5:7U64:UP7D
 
➜ ~ ssh-copy-id dimasm93@192.168.88.11
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/c/Users/dimasm93/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
dimasm93@192.168.88.11 password:

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'dimasm93@192.168.88.11'"
and check to make sure that only the key(s) you wanted were added.
```

Ok setelah kita setup ssh connection-nya sekarang kita bisa jalankan docker-compose secara remotely from local to target using `DOCKER_HOST`

Jika temen-temen menggunakan Windows kita perlu set Environtment variable dengan perintah seperti berikut:

{% highlight powershell %}
$Env:DOCKER_HOST="ssh://dimasm93@192.168.88.11"

docker-compose up -d
{% endhighlight %}

Jika temen-temen menggunakan Linux/macOs kita bisa menggunakan perintah seperti berikut:

{% highlight bash %}
export DOCKER_HOST=ssh://dimasm93@192.168.88.11
docker-compose up -d

## or you can run directly
DOCKER_HOST=ssh://dimasm93@192.168.88.11 docker-compose up -d
{% endhighlight %}

Dan kita akan menggunakan `docker-compose.yaml` untuk menjalankan nginx web server seperti berikut: 

{% gist page.gist "09a-docker-compose.yaml" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ ~  $Env:DOCKER_HOST="ssh://dimasm93@192.168.88.11"
➜ ~  docker info
Client:
 Context:    default
 Debug Mode: false
 Plugins:
  buildx: Build with BuildKit (Docker Inc., v0.6.3)
  compose: Docker Compose (Docker Inc., v2.0.0)
  scan: Docker Scan (Docker Inc., v0.8.0)

Server:
 Containers: 0
  Running: 0
  Paused: 0
  Stopped: 0
 Images: 0
 Server Version: 20.10.10
 Operating System: CentOS Linux 8
 OSType: linux
 Architecture: x86_64
 CPUs: 2
 Total Memory: 3.623GiB
 Name: docker-centos8.udemy.dimas-maryanto.com
 ID: ZWET:4ZXS:QFUF:H56E:6MVB:QBQA:AWAJ:5KHC:CM2X:67C5:7U64:UP7D
 Docker Root Dir: /var/lib/docker

cd .\08-docker-compose\01-getting-started\
➜ 01-getting-started git:(master) docker-compose -f .\docker-compose.yaml up -d
Creating 01-getting-started_db_1     ... done
Creating 01-getting-started_webapp_1 ... done

➜ 01-getting-started git:(master) docker-compose -f .\docker-compose.yaml -f .\database.docker-compose.yaml ps
          Name                     Command           State            Ports
------------------------------------------------------------------------------------01-getting-started_db_1    docker-entrypoint.sh      Up      0.0.0.0:5432->5432/tcp,                           postgres                          :::5432->5432/tcp
01-getting-                /docker-entrypoint.sh     Up      0.0.0.0:80->80/tcp,:::8started_webapp_1           ngin ...                          0->80/tcp

➜ 01-getting-started git:(master) curl 192.168.88.11

StatusCode        : 200
StatusDescription : OK
Content           : <!DOCTYPE html>
                    <html>
                    <head>
                    <title>Welcome to nginx!</title>
                    <style>
                    html { color-scheme: light dark; }
                    body { width: 35em; margin: 0 auto;
                    font-family: Tahoma, Verdana, Arial, sans-serif; }
                    </style...
Headers           : {[Connection, keep-alive], [Accept-Ranges, bytes], [Content-Length, 615], [Content-Type, text/html]...}

➜ 01-getting-started git:(master) docker-compose -f .\docker-compose.yaml down
Stopping 01-getting-started_webapp_1 ... done
Stopping 01-getting-started_db_1     ... done
Removing 01-getting-started_webapp_1 ... done
Removing 01-getting-started_db_1     ... done
```

This is a better approach than the manual deployment. But it gets quite annoying as it requires to set/export the remote host endpoint on every application change or host change.

## Remote Using `-H` command line option from `docker-compose`

Ok selanjutnya adalah kita bisa menggunakan `-H` option command line pada `docker` atau `docker-compose`, pertama sama seperti sebelumnya kita bisa siapkan Server VM atau kita juga bisa menggunakan VM Sebelumnya. Dan kita setup juga untuk ssh connectionnya menggunakan perintah `ssh-copy-id` dan install docker jika belum ada. Untuk menggunakannya kita bisa menggunakan perintah seperti berikut:

{% highlight powershell %}
docker --host=ssh://dimasm93@192.168.88.11 info
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker --host=ssh://dimasm93@192.168.88.11 info
Client:
 Context:    default
 Debug Mode: false
 Plugins:
  buildx: Build with BuildKit (Docker Inc., v0.6.3)
  compose: Docker Compose (Docker Inc., v2.0.0)
  scan: Docker Scan (Docker Inc., v0.8.0)

Server:
 Kernel Version: 4.18.0-305.19.1.el8_4.x86_64
 Operating System: CentOS Linux 8
 OSType: linux
 Architecture: x86_64
 CPUs: 2
 Total Memory: 3.623GiB
 Name: docker-centos8.udemy.dimas-maryanto.com
 ID: ZWET:4ZXS:QFUF:H56E:6MVB:QBQA:AWAJ:5KHC:CM2X:67C5:7U64:UP7D
```

Sedangkan untuk menjalankan `docker-compose` seperti berikut perintahnya:

{% highlight powershell %}
docker-compose --host=ssh://dimasm93@192.168.88.11 -f docker-compose.yaml up -d
{% endhighlight %}

Jika di jalankan maka hasilnya seperti berikut:


```powershell
➜ docker git:(master) cd .\08-docker-compose\01-getting-started\
➜ 01-getting-started git:(master) docker-compose --host ssh://dimasm93@192.168.88.11 -f .\docker-compose.yaml up -d
Creating network "01-getting-started_default" with the default driver
Creating 01-getting-started_db_1     ... done
Creating 01-getting-started_webapp_1 ... done

➜ 01-getting-started git:(master) docker-compose --host ssh://dimasm93@192.168.88.11 -f .\docker-compose.yaml ps
           Name                          Command               State                    Ports
---------------------------------------------------------------------------------------------------------------
01-getting-started_db_1       docker-entrypoint.sh postgres    Up      0.0.0.0:5432->5432/tcp,:::5432->5432/tcp
01-getting-started_webapp_1   /docker-entrypoint.sh ngin ...   Up      0.0.0.0:80->80/tcp,:::80->80/tcp

➜ 01-getting-started git:(master) curl 192.168.88.11

StatusCode        : 200
StatusDescription : OK
Content           : <!DOCTYPE html>
                    <html>
                    <head>
                    <title>Welcome to nginx!</title>
                    <style>
                    html { color-scheme: light dark; }
                    body { width: 35em; margin: 0 auto;
                    font-family: Tahoma, Verdana, Arial, sans-serif; }
                    </style...

➜ 01-getting-started git:(master) docker-compose --host ssh://dimasm93@192.168.88.11 -f .\docker-compose.yaml down --volumes
Stopping 01-getting-started_db_1     ... done
Stopping 01-getting-started_webapp_1 ... done
Removing 01-getting-started_db_1     ... done
Removing 01-getting-started_webapp_1 ... done
Removing network 01-getting-started_default
```

This is a better approach than the manual deployment. But same as before it gets quite annoying as it requires to set/export the remote host endpoint on every application change or host change.

## Remote Using docker context

Docker Contexts are an efficient way to automatically switch between different deployment targets. Pada [artikel sebelumnya]({% post_url docker/10-docker-context/2021-10-26-11a-docker-context %}) kita udah membahas/membuat docker context. Seperti berikut

```powershell
➜ 01-getting-started git:(master) docker context ls
NAME                     TYPE                DESCRIPTION                               DOCKER ENDPOINT                             KUBERNETES ENDPOINT   ORCHESTRATOR
default *                moby                Current DOCKER_HOST based configuration   npipe:////./pipe/docker_engine                                    swarm
desktop-linux            moby                                                          npipe:////./pipe/dockerDesktopLinuxEngine
docker-ssh-server-test   moby                                                          ssh://dimasm93@192.168.88.11                                      swarm
```

Untuk menggunakan context dalam `docker-compose` kita bisa menggunakan 2 cara yaitu 

1. `docker context use` command
2. Using `docker-compose --context` command line option

Ok kita akan coba `docker context use`, seperti berikut:

1. Kita set docker context ke docker host / target yang kita inginkan menggunakan 

{% highlight powershell %}
docker context use <context-name>
{% endhighlight %}

2. Setelah itu kita coba jalankan perintah `docker-compose up -d` seperti biasa

Jika kita jalankan maka hasilnya seperti berikut:

```powershell
➜ 01-getting-started git:(master) docker context ls --format '{% raw %}{{ .Name }} => {{json .DockerEndpoint }} {% endraw %}'
default => "npipe:////./pipe/docker_engine"
desktop-linux => "npipe:////./pipe/dockerDesktopLinuxEngine"
docker-ssh-server-test => "ssh://dimasm93@192.168.88.11"

➜ 01-getting-started git:(master) docker context use docker-ssh-server-test
docker-ssh-server-test

➜ 01-getting-started git:(master) docker info
Client:
 Context:    docker-ssh-server-test
 Debug Mode: false
 Plugins:
  buildx: Build with BuildKit (Docker Inc., v0.6.3)
  compose: Docker Compose (Docker Inc., v2.0.0)
  scan: Docker Scan (Docker Inc., v0.8.0)

Server:
 Kernel Version: 4.18.0-305.19.1.el8_4.x86_64
 Operating System: CentOS Linux 8
 OSType: linux
 Architecture: x86_64
 CPUs: 2
 Total Memory: 3.623GiB
 Name: docker-centos8.udemy.dimas-maryanto.com
 ID: ZWET:4ZXS:QFUF:H56E:6MVB:QBQA:AWAJ:5KHC:CM2X:67C5:7U64:UP7D

➜ 01-getting-started git:(master) docker-compose -f .\docker-compose.yaml up -d
Creating network "01-getting-started_default" with the default driver
Creating 01-getting-started_db_1     ... done
Creating 01-getting-started_webapp_1 ... done

➜ 01-getting-started git:(master) docker-compose -f .\docker-compose.yaml ps
           Name                          Command               State                    Ports
---------------------------------------------------------------------------------------------------------------
01-getting-started_db_1       docker-entrypoint.sh postgres    Up      0.0.0.0:5432->5432/tcp,:::5432->5432/tcp
01-getting-started_webapp_1   /docker-entrypoint.sh ngin ...   Up      0.0.0.0:80->80/tcp,:::80->80/tcp

➜ 01-getting-started git:(master) curl 192.168.88.11

StatusCode        : 200
StatusDescription : OK
Content           : <!DOCTYPE html>
                    <html>
                    <head>
                    <title>Welcome to nginx!</title>
                    <style>
                    html { color-scheme: light dark; }
                    body { width: 35em; margin: 0 auto;
                    font-family: Tahoma, Verdana, Arial, sans-serif; }
                    </style...

➜ 01-getting-started git:(master) docker-compose -f .\docker-compose.yaml down --volumes
Stopping 01-getting-started_webapp_1 ... done
Stopping 01-getting-started_db_1     ... done
Removing 01-getting-started_webapp_1 ... done
Removing 01-getting-started_db_1     ... done
Removing network 01-getting-started_default

## reset to default
➜ 01-getting-started git:(master) docker context use default
default

```


Jadi dengan menggunakan set context, kita bisa mudah untuk berpindah remote docker host dan secara default tersimpan dalam list docker context. 

Dan selanjutnya kita juga bisa menggunakan `--context` baik itu `docker` maupun `docker-compose` Seperti berikut implementasinya:

```powershell
➜ 01-getting-started git:(master) docker --context docker-ssh-server-test info
Client:
 Context:    docker-ssh-server-test
 Debug Mode: false
 Plugins:
  buildx: Build with BuildKit (Docker Inc., v0.6.3)
  compose: Docker Compose (Docker Inc., v2.0.0)
  scan: Docker Scan (Docker Inc., v0.8.0)

Server:
 Kernel Version: 4.18.0-305.19.1.el8_4.x86_64
 Operating System: CentOS Linux 8
 OSType: linux
 Architecture: x86_64
 CPUs: 2
 Total Memory: 3.623GiB
 Name: docker-centos8.udemy.dimas-maryanto.com
 ID: ZWET:4ZXS:QFUF:H56E:6MVB:QBQA:AWAJ:5KHC:CM2X:67C5:7U64:UP7D
 Docker Root Dir: /var/lib/docker

➜ 01-getting-started git:(master) docker-compose --context docker-ssh-server-test -f .\docker-compose.yaml up -d
Creating network "01-getting-started_default" with the default driver
Creating 01-getting-started_db_1     ... done
Creating 01-getting-started_webapp_1 ... done

➜ 01-getting-started git:(master) docker-compose --context docker-ssh-server-test -f .\docker-compose.yaml ps
           Name                          Command               State                    Ports
---------------------------------------------------------------------------------------------------------------
01-getting-started_db_1       docker-entrypoint.sh postgres    Up      0.0.0.0:5432->5432/tcp,:::5432->5432/tcp
01-getting-started_webapp_1   /docker-entrypoint.sh ngin ...   Up      0.0.0.0:80->80/tcp,:::80->80/tcp

➜ 01-getting-started git:(master) curl 192.168.88.11

StatusCode        : 200
StatusDescription : OK
Content           : <!DOCTYPE html>
                    <html>
                    <head>
                    <title>Welcome to nginx!</title>
                    <style>
                    html { color-scheme: light dark; }
                    body { width: 35em; margin: 0 auto;
                    font-family: Tahoma, Verdana, Arial, sans-serif; }
                    </style...

➜ 01-getting-started git:(master) docker-compose --context docker-ssh-server-test -f .\docker-compose.yaml down --volumes
Stopping 01-getting-started_webapp_1 ... done
Stopping 01-getting-started_db_1     ... done
Removing 01-getting-started_webapp_1 ... done
Removing 01-getting-started_db_1     ... done
Removing network 01-getting-started_default
```

Untuk menggunakan `--context` sebetulnya lebih sering jika hanya temporary connect ke docker daemon. Dan klo saya lebih sering menggunakan method set context ketimbang menggunakan `--context` command line option.