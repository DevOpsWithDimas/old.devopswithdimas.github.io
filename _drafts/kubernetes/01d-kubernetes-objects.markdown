---
layout: post
title: "What is Kubernetes Objects?"
lang: k8s
categories:
- DevOps
- Orchestration
- Kubernetes
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/
- https://minikube.sigs.k8s.io/docs/
youtube: 
comments: true
catalog_key: introduction
image_path: /resources/posts/kubernetes/01d-kubernetes-objects
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---


Hai semuanya, di materi kali ini sebelum kita mencoba menggunakan Kubernetes kita berkenalan dulu dengan Kubernetes Objects. Diataranya

1. Understanding Kubernetes Objects
2. Object Spec and Status
3. Describing a Kubernetes object
4. Required Fields

Ok langsung saja kita bahas materi yang pertama

## Understanding Kubernetes Objects

Kubernetes objects are persistent entities in the Kubernetes system. Kubernetes uses these entities to represent the state of your cluster. Specifically, they can describe:

1. What containerized applications are running (and on which nodes)
2. The resources available to those applications
3. The policies around how those applications behave, such as restart policies, upgrades, and fault-tolerance

A Kubernetes object is a "record of intent"--once you create the object, the Kubernetes system will constantly work to ensure that object exists. By creating an object, you're effectively telling the Kubernetes system what you want your cluster's workload to look like; this is your cluster's desired state.

To work with Kubernetes objects--whether to create, modify, or delete them--you'll need to use the [Kubernetes API](https://kubernetes.io/docs/concepts/overview/kubernetes-api/). When you use the `kubectl` command-line interface, for example, the CLI makes the necessary Kubernetes API calls for you. You can also use the Kubernetes API directly in your own programs using one of the [Client Libraries](https://kubernetes.io/docs/reference/using-api/client-libraries/).