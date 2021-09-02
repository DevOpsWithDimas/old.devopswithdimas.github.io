---
layout: post
title: "Example use case of multiple compose files"
date: 2021-08-31T06:49:29+07:00
lang: docker
categories:
- DevOps
- Docker
- Workflows
refs: 
- https://docs.docker.com/compose/extends/
youtube: 
comments: true
image_path: /resources/posts/docker/09p-multi-compose-example
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang contoh kasusnya dalam penggunaan multiple compose file. Diantaranya:

1. Changing a Compose app for different environments 
2. Running administrative tasks against a Compose app

Ok langsung aja kita ke pembahasan yang pertama

## Different environments

A common use case for multiple files is changing a development Compose app for a production-like environment (which may be production, staging or CI). To support these differences, you can split your Compose configuration into a few different files:

Start with a base file that defines the canonical configuration for the services. `docker-compose.yaml`

{% gist page.gist "09p-diff-env.docker-compose.yaml" %}

In this example the development configuration exposes some ports to the host, mounts our code as a volume, and builds the web image. `docker-compose.override.yaml`

{% gist page.gist "09p-diff-env.docker-compose.override.yaml" %}

When you run `docker-compose up` it reads the overrides automatically.

Now, it would be nice to use this Compose app in a production environment. So, create another override file (which might be stored in a different git repo or managed by a different team).

{% gist page.gist "09-diff-env.docker-compose.prod.yaml" %}

To deploy with this production Compose file you can run

{% highlight bash %}
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
{% endhighlight %}

This deploys all three services using the configuration in `docker-compose.yml` and `docker-compose.prod.yml` (but not the dev configuration in `docker-compose.override.yml`).

```powershell
➜ docker  docker-compose --project-directory .\09-docker-compose\multiple-compose\diff-envs\ config
networks:
  backend: {}
  frontend: {}
services:
  backend:
    depends_on:
      db:
        condition: service_started
    image: php:8.0-apache
    networks:
      backend: {}
      frontend: {}
    ports:
    - published: 8080
      target: 80
  db:
    environment:
      POSTGRES_DB: example_db
      POSTGRES_PASSWORD: secretPassword
      POSTGRES_USER: example_user
    image: postgres:12.6
    networks:
      backend: {}
    ports:
    - published: 5432
      target: 5432
    volumes:
    - source: pg_data
      target: /var/lib/postgresql/data
      type: volume
  webapp:
    image: nginx:latest
    networks:
      frontend: {}
    ports:
    - published: 80
      target: 80
    volumes:
    - C:\Users\dimasm93\Workspaces\youtube\docker\09-docker-compose\multiple-compose\diff-envs\html:/usr/share/nginx/html:rw
version: '3.9'
volumes:
  pg_data: {}

➜ docker  docker-compose -f .\09-docker-compose\multiple-compose\diff-envs\docker-compose.yaml `
>> -f .\09-docker-compose\multiple-compose\diff-envs\docker-compose.prod.yaml config
networks:
  backend: {}
  frontend: {}
services:
  backend:
    build:
      args:
        PHP_VERSION: 8.0-apache
      context: C:\Users\dimasm93\Workspaces\youtube\docker\09-docker-compose\multiple-compose\diff-envs
      dockerfile: Dockerfile-php
    depends_on:
      db:
        condition: service_started
    image: php:8.0-apache
    networks:
      backend: {}
      frontend: {}
  db:
    environment:
      POSTGRES_DB: prod_db
      POSTGRES_PASSWORD_FILE: /run/secrets/postgres-passwd
      POSTGRES_USER: user_prod
    image: postgres:12.6
    networks:
      backend: {}
    volumes:
    - source: pg_data
      target: /var/lib/postgresql/data
      type: volume
  webapp:
    build:
      args:
        NGINX_VERSION: mainline
      context: C:\Users\dimasm93\Workspaces\youtube\docker\09-docker-compose\multiple-compose\diff-envs
      dockerfile: Dockerfile
    image: nginx:latest
    networks:
      frontend: {}
    ports:
    - published: 80
      target: 80
version: '3.9'
volumes:
  pg_data: {}
```

## Administrative tasks

Another common use case is running adhoc or administrative tasks against one or more services in a Compose app. This example demonstrates running a database backup. `docker-compose.yaml`

{% gist page.gist "09p-migrate.docker-compose.yaml" %}

In a `docker-compose.admin.yml` add a new service to run the database migrate, backup or exports.

{% gist page.gist "09p-migrate.docker-compose.admin.yaml" %}

To start a normal environment run `docker-compose up -d`. To run a database backup, include the `docker-compose.admin.yml` as well.

{% highlight bash %}
docker-compose -f docker-compose.yml -f docker-compose.admin.yml up -d
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ docker  docker-compose -f .\09-docker-compose\multiple-compose\admin-task\docker-compose.yaml `
>> -f .\09-docker-compose\multiple-compose\admin-task\docker-compose.admin-task.yaml config
networks:
  backend: {}
services:
  backend:
    depends_on:
      db:
        condition: service_started
    image: php:8.0-apache
    networks:
      backend: {}
    ports:
    - published: 8080
      target: 80
  db:
    environment:
      POSTGRES_DB: example_db
      POSTGRES_PASSWORD: secretPassword
      POSTGRES_USER: example_user
    image: postgres:12.6
    networks:
      backend: {}
    ports:
    - published: 5432
      target: 5432
    volumes:
    - source: pg_data
      target: /var/lib/postgresql/data
      type: volume
  migrate:
    command:
    - -user=
    - -password=
    - -url=jdbc:postgresql://postgres:5432/
    - info
    depends_on:
      db:
        condition: service_started
    environment:
      FLYWAY_EDITION: null
    image: flyway/flyway:latest-alpine
    networks:
      backend: {}
version: '3.9'
volumes:
  pg_data: {}
```