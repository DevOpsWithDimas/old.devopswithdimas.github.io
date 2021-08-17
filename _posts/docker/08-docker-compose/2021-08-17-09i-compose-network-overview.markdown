---
layout: post
title: "Networking Overview in Compose file"
date: 2021-08-17T13:50:38+07:00
lang: docker
categories:
- DevOps
- Docker
- Compose
refs: 
- https://docs.docker.com/compose/networking/
youtube: 
comments: true
image_path: /resources/posts/docker/09f-compose-networking
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini kita akan membahas tentang Networking menggunakan Docker Compose

By default Compose sets up a single [network](https://docs.docker.com/engine/reference/commandline/network_create/) for your app. Each container for a service joins the default network and is both reachable by other containers on that network, and discoverable by them at a hostname identical to the container name.

For example, suppose your app is in a directory called myapp, and your `docker-compose.yml` looks like this:

{% gist page.gist "09i-simple-network.docker-compose.yaml" %}

When you run `docker-compose -p myapp up`, the following happens:

1. A network called `myapp_default` is created.
2. A container is created using `web’s` configuration. It joins the network `myapp_default` under the name web.
3. A container is created using `db’s` configuration. It joins the network `myapp_default` under the name db.

Look like this:

```powershell
➜ docker  docker-compose -f .\09-docker-compose\network\docker-compose.yaml -p myapp up -d
Creating network "myapp_default" with the default driver
Status: Downloaded newer image for postgres:12.6
Creating myapp_webapp_1 ... done
Creating myapp_db_1     ... done

➜ docker  docker-compose -f .\09-docker-compose\network\docker-compose.yaml -p myapp ps
     Name                   Command               State                  Ports
----------------------------------------------------------------------------------------------
myapp_db_1       docker-entrypoint.sh postgres    Up      0.0.0.0:31432->5432/tcp,:::5432->5432/tcp
myapp_webapp_1   /docker-entrypoint.sh ngin ...   Up      0.0.0.0:8080->80/tcp,:::80->80/tcp

➜ docker  docker network ls -f name=myapp_default
NETWORK ID     NAME            DRIVER    SCOPE
1d8ba9a6b979   myapp_default   bridge    local

➜ docker  docker network inspect myapp_default -f '{%raw%}{{json .Containers}}{%endraw%}' | python -m json.tool
{
    "06bc1e24abdb11c0fca7fc9660f17b890f5d67b06b9b3970d71839258873dcb4": {
        "Name": "myapp_webapp_1",
        "EndpointID": "b64417fe1ef6ab57b1ec22b9322fbc097e1b0e4a7a7311a58b46e224a380fecd",
        "MacAddress": "02:42:ac:12:00:02",
        "IPv4Address": "172.18.0.2/16",
        "IPv6Address": ""
    },
    "ae6570375deaf908ff225f2751b9979a1ec3279d9c66680b4715153789805514": {
        "Name": "myapp_db_1",
        "EndpointID": "c9ac8916797a4166522aad097b7807d6825e4e7bc1c03e8992d67bd3c61cbb1a",
        "MacAddress": "02:42:ac:12:00:03",
        "IPv4Address": "172.18.0.3/16",
        "IPv6Address": ""
    }
}
```

Each container can now look up the hostname `webapp` or `db` and get back the appropriate container’s IP address. For example, web’s application code could connect to the URL `postgres://db:5432` and start using the Postgres database. 

It is important to note the distinction between `HOST_PORT` and `CONTAINER_PORT`. In the above example, for `db`, the `HOST_PORT` is `31432` and the container port is `5432` (postgres default). Networked service-to-service communication uses the `CONTAINER_PORT`. When `HOST_PORT` is defined, the service is accessible outside the swarm as well.

Within the web container, your connection string to `db` would look like `postgres://db:5432`, and from the host machine, the connection string would look like `postgres://{DOCKER_IP}:31432`.

If you make a configuration change to a service and run `docker-compose up` to update it, the old container is removed and the new one joins the network under a different IP address but the same name. 