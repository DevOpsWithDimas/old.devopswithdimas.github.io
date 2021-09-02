---
layout: post
title: "Use Compose in production"
lang: docker
categories:
- DevOps
- Docker
- Compose
- Workflow
refs: 
- https://docs.docker.com/compose/production/
youtube: 
comments: true
image_path: /resources/posts/docker/09q-best-practice-write-compose
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini kita akan membahas lebih detail tentang docker compose in production used. Diataranya

1. Modify your Compose file for production
2. Deploying changes
3. Running Compose on a single server

When you define your app with Compose in development, you can use this definition to run your application in different environments such as CI, staging, and production. 

## Modify your Compose file for production

The easiest way to deploy an application is to run it on a single server, similar to how you would run your development environment. But you probably need to make changes to your app configuration to make it ready for production. These changes may include:

1. Removing any volume bindings for application code, so that code stays inside the container and can’t be changed from outside
2. Binding to different ports on the host
3. Setting environment variables differently, such as reducing the verbosity of logging, or to specify settings for external services such as an email server
4. Specifying a restart policy like `restart: always` to avoid downtime
5. Adding extra services such as a log aggregator

For this reason, consider defining an additional Compose file, say `production.yml`, which specifies production-appropriate configuration. This configuration file only needs to include the changes you’d like to make from the original Compose file. The additional Compose file can be applied over the original` docker-compose.yml` to create a new configuration.

Once you’ve got a second configuration file, tell Compose to use it with the `-f` option:

{% highlight bash %}
docker-compose -f docker-compose.yml -f production.yml up -d
{% endhighlight %}

## Deploying changes

When you make changes to your app code, remember to rebuild your image and recreate your app’s containers. To redeploy a service called `web`, use:

{% highlight bash %}
docker-compose build web
docker-compose up --no-deps -d web
{% endhighlight %}

This first rebuilds the image for `web` and then stop, destroy, and recreate _just_ the `web` service. The `--no-deps` flag prevents Compose from also recreating any services which `web` depends on.

## Running Compose on a single server

You can use Compose to deploy an app to a remote Docker host by setting the `DOCKER_HOST`, `DOCKER_TLS_VERIFY`, and `DOCKER_CERT_PATH` environment variables appropriately.

Once you’ve set up your environment variables, all the normal `docker-compose` commands work with no further configuration.