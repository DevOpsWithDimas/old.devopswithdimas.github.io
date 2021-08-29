---
layout: post
title: "Multiple Compose files to customize for different environments or workflows"
lang: docker
categories:
- DevOps
- Docker
- Compose
- Workflows
refs: 
- https://docs.docker.com/compose/extends/
youtube: 
comments: true
image_path: /resources/posts/docker/09e-multiple-compose-files
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini kita akan membahas lebih detail tentang multiple compose files. Diantaranya

1. Add & Override attribute in compose files
2. Multiple compose file for diffreent environment
3. Administrative tasks

Using multiple Compose files enables you to customize a Compose application for different environments or different workflows. By default, Compose reads two files, a `docker-compose.yml` and an optional `docker-compose.override.yml` file. By convention, the `docker-compose.yml` contains your base configuration. The override file, as its name implies, can contain configuration overrides for existing services or entirely new services.

When you use multiple configuration files, you must make sure all paths in the files are relative to the base Compose file (the first Compose file specified with `-f`). This is required because override files need not be valid Compose files. Override files can contain small fragments of configuration. Tracking which fragment of a service is relative to which path is difficult and confusing, so to keep paths easier to understand, all paths must be defined relative to the base file.