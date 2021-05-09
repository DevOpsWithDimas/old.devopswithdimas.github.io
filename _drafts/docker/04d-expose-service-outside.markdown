---
layout: post
title: "Expose services to outside using ports"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/config/containers/container-networking/
youtube: 
comments: true
image_path: /resources/posts/docker/04d-expose-ports
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


By default, when you create or run a container using docker create or docker run, it does not publish any of its ports to the outside world. To make a port available to services outside of Docker, or to Docker containers which are not connected to the container’s network, use the --publish or -p flag. This creates a firewall rule which maps a container port to a port on the Docker host to the outside world. Here are some examples.

| Flag value                        | Description   |
| :---                              | :---          |
| `-p 8080:80`                      | Map TCP port 80 in the container to port 8080 on the Docker host. |
| `-p 192.168.1.100:8080:80`        | Map TCP port 80 in the container to port 8080 on the Docker host for connections to host IP 192.168.1.100. |
| `-p 8080:80/udp` 	                | Map UDP port 80 in the container to port 8080 on the Docker host. |
| `-p 8080:80/tcp -p 8080:80/udp`   | Map TCP port 80 in the container to TCP port 8080 on the Docker host, and map UDP port 80 in the container to UDP port 8080 on the Docker host. |

Sebagai contoh kita buat 3 container dengan network yang berbeda, seperti berikut:

{% gist page.gist "04d-expose-ports.bash" %}

Sekarang coba, jalankan maka hasilnya seperti berikut:

```powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Try the new cross-platform PowerShell https://aka.ms/pscore6

➜ nginx  docker container run --name nginx-worldwide -d -p 8090:80 nginx
18daccdafc85e222b0855fcd753d4c3d57f01c0ee5238ddb8e6ba3ac4b11ea66
➜ nginx  docker container run --name nginx-localnetwork -d -p 192.168.88.254:8080:80 nginx
a0dc5482893666989812710242b7be3ed9c9b7ef8fded9d9812879b4cda1f09a
➜ nginx  docker container run --name nginx-localhost -d -p 127.0.0.1:80:80 nginx
966a5752b45b115489444682d881a039c497a57542fd7f1f3b7b4f91db6d3f03

➜ nginx  docker container ls
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                         NAMES
966a5752b45b   nginx     "/docker-entrypoint.…"   21 seconds ago   Up 21 seconds   127.0.0.1:80->80/tcp          nginx-localhost
a0dc54828936   nginx     "/docker-entrypoint.…"   27 seconds ago   Up 26 seconds   192.168.88.254:8080->80/tcp   nginx-localnetwork
18daccdafc85   nginx     "/docker-entrypoint.…"   51 seconds ago   Up 50 seconds   0.0.0.0:8090->80/tcp          nginx-worldwide
```

Sekarang kita coba scenario berikut:

| Ports     | `localhost`                               | `192.168.88.254`                          | from outside                                              |
| :---      | :---                                      | :---                                      | :---                                                      |
| `80`      | `StatusDescription : OK`                  | `Unable to connect to the remote server`  | `Unable to reach`                                         |
| `8080`    | `Unable to connect to the remote server`  | `StatusDescription : OK`                  | `StatusDescription : OK` ***note if firewall allowed**    |
| `8090`    | `StatusDescription : OK`                  | `StatusDescription : OK`                  | `StatusDescription : OK` ***note if firewall allowed**    |