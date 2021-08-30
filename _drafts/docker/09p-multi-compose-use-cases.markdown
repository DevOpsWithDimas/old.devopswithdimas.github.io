---
layout: post
title: "Example use case of multiple compose files"
lang: docker
categories:
- Containerization
- DevOps
- Docker
- Workflows
refs: 
- https://docs.docker.com/compose/extends/
youtube: 
comments: true
image_path: /resources/posts/docker/09p-multi-compose-example
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang contoh kasusnya dalam penggunaan multiple compose file. Diantaranya:

1. Changing a Compose app for different environments 
2. Running administrative tasks against a Compose app

Ok langsung aja kita ke pembahasan yang pertama

## Different environments

A common use case for multiple files is changing a development Compose app for a production-like environment (which may be production, staging or CI). To support these differences, you can split your Compose configuration into a few different files:

Start with a base file that defines the canonical configuration for the services.

