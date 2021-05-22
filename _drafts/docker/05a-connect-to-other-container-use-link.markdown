---
layout: post
title: "Legacy container links"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/network/links/
youtube: 
comments: true
image_path: /resources/posts/docker/04g-docker-container-link
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


Hai semuanya, di materi kali ini kita akan membahas tentang Simple Networking dengan Docker Network Link.

1. Connecting another container using intenal ip-address
2. Connecting another containers using link system

Before the Docker networks feature, you could use the Docker link feature to allow containers to discover each other and securely transfer information about one container to another container.

<!--more-->

Ok pertama kita siapkan dulu running container sebagai contoh disini saya mau menjalankan Web-Server dengan image `nginx` seperti berikut:

For Bash script:

{% gist page.gist "05a-setup-webapp.bash" %}

For Powershell script: 

{% gist page.gist "05a-setup-webapp.ps1" %}

## Connecting another container using internal ip-address

> NOTE: Containers have an internal network and an IP address. Docker can have a variety of network configurations. You can see more information on Docker networking

Setelah itu coba buat container baru, untuk memanggil web tersebut dengan perintah `curl` seperti berikut:

For Bash script:

{% gist page.gist "05a-container-not-connect.bash" %}

For Powershell script: 

{% gist page.gist "05a-container-not-connect.ps1" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker container ls
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS     NAMES
57f5f5084bf3   nginx     "/docker-entrypoint.…"   12 minutes ago   Up 12 minutes   80/tcp    webapp

➜ ~  docker container run `
>> --name ubuntu_not_linked `
>> --rm ubuntu:21.04 `
>> bash -c "apt update -y && apt install curl -y && curl http://localhost:80"

## update dependencies
Fetched 20.5 MB in 20s (1000 kB/s)
Reading package lists...
Building dependency tree...
Reading state information...
All packages are up to date.

## installing package for curl
Reading package lists...
Building dependency tree...
Reading state information...
The following NEW packages will be installed:
  ca-certificates curl krb5-locales libasn1-8-heimdal libbrotli1 libcurl4
  libgssapi-krb5-2 libgssapi3-heimdal libhcrypto4-heimdal libheimbase1-heimdal
  libheimntlm0-heimdal libhx509-5-heimdal libk5crypto3 libkeyutils1
  libkrb5-26-heimdal libkrb5-3 libkrb5support0 libldap-2.4-2 libldap-common
  libnghttp2-14 libpsl5 libroken18-heimdal librtmp1 libsasl2-2
  libsasl2-modules libsasl2-modules-db libsqlite3-0 libssh-4 libssl1.1
  libwind0-heimdal openssl publicsuffix
0 upgraded, 32 newly installed, 0 to remove and 0 not upgraded.

## result curl http://localhost:80
curl: (7) Failed to connect to localhost port 80: Connection refused
```

Yapp, nah disini hasilnya kita gak bisa connect ke container `webapp` menggunakan image `nginx`. Ada yang tau kenapa?

Ok coba perhatikan output berikut:

```powershell
➜ ~  docker container inspect webapp -f '{% raw %}{{json .NetworkSettings.Networks }}{% endraw %}'
{
   "bridge":{
      "NetworkID":"e5603937860bca14ffbc6125930670c863d7a910e831ef0b4c149f817523762c",
      "EndpointID":"bc2ef8cbd9c5cf5e4d6b1c119b6eee195429c75680d91ac7444d02c88429cd3b",
      "Gateway":"172.17.0.1",
      "IPAddress":"172.17.0.2",      
      "MacAddress":"02:42:ac:11:00:02"
   }
}

➜ ~  docker container inspect ubuntu -f '{% raw %}{{json .NetworkSettings.Networks }}{% endraw %}'
{
   "bridge":{
      "NetworkID":"e5603937860bca14ffbc6125930670c863d7a910e831ef0b4c149f817523762c",
      "EndpointID":"e4786533382724ea0bd7946dd13a01cb417d629db563c7b9708541684aec1400",
      "Gateway":"172.17.0.1",
      "IPAddress":"172.17.0.3",
      "MacAddress":"02:42:ac:11:00:03"
   }
}
```

Nah jadi setiap container yang sedang berjalan, memiliki ip sendiri ya. jadi klo kita liat dari inspect object network brige tersebut terlihat bahwa ip address yang digunakan oleh container `webapp` adalah `172.17.0.2`

Nah sekarang coba klo kita jalankan perintahnya seperti berikut:

```powershell
➜ ~  docker container run `
>> --name ubuntu_not_linked `
>> --rm ubuntu:21.04 `
>> bash -c "apt update -y && apt install curl -y && curl http://172.17.0.2:80"

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

Nah terlihat hasilnya khan sekarang kita berhasil, connect ke container `nginx` dari dalam container ubuntu dengan menggunakan internal IP Addresses.

## Connecting another containers using link system

Selain menggunakan Internal IP-Address yang setiap kali kita buat container baru maka nilai ip-addressnya akan berubah-ubah. kita juga bisa menggunakan System Link yaitu menggunakan domain-names. 

Untuk membuat links, Docker menggunakan nama container yang telah dibuat dan statusnya running. Seperti yang telah kita buat contohnya `webapp`:

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