---
layout: post
title: "Configure env (Environment Variables) in a Pods"
date: 2022-05-26T15:49:31+07:00
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Workloads
refs: 
- https://kubernetes.io/docs/concepts/configuration/configmap/
- https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/
- https://kubernetes.io/docs/concepts/configuration/secret/
- https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/
youtube: 
comments: true
catalog_key: pod-container
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

Ok langsung aja kita bahas materi yang pertama

<!--more-->

## Basic Usage env-values

Seperti yang temen-temen ketahui suatu Environtment Variable ini biasanya digunakan untuk meng-inject data kedalam Container bertujuan untuk merubah behavior atau prilaku dari command yang di eksekusi oleh container runtime.

Pada meteri sebelumnya tentang Basic Pod and Container spesification pada section Environment Variable, kita mendefinikan env `POSTGRES_PASSWORD` ke Container image `postgres` bertujuan meng-override default password pada user `postgres` dalam database.

Sometime, penggunaan `env` pada containerSpec tidak hanya itu saja. Suatu environment variables bisa di gunakan bersamaan (suatu value dari env me-refer ke object yang berbeda) contohnya ketika membuat aplikasi bisnis (CRUD) yang terdiri dari web-server dan database saling berinteraksi kita bisa menggunan env yang sama seperti berikut:

{% gist page.gist "03f-pod-env-multiple.yaml" %}

Nah terlihat pada podSpec diatas, ada beberapa value dari env yang sebetulnya kita bisa generalisasi karena menggunakan value yang sama yaitu (`DB_NAME == POSTGRES_DB`, `POSTGRES_USER == DB_USERNAME` dan `POSTGRES_PASSWORD == DB_PASSWORD`). Disinilah kita bisa menggunakan salah satu object dari kubernetes untuk me-maintanance data tersebut yaitu `ConfigMap` dan `Secret`

## What is ConfigMap?

A ConfigMap is an API object used to store non-confidential data in key-value pairs. Pods can consume ConfigMaps as environment variables, command-line arguments, or as configuration files in a volume.

Many applications rely on configuration which is used during either application initialization or runtime. Most of the times there is a requirement to adjust values assigned to configuration parameters. 

ConfigMaps allow you to decouple configuration artifacts from image content to keep containerized applications portable.

You can use either `kubectl create configmap` or a ConfigMap generator in `kustomization.yaml` to create a ConfigMap.

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

Selain menggunakan `envFrom` yang meng-include semua environment variable dalam object ConfigMap, kita juga bisa gunakan sebagian data dari object ConfigMap tersebut menggunakan `valueFrom` dalam `env`.

Hal ini berguna, untuk me-reused environment variable tersebut ke beberapa container atau pod atau workload resource lainnya. Contohnya seperti berikut:

{% gist page.gist "03f-pod-env-valuefrom-configmap.yaml" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ kubernetes git:(main) ✗ kubectl apply -f .\02-workloads\01-pod\pod-env-valuefrom-configmap.yaml
configmap/config-db3 created
pod/pod-envfrom-configmap created

➜ kubernetes git:(main) kubectl get pod
NAME                    READY   STATUS    RESTARTS   AGE
pod-envfrom-configmap   2/2     Running   0          11s

➜ kubernetes git:(main) kubectl describe pod pod-envfrom-configmap
Name:         pod-envfrom-configmap
Namespace:    default
Priority:     0
Node:         minikube-m03/192.168.49.4
Start Time:   Thu, 26 May 2022 12:16:49 +0700
Labels:       app=postgres
Annotations:  <none>
Status:       Running
IP:           10.244.2.5
IPs:
  IP:  10.244.2.5
Containers:
  database:
    Image:          postgres
    Port:           5432/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Thu, 26 May 2022 12:16:50 +0700
    Ready:          True
    Restart Count:  0
    Environment:
      POSTGRES_PASSWORD:  <set to the key 'DB_PASSWORD' of config map 'config-db3'>  Optional: false
      POSTGRES_USER:      <set to the key 'DB_USER' of config map 'config-db3'>      Optional: false
      POSTGRES_DB:        <set to the key 'DB_NAME' of config map 'config-db3'>      Optional: false
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-2p4b8 (ro)
  webapps:
    Image:          nginx
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Thu, 26 May 2022 12:16:53 +0700
    Ready:          True
    Restart Count:  0
    Environment:
      DATABASE_PASSWORD:  <set to the key 'DB_PASSWORD' of config map 'config-db3'>  Optional: false
      DATABASE_USER:      <set to the key 'DB_USER' of config map 'config-db3'>      Optional: false
      DATABASE_NAME:      <set to the key 'DB_NAME' of config map 'config-db3'>      Optional: false
      DATABASE_HOST:      localhost
      DATABASE_PORT:      5432
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-2p4b8 (ro)
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
  Normal  Scheduled  28s   default-scheduler  Successfully assigned default/pod-envfrom-configmap to minikube-m03
  Normal  Pulled     28s   kubelet            Container image "postgres" already present on machine
  Normal  Created    28s   kubelet            Created container database
  Normal  Started    28s   kubelet            Started container database
  Normal  Pulling    28s   kubelet            Pulling image "nginx"
  Normal  Pulled     25s   kubelet            Successfully pulled image "nginx" in 3.4689305s
  Normal  Created    25s   kubelet            Created container webapps
  Normal  Started    25s   kubelet            Started container webapps

➜ kubernetes git:(main) ✗ kubectl exec pod-envfrom-configmap -c database -- printenv
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/postgresql/14/bin
HOSTNAME=pod-envfrom-configmap
POSTGRES_DB=crud_apps
POSTGRES_PASSWORD=crud_apps
POSTGRES_USER=crud_apps
GOSU_VERSION=1.14
LANG=en_US.utf8
PG_MAJOR=14
PG_VERSION=14.3-1.pgdg110+1
PGDATA=/var/lib/postgresql/data
HOME=/root

➜ kubernetes git:(main) ✗ kubectl exec pod-envfrom-configmap -c webapps -- printenv
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=pod-envfrom-configmap
DATABASE_USER=crud_apps
DATABASE_NAME=crud_apps
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_PASSWORD=crud_apps
NGINX_VERSION=1.21.6
NJS_VERSION=0.7.3
PKG_RELEASE=1~bullseye
HOME=/root
```

## What is Secret?

A Secret is an object that contains a small amount of sensitive data such as a password, a token, or a key. Such information might otherwise be put in a Pod specification or in a container image. Using a Secret means that you don't need to include confidential data in your application code.

Because Secrets can be created independently of the Pods that use them, there is less risk of the Secret (and its data) being exposed during the workflow of creating, viewing, and editing Pods. Kubernetes, and applications that run in your cluster, can also take additional precautions with Secrets, such as avoiding writing secret data to nonvolatile storage.

Secrets are similar to ConfigMaps but are specifically intended to hold confidential data.

There are three main ways for a Pod to use a Secret:

1. As files in a volume mounted on one or more of its containers.
2. As container environment variable.
3. By the kubelet when pulling images for the Pod.

There are several options to create a Secret:

1. create Secret using `kubectl create secret` command
2. create Secret from config file
3. create Secret using kustomize

The values for all keys in the data field have to be base64-encoded strings. If the conversion to base64 string is not desirable, you can choose to specify the stringData field instead, which accepts arbitrary strings as values.

If you want to skip the Base64 encoding step, you can create the same Secret using the `kubectl create secret` command. For example:

{% highlight bash %}
kubectl create secret generic db-credential \
--from-literal='POSTGRES_PASSWORD=crud_apps' \
--from-literal='POSTGRES_USER=crud_apps'
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ kubernetes git:(main) kubectl create secret generic db-credential `
> --from-literal='POSTGRES_PASSWORD=crud_apps' `
> --from-literal='POSTGRES_USER=crud_apps'
secret/db-credential created

➜ kubernetes git:(main) kubectl get secret
NAME                  TYPE                                  DATA   AGE
db-credential         Opaque                                2      10s
default-token-5z46t   kubernetes.io/service-account-token   3      4d3h

➜ kubernetes git:(main) kubectl describe secret db-credential
Name:         db-credential
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
POSTGRES_PASSWORD:  9 bytes
POSTGRES_USER:      9 bytes
```

## Using Secret as Ref for `envFrom`

When you have a Secret in your cluster, you can include all Secret data into your container using `envFrom` like this:

{% highlight yaml %}
apiVersion: v1
kind: Pod
metadata:
  name: pod-env-envfrom-secret
  labels:
    app: postgres
spec:
  containers:
    - name: database
      image: postgres
      imagePullPolicy: IfNotPresent
      env:
        - name: POSTGRES_DB
          value: crud_apps
      envFrom:
        - secretRef:
            name: db-credential
            optional: false
      ports:
        - containerPort: 5432
  restartPolicy: Always
{% endhighlight %}

Jika dijalankan seperti berikut:

```powershell
➜ kubernetes git:(main) kubectl apply -f .\02-workloads\01-pod\pod-env-envfrom-secret.yaml
pod/pod-env-envfrom-secret created

➜ kubernetes git:(main) kubectl get pod
NAME                     READY   STATUS    RESTARTS   AGE
pod-env-envfrom-secret   1/1     Running   0          11s

➜ kubernetes git:(main) kubectl describe pod pod-env-envfrom-secret
Name:         pod-env-envfrom-secret
Namespace:    default
Priority:     0
Node:         minikube-m03/192.168.49.4
Start Time:   Thu, 26 May 2022 15:16:51 +0700
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
      Started:      Thu, 26 May 2022 15:16:52 +0700
    Ready:          True
    Restart Count:  0
    Environment Variables from:
      db-credential  Secret  Optional: false
    Environment:
      POSTGRES_DB:  crud_apps
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
  Normal  Scheduled  33s   default-scheduler  Successfully assigned default/pod-env-envfrom-secret to minikube-m03
  Normal  Pulled     33s   kubelet            Container image "postgres" already present on machine
  Normal  Created    33s   kubelet            Created container database
  Normal  Started    33s   kubelet            Started container database

➜ kubernetes git:(main) kubectl exec pod-env-envfrom-secret -- printenv
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/postgresql/14/bin
HOSTNAME=pod-env-envfrom-secret
POSTGRES_USER=crud_apps
POSTGRES_DB=crud_apps
POSTGRES_PASSWORD=crud_apps
GOSU_VERSION=1.14
LANG=en_US.utf8
PG_MAJOR=14
PG_VERSION=14.3-1.pgdg110+1
PGDATA=/var/lib/postgresql/data
HOME=/root
```

Or you can define Secret in file too, like this:

{% gist page.gist "03f-pod-env-envfrom-secret.yaml" %}

Jika dijalankan seperti berikut:

```powershell
➜ kubernetes git:(main) kubectl apply -f .\02-workloads\01-pod\pod-env-envfrom-secret.yaml
secret/db-cred created
pod/pod-env-envfrom-secret created

➜ kubernetes git:(main) kubectl get secret
NAME                  TYPE                                  DATA   AGE
db-cred               Opaque                                2      11s
default-token-plxx7   kubernetes.io/service-account-token   3      74s

➜ kubernetes git:(main) kubectl describe secret db-cred
Name:         db-cred
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
POSTGRES_PASSWORD:  18 bytes
POSTGRES_USER:      9 bytes

➜ kubernetes git:(main) kubectl get pod
NAME                     READY   STATUS    RESTARTS   AGE
pod-env-envfrom-secret   1/1     Running   0          40s

➜ kubernetes git:(main) kubectl describe pod pod-env-envfrom-secret
Name:         pod-env-envfrom-secret
Namespace:    default
Priority:     0
Node:         minikube-m03/192.168.49.4
Start Time:   Thu, 26 May 2022 15:23:18 +0700
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
      Started:      Thu, 26 May 2022 15:23:18 +0700
    Ready:          True
    Restart Count:  0
    Environment Variables from:
      db-cred  Secret  Optional: false
    Environment:
      POSTGRES_DB:  crud_apps
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-gkxpf (ro)
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
  Normal  Scheduled  59s   default-scheduler  Successfully assigned default/pod-env-envfrom-secret to minikube-m03
  Normal  Pulled     59s   kubelet            Container image "postgres" already present on machine
  Normal  Created    59s   kubelet            Created container database
  Normal  Started    59s   kubelet            Started container database
```

## Using Secret as Ref for `valueFrom`

Selain menggunakan `envFrom` yang meng-include semua data dalam object Secret, kita juga bisa gunakan sebagian data dari object Secret tersebut menggunakan `valueFrom` dalam `env`.

Hal ini berguna, untuk me-reused environment variable tersebut ke beberapa container atau pod atau workload resource lainnya. Contohnya seperti berikut:

{% gist page.gist "03f-pod-env-valuefrom-secret.yaml" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ kubernetes git:(main) kubectl apply -f .\02-workloads\01-pod\pod-env-valuefrom-secret.yaml
secret/db-cred created
configmap/db-config created
pod/pod-env-valuefrom-secret created

➜ kubernetes git:(main) kubectl get secret
NAME                  TYPE                                  DATA   AGE
db-cred               Opaque                                2      10s
default-token-zx6bv   kubernetes.io/service-account-token   3      32s

➜ kubernetes git:(main) kubectl describe secret db-cred
Name:         db-cred
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
PASSWORD:  18 bytes
USER:      9 bytes

➜ kubernetes git:(main) kubectl get configmap
NAME               DATA   AGE
db-config          1      28s
kube-root-ca.crt   1      33s

➜ kubernetes git:(main) kubectl describe configmap db-config
Name:         db-config
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
DB_NAME:
----
crud_apps


➜ kubernetes git:(main) kubectl get pod
NAME                       READY   STATUS    RESTARTS   AGE
pod-env-valuefrom-secret   2/2     Running   0          64s

➜ kubernetes git:(main) kubectl describe pod pod-env-valuefrom-secret
Name:         pod-env-valuefrom-secret
Namespace:    default
Priority:     0
Node:         minikube-m03/192.168.49.4
Start Time:   Thu, 26 May 2022 15:35:18 +0700
Labels:       app=postgres
Annotations:  <none>
Status:       Running
IP:           10.244.2.6
IPs:
  IP:  10.244.2.6
Containers:
  database:
    Image:          postgres
    Port:           5432/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Thu, 26 May 2022 15:35:18 +0700
    Ready:          True
    Restart Count:  0
    Environment:
      POSTGRES_PASSWORD:  <set to the key 'PASSWORD' in secret 'db-cred'>       Optional: false
      POSTGRES_USER:      <set to the key 'USER' in secret 'db-cred'>           Optional: false
      POSTGRES_DB:        <set to the key 'DB_NAME' of config map 'db-config'>  Optional: false
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-hw7gz (ro)
  webapps:
    Image:          nginx
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Thu, 26 May 2022 15:35:22 +0700
    Ready:          True
    Restart Count:  0
    Environment:
      DATABASE_PASSWORD:  <set to the key 'PASSWORD' in secret 'db-cred'>       Optional: false
      DATABASE_USER:      <set to the key 'USER' in secret 'db-cred'>           Optional: false
      DATABASE_NAME:      <set to the key 'DB_NAME' of config map 'db-config'>  Optional: false
      DATABASE_HOST:      localhost
      DATABASE_PORT:      5432
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-hw7gz (ro)
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
  Normal  Scheduled  76s   default-scheduler  Successfully assigned default/pod-env-valuefrom-secret to minikube-m03
  Normal  Pulled     76s   kubelet            Container image "postgres" already present on machine
  Normal  Created    76s   kubelet            Created container database
  Normal  Started    76s   kubelet            Started container database
  Normal  Pulling    76s   kubelet            Pulling image "nginx"
  Normal  Pulled     72s   kubelet            Successfully pulled image "nginx" in 3.7097657s
  Normal  Created    72s   kubelet            Created container webapps
  Normal  Started    72s   kubelet            Started container webapps

➜ kubernetes git:(main) kubectl exec pod-env-valuefrom-secret -c database -- printenv
HOSTNAME=pod-env-valuefrom-secret
POSTGRES_PASSWORD=crud_apps_password
POSTGRES_USER=crud_apps
POSTGRES_DB=crud_apps
GOSU_VERSION=1.14
LANG=en_US.utf8
PG_MAJOR=14
PG_VERSION=14.3-1.pgdg110+1
PGDATA=/var/lib/postgresql/data
HOME=/root

➜ kubernetes git:(main) kubectl exec pod-env-valuefrom-secret -c webapps -- printenv
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=pod-env-valuefrom-secret
DATABASE_PASSWORD=crud_apps_password
DATABASE_USER=crud_apps
DATABASE_NAME=crud_apps
DATABASE_HOST=localhost
DATABASE_PORT=5432
NGINX_VERSION=1.21.6
NJS_VERSION=0.7.3
PKG_RELEASE=1~bullseye
HOME=/root
```
