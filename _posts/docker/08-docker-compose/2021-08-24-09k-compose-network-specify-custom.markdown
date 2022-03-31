---
layout: post
title: "Specify custom networks in Compose file"
date: 2021-08-24T05:57:55+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Compose
- Network
refs: 
- https://docs.docker.com/compose/networking/#specify-custom-networks
youtube: MTK9fRuKVFY
comments: true
catalog_key: docker-compose
image_path: /resources/posts/docker/09k-compose-network-specify-custom
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


Hai semuanya di materi kali ini kita akan membahas lebih detail tentang specify custom network di compose file.

<!--more-->

Instead of just using the default app network, you can specify your own networks with the top-level `networks` key. This lets you create more complex topologies and specify custom network drivers and options. You can also use it to connect services to externally-created networks which aren’t managed by Compose.

Each service can specify what networks to connect to with the service-level `networks` key, which is a list of names referencing entries under the top-level `networks` key.

Here’s an example Compose file defining two custom networks. The `proxy` service is isolated from the `mysql` service, because they do not share a network in common - only `workpress` can talk to both.

{% gist page.gist "09k-custom-specify-net.docker-compose.yaml" %}

Dan berikut adalah file `wordpress-proxy.nginx.template.conf` yang di simpan dalam folder `nginx` seperti berikut:

{% gist page.gist "09k-wordpress-proxy.nginx.template.conf" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ docker  docker-compose -f .\09-docker-compose\network\specify\docker-compose.yaml -p specify-net up -d
Creating volume "specify-net_mysql_data" with default driver
Creating specify-net_mysql_1     ... done
Creating specify-net_wordpress_1 ... done
Creating specify-net_proxy_1     ... done

➜ docker  docker-compose -f .\09-docker-compose\network\specify\docker-compose.yaml -p specify-net ps
         Name                        Command               State                Ports
---------------------------------------------------------------------------------------------------
specify-net_mysql_1       docker-entrypoint.sh mysqld      Up      3306/tcp, 33060/tcp
specify-net_proxy_1       /docker-entrypoint.sh ngin ...   Up      0.0.0.0:80->80/tcp,:::80->80/tcp
specify-net_wordpress_1   docker-entrypoint.sh apach ...   Up      80/tcp

docker container inspect $(docker-compose -f .\09-docker-compose\network\specify\docker-compose.yaml -p specify-net ps -q) -f '{%raw%}{{.Name}} => {{json .NetworkSettings.Networks}}{%endraw%}'
/specify-net_mysql_1 => {
   "specify-net_backend":{
      "Aliases":[
         "34e0a0d75272",
         "mysql"
      ],
      "NetworkID":"f4c208b1cb2203c39a83d5b50fb295ed991ed5d5f7069bd87a383bd2525e30da",
      "EndpointID":"ec3ad3aabe51d5b60728bc86fae9b415383eed9295724244305b71bc68aec4bb",
      "Gateway":"172.23.0.1",
      "IPAddress":"172.23.0.2",
      "IPPrefixLen":16,
      "MacAddress":"02:42:ac:17:00:02"
   }
}
/specify-net_proxy_1 => {
   "specify-net_frontend":{
      "Aliases":[
         "proxy",
         "5298737da335"
      ],
      "Gateway":"172.24.0.1",
      "IPAddress":"172.24.0.3",
      "IPPrefixLen":16,
      "MacAddress":"02:42:ac:18:00:03"
   }
}
/specify-net_wordpress_1 => {
   "specify-net_backend":{
      "Aliases":[
         "wordpress",
         "f73d5704d113"
      ],
      "Gateway":"172.23.0.1",
      "IPAddress":"172.23.0.3",
      "IPPrefixLen":16,
      "MacAddress":"02:42:ac:17:00:03"
   },
   "specify-net_frontend":{
     "Aliases":[
         "wordpress",
         "f73d5704d113"
      ],
      "Gateway":"172.24.0.1",
      "IPAddress":"172.24.0.2",
      "IPPrefixLen":16,
      "MacAddress":"02:42:ac:18:00:02"
   }
}

➜ docker  docker network inspect $(docker network ls -f label=com.docker.compose.project=specify-net -q) -f '{%raw%}{{.Name}} => {{json .Containers}}{%endraw%}'
specify-net_backend => {
   "34e0a0d7527219b679a861818b3e8805990046a098dbff31201fb328b048fe8d":{
      "Name":"specify-net_mysql_1",
      "EndpointID":"ec3ad3aabe51d5b60728bc86fae9b415383eed9295724244305b71bc68aec4bb",
      "MacAddress":"02:42:ac:17:00:02",
      "IPv4Address":"172.23.0.2/16",
      "IPv6Address":""
   },
   "f73d5704d11395e4520d08e59a2b3b24008b2a821daf6cf7f1c2275ea8095e39":{
      "Name":"specify-net_wordpress_1",
      "EndpointID":"a3bde3db75fa2c1e4bd8aac6b9f115287fd1fcf9d0351a97d954220152f9c206",
      "MacAddress":"02:42:ac:17:00:03",
      "IPv4Address":"172.23.0.3/16",
      "IPv6Address":""
   }
}
specify-net_frontend => {
   "5298737da335d3365410d920d3f1472b18f88b7abebec2c24b717335a8dd26c2":{
      "Name":"specify-net_proxy_1",
      "EndpointID":"b33b9a75483defd04d5c636ba2d25850cbf0740b813838674dc66e58532376a3",
      "MacAddress":"02:42:ac:18:00:03",
      "IPv4Address":"172.24.0.3/16",
      "IPv6Address":""
   },
   "f73d5704d11395e4520d08e59a2b3b24008b2a821daf6cf7f1c2275ea8095e39":{
      "Name":"specify-net_wordpress_1",
      "EndpointID":"4f8507ad779853851422bc6bf0d36ccff539b8a089e12d2857ba76824342f98f",
      "MacAddress":"02:42:ac:18:00:02",
      "IPv4Address":"172.24.0.2/16",
      "IPv6Address":""
   }
}
```