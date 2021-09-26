---
layout: post
title: "Overview of Docker Compose"
date: 2021-08-10T18:55:52+07:00
lang: docker
categories:
- DevOps
- Docker
- Compose
refs: 
- https://docs.docker.com/compose/
youtube: q96KQweHPpU
comments: true
catalog_key: docker-compose
image_path: /resources/posts/docker/09-docker-compose
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini kita akan membahas tentang Docker Compose, diantaranya:

1. Overview
2. Features
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

The features of Compose that make it effective are:

1. **Multiple isolated environments on a single host**, Compose uses a project name to isolate environments from each other. The default project name is the basename of the project directory. You can set a custom project name by using the `-p` command line option.
2. **Preserve volume data when containers are created**, Compose preserves all volumes used by your services. When `docker-compose up` runs, if it finds any containers from previous runs, it copies the volumes from the old container to the new container. This process ensures that any data you’ve created in volumes isn’t lost.
3. **Only recreate containers that have changed**, Compose caches the configuration used to create a container. When you restart a service that has not changed, Compose re-uses the existing containers. Re-using containers means that you can make changes to your environment very quickly.
4. **Variables and moving a composition between environments**, Compose supports variables in the Compose file. You can use these variables to customize your composition for different environments, or different users.

## Common use cases

Compose can be used in many different ways.

1. **Development environments**, When you’re developing software, the ability to run an application in an isolated environment and interact with it is crucial. The Compose command line tool can be used to create the environment and interact with it.
2. **Automated testing environments**, An important part of any Continuous Deployment or Continuous Integration process is the automated test suite. Automated end-to-end testing requires an environment in which to run tests. Compose provides a convenient way to create and destroy isolated testing environments for your test suite.
3. **Single host deployments**, Compose has traditionally been focused on development and testing workflows, but with each release we’re making progress on more production-oriented features.