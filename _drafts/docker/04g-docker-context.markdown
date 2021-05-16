---
layout: post
title: "Context Management"
lang: docker
date: 2021-05-14T12:00:04+07:00
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/engine/context/working-with-contexts/
youtube: 
comments: true
image_path: /resources/posts/docker/04g-docker-context
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

A single Docker CLI can have multiple contexts. Each context contains all of the endpoint and security information required to manage a different cluster or node. The `docker context` command makes it easy to configure these contexts and switch between them.