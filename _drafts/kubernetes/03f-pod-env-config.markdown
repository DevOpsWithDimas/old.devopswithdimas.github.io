---
layout: post
title: "Configure env (Environment Variables) in a Pods"
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Workloads
refs: 
- https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/
- https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/
youtube: 
comments: true
catalog_key: workloads
image_path: /resources/posts/kubernetes/03f-pod-env
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas lebih detail tentang Environment Variables pada Pod Specification, diantaranya:

1. Basic Usage env-values
2. What is ConfigMap?
3. Using ConfigMap as Ref `envFrom`
4. What is Secret?
5. Using Secret as Ref to `envFrom`
6. Using `valueFrom` of ConfigMap or Secret
7. Motivation for using ConfigMap and Secret

Ok langsung aja kita bahas materi yang pertama

<!--more-->

## Basic Usage env-values

Seperti yang temen-temen ketahui suatu Environtment Variable ini biasanya digunakan untuk meng-inject data kedalam Container bertujuan untuk merubah behavior atau prilaku dari command yang di eksekusi oleh container runtime.

Pada meteri sebelumnya tentang Basic Pod and Container spesification pada section Environment Variable, kita mendefinikan env `POSTGRES_PASSWORD` ke Container image `postgres` bertujuan meng-override default password pada user `postgres` dalam database.

Sometime, penggunaan `env` pada containerSpec tidak hanya itu saja. Suatu environment variables bisa di gunakan bersamaan (suatu value dari env me-refer ke object yang berbeda) contohnya ketika membuat aplikasi bisnis (CRUD) yang terdiri dari web-server dan database saling berinteraksi kita bisa menggunan env yang sama seperti berikut:

{% gist page.gist "03f-pod-env-multiple.yaml" %}

Nah terlihat pada podSpec diatas, ada beberapa value dari env yang sebetulnya kita bisa generalisasi karena menggunakan value yang sama yaitu (`DB_NAME == POSTGRES_DB`, `POSTGRES_USER == DB_USERNAME` dan `POSTGRES_PASSWORD == DB_PASSWORD`). Disinilah kita bisa menggunakan salah satu object dari kubernetes untuk me-maintanance data tersebut yaitu `ConfigMap` dan `Secret`

## What is ConfigMap?

Many applications rely on configuration which is used during either application initialization or runtime. Most of the times there is a requirement to adjust values assigned to configuration parameters. 

ConfigMaps is the kubernetes way to inject application pods with configuration data. ConfigMaps allow you to decouple configuration artifacts from image content to keep containerized applications portable.

You can use either kubectl create configmap or a ConfigMap generator in `kustomization.yaml` to create a ConfigMap.

Use the `kubectl create configmap` command to create ConfigMaps from [directories](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#create-configmaps-from-directories), [files](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#create-configmaps-from-files), or [literal values](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#create-configmaps-from-literal-values):

{% highlight bash %}
kubectl create configmap <map-name> <data-source>
{% endhighlight %}

where `<map-name>` is the name you want to assign to the ConfigMap and `<data-source>` is the directory, file, or literal value to draw the data from. The name of a ConfigMap object must be a valid [DNS subdomain name](https://kubernetes.io/docs/concepts/overview/working-with-objects/names#dns-subdomain-names).

When you are creating a ConfigMap based on a file, the key in the `<data-source>` defaults to the basename of the file, and the value defaults to the file content.

You can use `kubectl describe` or `kubectl get` to retrieve information about a ConfigMap.

For Example, you can create ConfigMap using this command:

{% highlight bash %}
kubectl create configmap db-config \
--from-literal=POSTGRES_PASSWORD=crud_apps \
--from-literal=POSGRES_USER=crud_apps \
--from-literal=POSGRES_DB=crud_apps
{% endhighlight %}

Jika dijalankan hasilnya seperti berikut:

```powershell
➜ ~  kubectl create configmap db-config `
> --from-literal=POSTGRES_PASSWORD=crud_app `
> --from-literal=POSTGRES_USER=crud_app `
> --from-literal=POSTGRES_DB=crud_app
configmap/db-config created

➜ ~  kubectl get configmap
NAME               DATA   AGE
db-config          3      27s
kube-root-ca.crt   1      4d

➜ ~  kubectl describe configmap db-config
Name:         db-config
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
POSTGRES_DB:
----
crud_app
POSTGRES_PASSWORD:
----
crud_app
POSTGRES_USER:
----
crud_app

BinaryData
====

Events:  <none>
```

Setelah ini kita bisa terapkan pada suatu container untuk digunakan menggunakan `envFrom` ataupun `valueFrom`