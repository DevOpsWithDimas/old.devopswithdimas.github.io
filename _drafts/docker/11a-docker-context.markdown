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
  --default-stack-orchestrator swarm \
  --docker host=ssh://user@192.168.88.199

## using tcp (Not Recommended because not secure)
docker context create docker-tcp-test \
  --default-stack-orchestrator=swarm \
  --docker host=tcp://192.168.88.199:2375
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ ~ ✗  docker context ls
NAME                TYPE                DESCRIPTION                               DOCKER ENDPOINT                             KUBERNETES ENDPOINT   ORCHESTRATOR
default *           moby                Current DOCKER_HOST based configuration   npipe:////./pipe/docker_engine                                    swarm
desktop-linux       moby                                                          npipe:////./pipe/dockerDesktopLinuxEngine

➜ ~  docker info
Server:
 Kernel Version: 4.19.128-microsoft-standard
 Operating System: Docker Desktop
 OSType: linux
 Architecture: x86_64
 CPUs: 2
 Total Memory: 3.842GiB
 Name: docker-desktop
 ID: AOXY:2GUY:EZ3L:6RFF:G7XZ:SDFL:6U6X:XEK4:3N5Q:GVZZ:6ROI:6WYI
 Docker Root Dir: /var/lib/docker

## Generate ssh-key https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

➜ ~ ssh-copy-id dimasm93@192.168.88.11
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/c/Users/dimasm93/.ssh/id_rsa.pub"
The authenticity of host '192.168.88.11 (192.168.88.11)' can''t be established.
ED25519 key fingerprint is SHA256:evGwEQ5wsOsSkCle6t9+aJ++2Z1V1D7u/AMGHfClQ7Q.

Now try logging into the machine, with:   "ssh 'dimasm93@192.168.88.11'" and check to make sure that only the key(s) you wanted were added.

➜ ~ docker context create docker-ssh-test `
>> --default-stack-orchestrator swarm `
>> --docker host=ssh://dimasm93@192.168.88.11
docker-ssh-test
Successfully created context "docker-ssh-test"

➜ ~  docker context use docker-ssh-test
docker-ssh-test

➜ ~  docker context ls
NAME                TYPE                DESCRIPTION                               DOCKER ENDPOINT                             KUBERNETES ENDPOINT   ORCHESTRATOR
default             moby                Current DOCKER_HOST based configuration   npipe:////./pipe/docker_engine                                    swarm
desktop-linux       moby                                                          npipe:////./pipe/dockerDesktopLinuxEngine
docker-ssh-test *   moby                                                          ssh://dimasm93@192.168.88.11                                      swarm

➜ ~  docker info
Server:
 Kernel Version: 4.18.0-305.19.1.el8_4.x86_64
 Operating System: CentOS Linux 8
 OSType: linux
 Architecture: x86_64
 CPUs: 2
 Total Memory: 1.748GiB
 Name: docker.dimas-maryanto.com
 ID: 52LG:X5YZ:6KR2:6VK5:EKVJ:3XZ5:Q2TX:PF36:6ING:UN2J:GA5F:LCPB
 Docker Root Dir: /var/lib/docker
```

## Export & Import Docker Context

The `docker context` command makes it easy to export and import contexts on different machines with the Docker client installed.

You can use the `docker context export` command to export an existing context to a file. This file can later be imported on another machine that has the `docker` client installed. By default, contexts will be exported as a _native Docker contexts_. **You can export and import** these using the `docker context` command. If the context you are exporting includes a Kubernetes endpoint, the Kubernetes part of the context will be included in the `export` and `import` operations.

Exporting and importing a native Docker context

The following example exports an existing context called `docker-ssh-test`. It will be written to a file called

{% highlight bash %}
docker context export docker-ssh-test
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker context export docker-ssh-test
Written file "docker-ssh-test.dockercontext"

➜ ~  cat .\docker-ssh-test.dockercontext
meta.json0000644000000000000000000000023000000000000011021 0ustar0000000000000000{"Name":"docker-ssh-test","Metadata":{"StackOrchestrator":"swarm"},"Endpoints":{"docker":{"Host":"ssh://dimasm93@192.168.88.11","SkipTLSVerify":false}}}tls0000700000000000000000000000000000000000000007716 5ustar0000000000000000

➜ ~  docker context rm docker-ssh-test
docker-ssh-test

➜ ~  docker context ls
NAME                TYPE                DESCRIPTION                               DOCKER ENDPOINT                             KUBERNETES ENDPOINT   ORCHESTRATOR
default *           moby                Current DOCKER_HOST based configuration   npipe:////./pipe/docker_engine                                    swarm
desktop-linux       moby                                                          npipe:////./pipe/dockerDesktopLinuxEngine

➜ ~  docker context import docker-ssh-server-test .\docker-ssh-test.dockercontext
docker-ssh-server-test
Successfully imported context "docker-ssh-server-test"

➜ ~  docker context ls
NAME                     TYPE                DESCRIPTION                               DOCKER ENDPOINT                             KUBERNETES ENDPOINT   ORCHESTRATOR
default *                moby                Current DOCKER_HOST based configuration   npipe:////./pipe/docker_engine                                    swarm
desktop-linux            moby                                                          npipe:////./pipe/dockerDesktopLinuxEngine
docker-ssh-server-test   moby                                                          ssh://dimasm93@192.168.88.11                                      swarm
```