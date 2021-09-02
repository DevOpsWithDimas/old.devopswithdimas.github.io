---
layout: post
title: "Scale services using compose command"
lang: docker
categories:
- Containerization
- DevOps
- Docker
- Workflows
refs: 
- https://docs.docker.com/compose/reference/scale/
- https://docker-k8s-lab.readthedocs.io/en/latest/docker/docker-compose-lb-scale.html
- https://en.wikipedia.org/wiki/Load_balancing_(computing)
- https://avinetworks.com/glossary/round-robin-load-balancing/
youtube: 
comments: true
image_path: /resources/posts/docker/09q-compose-scale
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini kita akan membahas tentang system scale services dengan `docker-compose` command. Diantaranya yang akan kita bahas

1. Scale up and down a service
2. What happens in background
3. Execute command specify container

Ok langsung aja kita ke pembahasan yang pertama yaitu

##  Scale up and down a service

By default docker compose akan membuat semua servicenya dalam 1 instance, now we will create a web service, try to scale this service, and add load blancer.

{% gist page.gist "09q-scale.docker-compose.yaml" %}

Berikut adalah `default.template.conf` file untuk nginx proxy ke backend service

{% gist page.gist "09q-scale.default.template.conf" %}

Sekarang coba jalankan dengan perintah `docker-compose up -d` maka hasilnya seperti berikut:

```powershell
➜ docker  docker-compose -f .\09-docker-compose\scale\docker-compose.yaml -p scale up -d
Creating network "scale_default" with the default driver
Creating scale_backend_1 ... done
Creating scale_proxy_1   ... done

➜ docker  docker-compose -f .\09-docker-compose\scale\docker-compose.yaml -p scale ps
     Name                    Command               State                Ports
-------------------------------------------------------------------------------------------
scale_backend_1   /docker-entrypoint.sh ngin ...   Up      80/tcp
scale_proxy_1     /docker-entrypoint.sh ngin ...   Up      0.0.0.0:80->80/tcp,:::80->80/tcp
```

Scale the `backend` service to 2 with command `docker-compose up -d --scale <service-name>=<instance-numbers>`:

{% highlight bash %}
docker-compose up -d --scale backend=3
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ docker  docker-compose -f .\09-docker-compose\scale\docker-compose.yaml -p scale up -d --scale backend=3
scale_proxy_1 is up-to-date
Creating scale_backend_2 ... done
Creating scale_backend_3 ... done

➜ docker  docker-compose -f .\09-docker-compose\scale\docker-compose.yaml -p scale ps
     Name                    Command               State                Ports
-------------------------------------------------------------------------------------------
scale_backend_1   /docker-entrypoint.sh ngin ...   Up      80/tcp
scale_backend_2   /docker-entrypoint.sh ngin ...   Up      80/tcp
scale_backend_3   /docker-entrypoint.sh ngin ...   Up      80/tcp
scale_proxy_1     /docker-entrypoint.sh ngin ...   Up      0.0.0.0:80->80/tcp,:::80->80/tcp
```

## What happens in background

Scalling service instance pada docker-compose jika kita gambarkan maka seperti berikut:

![arch-docker-compose-scale]({{ page.image_path | prepend: site.baseurl }}/arch-docker-scale.png)

By default docker akan menambahkan [loadbalancer](https://en.wikipedia.org/wiki/Load_balancing_(computing)) dengan konfigurasi [Round Robin](https://avinetworks.com/glossary/round-robin-load-balancing/)

Pada contoh diatas kita melakukan reverse proxy dari service `proxy` ke service `backend`, dengan round-robin load balancing maka jika ada setiap request dari service `proxy` ke `backend` maka terminologinya akan seperti berikut:

1. The first request is sent to `backend_1`.
2. The second request is sent to `backend_2`.
3. The third request is sent to `backend_3`.

Sekarang coba akses [localhost:80](http://localhost:80) pada browser kemudian refresh beberapa kali, kemudian access logs pada service `backend` dengan perintah seperti berikut:

```powershell
➜ docker  docker-compose -f .\09-docker-compose\scale\docker-compose.yaml -p scale logs --tail 1 -f backend
Attaching to scale_backend_4, scale_backend_3, scale_backend_2
backend_2  | 172.20.0.3 - - [02/Sep/2021:22:10:22 +0000] "GET / HTTP/1.1" 200 3105 "-" "curl/7.78.0" "-"
backend_3  | 172.20.0.3 - - [02/Sep/2021:22:10:12 +0000] "GET / HTTP/1.1" 200 3105 "-" "curl/7.78.0" "-"
backend_4  | 2021/09/02 22:10:48 [notice] 1#1: start worker process 35
backend_2  | 172.20.0.3 - - [02/Sep/2021:22:10:57 +0000] "GET / HTTP/1.1" 200 3105 "-" "curl/7.78.0" "-"
backend_4  | 172.20.0.3 - - [02/Sep/2021:22:10:59 +0000] "GET / HTTP/1.1" 200 3105 "-" "curl/7.78.0" "-"
backend_3  | 172.20.0.3 - - [02/Sep/2021:22:11:06 +0000] "GET / HTTP/1.1" 200 3105 "-" "curl/7.78.0" "-"
backend_4  | 172.20.0.3 - - [02/Sep/2021:22:11:10 +0000] "GET / HTTP/1.1" 200 3105 "-" "curl/7.78.0" "-" 
```

## Execute command specify container

