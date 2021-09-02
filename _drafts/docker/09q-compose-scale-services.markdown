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
youtube: 
comments: true
image_path: /resources/posts/docker/09p-compose-scale-services
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini kita akan membahas tentang system scale services dengan `docker-compose` command. Diantaranya yang akan kita bahas

1. Scale up and down a service
2. What happens in background
3. Execute command
4. View logs specify instance

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