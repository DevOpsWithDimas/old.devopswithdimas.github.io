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
3. what are `initContainers` for?
4. Examples using `initContainers`
5. Behavior of initContainers

Ok langsung aja kita bahas ke materi yang pertama

<!--more-->

## What is init containers

A Pod can have multiple containers running apps within it, but it can also have one or more init containers, which are run before the app containers are started. 

Init containers are exactly like regular containers, except:

1. Init containers always run to completion.
2. Each init container must complete successfully before the next one starts.

If a Pod's init container fails, the kubelet repeatedly restarts that init container until it succeeds. However, if the Pod has a `restartPolicy` of Never, and an init container fails during startup of that Pod, Kubernetes treats the overall Pod as failed.

To specify an init container for a Pod, add the `initContainers` field into the Pod specification, as an array of `container` items (similar to the app containers field and its contents).

The status of the init containers is returned in `.status.initContainerStatuses` field as an array of the container statuses (similar to the `.status.containerStatuses` field).

## Differences from regular containers

Mungkin sebagian banyak dari temen-temen bertanya apasih bedanya antara `initContainers` dengan `containers`?

Init containers support all the fields and features of app containers, including resource limits, volumes, and security settings. However, the resource requests and limits for an init container are handled differently, as documented in [Resources](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/#resources).

Also, init containers do not support `lifecycle`, `livenessProbe`, `readinessProbe`, or `startupProbe` because they must run to completion before the Pod can be ready.

If you specify multiple init containers for a Pod, kubelet runs each init container sequentially. Each init container must succeed before the next can run. When all of the init containers have run to completion, kubelet initializes the application containers for the Pod and runs them as usual.

## what are `initContainers` for?

Because init containers have separate images from app containers, they have some advantages for start-up related code:

1. Init containers can contain utilities or custom code for setup that are not present in an app image. For example, there is no need to make an image FROM another image just to use a tool like `sed`, `awk`, `python`, or `dig` during setup.
2. The application image builder and deployer roles can work independently without the need to jointly build a single app image.
3. Init containers can run with a different view of the filesystem than app containers in the same Pod. Consequently, they can be given access to Secrets that app containers cannot access.
4. Because init containers run to completion before any app containers start, init containers offer a mechanism to block or delay app container startup until a set of preconditions are met. Once preconditions are met, all of the app containers in a Pod can start in parallel.
5. Init containers can securely run utilities or custom code that would otherwise make an app container image less secure. By keeping unnecessary tools separate you can limit the attack surface of your app container image.

The most commons of initContainer is, if your application need to run task before they can run for exaample migrate db, backup file config, cleanup systemfiles and etc.