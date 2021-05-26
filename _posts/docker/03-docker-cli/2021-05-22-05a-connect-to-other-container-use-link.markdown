---
layout: post
title: "Legacy feature of Docker Network - Container Links"
date: 2021-05-22T16:03:31+07:00
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/network/links/
youtube: oEuqbHQuq8Y
comments: true
image_path: /resources/posts/docker/04g-docker-container-link
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


Hai semuanya, di materi kali ini kita akan membahas tentang Simple Networking dengan Docker Network Link.

Before the Docker networks feature, you could use the Docker link feature to allow containers to discover each other and securely transfer information about one container to another container.

<!--more-->

Ok pertama kita siapkan dulu running container sebagai contoh disini saya mau menjalankan Web-Server dengan image `nginx` seperti berikut:

For Bash script:

{% gist page.gist "05a-setup-webapp.bash" %}

For Powershell script: 

{% gist page.gist "05a-setup-webapp.ps1" %}

## Connecting another containers using link system

Untuk membuat container links, Docker menggunakan nama container yang telah dibuat dan statusnya running. Seperti yang telah kita buat contohnya `webapp`:

```powershell
➜ ~  docker container ls

CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS     NAMES
57f5f5084bf3   nginx     "/docker-entrypoint.…"   58 minutes ago   Up 58 minutes   80/tcp    webapp
```

Jika kita mau connect ke container `webapp` tersebut kita buat container baru dengan image ubuntu dan menjalankan perintah seperti berikut:

For Bash script:

{% gist page.gist "05a-connect-link.bash" %}

For Powershell script:

{% gist page.gist "05a-connect-link.ps1" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ ~ docker container run `
>> --rm `
>> --link webapp:nginx_dev `
>> ubuntu:21.04 `
>> bash -c "apt update -y && apt install curl -y && curl http://nginx_dev:80"
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

So what does linking the containers actually do? Docker exposes connectivity information for the source container to the recipient container in two ways:

1. Environment variables,
2. Updating the `/etc/hosts` file.

Seperti berikut:

```powershell
➜ ~  docker inspect -f "{% raw %}{{ .HostConfig.Links }}{% endraw %}" ubuntu
[/nginx-dev:/ubuntu/nginx-dev]

➜ ~  docker container run `
>> --rm `
>> --link webapp:nginx_dev `
>> ubuntu:21.04 `
>> bash -c "cat /etc/hosts"
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
172.17.0.2      nginx_dev 57f5f5084bf3 webapp
172.17.0.3      674f56f7b5e0

➜ ~  docker container run `
>> --rm `
>> --link webapp:nginx_dev `
>> ubuntu:21.04 `
>> env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=c69c0928aaeb
NGINX_DEV_PORT=tcp://172.17.0.2:80
NGINX_DEV_PORT_80_TCP=tcp://172.17.0.2:80
NGINX_DEV_PORT_80_TCP_ADDR=172.17.0.2
NGINX_DEV_PORT_80_TCP_PORT=80
NGINX_DEV_PORT_80_TCP_PROTO=tcp
NGINX_DEV_NAME=/flamboyant_vaughan/nginx_dev
NGINX_DEV_ENV_NGINX_VERSION=1.19.10
NGINX_DEV_ENV_NJS_VERSION=0.5.3
NGINX_DEV_ENV_PKG_RELEASE=1~buster
HOME=/root
```

## Cleanup

Ok setelah kita coba membuat link, sekarang kita bersihkan dulu ya supaya tidak nyampah. berikut perintahnya:

{% gist page.gist "05a-cleanup.bash" %}