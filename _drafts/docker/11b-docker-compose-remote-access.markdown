---
layout: post
title: "Remote deployment using docker-compose"
lang: docker
categories:
- DevOps
- Docker
- Context
refs: 
- https://www.docker.com/blog/how-to-deploy-on-remote-docker-hosts-with-docker-compose/
youtube: 
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
dimasm93@192.168.88.11''s password:
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
dimasm93@192.168.88.11''s password:

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
```

This is a better approach than the manual deployment. But it gets quite annoying as it requires to set/export the remote host endpoint on every application change or host change.

## Remote Using `-H` command line option from `docker-compose`