---
layout: post
title: "Kubernetes Workloads with Pods"
date: 2022-04-13T04:23:11+07:00
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Workloads
refs: 
- https://kubernetes.io/docs/concepts/workloads/pods/
youtube: 
comments: true
catalog_key: pod-container
image_path: /resources/posts/kubernetes/03a-workload-pods
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan bahas lebih detail tentang Kubernetes Workload dengan Pods. Karena materinya lumayan panjang kita akan bagi menjadi beberapa section diantaranya:

1. What is a Pod?
2. Using Pods into your kubernetes cluster
3. Containers inside a pod
4. How pods manage multiple containers

Ok langsung aja kita bahas materi pertama

<!--more-->

## What is a Pod?

Pods are the smallest deployable units of computing that you can create and manage in Kubernetes. 

A Pod (as in a pod of whales or pea pod) is a group of one or more containers, with shared storage and network resources, and a specification for how to run the containers.  A Pod's contents are always co-located and co-scheduled, and run in a shared context. A Pod models an application-specific "logical host": it contains one or more application containers which are relatively tightly coupled. In non-cloud contexts, applications executed on the same physical or virtual machine are analogous to cloud applications executed on the same logical host.

As well as application containers, a Pod can contain init containers that run during Pod startup. 

## Using Pods

Untuk menggunakan pod dalam kubernetes cluster, secara simple kita bisa menggunakan perintah 

{% highlight bash %}
kubectl create pod <pod-name> --image <image-name>:<image-version> --port <container-port>
{% endhighlight %}

Namun kali ini kita akan menggunakan format `yaml` file ya, Temen-temen masih inget dengan `docker-compose` di kelas Docker? yap betul di kubernetes juga kita bisa memanage object dengan file yang berformat `.yaml` file, contohnya membuat pod seperti berikut:

{% gist page.gist "03a-simple-nginx-pod.yaml" %}

To create the Pod shown above, run the following command:

{% highlight bash %}
kubectl apply -f simple-nginx-pod.yaml
{% endhighlight %}

Pods are generally not created directly and are created using workload resources.

## Container inside a pod

Pods in a Kubernetes cluster are used in two main ways:

1. **Pods that run a single container**. The "one-container-per-Pod" model is the most common Kubernetes use case; in this case, you can think of a Pod as a wrapper around a single container; Kubernetes manages Pods rather than managing the containers directly.

2. **Pods that run multiple containers that need to work together**. A Pod can encapsulate an application composed of multiple co-located containers that are tightly coupled and need to share resources. These co-located containers form a single cohesive unit of service—for example, one container serving data stored in a shared volume to the public, while a separate sidecar container refreshes or updates those files. The Pod wraps these containers, storage resources, and an ephemeral network identity together as a single unit.

> Note: Grouping multiple co-located and co-managed containers in a single Pod is a relatively advanced use case. You should use this pattern only in specific instances in which your containers are tightly coupled.

For Example multiple container in a pods

{% highlight yaml %}
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: backend
    image: springboot:latest
    ports:
    - containerPort: 8080
  - name: agent
    image: jaeger-agent:latest
{% endhighlight %}

Each Pod is meant to run a single instance of a given application. If you want to scale your application horizontally (to provide more overall resources by running more instances), you should use multiple Pods, one for each instance. In Kubernetes, this is typically referred to as replication. Replicated Pods are usually created and managed as a group by a workload resource and its controller.

## How pods manage multiple containers

Pods are designed to support multiple cooperating processes (as containers) that form a cohesive unit of service. The containers in a Pod are automatically co-located and co-scheduled on the same physical or virtual machine in the cluster. The containers can share resources and dependencies, communicate with one another, and coordinate when and how they are terminated.

For example, you might have a container that acts as a web server for files in a shared volume, and a separate "sidecar" container that updates those files from a remote source, as in the following diagram:

![pod-sidecar]({{ page.image_path | prepend: site.baseurl }}/01-pod-sidecar.png)

Some Pods have init containers as well as app containers. Init containers run and complete before the app containers are started.

Pods natively provide two kinds of shared resources for their constituent containers: networking and storage.