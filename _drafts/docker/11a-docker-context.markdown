---
layout: post
title: "Docker Context"
lang: docker
categories:
- DevOps
- Docker
refs: 
- https://docs.docker.com/engine/context/working-with-contexts/
youtube: 
comments: true
catalog_key: docker-context
image_path: /resources/posts/docker/04g-docker-context
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang akses Docker Daemon dengan menggunakan Docker Context. Pembahasan kali ini meliputi:

1. Introduction
2. The anatomy of a context
3. Create a new context
4. Use a different context
5. Export & Import Docker Context

Ok langsung aja kita ke pembahasan yang pertama

## Introduction of Docker Context

This guide shows how contexts make it easy for a single Docker CLI to manage multiple Swarm clusters, multiple Kubernetes clusters, and multiple individual Docker nodes.

A single Docker CLI can have multiple contexts. Each context contains all of the endpoint and security information required to manage a different cluster or node. The `docker context` command makes it easy to configure these contexts and switch between them.

As an example, a single Docker client on your company laptop might be configured with two contexts; `dev-k8s` and `prod-swarm`. `dev-k8s` contains the endpoint data and security credentials to configure and manage a Kubernetes cluster in a development environment. `prod-swarm` contains everything required to manage a Swarm cluster in a production environment. Once these contexts are configured, you can use the top-level `docker context use <context-name>` to easily switch between them.

To follow the examples in this guide, you’ll need:

1. A Docker client that supports the top-level `context` command

Run `docker context` to verify that your Docker client supports contexts.

You will also need one of the following:

1. Docker Swarm cluster
2. Single-engine Docker node
3. Kubernetes cluster