---
layout: post
title: "Kubernetes cluster environtments"
date: 2022-01-14T09:12:47+07:00
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/home/
- https://minikube.sigs.k8s.io/docs/
- https://kubernetes.io/id/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
- https://microk8s.io/
youtube: 
comments: true
catalog_key: introduction
image_path: /resources/posts/kubernetes/01h-kubernetes-environtments
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuannya, di materi kali ini kita akan membahas tentang Kubernetes cluster environtements. Ada beberapa approach untuk install kubernetes cluster diantaranya

1. Learning environments
2. Development/Production environment

<!--more-->

Untuk sekarang kita akan membahas untuk Learning environment dulu ya. Untuk learning environtment juga terdiri 2 methode yaitu based on cloud (interactive browser) salah satunya yng di sediakan [katacoda](https://www.katacoda.com/courses/kubernetes) dan on-premise (local environtment) yaitu

1. Docker-Kubernetes (Kind)
2. [minikube.io](https://minikube.sigs.k8s.io/docs/)