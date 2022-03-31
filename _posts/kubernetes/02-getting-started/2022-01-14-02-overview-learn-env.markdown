---
layout: post
title: "Overview learning environment with Minikube"
date: 2022-01-14T10:08:49+07:00
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/tasks/tools/
- https://minikube.sigs.k8s.io/docs/
youtube: uQj0mJxDpeE
comments: true
catalog_key: minikube
image_path: /resources/posts/kubernetes/02-overview-learn-env
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---


Hai semuanya, di materi kali ini kita akan membahas tentang Learning environment menggunakan Minikube. Diataranya

1. What is minikube?
2. Pre-requisite install minikube

Ok langung aja kita bahas materi yang pertama yaitu 

<!--more-->

## What is minikube?

Yess i know, install kubernetes cluster is hard. but with minikube quickly sets up a local Kubernetes cluster on macOS, Linux, and Windows for learning environtment. We recommend using minikube to helping application developers and new Kubernetes users learning kubernetes technology.

![minikube](https://minikube.sigs.k8s.io/images/screenshot.png)

Beberapa feature yang di tawarkan menggunakan minikube diantaranya:

1. Supports the latest Kubernetes release (+6 previous minor versions)
2. Cross-platform (Linux, macOS, Windows)
3. Deploy as a VM, a container, or on bare-metal
4. Multiple container runtimes (CRI-O, containerd, docker)
5. Direct API endpoint for blazing fast image load and build
6. Advanced features such as LoadBalancer, filesystem mounts, and FeatureGates
7. Addons for easily installed Kubernetes applications
8. Supports common CI environments

## Pre-requisite install minikube

Ada beberapa kebutuhan yang perlu kita penuhin untuk menggunakan Minikube diantaranya:

1. `2 CPUs` or more
2. `2GB` of free memory
3. `20GB` of free disk space
4. Internet connection
5. Container or virtual machine manager, such as: `Docker`, `Hyperkit`, `Hyper-V`, `KVM`, `Parallels`, `Podman`, `VirtualBox`, or `VMware Fusion/Workstation`