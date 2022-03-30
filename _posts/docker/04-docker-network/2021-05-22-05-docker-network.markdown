---
layout: post
title: "Networking overview"
date: 2021-05-22T12:12:35+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Network
refs: 
- https://docs.docker.com/network/
- https://docs.docker.com/network/bridge/
youtube: m-yLbKH28NM
comments: true
catalog_key: docker-network
image_path: /resources/posts/docker/06g-docker-network
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


Hai semuanya, setelah kita membahas tentang Containers. Sekarang kita akan membahas tentang Docker Networking.

<!--more-->

One of the reasons Docker containers and services are so powerful is that you can connect them together, or connect them to non-Docker workloads. Docker containers and services do not even need to be aware that they are deployed on Docker, or whether their peers are also Docker workloads or not. Whether your Docker hosts run Linux, Windows, or a mix of the two, you can use Docker to manage them in a platform-agnostic way.

This topic defines some basic Docker networking concepts and prepares you to design and deploy your applications to take full advantage of these capabilities.

## Scope of this topic

This topic does not go into OS-specific details about how Docker networks work, so you will not find information about how Docker manipulates iptables rules on Linux or how it manipulates routing rules on Windows servers, and you will not find detailed information about how Docker forms and encapsulates packets or handles encryption. See Docker and iptables.

## Network drivers

Docker’s networking subsystem is pluggable, using drivers. Several drivers exist by default, and provide core networking functionality:

1. `bridge`: The default network driver. If you don’t specify a driver, this is the type of network you are creating. Bridge networks are usually used when your applications run in standalone containers that need to communicate. See [bridge networks](https://docs.docker.com/network/bridge/).

2. `host`: For standalone containers, remove network isolation between the container and the Docker host, and use the host’s networking directly. See use the [host network](https://docs.docker.com/network/host/).

3. `overlay`: Overlay networks connect multiple Docker daemons together and enable swarm services to communicate with each other. You can also use overlay networks to facilitate communication between a swarm service and a standalone container, or between two standalone containers on different Docker daemons. This strategy removes the need to do OS-level routing between these containers. See [overlay networks](https://docs.docker.com/network/overlay/).

4. `macvlan`: Macvlan networks allow you to assign a MAC address to a container, making it appear as a physical device on your network. The Docker daemon routes traffic to containers by their MAC addresses. Using the macvlan driver is sometimes the best choice when dealing with legacy applications that expect to be directly connected to the physical network, rather than routed through the Docker host’s network stack. See [Macvlan networks](https://docs.docker.com/network/macvlan/).

5. `none`: For this container, disable all networking. Usually used in conjunction with a custom network driver. none is not available for swarm services. See [disable container networking](https://docs.docker.com/network/none/).

6. [Network plugins](https://docs.docker.com/engine/extend/plugins_services/): You can install and use third-party network plugins with Docker. These plugins are available from Docker Hub or from third-party vendors. See the vendor’s documentation for installing and using a given network plugin.