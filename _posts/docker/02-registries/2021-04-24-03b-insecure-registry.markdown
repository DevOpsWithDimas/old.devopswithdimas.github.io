---
layout: post
title: "Insecure Registry"
date: 2021-04-24T16:44:03+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Registry
refs: 
- https://jfrog.com/container-registry/
- https://cloud.google.com/container-registry
- https://www.sonatype.com/products/repository-oss
- https://docs.gitlab.com/ce/user/packages/container_registry/
- https://docs.github.com/en/packages/guides/about-github-container-registry
- https://www.redhat.com/en/technologies/cloud-computing/openshift-data-foundation
youtube: -FSutpLEEWc
comments: true
catalog_key: docker-registry
image_path: /resources/posts/docker/03b-private-registry
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, sebelumnya kita sudah memahami apa itu Docker Registry, sekarang kita akan membahas tentang Insecure Registry. 
Nah yang jadi pertanyaaan **apa itu Insecure Registry?**. Insecure Registry sama halnya dengan [Docker Hub](https://hub.docker.com/) yaitu bertujuan menyimpan docker images tetapi disini insecure registry lebih flexible artinya kita bisa tentukan mulai dari lokasi registry (on-premise, cloud), private atau public docker repository dan lain-lain. Adapun materi yang akan kita bahas kali ini yaitu

1. Macam-Macam Provider Insecure Registry
2. Manfaat menggunakan Insecure Registry
    1. Proxy Repository for saving bandwidth
    2. Unlimited private repository
    3. Push & Pull Docker Images more faster than Docker Hub

## Macam Macam Private Registry

Private Registry untuk docker ada banyak diantaranya:

1. [JFrog](https://jfrog.com/container-registry/)
2. [Google Cloud Registry](https://cloud.google.com/container-registry)
3. [Sonatype Nexus OSS](https://www.sonatype.com/products/repository-oss)
4. [Gitlab Registry](https://docs.gitlab.com/ce/user/packages/container_registry/)
5. [Github Registry](https://docs.github.com/en/packages/guides/about-github-container-registry)
6. [Redhat Registry](https://www.redhat.com/en/technologies/cloud-computing/openshift-data-foundation)
7. Dan masih banyak lagi registry-registry lainnya...

Jadi Kali ini kita akan membahas menggunakan **Nexus OSS**.

![proxy](https://www.sonatype.com/hs-fs/hubfs/Nexus_Repo_SDLC@2x.png?width=956&name=Nexus_Repo_SDLC@2x.png)

Nexus Repository Manager OSS support Docker registries as the Docker repository format for hosted and proxy repositories. You can expose these repositories to the client-side tools directly or as a repository group, which is a repository that merges and exposes the contents of multiple repositories in one convenient URL. This allows you to reduce time and bandwidth usage for accessing Docker images in a registry as well as share your images within your organization in a hosted repository.

## Manfaat menggunakan Insecure Registry

Ada beberapa manfaat jika kita menggunakan Insecure Registry, khususnya menggunakan Nexus OSS yaitu dianataranya:

1. Store and distribute Maven/Java, npm, NuGet, RubyGems, Docker, P2, OBR, APT and YUM and more.
2. Manage components from dev through delivery: binaries, containers, assemblies, and finished goods.
3. Mengurangi brantwith.
4. Mempercepat pull & push component