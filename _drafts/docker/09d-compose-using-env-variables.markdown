---
layout: post
title: "Environment variables in Compose"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/compose/environment-variables/
youtube: 
comments: true
image_path: /resources/posts/docker/09b-compose-using-env-variables
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini kita akan membahas Environment variable khususnya dalam Compose file, diantaranya

1. Set environtment variable in container
2. The `.env` file
3. Operation System environment variables
4. Using the `--env-file` option
5. The `env_file` configuration option

Ok langsung ja, kita ke pembahasan yang pertama yaitu

## Set environtment variable in container

You can set environment variables in a service’s containers with the `environment` key, just like with `docker run -e VARIABLE=VALUE ...`:

{% gist page.gist "09c-compose-service.yaml" %}

## The `.env` file

You can set default values for any environment variables referenced in the Compose file, or used to configure Compose, in an [environment file](https://docs.docker.com/compose/env-file/) named `.env`. The `.env` file path is as follows:

1. Starting with `+v1.28`, `.env` file is placed at the base of the project directory
2. Project directory can be explicitly defined with the `--file` option or `COMPOSE_FILE` environment variable. Otherwise, it is the current working directory where the docker compose command is executed (`+1.28`).
3. For previous versions, it might have trouble resolving `.env` file with `--file` or `COMPOSE_FILE`. To work around it, it is recommended to use `--project-directory`, which overrides the path for the `.env` file. This inconsistency is addressed in `+v1.28` by limiting the filepath to the project directory.

Contohnya kita buat file `.env` seperti berikut:

{% gist page.gist "09d-env-file" %}

Dan berikut adalah file `docker-compose.yaml` seperti berikut:

{% gist page.gist "09d-env-file.docker-compose.yaml" %}

When you run `docker-compose up`, the `web` service defined above uses the image `nginx:1.12.1`. You can verify this with the [config command](https://docs.docker.com/compose/reference/config/), which prints your resolved application config to the terminal:

```powershell
➜ env-file  docker-compose config
services:
  web:
    image: nginx:1.21.1
    ports:
    - published: 80
      target: 80
version: '3.8'
```

## Operation system environment variables

Selain menggunakan `.env` file, compose file juga listen dari OS Environtment variable, sebagai contoh kita masih menggunakan `docker-compose.yaml` sebelumnya yaitu:

{% gist page.gist "09d-env-file.docker-compose.yaml" %}

Sekarang coba set env variable di OS dengan perintah seperti berikut:

For Bash script:

{% highlight bash %}
export NGINX_VERSION=latest
{% endhighlight %}

For Powershell script:

{% highlight bash %}
$Env:NGINX_VERSION="latest"
{% endhighlight %}

Sekarang coba check dengan perintah seperti berikut `docker-compose config`, maka hasilnya seperti berikut:

```powershell
➜ env-file  $Env:NGINX_VERSION="latest"
➜ env-file  docker-compose config
services:
  web:
    image: nginx:latest
    ports:
    - published: 80
      target: 80
version: '3.8'

# To remove Env NGINX_VERSION from Session
➜ env-file  Remove-Item Env:NGINX_VERSION
```