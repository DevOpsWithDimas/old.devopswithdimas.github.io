---
layout: post
title: "Volume in Compose"
date: 2021-08-13T20:53:47+07:00
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/compose/compose-file/compose-file-v3/#volumes
youtube: 
comments: true
image_path: /resources/posts/docker/09h-compose-volume
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini kita akan membahas tentang Docker Volume menggunakan Compose file, Diantaranya yang akan kita bahas yaitu

1. Store data in volume
2. Mount-Bind 

Ok langsung aja kita ke pembahasan yang pertama yaitu

## Store data in volume

Mount host paths or named volumes, specified as sub-options to a service. 

But, if you want to reuse a volume across multiple services, then define a named volume in the top-level `volumes` key. Use named volumes with services, swarms, and stack files.

{% gist page.gist "09e-default-volumes.docker-compose.yaml" %}

This example shows a named volume (`pg_data`) being used by the db service, or you can use long format compose like this

{% gist page.gist "09e-long-volumes.docker-compose.yaml" %}

## Mount-Bind 

You can mount a host path as part of a definition for a single service, and there is no need to define it in the top level `volumes` key.

{% gist page.gist "09e-default-bind.docker-compose.yaml" %}

or you can use long format compose like this

{% gist page.gist "09e-long-bind.docker-compose.yaml" %}
