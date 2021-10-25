---
layout: post
title: "Docker Context"
lang: docker
categories:
- DevOps
- Docker
- Context
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

## The anatomy of a context

A context is a combination of several properties. These include:

1. Name
2. Type
2. Endpoint configuration
4. Orchestrator

The easiest way to see what a context looks like is to view the default context.

```powershell
➜ ~  docker context ls
NAME                TYPE  DESCRIPTION                               DOCKER ENDPOINT                             KUBERNETES ENDPOINT   ORCHESTRATOR
default *           moby  Current DOCKER_HOST based configuration   npipe:////./pipe/docker_engine                                    swarm
desktop-linux       moby                                            npipe:////./pipe/dockerDesktopLinuxEngine
```

This shows a single context called `default`. It’s configured to talk to a Swarm cluster through the local `./pipe/docker_engine` Unix socket. It has no Kubernetes endpoint configured. The asterisk in the `NAME` column indicates that this is the active context. This means all docker commands will be executed against the `default` context unless overridden with environment variables such as `DOCKER_HOST` and `DOCKER_CONTEXT`, or on the command-line with the `--context` and `--host` flags.

Dig a bit deeper with `docker context inspect`. In this example, we’re inspecting the context called `default`.


```powershell
➜ ~  docker context inspect default
[
    {
        "Name": "default",
        "Metadata": {
            "StackOrchestrator": "swarm"
        },
        "Endpoints": {
            "docker": {
                "Host": "npipe:////./pipe/docker_engine",
                "SkipTLSVerify": false
            }
        },
        "TLSMaterial": {},
        "Storage": {
            "MetadataPath": "\u003cIN MEMORY\u003e",
            "TLSPath": "\u003cIN MEMORY\u003e"
        }
    }
]
```

##  Create a new context

You can create new contexts with the `docker context create` command.

The following example creates a new context called `docker-remote-linux` and specifies the following:

1. Default `orchestrator = Swarm`
2. Issue commands to the local Unix socket `unix:///var/run/docker.sock`
3. Or you can using ssh to connect remote docker-daemon `ssh://user@remotehost`
4. Or you can using tcp to connect remote docker-daemon `tcp://127.0.0.1:2375`, required config for docker daemon export and expose tcp port `2375`

{% highlight bash %}
## using unix socket (by default enabled when installed docker daemon)
docker context create default \
  --default-stack-orchestrator=swarm \
  --docker host=unix:///var/run/docker.sock

## using ssh
docker context create docker-ssh-test \
  --default-stack-orchestrator=swarm \
  --docker host=ssh://user@192.168.88.199

## using tcp (Not Recommended because not secure)
docker context create docker-tcp-test \
  --default-stack-orchestrator=swarm \
  --docker host=tcp://192.168.88.199:2375
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell

```