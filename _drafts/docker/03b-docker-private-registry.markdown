---
layout: post
title: "Private Docker Registry"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://jfrog.com/container-registry/
- https://cloud.google.com/container-registry
- https://www.sonatype.com/products/repository-oss
- https://docs.gitlab.com/ce/user/packages/container_registry/
- https://docs.github.com/en/packages/guides/about-github-container-registry
- https://www.redhat.com/en/technologies/cloud-computing/openshift-data-foundation
youtube: 
comments: true
image_path: /resources/posts/docker/01f-docker-private-registry
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini kita akan membahas tentang private registry, diantaranya:

1. Macam-Macam private registry
2. Proxy for saving bandwidth
3. Setup private registry
4. Authenticate to private registry
5. Pulling image from proxy repository
6. Push to Hosted Repository

## Macam Macam Private Registry

Private Registry untuk docker ada banyak diantaranya:

1. [JFrog](https://jfrog.com/container-registry/)
2. [Google Cloud Registry](https://cloud.google.com/container-registry)
3. [Sonatype Nexus OSS](https://www.sonatype.com/products/repository-oss)
4. [Gitlab Registry](https://docs.gitlab.com/ce/user/packages/container_registry/)
5. [Github Registry](https://docs.github.com/en/packages/guides/about-github-container-registry)
6. [Redhat Registry](https://www.redhat.com/en/technologies/cloud-computing/openshift-data-foundation)
7. Dan masih banyak lagi registry-registry lainnya...

Kali ini kita akan membahas menggunakan **Nexus OSS**, Dengan nexus kita bisa membuat proxy, store registry dan lain-lain di on-premise. 

![proxy](https://www.sonatype.com/hs-fs/hubfs/Nexus_Repo_SDLC@2x.png?width=956&name=Nexus_Repo_SDLC@2x.png)

Nexus Repository Manager OSS support Docker registries as the Docker repository format for hosted and proxy repositories. You can expose these repositories to the client-side tools directly or as a repository group, which is a repository that merges and exposes the contents of multiple repositories in one convenient URL. This allows you to reduce time and bandwidth usage for accessing Docker images in a registry as well as share your images within your organization in a hosted repository.

So jadi kita install dlu di local network kita. 

1. Cara Install Nexus OSS, [disini articlenya](https://www.dimas-maryanto.com/notes/repository/nexus-repository)
2. Cara Setup private registry docker, [disini articlenya](https://www.dimas-maryanto.com/notes/docker/nexus-docker-private-registry)