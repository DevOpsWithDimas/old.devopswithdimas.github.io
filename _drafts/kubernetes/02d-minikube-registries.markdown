---
layout: post
title: "How to interact with registries"
lang: k8s
categories:
- DevOps
- Orchestration
- Kubernetes
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/home/
- https://minikube.sigs.k8s.io/docs/
youtube: 
comments: true
catalog_key: minikube
image_path: /resources/posts/kubernetes/02e-minikube-registries
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---


## Using insecure-registry to pull image

Dengan menggunakan minikube, by default registry yang digunakan adalah [DockerHUB](https://hub.docker.com/) tetapi selain itu juga kita bisa menggunakan registry lain seperti

1. AWS Elastic Container Registry (ECR)
2. Google Container Registry (GCR)
3. Insecure Docker registry (Docker)
4. Azure Container Registry (ACR)

dengan menambahkan feature / addon `registry-creds`

Sebagai contoh, disini saya menggunakan Nexus OSS yang telah di configurasi untuk docker registry (insecure docker registry) dengan address `192.168.88.50:8086`. Pertama kita perlu setting container runtime untuk bisa insecure registry dengan menggunakan `--insecure-registry` seperti berikut:

{% gist page.gist "02c-minikube-start-insecure-registry.bash" %}

Dan setelah clusternya terbuat maka kita bisa configure untuk authenctionnya menggunakan perintah:

{% gist page.gist "02c-minikube-addon-registry-creds.bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜  ~ minikube start --memory 2g --driver virtualbox --no-vtx-check -p insecure-registry --insecure-registry=192.168.88.50:8086
😄  [insecure-registry] minikube v1.25.1 on Ubuntu 21.10
✨  Using the virtualbox driver based on user configuration
👍  Starting control plane node insecure-registry in cluster insecure-registry
🔥  Creating virtualbox VM (CPUs=2, Memory=2048MB, Disk=20000MB) ...
🐳  Preparing Kubernetes v1.23.1 on Docker 20.10.12 ...
    ▪ kubelet.housekeeping-interval=5m
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🔎  Verifying Kubernetes components...
🌟  Enabled addons: storage-provisioner, default-storageclass
🏄  Done! kubectl is now configured to use "insecure-registry" cluster and "default" namespace by default

➜  ~ minikube profile insecure-registry
✅  minikube profile was successfully set to insecure-registry

➜  ~ minikube addons configure registry-creds
Do you want to enable AWS Elastic Container Registry? [y/n]: n

Do you want to enable Google Container Registry? [y/n]: n

Do you want to enable Docker Registry? [y/n]: y
-- Enter docker registry server url: 192.168.88.50:8086
-- Enter docker registry username: admin
-- Enter docker registry password: 

Do you want to enable Azure Container Registry? [y/n]: n
✅  registry-creds was successfully configured

## restart cluster
➜  ~  minikube stop -p insecure-registry
➜  ~  minikube start -p insecure-registry

➜  ~ kubectl create deploy nginx-insecure --image 192.168.88.50:8086/nginx
deployment.apps/nginx-insecure created

```