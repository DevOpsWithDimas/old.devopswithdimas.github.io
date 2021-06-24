---
layout: post
title: "Best practices for writing Dockerfiles"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
youtube: 
comments: true
image_path: /resources/posts/docker/07m-best-practice-dockerfile
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


This document covers recommended best practices and methods for building efficient images. A Docker image consists of read-only layers each of which represents a Dockerfile instruction. The layers are stacked and each one is a delta of the changes from the previous layer. Consider this `Dockerfile`:

{% highlight docker %}
FROM ubuntu:18.04
COPY . /app
RUN make /app
CMD python /app/app.py
{% endhighlight %}

Each instruction creates one layer:

1. `FROM` creates a layer from the `ubuntu:18.04` Docker image.
2. `COPY` adds files from your Docker client’s current directory.
3. `RUN` builds your application with `make`.
4. `CMD` specifies what command to run within the container.

## Exclude with .dockerignore

To exclude files not relevant to the build (without restructuring your source repository) use a `.dockerignore` file. This file supports exclusion patterns similar to `.gitignore` files.

## Use multi-stage builds

Multi-stage builds allow you to drastically reduce the size of your final image, without struggling to reduce the number of intermediate layers and files.

Because an image is built during the final stage of the build process, you can minimize image layers by leveraging build cache.

For example, if your build contains several layers, you can order them from the less frequently changed (to ensure the build cache is reusable) to the more frequently changed:

1. Install tools you need to build your application
2. Install or update library dependencies
3. Generate your application

## Decouple applications

Each container should have only one concern. Decoupling applications into multiple containers makes it easier to scale horizontally and reuse containers. For instance, a web application stack might consist of three separate containers, each with its own unique image, to manage the web application, database, and an in-memory cache in a decoupled manner.

## Installing packages into image

Probably the most common use-case for `RUN` is an application of `apt-get`. Because it installs packages, the `RUN apt-get` command has several gotchas to look out for. Always combine `RUN apt-get update` with `apt-get install` in the same RUN statement. For example:

{% highlight docker %}
RUN apt-get update && apt-get install -y package-bar package-baz 
RUN rm -rf /var/lib/apt/lists/*
{% endhighlight %}

## Sort multi-line arguments

Whenever possible, ease later changes by sorting multi-line arguments alphanumerically. This helps to avoid duplication of packages and make the list much easier to update. This also makes PRs (Pull Requests) a lot easier to read and review. Adding a space before a backslash (`\`) helps as well. Here’s an example from the `buildpack-deps` image:

{% highlight docker %}
RUN apt-get update && apt-get install -y \
  bzr \
  cvs \
  git \
  mercurial \
  subversion \
  && rm -rf /var/lib/apt/lists/*
{% endhighlight %}

## Don’t install unnecessary packages

To reduce complexity, dependencies, file sizes, and build times, avoid installing extra or unnecessary packages just because they might be “nice to have.” For example, you don’t need to include a text editor in a database image.

## ADD or COPY Instruction

Although `ADD` and `COPY` are functionally similar, generally speaking, `COPY` is preferred. That’s because it’s more transparent than `ADD`. `COPY` only supports the basic copying of local files into the container, while `ADD` has some features (like local-only tar extraction and remote URL support) that are not immediately obvious. Consequently, the best use for `ADD` is local tar file auto-extraction into the image, as in `ADD rootfs.tar.xz /`.
