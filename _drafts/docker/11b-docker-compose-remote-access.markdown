---
layout: post
title: "Remote deployment using docker-compose"
lang: docker
categories:
- DevOps
- Docker
- Context
refs: 
- https://www.docker.com/blog/how-to-deploy-on-remote-docker-hosts-with-docker-compose/
youtube: 
comments: true
catalog_key: docker-context
image_path: /resources/posts/docker/11b-docker-compose-remote-access
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang How to deploy on remote docker using docker-compose. Diantaranya

1. Introduction
2. Remote Using `DOCKER_HOST` Environtment Variable
3. Remote Using `-H` command line option from docker compose
4. Remote Using docker context

Ok langsung aja kita ke pembahasan yang pertama yaitu

## Introduction

The docker-compose tool is pretty popular for running dockerized applications in a local development environment. All we need to do is write a Compose file containing the configuration for the application’s services and have a running Docker engine for deployment. From here, we can get the application running locally in a few seconds with a single  `docker-compose up` command.

A common usage of Compose is to copy the project source with the `docker-compose.yml`, install `docker-compose` on the target machine where we want to deploy the compose app and finally run it. 

Tapi problem datang ketika kita punya banyak server, 1 sampai 3 server it's ok untuk melakukan copy semua source-code ke target dan run manualy setiap servernya, tpi klo ada 10 atau 100 bahkan 1000 server kita jalankan manual?

Ok jadi kita langung ja bahas permasalahan tersebut dengan beberapa solusi berikut:

## Remote using `DOCKER_HOST` env variable