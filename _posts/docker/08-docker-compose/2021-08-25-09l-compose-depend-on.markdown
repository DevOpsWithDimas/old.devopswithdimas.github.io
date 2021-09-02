---
layout: post
title: "Dependency between services in Compose file"
date: 2021-08-25T11:31:22+07:00
lang: docker
categories:
- DevOps
- Docker
- Compose
- Dependency
refs: 
- https://docs.docker.com/compose/compose-file/compose-file-v3/#depends_on
youtube: HPTSGkSkp98
comments: true
image_path: /resources/posts/docker/09l-compose-depend-on
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Service Dependencies dalam Compose file.

Service Dependency adalah the most-common dalam pengembangan aplikasi, component paling basic atau minimal biasanya kita memerlukan database atau external service. Sebagai contoh misalnya klo kita menjalankan aplikasi tapi tanpa database maka akan terjadi failure. 

Pada Compose file, ada `depends_on`. Express dependency between services. Service dependencies cause the following behaviors:

1. `docker-compose up` starts services in dependency order. In the following example, `db` and `migrate-tool` are started before `web`.
2. `docker-compose up SERVICE` automatically includes `SERVICE’s` dependencies. In the example below, `docker-compose up web` also creates and starts `db` and `migrate-tool`.
3. `docker-compose stop` stops services in dependency order. In the following example, `web` is stopped before `db`.

{% gist page.gist "09l-depend-on.docker-compose.yaml" %}

Dan berikut adalah file `.env`:

{% gist page.gist "09l-depend-on.env" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ docker  docker-compose -f .\09-docker-compose\dependency\docker-compose.yaml config
services:
  migrate-tools:
    command:
    - -user=bisnis_app
    - -password=secretPassword
    - -url=jdbc:postgresql://postgres:5432/bisnis_app
    - info
    depends_on:
      postgres:
        condition: service_started
    environment:
      FLYWAY_EDITION: community
    image: flyway/flyway:latest-alpine
  postgres:
    environment:
      POSTGRES_DB: bisnis_app
      POSTGRES_PASSWORD: secretPassword
      POSTGRES_USER: bisnis_app
    image: postgres:12.6
    ports:
    - published: 5432
      target: 5432
    volumes:
    - pg_data:/var/lib/postgresql/data:rw
  web:
    depends_on:
      migrate-tools:
        condition: service_started
      postgres:
        condition: service_started
    image: nginx
    ports:
    - published: 80
      target: 80
    volumes:
    - C:\Users\dimasm93\Workspaces\youtube\docker\09-docker-compose\dependency\html:/usr/share/nginx/html:rw
version: '3.9'
volumes:
  pg_data: {}

➜ docker  docker-compose -f .\09-docker-compose\dependency\docker-compose.yaml -p dependency up -d
Creating network "dependency_default" with the default driver
Creating volume "dependency_pg_data" with default driver
Creating dependency_postgres_1 ... done
Creating dependency_migrate-tools_1 ... done
Creating dependency_web_1           ... done

➜ docker  docker-compose -f .\09-docker-compose\dependency\docker-compose.yaml -p dependency ps
           Name                         Command               State                     Ports
---------------------------------------------------------------------------------------------------------------
dependency_migrate-tools_1   flyway -user=bisnis_app -p ...   Exit 0
dependency_postgres_1        docker-entrypoint.sh postgres    Up       0.0.0.0:5432->5432/tcp,:::5432->5432/tcp
dependency_web_1             /docker-entrypoint.sh ngin ...   Up       0.0.0.0:80->80/tcp,:::80->80/tcp

➜ docker  docker-compose -f .\09-docker-compose\dependency\docker-compose.yaml -p dependency logs migrate-tools
Attaching to dependency_migrate-tools_1
migrate-tools_1  | Flyway Community Edition 7.14.0 by Redgate
migrate-tools_1  | Database: jdbc:postgresql://postgres:5432/bisnis_app (PostgreSQL 12.6)
migrate-tools_1  | Schema version: << Empty Schema >>
migrate-tools_1  |
migrate-tools_1  | +----------+---------+-------------+------+--------------+-------+
migrate-tools_1  | | Category | Version | Description | Type | Installed On | State |
migrate-tools_1  | +----------+---------+-------------+------+--------------+-------+
migrate-tools_1  | | No migrations found                                            |
migrate-tools_1  | +----------+---------+-------------+------+--------------+-------+
migrate-tools_1  |

➜ docker  docker-compose -f .\09-docker-compose\dependency\docker-compose.yaml -p dependency down
Stopping dependency_web_1      ... done
Stopping dependency_postgres_1 ... done
Removing dependency_web_1           ... done
Removing dependency_migrate-tools_1 ... done
Removing dependency_postgres_1      ... done
Removing network dependency_default

# testing start from service name: migrate-tools
➜ docker  docker-compose -f .\09-docker-compose\dependency\docker-compose.yaml -p dependency up -d migrate-tools
Creating network "dependency_default" with the default driver
Creating dependency_postgres_1 ... done
Creating dependency_migrate-tools_1 ... done

➜ docker  docker-compose -f .\09-docker-compose\dependency\docker-compose.yaml -p dependency down
Stopping dependency_postgres_1 ... done
Removing dependency_migrate-tools_1 ... done
Removing dependency_postgres_1      ... done
Removing network dependency_default

# testing start from service name: web
➜ docker  docker-compose -f .\09-docker-compose\dependency\docker-compose.yaml -p dependency up -d web
Creating network "dependency_default" with the default driver
Creating dependency_postgres_1 ... done
Creating dependency_migrate-tools_1 ... done
Creating dependency_web_1           ... done

➜ docker  docker-compose -f .\09-docker-compose\dependency\docker-compose.yaml -p dependency down --volumes
Stopping dependency_web_1      ... done
Stopping dependency_postgres_1 ... done
Removing dependency_web_1           ... done
Removing dependency_migrate-tools_1 ... done
Removing dependency_postgres_1      ... done
Removing network dependency_default
Removing volume dependency_pg_data
```

There are several things to be aware of when using `depends_on`:

1. `depends_on` does not wait for db and `migrate-tools` to be “ready” before starting `web` - only until they have been started. If you need to wait for a service to be ready, see [Controlling startup order](https://docs.docker.com/compose/startup-order/) for more on this problem and strategies for solving it.
2. The `depends_on` option is ignored when [deploying a stack in swarm mode](https://docs.docker.com/engine/reference/commandline/stack_deploy/) with a version 3 Compose file.