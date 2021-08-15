---
layout: post
title: "Environment variables in Compose"
date: 2021-08-11T17:01:40+07:00
lang: docker
categories:
- DevOps
- Docker
- Compose
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
5. Pass environment variables to containers
6. The `env_file` configuration option
7. Set environment variables with `docker-compose run`

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
## perintah berikut akan meng-override file `.env` file karena levelnya lebih tinggi
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

here’s the priority used by Compose to choose which value to use:

1. Compose file
2. Shell environment variables
3. Environment file
4. Dockerfile
5. Variable is not defined

## Using the `--env-file` option

By passing the file as an argument, you can store it anywhere and name it appropriately, for example, `.env.ci`, `.env.dev`, `.env.prod`. Passing the file path is done using the `--env-file` option:

{% highlight bash %}
docker-compose -f .env.dev config
{% endhighlight %}

Jika di jalankan maka hasilnya seperti berikut:

```bash
## create copy file of `.env` to `.env.dev`
➜ env-file  cp .env .env.dev
# the edit value in `.env.dev` file
➜ env-file  sed -i 's|1.21.1|mainline|g' .env.dev

➜ env-file  cat .env.dev
NGINX_VERSION=mainline

➜ env-file  docker-compose --env-file .env.dev config
services:
  web:
    image: nginx:mainline
    ports:
    - published: 80
      target: 80
version: '3.8'
```

## Pass environment variables to containers

You can pass environment variables from your shell straight through to a service’s containers with the [‘environment’ key](https://docs.docker.com/compose/compose-file/compose-file-v3/#environment) by not giving them a value, just like with `docker run -e VARIABLE ...`:

Buat file baru dengan nama `.env` seperti berikut:

{% gist page.gist "09d-env-pass-container" %}

Dan berikut adalah file `docker-compose.yaml` seperti berikut:

{% gist page.gist "09d-pass-container.docker-compose.yaml" %}

Jika kita coba validate maka hasilnya seperti berikut:

```powershell
➜ pass-env  cat .env
POSTGRES_PASSWORD=test_db
DB_USERNAME=test_db
POSTGRES_DB=test_db

➜ pass-env  cat docker-compose.yaml
version: '3.8'
services:
  db:
    image: postgres:12.6
    environment:
      - POSTGRES_PASSWORD
      - POSTGRES_USER=${DB_USERNAME}
      - POSTGRES_DB
    ports:
      - 5432:5432

➜ pass-env  docker-compose --env-file .env config
services:
  db:
    environment:
      POSTGRES_DB: test_db
      POSTGRES_PASSWORD: test_db
      POSTGRES_USER: test_db
    image: postgres:12.6
    ports:
    - published: 5432
      target: 5432
version: '3.8'
```

The value of the `POSTGRES_DB` variable in the container is taken from the value for the same variable in the shell in which Compose is run.

## The `env_file` configuration option

You can pass multiple environment variables from an external file through to a service’s containers with the `env_file` option, just like with `docker run --env-file=FILE ...`:

Buat file baru dengan nama `database.dev.env` seperti berikut:

{% gist page.gist "09d-custome-env-file" %}

Dan berikut adalah file `docker-compose.yaml` seperti berikut:

{% gist page.gist "09d-custome-env-file.docker-compose.yaml" %}

Jika kita coba validate maka hasilnya seperti berikut:

```powershell
➜ env-file-option  docker-compose config
services:
  db:
    environment:
      POSTGRES_DB: hr_db
      POSTGRES_PASSWORD: dev_db
      POSTGRES_USER: dev_db
    image: postgres:12.6
    ports:
    - published: 5432
      target: 5432
version: '3.8'
```

## Set environment variables with `docker-compose run`

Similar to `docker run -e`, you can set environment variables on a one-off container with `docker-compose run -e`:

Berikut adalah `docker-compose.yaml` template:

{% gist page.gist "09d-run.docker-compose.yaml" %}

Kemudian coba jalan perintah berikut

{% highlight bash %}
docker-compose -f .\docker-compose.yaml run \
-e POSTGRES_DB=hr_db \
-e POSTGRES_USER=prod_db \
db
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ docker-compose-run  docker-compose -f .\docker-compose.yaml run `
>> -e POSTGRES_DB=hr_db `
>> -e POSTGRES_USER=prod_db `
>> -d db

Creating docker-compose-run_db_run ... done
docker-compose-run_db_run_bef93b57be79

➜ docker-compose-run  docker-compose ps
                 Name                               Command              State    Ports
-----------------------------------------------------------------------------------------
docker-compose-run_db_run_bef93b57be79   docker-entrypoint.sh postgres   Up      5432/tcp

➜ docker-compose-run  docker container inspect docker-compose-run_db_run_bef93b57be79 -f '{% raw %}{{json .Config.Env}}{% endraw %}' | python.exe -m json.tool
[
    "POSTGRES_PASSWORD=hr_db",
    "POSTGRES_DB=hr_db",
    "POSTGRES_USER=prod_db",
    "PGDATA=/var/lib/postgresql/data"
]
```