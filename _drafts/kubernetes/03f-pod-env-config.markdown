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
3. Using ConfigMap as Ref for `envFrom`
4. Using ConfigMap as Ref for `valueFrom`
5. What is Secret?
6. Using Secret as Ref for `envFrom`
7. Using Secret as Ref for `valueFrom`
8. Motivation for using ConfigMap and Secret

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

## Using ConfigMap as Ref `envFrom`

When you have a ConfigMap in your cluster, you can include all Environment Variables into your container using `envFrom` like this:

{% highlight yaml %}
apiVersion: v1
kind: Pod
metadata:
  name: pod-env-envfrom
  labels:
    app: postgres
spec:
  containers:
    - name: database
      image: postgres
      imagePullPolicy: IfNotPresent
      envFrom:
        - configMapRef:
            name: db-config
            optional: false
      ports:
        - containerPort: 5432
  restartPolicy: Always
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ ~  kubectl get configmap
NAME               DATA   AGE
db-config          3      19m
kube-root-ca.crt   1      4d

➜ kubernetes git:(main) kubectl apply -f .\02-workloads\01-pod\pod-envfrom.yaml
pod/pod-env-envfrom created

➜ kubernetes git:(main) kubectl get pod
NAME              READY   STATUS    RESTARTS   AGE
pod-env-envfrom   1/1     Running   0          13s

➜ kubernetes git:(main) kubectl describe pod pod-env-envfrom
Name:         pod-env-envfrom
Namespace:    default
Priority:     0
Node:         minikube-m03/192.168.49.4
Start Time:   Thu, 26 May 2022 11:12:43 +0700
Labels:       app=postgres
Annotations:  <none>
Status:       Running
IP:           10.244.2.3
IPs:
  IP:  10.244.2.3
Containers:
  database:
    Image:          postgres
    Port:           5432/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Thu, 26 May 2022 11:12:44 +0700
    Ready:          True
    Restart Count:  0
    Environment Variables from:
      db-config   ConfigMap  Optional: false
    Environment:  <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-qzg9d (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True

Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  33s   default-scheduler  Successfully assigned default/pod-env-envfrom to minikube-m03
  Normal  Pulled     33s   kubelet            Container image "postgres" already present on machine
  Normal  Created    33s   kubelet            Created container database
  Normal  Started    33s   kubelet            Started container database

➜ kubernetes git:(main) kubectl exec pod-env-envfrom -- printenv
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/postgresql/14/bin
HOSTNAME=pod-env-envfrom
POSTGRES_USER=crud_app
POSTGRES_DB=crud_app
POSTGRES_PASSWORD=crud_app
GOSU_VERSION=1.14
LANG=en_US.utf8
PG_MAJOR=14
PG_VERSION=14.3-1.pgdg110+1
PGDATA=/var/lib/postgresql/data
HOME=/root
```

Or you can define configmap in file too, like this:

{% gist page.gist "03f-pod-env-configmap.yaml" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ kubernetes git:(main) kubectl apply -f .\02-workloads\01-pod\pod-env-configmap.yaml
configmap/config-db2 created
pod/pod-envfrom-configmap created

➜ kubernetes git:(main) kubectl get pod
NAME                    READY   STATUS    RESTARTS   AGE
pod-env-envfrom         1/1     Running   0          8m40s
pod-envfrom-configmap   1/1     Running   0          13s

➜ kubernetes git:(main) kubectl describe pod pod-envfrom-configmap
Name:         pod-envfrom-configmap
Namespace:    default
Priority:     0
Node:         minikube-m03/192.168.49.4
Start Time:   Thu, 26 May 2022 11:21:10 +0700
Labels:       app=postgres
Annotations:  <none>
Status:       Running
IP:           10.244.2.4
IPs:
  IP:  10.244.2.4
Containers:
  database:
    Image:          postgres
    Port:           5432/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Thu, 26 May 2022 11:21:11 +0700
    Ready:          True
    Restart Count:  0
    Environment Variables from:
      db-config2   ConfigMap  Optional: false
    Environment:  <none>
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  39s   default-scheduler  Successfully assigned default/pod-envfrom-configmap to minikube-m03
  Normal  Pulled     38s   kubelet            Container image "postgres" already present on machine
  Normal  Created    38s   kubelet            Created container database
  Normal  Started    38s   kubelet            Started container database
```

## Using ConfigMap as Ref for `valueFrom`

