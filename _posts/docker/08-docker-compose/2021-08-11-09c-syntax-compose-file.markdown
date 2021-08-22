---
layout: post
title: "Compose file specification and syntax"
date: 2021-08-11T14:02:57+07:00
lang: docker
categories:
- DevOps
- Docker
- Compose
refs: 
- https://docs.docker.com/compose/compose-file/compose-versioning/
- https://docs.docker.com/compose/compose-file/compose-file-v3/
youtube: y3QAs0NZg-s
comments: true
image_path: /resources/posts/docker/09c-syntax-compose-file
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
doc_link: https://docs.docker.com/compose/compose-file/compose-file-v3/
---

Hai semuanya di materi kali ini kita akan membahas basic syntax dalam penulisan Compose file, diantaranya yang akan kita bahas yaitu

1. Compose file version
2. Service configuration reference
3. Volume configuration reference
4. Network configuration reference

Ok langsung ja kita kepembahasan yang pertama yaitu

## Compose file version

There are several versions of the Compose file format – `1`, `2`, `2.x`, and `3.x`.The Compose file formats are now described in these references, specific to each version.

1. [Version 3](https://docs.docker.com/compose/compose-file/compose-file-v3/)
2. [Version 2](https://docs.docker.com/compose/compose-file/compose-file-v2/)
3. Version 1 (Deprecated / obsolate)

The latest Compose file format is defined by the [Compose Specification](https://github.com/compose-spec/compose-spec/blob/master/spec.md) and is implemented by Docker Compose 1.27.0+.

Several things differ depending on which version you use:
1. The structure and permitted configuration keys
2. The minimum Docker Engine version you must be running
3. Compose’s behaviour with regards to networking

Berikut adalah table compatibility matrix

| Compose file format | Docker engine release |
| :---  | :---        |
| `3.8` | `19.03.0+` |        
| `3.7` | `18.06.0+` |        
| `3.6` | `18.02.0+` |        
| `3.5` | `17.12.0+` |        
| `3.4` | `17.09.0+` |        
| `3.3` | `17.06.0+` |        
| `3.2` | `17.04.0+` |        

so in this tutorial we will covers latest version docker-compose file which is version `3.x`, contoh penggunaanya seperti berikut

{% highlight yaml %}
version: '3.8'
services:
    ...
{% endhighlight %}

## Service configuration reference

A service definition contains configuration that is applied to each container started for that service, much like passing command-line parameters to `docker run`. Likewise, network and volume definitions are analogous to `docker network create` and `docker volume create`. 

As with `docker run`, options specified in the Dockerfile, such as `CMD`, `EXPOSE`, `VOLUME`, `ENV`, are respected by default - you don’t need to specify them again in docker-compose.yml.

Berikut adalah beberapa list yang termasuk service configuration yang sering saya gunakan pada compose file specification version `3.x` diantaranya:

1. [build]({{ page.doc_link }}#build)
2. [command]({{ page.doc_link }}#command)
5. [depends_on]({{ page.doc_link }}#depends_on)
6. [deploy]({{ page.doc_link }}#deploy)
7. [dns]({{ page.doc_link }}#dns)
8. [dns_search]({{ page.doc_link }}#dns_search)
9. [entrypoint]({{ page.doc_link }}#entrypoint)
10. [env_file]({{ page.doc_link }}#env_file)
11. [environment]({{ page.doc_link }}#environment)
14. [healthcheck]({{ page.doc_link }}#healthcheck)
15. [image]({{ page.doc_link }}#image)
16. [networks]({{ page.doc_link }}#networks)
17. [ports]({{ page.doc_link }}#ports)
18. [profiles]({{ page.doc_link }}#profiles)
19. [restart]({{ page.doc_link }}#restart)
20. [volumes]({{ page.doc_link }}#volumes)

## Volume configuration reference

While it is possible to declare volumes on the fly as part of the service declaration, this section allows you to create named volumes that can be reused across multiple services (without relying on volumes_from), and are easily retrieved and inspected using the docker command line or API. See the docker volume subcommand documentation for more information.

See [use volumes](https://docs.docker.com/storage/volumes/) and [volume plugins](https://docs.docker.com/engine/extend/plugins_volume/) for general information on volumes

Berikut adalah beberapa list yang termasuk volume configuration yang sering saya gunakan pada compose file specification version `3.x` diantaranya:

1. [driver]({{ page.doc_link }}#driver)
2. [driver_opts]({{ page.doc_link }}#driver_opts)
3. [labels]({{ page.doc_link }}#labels-3)
4. [name]({{ page.doc_link }}#name)

## Network configuration reference

The top-level `networks` key lets you specify networks to be created.

Berikut adalah beberapa list yang termasuk networking config yang sering saya gunakan pada compose file specification version `3.x` diantaranya:

1. [driver](https://docs.docker.com/compose/compose-file/compose-file-v3/#driver-1)
2. [driver_opts](https://docs.docker.com/compose/compose-file/compose-file-v3/#driver_opts-1)
3. [labels](https://docs.docker.com/compose/compose-file/compose-file-v3/#labels-4)

## Examples

For example if you wont run docker config like this:

{% highlight bash %}
docker network create backend && \
docker volume create pg_data && \
docker run --name db_test \
-p 5432:5432 \
-e POSTGRES_PASSWORD=password \
-e POSTGRES_USER=test_sit_user \
-e POSTGRES_DB=test_sit_db \
-v pg_data:/var/lib/postgresql/data \
-d postgres:12.6
{% endhighlight %}

First you need create/define a file `docker-compose.yaml` like this:

{% gist page.gist "09c-compose-service.yaml" %}

Setelah itu kita bisa jalankan menggunakan perintah 

{% highlight bash %}
docker-compose up -d
{% endhighlight %}

Jika dijalankan maka outputnya seperti berikut:

```powershell
➜ 09-docker-compose  docker-compose -f .\docker-compose.yaml up -d
Creating network "09-docker-compose_backend" with the default driver
Creating volume "09-docker-compose_pg_data" with default driver

➜ 09-docker-compose ✗  docker-compose ps
         Name                       Command              State                    Ports
---------------------------------------------------------------------------------------------------------
09-docker-compose_db_1   docker-entrypoint.sh postgres   Up      0.0.0.0:5432->5432/tcp,:::5432->5432/tcp

➜ 09-docker-compose  docker container inspect 09-docker-compose_db_1 -f '{% raw %}{{json .Config.Env}}{% endraw %}' | python.exe -m json.tool

[
    "POSTGRES_PASSWORD=password",
    "POSTGRES_USER=test_sit_user",
    "POSTGRES_DB=test_sit_db"
]

➜ 09-docker-compose  docker network ls
NETWORK ID     NAME                        DRIVER    SCOPE
8896f4f5181c   09-docker-compose_backend   bridge    local

➜ 09-docker-compose  docker volume ls
DRIVER    VOLUME NAME
local     09-docker-compose_pg_data

➜ 09-docker-compose  docker container ls
CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS          PORTS
             NAMES
08e9f406c84a   postgres:12.6   "docker-entrypoint.s…"   12 minutes ago   Up 12 minutes   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   09-docker-compose_db_1
```

Jadi kedepannya kita tidak perlu lagi mengingat config yang kita perlu run, cukup menggunakan template `docker-compose.yaml` dan perintah `docker-compose up` done!. 