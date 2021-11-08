---
layout: post
title: "Using docker on portainer.io"
lang: docker
categories:
- DevOps
- Docker
- Context
- Dashboard
refs: 
- https://www.portainer.io/
- https://docs.portainer.io/v/ce-2.9/
youtube: 
comments: true
catalog_key: docker-context
image_path: /resources/posts/docker/11f-docker-portainer
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


Hai semuanya, di materi kali ini kita akan membahas tentang dashboard di lingkungan server yang paling sering digunakan adalah linux dan paling juga sifatnya web based. Ada banyak sekali dashboard untuk docker yaitu

1. [DataDog](https://www.datadoghq.com/dashboards/docker-dashboard/)
2. [portainer.io](https://www.portainer.io/)
3. [Big Boat (deprecated)](https://github.com/ICTU/docker-dashboard#big-boat)
4. dan masih banyak lagi. 

Nah sekarang kita bahas menggunakan yang paling populer ya yaitu [portainer.io](https://www.portainer.io/). Diantaranya yang akan kita bahas:

1. Introduction
2. Install Portainer with Docker on Linux
3. Deploy a container
4. Container interaction
5. Deploy a stack
6. Managing docker image
7. Managing docker network
8. Managing docker volumes
9. Dashboard

Ok langsung aja kita ke pembahas yang pertama

## Introduction

Portainer Community Edition (CE) is our foundation. With over half a million regular users, CE is a powerful, open source toolset that allows you to easily build and manage containers in Docker, Docker Swarm, Kubernetes and Azure ACI.

Portainer hides the complexity of managing containers behind an easy-to-use UI. By removing the need to use the CLI, write YAML or understand manifests, Portainer makes deploying apps and troubleshooting problems so easy that anyone can do it.

**Portainer architecture**

Portainer consists of two elements: the Portainer Server and the Portainer Agent. Both run as lightweight containers on your existing containerized infrastructure. The Portainer Agent should be deployed to each node in your cluster and configured to report back to the Portainer Server container.

## How to install Portainer on Linux with Docker

Untuk meng-install Portainer ada beberapa Requirement & Prerequistes yaitu:

1. **Persistent storage**, The Portainer Server requires persistent storage in order to maintain the database and configuration information it needs to function.
2. **Ports**, In order to access the UI and API, and for the Portainer Server instance and the Portainer Agents to communicate, certain ports need to be accessible.
3. The latest version of Docker installed and working
4. sudo access on the machine that will host your Portainer Server instance
5. By default, Portainer Server will expose the UI over port `9443` and expose a TCP tunnel server over port `8000`.
6. SELinux is disabled on the machine running Docker. If you require SELinux, you will need to pass the `--privileged` flag to Docker when deploying Portainer.

Ok sekarang kita bisa langsung install, untuk memudahkan kita bisa menggunakan `docker-compose.yaml` seperti berikut:

{% gist page.gist "11f-install.docker-compose.yaml" %}

Jika di jalankan seperti berikut:

```powershell
➜ docker git:(master) docker-compose --project-directory 09-docker-context/portainer up -d portainerd
Creating network "portainer_default" with the default driver
Creating volume "portainer_portainer_data" with default driver
Pulling portainerd (portainer/portainer-ce:latest)...
latest: Pulling from portainer/portainer-ce
7721cab3d696: Pull complete
0645e7e2a110: Pull complete
8f36f6c7596b: Pull complete
Digest: sha256:af387baba14e0342e40d274c0c894fd333d3cca0d6737a8e1e0d6d9523c87a8a
Status: Downloaded newer image for portainer/portainer-ce:latest
Creating portainer_portainerd_1 ... done

➜ docker git:(master) docker-compose --project-directory 09-docker-context/portainer ps
         Name             Command     State                     Ports
----------------------------------------------------------------------------------------
portainer_portainerd_1   /portainer   Up      8000/tcp, 9000/tcp, 0.0.0.0:9443->9443/tcp
```

Sekarang kita buka menggunakan browser untuk inital setup dengan meng-akses halaman [https://ip-server:9443](https://localhost:9443) Seperti berikut:

![initial setup]({{ page.image_path | prepend: site.baseurl }}/01-initial-setup.png)

Setelah itu kita bisa klik button `create`, untuk membuat user dan masuk ke halaman home seperti berikut:

![home]({{ page.image_path | prepend: site.baseurl }}/01a-home.png)

The Home page is the first page you will see after logging into Portainer. This page provides an overview of your environments along with vital statistics about each. To manage an environment, click to select it

## Deploy a container

Put simply, a container is a runnable instance of an image. Containers do not hold any persistent data and therefore can be destroyed and recreated as needed.

To deploy new container, Select Containers from the menu then click Add container.

Sebagai contoh disini kita akan jalankan image `nginx:mainline` dan portbinding random, jadi configurasinya seperti berikut:

![deploy-new-container]({{ page.image_path | prepend: site.baseurl }}/02-deploy-simple-container.png)

Kemudian klik `Deploy the container`, jika sudah maka hasilnya seperti berikut:

![deploy-new-container]({{ page.image_path | prepend: site.baseurl }}/02a-list-containers.png)

Sekarang kita bisa check hasilnya dengan klik `Published ports` seperti berikut hasilnya:

![deploy-new-container]({{ page.image_path | prepend: site.baseurl }}/02b-simple-container-app.png)

Dari menu tersebut juga kita bisa melakukan management terhadap containernya seperti

1. View logs
2. View Inspect
3. View Stats
4. Exec into container
5. Start/Stop container
6. Kill container
7. Restart container
