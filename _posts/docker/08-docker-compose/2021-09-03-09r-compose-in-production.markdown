---
layout: post
title: "Use Compose in production"
date: 2021-09-03T09:24:07+07:00
lang: docker
categories:
- DevOps
- Docker
- Compose
- Workflow
refs: 
- https://docs.docker.com/compose/production/
youtube: ijGi37zj1IA
comments: true
catalog_key: docker-compose
image_path: /resources/posts/docker/09q-best-practice-write-compose
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini kita akan membahas lebih detail tentang docker compose in production used. Diataranya

1. Modify your Compose file for production
2. Deploying changes
3. Running Compose on a single server

When you define your app with Compose in development, you can use this definition to run your application in different environments such as CI, staging, and production. 

## Modify your Compose file for production

The easiest way to deploy an application is to run it on a single server, similar to how you would run your development environment. But you probably need to make changes to your app configuration to make it ready for production. These changes may include:

1. Removing any volume bindings for application code, so that code stays inside the container and can’t be changed from outside
2. Binding to different ports on the host
3. Setting environment variables differently, such as reducing the verbosity of logging, or to specify settings for external services such as an email server
4. Specifying a restart policy like `restart: always` to avoid downtime
5. Adding extra services such as a log aggregator

For this reason, consider defining an additional Compose file, say `production.yml`, which specifies production-appropriate configuration. This configuration file only needs to include the changes you’d like to make from the original Compose file. The additional Compose file can be applied over the original` docker-compose.yml` to create a new configuration.

Once you’ve got a second configuration file, tell Compose to use it with the `-f` option:

{% highlight bash %}
docker-compose -f docker-compose.yml -f production.yml up -d
{% endhighlight %}

Berikut adalah contohnya:

1. `docker-compose.yaml` :
    {% gist page.gist "09r-docker-compose.yaml" %}
2. `docker-compose.override.yaml`
    {% gist page.gist "09r-docker-compose.override.yaml" %}
3. `docker-compose.prod.yaml`
    {% gist page.gist "09r-docker-compose.prod.yaml" %}
4. `.env`
    {% gist page.gist "09r-dotenv" %}
5. `.nginx/default.template.conf`
    {% gist page.gist "09q-scale.default.template.conf" %}
6. `Dockerfile-php`
    {% gist page.gist "09r-dockerfile-php" %}
7. `Dockerfile-proxy`
    {% gist page.gist "09r-dockerfile-proxy" %}

Jika kita jalankan maka hasilnya seperti berikut:

```powershell
➜ docker  docker-compose --project-directory .\09-docker-compose\production-use config
networks:
  backend: {}
  frontend: {}
services:
  db:
    environment:
      POSTGRES_DB: example
      POSTGRES_PASSWORD: secret_dev_passwd
      POSTGRES_USER: ex_user_pg
    image: postgres:12.6
    networks:
      backend: {}
    ports:
    - published: 5432
      target: 5432
    volumes:
    - pg_data:/var/lib/postgresql/data:rw
  proxy:
    depends_on:
      webapp:
        condition: service_started
    environment:
      APPLICATION_PORT: '80'
      BACKEND_CONTEXT_PATH: /
      BACKEND_HOST: webapp
      BACKEND_PORT: '80'
      NGINX_ROOT_DOCUMENT: /usr/share/nginx/html
    image: nginx:alpine
    networks:
      backend: {}
      frontend: {}
    ports:
    - published: 80
      target: 80
    volumes:
    - C:\Users\dimasm93\Workspaces\youtube\docker\09-docker-compose\production-use\.nginx\default.template.conf:/etc/nginx/templates/default.conf.template:rw
  webapp:
    depends_on:
      db:
        condition: service_started
    environment:
      DB_HOST: postgres
      DB_NAME: example
      DB_PASSWD: secret_dev_passwd
      DB_PORT: '5432'
      DB_USER: ex_user_pg
    image: php:8.0-apache
    networks:
      backend: {}
    ports:
    - published: 8080
      target: 80
    volumes:
    - C:\Users\dimasm93\Workspaces\youtube\docker\09-docker-compose\production-use:/var/www/html:rw
version: '3.9'
volumes:
  pg_data: {}

➜ docker  docker-compose --project-directory .\09-docker-compose\production-use -p dev up -d
Creating volume "dev_pg_data" with default driver
Creating dev_db_1 ... done
Creating dev_webapp_1 ... done
Creating dev_proxy_1  ... done

➜ docker  docker-compose --project-directory .\09-docker-compose\production-use -p dev ps
    Name                  Command               State                    Ports
------------------------------------------------------------------------------------------------
dev_db_1       docker-entrypoint.sh postgres    Up      0.0.0.0:5432->5432/tcp,:::5432->5432/tcp
dev_proxy_1    /docker-entrypoint.sh ngin ...   Up      0.0.0.0:80->80/tcp,:::80->80/tcp
dev_webapp_1   docker-php-entrypoint apac ...   Up      0.0.0.0:8080->80/tcp,:::8080->80/tcp

➜ docker  docker-compose --project-directory .\09-docker-compose\production-use -p prod `
>> -f .\09-docker-compose\production-use\docker-compose.yaml -f .\09-docker-compose\production-use\docker-compose.prod.yaml `
>> config --no-interpolate
networks:
  backend: {}
  frontend: {}
services:
  proxy:
    build:
      context: C:\Users\dimasm93\Workspaces\youtube\docker\09-docker-compose\production-use
      dockerfile: Dockerfile-proxy
    depends_on:
      webapp:
        condition: service_started
    environment:
      APPLICATION_PORT: '80'
      BACKEND_CONTEXT_PATH: /
      BACKEND_HOST: webapp
      BACKEND_PORT: '80'
      NGINX_ROOT_DOCUMENT: /usr/share/nginx/html
    image: nginx:alpine
    labels:
      org.vendor.application.description: Webapp Description
      org.vendor.application.name: FrontendAppName
    networks:
      backend: {}
      frontend: {}
    ports:
    - published: 30808
      target: 80
    restart: always
  webapp:
    build:
      context: C:\Users\dimasm93\Workspaces\youtube\docker\09-docker-compose\production-use
      dockerfile: Dockerfile-php
    environment:
      APP_ENV: production
      DB_HOST: 192.168.88.100
      DB_NAME: ${POSTGRES_DB}
      DB_PASSWD: ${POSTGRES_PASSWORD}
      DB_PORT: '5432'
      DB_USER: ${POSTGRES_USER}
      DEBUG: "false"
    expose:
    - '80'
    image: php:8.0-apache
    labels:
      org.vendor.application.description: Web Service Description
      org.vendor.application.name: BackendAppName
    networks:
      backend: {}
    restart: always
    volumes:
    - webapp_data:/var/www/html/storage:rw
version: '3.9'
volumes:
  pg_data: {}
  webapp_data: {}

➜ docker  docker-compose --project-directory .\09-docker-compose\production-use -p prod `
>> -f .\09-docker-compose\production-use\docker-compose.yaml -f .\09-docker-compose\production-use\docker-compose.prod.yaml `
>> up -d --build
Creating network "prod_backend" with the default driver
Creating network "prod_frontend" with the default driver
Creating volume "prod_pg_data" with default driver
Creating volume "prod_webapp_data" with default driver
Building webapp
[+] Building 0.4s (8/8) FINISHED
 => [internal] load build definition from Dockerfile-php                                                           0.0s
 => => transferring dockerfile: 273B                                                                               0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 2B                                                                                    0.0s
 => [internal] load metadata for docker.io/library/php:8.0-apache                                                  0.0s
 => [internal] load build context                                                                                  0.0s
 => => transferring context: 55B                                                                                   0.0s
 => [1/3] FROM docker.io/library/php:8.0-apache                                                                    0.1s
 => [2/3] WORKDIR /var/www/html                                                                                    0.0s
 => [3/3] COPY index.php .                                                                                         0.0s
 => exporting to image                                                                                             0.1s
 => => exporting layers                                                                                            0.0s
 => => writing image sha256:28f6054e1b22682d7520949878418a10ceea8c71cfbd4bf87142f389f82e57d0                       0.0s
 => => naming to docker.io/library/php:8.0-apache                                                                  0.0s
Building proxy
[+] Building 3.1s (9/9) FINISHED
 => [internal] load build definition from Dockerfile-proxy                                                         0.0s
 => => transferring dockerfile: 319B                                                                               0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 2B                                                                                    0.0s
 => [internal] load metadata for docker.io/library/nginx:mainline                                                  3.0s
 => [auth] library/nginx:pull token for registry-1.docker.io                                                       0.0s
 => [1/3] FROM docker.io/library/nginx:mainline@sha256:4d4d96ac750af48c6a551d757c1cbfc071692309b491b70b2b8976e102  0.0s
 => [internal] load build context                                                                                  0.0s
 => => transferring context: 497B                                                                                  0.0s
 => CACHED [2/3] WORKDIR /usr/share/nginx/html                                                                     0.0s
 => CACHED [3/3] COPY .nginx/default.template.conf /etc/nginx/templates/default.conf.template                      0.0s
 => exporting to image                                                                                             0.0s
 => => exporting layers                                                                                            0.0s
 => => writing image sha256:cab13ff283f33d5ec43d7110fba2276580166d6735eb07c6b5c8bd68b34207cb                       0.0s
 => => naming to docker.io/library/nginx:alpine                                                                    0.0s
Creating prod_webapp_1 ... done
Creating prod_proxy_1  ... done

>> -f .\09-docker-compose\production-use\docker-compose.yaml -f .\09-docker-compose\production-use\docker-compose.prod.yaml `
>> ps
    Name                   Command               State                   Ports
-----------------------------------------------------------------------------------------------
prod_proxy_1    /docker-entrypoint.sh ngin ...   Up      0.0.0.0:30808->80/tcp,:::30808->80/tcp
prod_webapp_1   docker-php-entrypoint apac ...   Up      80/tcp

## sekarang coba restart docker engine, kemudian check lagi servicenyang running
➜ docker  docker container ls -a
CONTAINER ID   IMAGE            COMMAND                  CREATED              STATUS                        PORTS                                       NAMES
f1c5f7c5d1ef   nginx:alpine     "/docker-entrypoint.…"   About a minute ago   Up 12 seconds                 0.0.0.0:30808->80/tcp, :::30808->80/tcp     prod_proxy_1
8672316b76b8   php:8.0-apache   "docker-php-entrypoi…"   About a minute ago   Up 12 seconds                 80/tcp                                      prod_webapp_1
a9fcea99212d   nginx:alpine     "/docker-entrypoint.…"   3 minutes ago        Exited (255) 13 seconds ago   0.0.0.0:80->80/tcp, :::80->80/tcp           dev_proxy_1
dc6b24c1db00   bcabf70c31a8     "docker-php-entrypoi…"   3 minutes ago        Exited (255) 13 seconds ago   0.0.0.0:8080->80/tcp, :::8080->80/tcp       dev_webapp_1
3564f8c4c0a3   postgres:12.6    "docker-entrypoint.s…"   3 minutes ago        Exited (255) 13 seconds ago   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   dev_db_1
```

## Deploying changes

When you make changes to your app code, remember to rebuild your image and recreate your app’s containers. To redeploy a service called `webapp`, use:

{% highlight bash %}
docker-compose -f docker-compose.yaml -f docker-compose.prod.yaml build webapp
docker-compose -f docker-compose.yaml -f docker-compose.prod.yaml up --no-deps -d webapp
{% endhighlight %}

This first rebuilds the image for `proxy` and then stop, destroy, and recreate _just_ the `proxy` service. The `--no-deps` flag prevents Compose from also recreating any services which `proxy` depends on.

## Running Compose on a single server

You can use Compose to deploy an app to a remote Docker host by setting the `DOCKER_HOST`, `DOCKER_TLS_VERIFY`, and `DOCKER_CERT_PATH` environment variables appropriately.

Once you’ve set up your environment variables, all the normal `docker-compose` commands work with no further configuration.

Untuk lebih jelasnya nanti kita akan bahas di bagian Docker Context.