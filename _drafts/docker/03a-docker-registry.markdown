---
layout: post
title: "Docker Default Registry (hub.docker.com)"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/docker-hub/official_images/
youtube: 
comments: true
image_path: /resources/posts/docker/01e-docker-registry
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


halo semuanya, dimateri kali ini kita akan membahas tentang [default registry](hub.docker.com) yaitu

1. Official docker images
2. Public docker images
3. Signup to [hub.docker.com](https://hub.docker.com)
4. Store your own images

<!--more-->

## Official Image

The Docker Official Images are a curated set of Docker repositories hosted on Docker Hub. They are designed to:

1. Provide essential base OS repositories (for example, ubuntu, centos) that serve as the starting point for the majority of users.
2. Provide drop-in solutions for popular programming language runtimes, data stores, and other services, similar to what a Platform as a Service (PAAS) would offer.
3. Exemplify Dockerfile best practices and provide clear documentation to serve as a reference for other Dockerfile authors.
4. Ensure that security updates are applied in a timely manner. This is particularly important as Official Images are some of the most popular on Docker Hub.

Docker, Inc. sponsors a dedicated team that is responsible for reviewing and publishing all content in the Official Images. This team works in collaboration with upstream software maintainers, security experts, and the broader Docker community. If you are new to Docker, we recommend that you use the Official Images in your projects. These images have clear documentation, promote best practices, and are designed for the most common use cases. Advanced users can review the Official Images as part of your Dockerfile learning process.

A common rationale for diverging from Official Images is to optimize for image size. For instance, many of the programming language stack images contain a complete build toolchain to support installation of modules that depend on optimized code. An advanced user could build a custom image with just the necessary pre-compiled libraries to save space.