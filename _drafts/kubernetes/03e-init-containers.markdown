---
layout: post
title: "Initialization of Containers"
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Workloads
refs: 
- https://kubernetes.io/docs/concepts/workloads/pods/init-containers/
youtube: 
comments: true
catalog_key: workloads
image_path: /resources/posts/kubernetes/03c-init-containers
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, setelah kita mempelajari tentang basic Container dan Pod configuration selanjutnya kita bahas Init Containers. Ok seperti biasa karena materi ini akan lumayan panyang jadi kita akan bagi-bagi menjadi beberapa bagian diantaranya:

1. What is init containers
2. Differences from regular containers
3. Using ini containers
4. Example use cases
5. Behavior of init containers

Ok langsung aja kita bahas ke materi yang pertama

<!--more-->


## What is init containers

A Pod can have multiple containers running apps within it, but it can also have one or more init containers, which are run before the app containers are started.

You can specify init containers in the Pod specification alongside the `containers` array (which describes app containers). 

Init containers are exactly like regular containers, except:

1. Init containers always run to completion.
2. Each init container must complete successfully before the next one starts.

If a Pod's init container fails, the kubelet repeatedly restarts that init container until it succeeds. However, if the Pod has a `restartPolicy` of Never, and an init container fails during startup of that Pod, Kubernetes treats the overall Pod as failed.

To specify an init container for a Pod, add the `initContainers` field into the Pod specification, as an array of `container` items (similar to the app containers field and its contents).

The status of the init containers is returned in `.status.initContainerStatuses` field as an array of the container statuses (similar to the `.status.containerStatuses` field).

