---
layout: post
title: "What is Kubernetes Namespaces?"
lang: k8s
categories:
- DevOps
- Orchestration
- Kubernetes
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/home/
- https://minikube.sigs.k8s.io/docs/
youtube: 
comments: true
catalog_key: introduction
image_path: /resources/posts/kubernetes/01g-k8s-namespaces
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, Setelah kita bahas Penamaan suatu Object pada Kubernetes sekarang kita akan membahas Namespace. Diantaranya

1. What is Kubernetes Namespaces?
2. When to Use Kubernetes Namespaces?
3. Working with Namespaces
4. Namespaces and DNS
5. Not All Objects are in a Namespace

Ok lansung aja kita ke pembahasan yang pertama yaitu

## What is Kubernetes Namespaces?

In Kubernetes, namespaces provides a mechanism for isolating groups of resources within a single cluster. Names of resources need to be unique within a namespace, but not across namespaces. Namespace-based scoping is applicable only for namespaced objects (e.g. `Deployments`, `Services`, etc) and not for cluster-wide objects (e.g. `StorageClass`, `Nodes`, `PersistentVolumes`, etc).

## When to Use Kubernetes Namespaces?

Namespaces are intended for use in environments with many users spread across multiple teams, or projects. For clusters with a few to tens of users, you should not need to create or think about namespaces at all. Start using namespaces when you need the features they provide.

Namespaces provide a scope for names. Names of resources need to be unique within a namespace, but not across namespaces. Namespaces cannot be nested inside one another and each Kubernetes resource can only be in one namespace.

Namespaces are a way to divide cluster resources between multiple users (via [resource quota](https://kubernetes.io/docs/concepts/policy/resource-quotas/)).

It is not necessary to use multiple namespaces to separate slightly different resources, such as different versions of the same software: use labels to distinguish resources within the same namespace.

## Working with Namespaces

Creation and deletion of namespaces are described in the Admin Guide documentation for namespaces.

> Note: Avoid creating namespaces with the prefix `kube-`, since it is reserved for Kubernetes system namespaces.

You can list the current namespaces in a cluster using:

{% highlight bash %}
kubectl get namespace
{% endhighlight %}

Kubernetes starts with four initial namespaces:

1. `default` The default namespace for objects with no other namespace
2. `kube-system` The namespace for objects created by the Kubernetes system
3. `kube-public` This namespace is created automatically and is readable by all users (including those not authenticated). This namespace is mostly reserved for cluster usage, in case that some resources should be visible and readable publicly throughout the whole cluster. The public aspect of this namespace is only a convention, not a requirement.
4. `kube-node-lease` This namespace holds [Lease](https://kubernetes.io/docs/reference/kubernetes-api/cluster-resources/lease-v1/) objects associated with each node. Node leases allow the kubelet to send [heartbeats](https://kubernetes.io/docs/concepts/architecture/nodes/#heartbeats) so that the control plane can detect node failure.

To set the namespace for a current request, use the `--namespace` or `-n` flag:

{% highlight bash %}
kubectl run nginx --image=nginx --namespace=<insert-namespace-name-here>
kubectl get pods --namespace=<insert-namespace-name-here>
{% endhighlight %}

## Namespaces and DNS

When you create a [Service](https://kubernetes.io/docs/concepts/services-networking/service/), it creates a corresponding DNS entry. This entry is of the form `<service-name>.<namespace-name>.svc.cluster.local`, which means that if a container only uses `<service-name>`, it will resolve to the service which is local to a namespace. This is useful for using the same configuration across multiple namespaces such as Development, Staging and Production. If you want to reach across namespaces, you need to use the fully qualified domain name (FQDN).

## Not All Objects are in a Namespace

Most Kubernetes resources (e.g. `pods`, `services`, `replication controllers`, and others) are in some namespaces. However namespace resources are not themselves in a namespace. And low-level resources, such as `nodes` and `persistentVolumes`, are not in any namespace.

To see which Kubernetes resources are and aren't in a namespace:

{% highlight bash %}
# In a namespace
kubectl api-resources --namespaced=true

# Not in a namespace
kubectl api-resources --namespaced=false
{% endhighlight %}