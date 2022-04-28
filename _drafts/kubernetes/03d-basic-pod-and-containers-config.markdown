---
layout: post
title: "Basic Pods and Containers Configs"
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Workloads
refs: 
- https://kubernetes.io/docs/tasks/configure-pod-container/
- https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/
- https://kubernetes.io/docs/concepts/containers/images/
youtube: 
comments: true
catalog_key: workloads
image_path: /resources/posts/kubernetes/03d-basic-config-pod
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Basic configuration pada Pods and Containers. PodSpec adalah Specification supaya kita bisa meng-konfigurasi container yang akan kita sesuai dengan harapan kita contohnya seperti command apa yang akan di execute ketika container startup, port berapa yang kita mau expose ke luar, dan masih banyak lagi.

Ok karena materinya akan lumayan panjang kita akan bagi memjadi beberapa bagian diantaranya:

1. Using Labels in a Pods
2. Using Namespace
3. Using `image` & `imagePullPolicy` in containerSpec
4. Using `imagePullSecrets` for pull image from private registry
5. Using `env` (Environment Variables)
6. Using Working directory in containerSpec
7. Using Entrypoin (`command` and `args`)
8. Using normal user or non-root to run container
9. Using `ports`
10. Using Resource request & limit
11. Using privileged mode

Ok lansung aja kita bahas materi yang pertama

<!--more-->

## Using Labels in a Pods

Labels can be used to organize and to select subsets of objects. Labels can be attached to objects at creation time and subsequently added and modified at any time. Each object can have a set of key/value labels defined. Each Key must be unique for a given object.

Labels are key/value pairs. Valid label keys have two segments: an optional prefix and name, separated by a slash (`/`). The name segment is required and must be `63` characters or less, beginning and ending with an alphanumeric character (`[a-z0-9A-Z]`) with dashes (`-`), underscores (`_`), dots (`.`), and alphanumerics between.

The `kubernetes.io/` and `k8s.io/` prefixes are reserved for Kubernetes core components.

Example labels:

{% gist page.gist "03d-pod-labels.yaml" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ kubernetes git:(main) kubectl apply -f .\02-workloads\01-pod\pod-labels.yaml
pod/webapp-prod created
pod/webapp-test created

➜ kubernetes git:(main) kubectl get pod --show-labels
NAME          READY   STATUS    RESTARTS   AGE     LABELS
webapp-prod   1/1     Running   0          2m40s   app=nginx,environment=production,release=stable,tier=frontend
webapp-test   1/1     Running   0          2m40s   app=nginx,environment=qa,release=latest,tier=frontend

➜ kubernetes git:(main) kubectl get pod -l environment=production
NAME          READY   STATUS    RESTARTS   AGE
webapp-prod   1/1     Running   0          3m16s
```

Selain digunakan untuk melakukan query tersebut, biasanya labels juga bisa digunakan untuk menentukan lokasih suatu pod di jalankan pada node tertentu. Hanya untuk kasus ini nanti kita akan bahas di materi selanjutnya ya.

## Using Namespace in a Pods

Namespaces are intended for use in environments with many users spread across multiple teams, or projects. Contohnya seperti yang telah kita praktek sebelumnya, kita memiliki 2 pod dengan specifikasi yang mirip hanya berbeda version dan environtment atau perpose untuk meng-organisasi object tersebut akan lebih mudah menggunakan Namespace tersebut.

Pertama kita harus membuat object namespace tersebut dengan perintah 

{% highlight bash %}
kubectl create ns production;
kubectl create namespace qa
{% endhighlight %}

Atau bisa juga menggunakan file `.yaml` seperti berikut:

{% gist page.gist "03d-pod-namespaced.yaml" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ kubernetes git:(main) kubectl apply -f .\02-workloads\01-pod\pod-namespaced.yaml
namespace/production created
namespace/qa created
pod/webapp-namespaced created
pod/webapp-namespaced created

➜ kubernetes git:(main) kubectl get pod --all-namespaces -l app=nginx
NAMESPACE    NAME                READY   STATUS    RESTARTS   AGE
default      webapp-prod         1/1     Running   0          30m
default      webapp-test         1/1     Running   0          30m
production   webapp-namespaced   1/1     Running   0          48s
qa           webapp-namespaced   1/1     Running   0          48s

➜ kubernetes git:(main) ✗ kubectl get pod -n production
NAME                READY   STATUS    RESTARTS   AGE
webapp-namespaced   1/1     Running   0          72s
```

You can permanently save the namespace for all subsequent kubectl commands in that context.

{% highlight bash %}
kubectl config set-context --current --namespace=qa
# Validate it
kubectl config view --minify | grep namespace:
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ kubernetes git:(main) kubectl config set-context --current --namespace=qa
Context "minikube" modified.

➜ kubernetes git:(main) kubectl get pod --show-labels
NAME                READY   STATUS    RESTARTS   AGE     LABELS
webapp-namespaced   1/1     Running   0          2m46s   app=nginx,release=latest,tier=frontend
```

## Using `image` & `imagePullPolicy` in containerSpec

