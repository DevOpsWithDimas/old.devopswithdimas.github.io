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

A container image represents binary data that encapsulates an application and all its software dependencies. Container images are executable software bundles that can run standalone and that make very well defined assumptions about their runtime environment.

You typically create a container image of your application and push it to a registry before referring to it in a Pod

When you first create a Deployment, StatefulSet, Pod, or other object that includes a Pod template, then by default the pull policy of all containers in that pod will be set to `IfNotPresent` if it is not explicitly specified. This policy causes the kubelet to skip pulling an image if it already exists.

Here's a list of the values you can set for imagePullPolicy and the effects these values have:

1. `IfNotPresent`, the image is pulled only if it is not already present locally.
2. `Always`, every time the kubelet launches a container, the kubelet queries the container image registry to resolve the name to an image digest. If the kubelet has a container image with that exact digest cached locally, the kubelet uses its cached image; otherwise, the kubelet pulls the image with the resolved digest, and uses that image to launch the container.
3. `Never`, the kubelet does not try fetching the image. If the image is somehow already present locally, the kubelet attempts to start the container; otherwise, startup fails.

> Note: You should avoid using the `:latest` tag when deploying containers in production as it is harder to track which version of the image is running and more difficult to roll back properly. Instead, specify a meaningful tag such as `v1.42.0`.

Default image pull policy, When you (or a controller) submit a new Pod to the API server, your cluster sets the imagePullPolicy field when specific conditions are met:

1. if you omit the `imagePullPolicy` field, and the tag for the container image is `:latest`, `imagePullPolicy` is automatically set to `Always`
2. if you omit the `imagePullPolicy` field, and you don't specify the tag for the container image, `imagePullPolicy` is automatically set to Always;
3. if you omit the `imagePullPolicy` field, and you specify the tag for the container image that isn't `:latest`, the `imagePullPolicy` is automatically set to `IfNotPresent`.

ImagePullBackOff, When a kubelet starts creating containers for a Pod using a container runtime, it might be possible the container is in Waiting state because of `ImagePullBackOff`.

The status `ImagePullBackOff` means that a container could not start because Kubernetes could not pull a container image (for reasons such as invalid image name, or pulling from a private registry without `imagePullSecret`). The `BackOff` part indicates that Kubernetes will keep trying to pull the image, with an increasing back-off delay.

For example, kita akan coba buat docker image berdasarkan `Dockerfile` berikut:

{% gist page.gist "02d-dockerfile" %}

Dan berikut adalah file `index.html` seperti berikut:

{% gist page.gist "03d-index.html" %}

Kemudian coba build dan push ke docker hub dengan image name `dimmaryanto93/kubernetes-cource:latest`

Setelah itu coba jalankan container image tersebut dengan `pod-image-same.yaml` seperti berikut:

{% gist page.gist "03d-pod-image-same-tag.yaml" %}

Sekarang kita coba jalankan maka hasilnya seperti berikut:

```powershell
➜ kubectl apply -f .\02-workloads\01-pod\pod-image-tag.yaml
pod/pod-same-image created

➜ kubectl get pod
NAME             READY   STATUS    RESTARTS   AGE
pod-same-image   1/1     Running   0          12s

➜ kubernetes git:(main) kubectl exec pod/pod-same-image -- curl localhost
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   349  100   349    0     0   340k      0 --:--:-- --:--:-- --:--:--  340k
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DevOps Kubernetes: Pemula sampai Mahir</title>
</head>
<body>
    <p>dimmaryanto93/kubernetes-cource v1.0</p>
</body>
</html>
```

Sekarang kita coba build ulang dengan meng-update textnya misalnya seperti berikut:

{% highlight html %}
<!DOCTYPE html>
<html lang="en">
<head>
    <title>DevOps Kubernetes: Pemula sampai Mahir</title>
</head>
<body>
    <p>dimmaryanto93/kubernetes-cource v1.1</p>
</body>
</html>
{% endhighlight %}

Kemudian coba push kembali ke docker hub, dan coba delete Pod dan buat lagi dengan perintah berikut:

{% highlight bash %}
kubectl delete -f pod-image-same-tag.yaml
kubectl apply -f pod-image-same-tag.yaml
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ kubernetes git:(main) kubectl -f .\02-workloads\01-pod\pod-image-tag.yaml delete
pod "pod-same-image" deleted
➜ kubernetes git:(main) kubectl -f .\02-workloads\01-pod\pod-image-tag.yaml apply
pod/pod-same-image created

➜ kubernetes git:(main) kubectl get pod
NAME             READY   STATUS    RESTARTS   AGE
pod-same-image   1/1     Running   0          28s

➜ kubernetes git:(main) kubectl exec pod/pod-same-image -- curl localhost
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   349  100   349    0     0   340k      0 --:--:-- --:--:-- --:--:--  340k
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DevOps Kubernetes: Pemula sampai Mahir</title>
</head>
<body>
    <p>dimmaryanto93/kubernetes-cource v1.0</p>
</body>
</html>
```

Klo kita liat dari hasil request curl tersebut imagenya belum ter-update karena kita menggunakan `imagePullPolicy: IfNotPresent` artinya karena imagenya sudah ada di hostnya maka tidak akan pull ulang, sekarang coba ganti `imagePullPolicy: Always` dan kemudian jalankan kembali maka hasilnya seperti berikut:

```powershell
➜ kubernetes git:(main) kubectl -f .\02-workloads\01-pod\pod-image-tag.yaml delete
pod "pod-same-image" deleted

➜ kubernetes git:(main) kubectl -f .\02-workloads\01-pod\pod-image-tag.yaml apply
pod/pod-same-image created

➜ kubernetes git:(main) kubectl exec pod/pod-same-image -- curl localhost
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DevOps Kubernetes: Pemula sampai Mahir</title>
</head>
<body>
    <p>dimmaryanto93/kubernetes-cource v1.1</p>
</body>
</html>
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   349  100   349    0     0   340k      0 --:--:-- --:--:-- --:--:--  340k
```