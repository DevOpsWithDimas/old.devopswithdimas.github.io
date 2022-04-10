---
layout: post
title: "Example Use Cases of docker-machine"
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Machine
refs: 
- https://docs.docker.com/
youtube: 
comments: true
catalog_key: docker-machine
image_path: /resources/posts/docker/13d-usecase-docker-machine
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas salah satu contoh penggunaannya untuk Docker Machine. Diantaranya

1. Multiple Docker Host by Projects
2. DRC (Disaster Revovery Center) system.

Ok langsung aja kita bahas materi yang pertama:

<!--more-->

## Multiple Docker Host by projects

Salah satu implementasi docker-machine adalah menggunakan multiple Docker Host by project. Magsudnya jika kita punya 3 project setiap project punya specifikasi containernya yang berbeda seperti berikut:

```yaml
prejects:
    projectA: ['mysql', 'laravel']
    projectB: ['postgresql', 'springboot', 'angular']
    projectC: ['oracle', 'java-web'] 
```

Nah klo kita deploy dalam 1 docker host, maka semua container tersebut akan tercampur atau istilahnya (shared host). Ada kalanya kita ingin jalankan setiap project tersebut dalam environtment terpisah atau isolate (dedicated host) nah disini kita bisa manfaatkan docker-machine untuk membuat Docker Host masing-masing project dengan perintah seperti berikut:

{% highlight bash %}
docker-machine create -d virtualbox project-a;
eval $(docker-machine env project-a);
## deploy your container for projectA

docker-machine create -d virtualbox project-b;
eval $(docker-machine env project-b);
## deploy your container for projectB

docker-machine create -d virtualbox project-c;
eval $(docker-machine env project-c);
## deploy your container for projectC
{% endhighlight %}

Jika kita jalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker-machine create -d virtualbox --virtualbox-no-vtx-check project-a
Running pre-create checks...
Docker is up and running!
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: C:\ProgramData\chocolatey\lib\docker-machine\bin\docker-machine.exe env project-a

➜ ~  docker-machine env project-a
$Env:DOCKER_TLS_VERIFY = "1"
$Env:DOCKER_HOST = "tcp://192.168.99.103:2376"
$Env:DOCKER_CERT_PATH = "C:\Users\dimasm93\.docker\machine\machines\project-a"
$Env:DOCKER_MACHINE_NAME = "project-a"
$Env:COMPOSE_CONVERT_WINDOWS_PATHS = "true"

➜ ~  & "C:\ProgramData\chocolatey\lib\docker-machine\bin\docker-machine.exe" env project-a | Invoke-Expression

➜ ~  docker run -p 80:80 -d nginx
➜ ~  docker container ls
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                NAMES
903498c8d16c   nginx     "/docker-entrypoint.…"   25 seconds ago   Up 24 seconds   0.0.0.0:80->80/tcp   exciting_mirzakhani

➜ ~  curl $(docker-machine ip project-a)
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
RawContent        : HTTP/1.1 200 OK

➜ ~  docker-machine create -d virtualbox --virtualbox-no-vtx-check project-b
Running pre-create checks...
Creating machine...
Docker is up and running!
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: C:\ProgramData\chocolatey\lib\docker-machine\bin\docker-machine.exe env project-b

➜ ~  docker-machine env project-b
$Env:DOCKER_TLS_VERIFY = "1"
$Env:DOCKER_HOST = "tcp://192.168.99.104:2376"
$Env:DOCKER_CERT_PATH = "C:\Users\dimasm93\.docker\machine\machines\project-b"
$Env:DOCKER_MACHINE_NAME = "project-b"
$Env:COMPOSE_CONVERT_WINDOWS_PATHS = "true"

➜ ~  & "C:\ProgramData\chocolatey\lib\docker-machine\bin\docker-machine.exe" env project-b | Invoke-Expression

➜ ~  docker run -p 80:80 -d httpd
➜ ~  docker container ls
CONTAINER ID   IMAGE     COMMAND              CREATED          STATUS          PORTS
NAMES
cf215cc32b4a   httpd     "httpd-foreground"   11 seconds ago   Up 10 seconds   0.0.0.0:80->80/tcp   focused_dewdney

➜ ~  curl $(docker-machine ip project-b)                                                            
StatusCode        : 200
StatusDescription : OK
Content           : <html><body><h1>It works!</h1></body></html>
RawContent        : HTTP/1.1 200 OK

➜ ~  docker-machine ls
NAME        ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER      ERRORS
default     -        virtualbox   Stopped                                       Unknown
project-a   -        virtualbox   Running   tcp://192.168.99.103:2376           v19.03.12
project-b   *        virtualbox   Running   tcp://192.168.99.104:2376           v19.03.12
```

## DRC (Disaster Recovery Center) system simulation.

Dan selain untuk multiple project docker-machine juga bisa kita gunakan untuk meng-simulasi DRC (Disaster Recovery Center) system. Disaster Recovery System ini biasanya digunakan pada perusahan berscala menengah hinga besar, pemerintahan, dan beberapa startup karena untuk melindungi aplikasi, service, data agar tetap running jika terjadi bencana alam, hardware failure, network down dan lain-lain.

Dalam best practice suatu Disaster Recovery Center biasanya di tentukan berdasarkan jarak lokasi penentuan Data Center dan replicasinya memiliki radius 60KM (Kilometer). secara Topology kalo kita gambarkan maka seperti berikut:

![topology-drc]({{ page.image_path | prepend: site.baseurl }}/01-topology-drc.png)

Jadi pada gambar tersebut, kita lihat ada 4 region dan 1 routing yaitu 

1. `dc1` (Data Center utama)
2. `drc1` (Replication)
3. `drc2` (Replication)
4. `drc3` (Replication)

Setiap `dc` dan `drc` biasanya kita akan kita installkan aplikasi, service, database dan lain-lain. Nah sekarang kita coba implement dengan docker-machine ya berikut perintahnya:

{% highlight bash %}
docker-machine create -d virtualbox dc1;
docker-machine create -d virtualbox drc1;
docker-machine create -d virtualbox drc2;
{% endhighlight %}

Nah Untuk routing sendiri biasanya adalah hardware tersediri ada banyak sekali implementasinya bisa pake [f5](https://www.f5.com/), [cisco](https://www.cisco.com/c/en/us/index.html), microtic dan lain-lain. Tetapi karena disini kita menggunakan di local semua kita bisa manfaat loadbalancer/proxy seperti 

1. [Traefik proxy](https://traefik.io/traefik/)
2. [nginx load balancer](https://nginx.org/en/docs/http/load_balancing.html)
3. [etcd](https://etcd.io/docs/v3.5/quickstart/)
4. dan lain-lain.

Ok sekarang kita coba implement untuk routingnya juga, dengan menggunakan docker-machine seperti berikut:

{% highlight bash %}
docker-machine create -d virtualbox routing;
{% endhighlight %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell

```