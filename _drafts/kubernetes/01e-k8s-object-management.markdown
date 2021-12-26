---
layout: post
title: "Managing Kubernetes Object"
lang: k8s
categories:
- DevOps
- Orchestration
- Kubernetes
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/concepts/overview/working-with-objects/object-management/
- https://kubectl.docs.kubernetes.io/guides/introduction/kubectl/
- https://minikube.sigs.k8s.io/docs/
youtube: 
comments: true
catalog_key: introduction
image_path: /resources/posts/kubernetes/01e-kubernetes-object-management
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---


Hai semuanya, sebelumnya kita udah membahas tentang Objects pada Kubernetes sekarang kita akan bagaimana cara memanage Objectnya. Seperti yang kita tahu untuk berinteraksi dengan Kubernetes Cluster yaitu dengan menggunakan Kubernetes Client yaitu `kubectl`, Kubernetes API, dan Kubernetes Client Libraries. Kali ini kita akan membahas tentang `kubectl` command line terlebih dulu ya Diantaranya

1. Management techniques
2. Imperative commands
3. Imperative object configuration
4. Declarative object configuration

Ok langsung aja kita bahas materi pertama 

## Management techniques

The `kubectl` command-line tool supports several different ways to create and manage Kubernetes objects.