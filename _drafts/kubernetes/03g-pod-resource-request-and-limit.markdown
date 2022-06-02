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
4. How Kubernetes applies resource requests and limits?
5. Install prerequisite, Before you begin
6. Specify a CPU request and a CPU limit
7. Specify a CPU request that is too big for your Nodes
8. If you do not specify a CPU limit?
9. Specify a memory request and a memory limit
10. Exceed a Container's memory limit 
11. Specify a memory request that is too big for your Nodes
12. If you do not specify a memory limit?
13. Motivation for requests and limits

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

For example, on a system where the default page size is `4KiB`, you could specify a limit, `hugepages-2Mi: 80Mi`. If the container tries allocating over 40 `2MiB` huge pages (a total of 80 MiB), that allocation fails.

CPU and memory are collectively referred to as compute resources, or resources. Compute resources are measurable quantities that can be requested, allocated, and consumed. They are distinct from API resources. API resources, such as Pods and Services are objects that can be read and modified through the Kubernetes API server.

For each container, you can specify resource limits and requests, including the following:

{% highlight yaml %}
spec:
  containers:
    - resources:
        requests:
          memory: "<memory-unit>"
          cpu: "<cpu-unit>"
        limits:
          memory: "<memory-unit>"
          cpu: "<cpu-unit>"
{% endhighlight %}

Although you can only specify requests and limits for individual containers, it is also useful to think about the overall resource requests and limits for a Pod. For a particular resource, a Pod resource request/limit is the sum of the resource requests/limits of that type for each container in the Pod.

## What is Resource units?

Limits and requests for CPU resources are measured in cpu units. In Kubernetes, 1 CPU unit is equivalent to **1 physical CPU core**, or **1 virtual core**, depending on whether the node is a physical host or a virtual machine running inside a physical machine.

Fractional requests are allowed. When you define a container with `spec.containers[].resources.requests.cpu` set to `0.5`, you are requesting half as much CPU time compared to if you asked for `1.0` CPU. For CPU resource units, the quantity expression `0.1` is equivalent to the expression `100m`, which can be read as "one hundred millicpu". Some people say "one hundred millicores", and this is understood to mean the same thing.

CPU resource is always specified as an absolute amount of resource, never as a relative amount. For example, `500m` CPU represents the roughly same amount of computing power whether that container runs on a single-core, dual-core, or 48-core machine.

Limits and requests for `memory` are measured in bytes. You can express memory as a plain integer or as a fixed-point number using one of these quantity suffixes: `E`, `P`, `T`, `G`, `M`, `k`. You can also use the power-of-two equivalents: `Ei`, `Pi`, `Ti`, `Gi`, `Mi`, `Ki`. For example, the following represent roughly the same value:

{% highlight csv %}
128974848, 129e6, 129M,  128974848000m, 123Mi
{% endhighlight %}

Pay attention to the case of the suffixes. If you request `400m` of memory, this is a request for `0.4 bytes`. Someone who types that probably meant to ask for `400 mebibytes (400Mi)` or `400 megabytes (400M)`.

## How Kubernetes applies resource requests and limits?

