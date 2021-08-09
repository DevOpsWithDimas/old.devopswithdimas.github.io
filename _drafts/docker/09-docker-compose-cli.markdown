---
layout: post
title: "Overview of Docker Compose"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/compose/
youtube: 
comments: true
image_path: /resources/posts/docker/09-docker-compose
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini kita akan membahas tentang Docker Compose, diantaranya:

1. Overview
2. Features
    1. Multiple isolated environment on single host
    2. Preserve volume data when containers are created
    3. only recreate containers tha have changed
    4. Variables and moving a composition between environments
3. Common use cases

## Overview

Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a YAML file to configure your application’s services. Then, with a single command, you create and start all the services from your configuration. Compose works in all environments: production, staging, development, testing, as well as CI workflows.

Using Compose is basically a three-step process:

1. Define your app’s environment with a `Dockerfile` so it can be reproduced anywhere.
2. Define the services that make up your app in `docker-compose.yml` so they can be run together in an isolated environment.
3. Run `docker compose up` and the [Docker compose command](https://docs.docker.com/compose/cli-command/) starts and runs your entire app.

A `docker-compose.yml` looks like this:

{% highlight yaml %}
version: "3.9"  # optional since v1.27.0
services:
  web:
    build: .
    ports:
      - "5000:5000"
    volumes:
      - .:/code
      - logvolume01:/var/log
    links:
      - redis
  redis:
    image: redis
volumes:
  logvolume01: {}
{% endhighlight %}

## Features of Docker compose

