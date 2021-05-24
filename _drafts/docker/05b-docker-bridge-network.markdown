---
layout: post
title: "Use default bridge networks"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/network/bridge/
- https://docs.docker.com/network/network-tutorial-standalone/
youtube: 
comments: true
image_path: /resources/posts/docker/05b-docker-brige-network
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas Default Networking di Docker yaitu bridge networks. Diantaranya yang akan kita bahas

1. Default bridge network
2. Inspect the default bridge network
3. Communicate between containers using default bridge network


<!--more-->

Dalam Networking, `bridge network` is a Link Layer device which forwards traffic between network segments. A bridge can be a hardware device or a software device running within a host machine’s kernel.

Untuk Docker, `bridge network` uses a software bridge which allows containers connected to the same bridge network to communicate, while providing isolation from containers which are not connected to that bridge network. The Docker bridge driver automatically installs rules in the host machine so that containers on different bridge networks cannot communicate directly with each other.

## Use the default bridge network

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
