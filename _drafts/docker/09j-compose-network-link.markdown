---
layout: post
title: "Network links in Compose file"
lang: docker
categories:
- DevOps
- Docker
- Compose
- Network
refs: 
- https://docs.docker.com/compose/networking/
- https://docs.docker.com/compose/compose-file/compose-file-v3/#links
youtube: 
comments: true
image_path: /resources/posts/docker/09j-compose-network-link
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas legacy network di docker yaitu menggunakan links pada docker compose.

Links allow you to define extra aliases by which a service is reachable from another service. They are not required to enable services to communicate - by default, any service can reach any other service at that service’s name. In the following example, `db` is reachable from `web` at the hostnames `db` and `database`:

{% gist page.gist "09j-link.docker-compose.yaml" %}

Sekarang kita coba jalankan maka hasilnya seperti berikut:

```powershell

```