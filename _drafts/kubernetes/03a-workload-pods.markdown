---
layout: post
title: "Kubernetes Workloads with Pods"
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
catalog_key: workloads
image_path: /resources/posts/kubernetes/03a-workload-pods
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan bahas lebih detail tentang Kubernetes Workload dengan Pods. Karena materinya lumayan panjang kita akan bagi menjadi beberapa section diantaranya:

1. What is a Pod?
2. Using Pods into your kubernetes cluster
3. Workloads resources for managing pods
4. How pods manage multiple containers
5. Working with Pods

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