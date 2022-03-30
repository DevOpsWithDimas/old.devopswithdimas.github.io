---
layout: post
title: "Health Check Instruction"
date: 2021-06-22T20:48:45+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Dockerfile
refs: 
- https://docs.docker.com/engine/reference/builder/
youtube: PEos8f2ZMHw
comments: true
catalog_key: dockerfile
image_path: /resources/posts/docker/07j-dockerfile-healthcheck
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Health Check pada Dockerfile.

The `HEALTHCHECK` instruction tells Docker how to test a container to check that it is still working. This can detect cases such as a web server that is stuck in an infinite loop and unable to handle new connections, even though the server process is still running.

When a container has a healthcheck specified, it has a health status in addition to its normal status. This status is initially `starting`. Whenever a health check passes, it becomes healthy (whatever state it was previously in). After a certain number of consecutive failures, it becomes `unhealthy`.

The HEALTHCHECK instruction has two forms:

1. `HEALTHCHECK [OPTIONS] CMD command` (check container health by running a command inside the container)
2. `HEALTHCHECK NONE` (disable any healthcheck inherited from the base image)

The options that can appear before CMD are:

1. `--interval=DURATION` (default: 30s)
2. `--timeout=DURATION` (default: 30s)
3. `--start-period=DURATION` (default: 0s)
4. `--retries=N` (default: 3)

There can only be one `HEALTHCHECK` instruction in a Dockerfile. If you list more than one then only the last `HEALTHCHECK` will take effect.
The command after the `CMD` keyword can be either a shell command (e.g. `HEALTHCHECK CMD /bin/check-running)` or an exec array (as with other Dockerfile commands; see e.g. `ENTRYPOINT` for details).

The command’s exit status indicates the health status of the container. The possible values are:

1. `0: success` - the container is healthy and ready for use
2. `1: unhealthy` - the container is not working correctly
3. `2: reserved` - do not use this exit code

For example, to check every five minutes or so that a web-server is able to serve the site’s main page within three seconds:

{% highlight docker %}
HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost/ || exit 1
{% endhighlight %}

Contoh penggunaannya seperti berikut:

{% gist page.gist "07k-dockerfile-heathcheck" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ 07-dockerfile  docker build -t dimmaryanto93/centos:1.6 .
[+] Building 0.1s (9/9) FINISHED
 => [internal] load build definition from Dockerfile                                                               0.0s
 => => transferring dockerfile: 592B                                                                               0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 35B                                                                                   0.0s
 => [internal] load metadata for docker.io/library/centos:7                                                        0.0s
 => [internal] load build context                                                                                  0.0s
 => => transferring context: 32B                                                                                   0.0s
 => [1/4] FROM docker.io/library/centos:7                                                                          0.0s
 => CACHED [2/4] RUN yum install epel-release -y && yum install nginx -y                                           0.0s
 => CACHED [3/4] WORKDIR /usr/share/nginx/html                                                                     0.0s
 => CACHED [4/4] COPY index.html .                                                                                 0.0s
 => exporting to image                                                                                             0.0s
 => => exporting layers                                                                                            0.0s
 => => writing image sha256:64b1d99eeb283c88d0352dd8bb9544edcc4b52551dc8848226341caa03f1204e                       0.0s
 => => naming to docker.io/dimmaryanto93/centos:1.6

➜ 07-dockerfile  docker run -d --name webapp dimmaryanto93/centos:1.6
9f60172ba90b620dc2d5d424b0469f4a4fb7306632ea9f3e80af8d886aed6a85

➜ 07-dockerfile  watch docker container ls
Every 2.0s: docker container ls                                                   MSI-z390-pro: Tue Jun 22 20:36:24 2021

CONTAINER ID   IMAGE                      COMMAND                  CREATED          STATUS                    PORTS
NAMES
e7eb90183981   dimmaryanto93/centos:1.6   "nginx -g 'daemon of…"   3 seconds ago   Up 3 seconds (health: starting)
       webapp

## wait 10 detik hasilnya seperti berikut
Every 2.0s: docker container ls                                                   MSI-z390-pro: Tue Jun 22 20:37:09 2021

CONTAINER ID   IMAGE                      COMMAND                  CREATED          STATUS                    PORTS
NAMES
e7eb90183981   dimmaryanto93/centos:1.6   "nginx -g 'daemon of…"   29 seconds ago   Up 28 seconds (healthy)
webapp

## sekarang coba stop service nginxnya
➜ 07-dockerfile  docker exec -it webapp nginx -s stop

## containerpun ikut mati
Every 2.0s: docker container ls                                                   MSI-z390-pro: Tue Jun 22 20:39:27 2021

CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

➜ 07-dockerfile  docker run -it --name webapp2 dimmaryanto93/centos:1.6 bash
[root@abaef666dfb9 html]#

Every 2.0s: docker container ls                                                   MSI-z390-pro: Tue Jun 22 20:40:26 2021

CONTAINER ID   IMAGE                      COMMAND   CREATED          STATUS                      PORTS     NAMES        
abaef666dfb9  dimmaryanto93/centos:1.6   "bash"    18 seconds ago   Up 17 seconds (unhealthy)             webapp2

## Jalankan service nginx
[root@abaef666dfb9 html]# nginx

## statunya sekarang jadi healty
Every 2.0s: docker container ls                                                   MSI-z390-pro: Tue Jun 22 20:41:27 2021

CONTAINER ID   IMAGE                      COMMAND   CREATED              STATUS                        PORTS     NAMES  
abaef666dfb9   dimmaryanto93/centos:1.6   "bash"    About a minute ago   Up About a minute (healthy)             webapp2
```

Jadi kesimpulanya, dengan healthcheck Instruction ini kita bisa memastikan bahwa service yang kita buat sudah berjalan dengan sempura.

## Cleanup

Seperti biasa, setelah kita coba sekarang saatnya bersih-bersih. berikut perintahnya:

For Bash script:

{% gist page.gist "07k-cleanup.bash" %}

For Powershell script:

{% gist page.gist "07k-cleanup.ps1" %}