---
layout: post
title: "Configure Request and Limit of Resources (CPUs & Memory)"
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Workloads
refs: 
- https://kubernetes.io/docs/tasks/configure-pod-container/assign-memory-resource/
- https://kubernetes.io/docs/tasks/configure-pod-container/assign-cpu-resource/
youtube: 
comments: true
catalog_key: pod-container
image_path: /resources/posts/kubernetes/03h-pod-resource-request-and-limit
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita membahas tentang Resources Limit and Request pada suatu containers dalam Pod. Diantaranya:

1. What is Resource Request and Limit?
2. What is Resource types?
3. What is Resource units?
4. Install prerequisite, Before you begin
5. Specify a CPU request and a CPU limit
6. Specify a CPU request that is too big for your Nodes
7. If you do not specify a CPU limit?
8. Specify a memory request and a memory limit
9. Exceed a Container's memory limit 
10. Specify a memory request that is too big for your Nodes
11. If you do not specify a memory limit?
12. Motivation for requests and limits

Ok langsung aja kita bahas materi yang pertama

<!--more-->

## What is Resource Request and Limit?

When you specify a Pod, you can optionally specify how much of each resource a container needs. The most common resources to specify are CPU and memory (RAM); there are others.

When you specify the resource request for containers in a Pod, the kube-scheduler uses this information to decide which node to place the Pod on. When you specify a resource limit for a container, the kubelet enforces those limits so that the running container is not allowed to use more of that resource than the limit you set. The kubelet also reserves at least the request amount of that system resource specifically for that container to use.

If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more resource than its `request` for that resource specifies. However, a container is not allowed to use more than its resource `limit`.

For example, if you set a memory request of `256 MiB` for a container, and that container is in a Pod scheduled to a Node with `8GiB` of memory and no other Pods, then the container can try to use more RAM.

If you set a memory limit of `4GiB` for that container, the kubelet (and container runtime) enforce the limit. The runtime prevents the container from using more than the configured resource limit. For example: when a process in the container tries to consume more than the allowed amount of memory, the system kernel terminates the process that attempted the allocation, with an out of memory (OOM) error.

Limits can be implemented either reactively (the system intervenes once it sees a violation) or by enforcement (the system prevents the container from ever exceeding the limit). Different runtimes can have different ways to implement the same restrictions.

## What is Resource types?

CPU and memory are each a resource type. A resource type has a base unit. CPU represents compute processing and is specified in units of Kubernetes CPUs. Memory is specified in units of bytes. For Linux workloads, you can specify huge page resources. Huge pages are a Linux-specific feature where the node kernel allocates blocks of memory that are much larger than the default page size.