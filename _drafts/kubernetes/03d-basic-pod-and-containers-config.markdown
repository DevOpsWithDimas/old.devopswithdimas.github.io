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
- https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/
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
6. Define a Command and Args for a Container
7. Using `ports` in containerSpec

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

## Using `imagePullSecrets` for pull image from private registry

Private registries may require keys to read images from them.
Credentials can be provided in several ways:

1. Configuring Nodes to Authenticate to a Private Registry
2. Pre-pulled Images
3. Specifying ImagePullSecrets on a Pod
4. Vendor-specific or local extensions

Berdasarkan beberapa cara tersebut, biasanya klo saya untuk development menggunakan cara pertama sedangkan untuk Production menggunakan cara yang ketiga yaitu Specifying ImagePullSecrets on a Pod. 

Jadi sekarang kita akan menggunakan Specifying `ImagePullSecrets` on a Pod dengan cara membuat a Secret object dengan Docker config. 

You need to know the `username`, registry `password` and client email address for authenticating to the registry, as well as its hostname. Run the following command, substituting the appropriate uppercase values:

{% highlight bash %}
kubectl create secret docker-registry <name> \
--docker-server=DOCKER_REGISTRY_SERVER \
--docker-username=DOCKER_USER \
--docker-password=DOCKER_PASSWORD \
--docker-email=DOCKER_EMAIL
{% endhighlight %}

If you already have a Docker credentials file then, rather than using the above command, you can import the credentials file as a Kubernetes Secrets.

{% highlight bash %}
kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=<path/to/.docker/config.json> \
    --type=kubernetes.io/dockerconfigjson
{% endhighlight %}

Jika dijalankan seperti berikut:

```bash
➜ kubernetes git:(main) minikube ssh
docker@minikube:~$

docker@minikube:~$ docker login -u dimmaryanto93
Password:
WARNING! Your password will be stored unencrypted in /home/docker/.docker/config.json.
Configure a credential helper to remove this warning.

Login Succeeded

docker@minikube:~$ ls ~/.docker/
config.json

docker@minikube:~$ exit
➜ minikube cp minikube:/home/docker/.docker/config.json .docker/config.json

➜ kubernetes git:(main) kubectl create secret generic dockerhub `
> --from-file=.dockerconfigjson=.docker/config.json `
> --type=kubernetes.io/dockerconfigjson
secret/dockerhub created

➜ kubernetes git:(main) kubectl get secret dockerhub
NAME        TYPE                             DATA   AGE
dockerhub   kubernetes.io/dockerconfigjson   1      22s

➜ kubernetes git:(main) ✗ kubectl describe secret dockerhub
Name:         dockerhub
Namespace:    default

Type:  kubernetes.io/dockerconfigjson

Data
====
.dockerconfigjson:  124 bytes
```

Setelah itu kita bisa buat Workload resourcenya dari image yang di store di private registry atau Insecure Registry dengan manambahkan `ImagePullSecrets` seperti berikut:

{% gist page.gist "03d-pod-private-registry-pull-secret.yaml" %}

Jika dijalankan hasilnya seperti berikut:

```powershell
➜ kubernetes git:(main) kubectl -f .\02-workloads\01-pod\pod-private-registry-pull-secret.yaml apply
pod/webapp-private created

➜ kubernetes git:(main) kubectl get pod
NAME             READY   STATUS    RESTARTS   AGE
webapp-private   1/1     Running   0          43s

➜ kubernetes git:(main) kubectl describe pod webapp-private
Name:         webapp-private
Namespace:    default
Priority:     0
Node:         minikube/192.168.49.2
Start Time:   Fri, 29 Apr 2022 16:34:52 +0700
Labels:       app=webapp-private
Annotations:  <none>
Status:       Running
IP:           172.17.0.3
IPs:
  IP:  172.17.0.3
Containers:
  webapp-private:
    Image:          dimmaryanto93/kubernetes-udemy:1.0
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Fri, 29 Apr 2022 16:35:22 +0700
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-m95w2 (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  60s   default-scheduler  Successfully assigned default/webapp-private to minikube
  Normal  Pulling    60s   kubelet            Pulling image "dimmaryanto93/kubernetes-udemy:1.0"
  Normal  Pulled     30s   kubelet            Successfully pulled image "dimmaryanto93/kubernetes-udemy:1.0" in 29.075044s
  Normal  Created    30s   kubelet            Created container webapp-private
  Normal  Started    30s   kubelet            Started container webapp-private
```

## Using `env` (Environment Variables)

When you create a Pod, you can set environment variables for the containers that run in the Pod. To set environment variables, include the `env` or `envFrom` field in the configuration file.

For example, you create a Pod that runs one container. The configuration file for the Pod defines an environment variable with name `MYSQL_PASSWORD` and value "keepSecret". Here is the configuration manifest for the Pod:

{% gist page.gist "03d-pod-env.yaml" %}

Sekarang kita coba jalankan, maka hasilnya seperti berikut:

```powershell
➜ kubernetes git:(main) kubectl -f .\02-workloads\01-pod\pod-env.yaml apply
pod/database-env created

➜ kubernetes git:(main) kubectl get pod
NAME           READY   STATUS    RESTARTS   AGE
database-env   1/1     Running   0          48s

➜ kubernetes git:(main) kubectl exec database-env -- printenv
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=database-env
MYSQL_ROOT_PASSWORD=keepSecret
MYSQL_USER=default
MYSQL_PASSWORD=default
MYSQL_DATABASE=bootcamp
...
MYSQL_MAJOR=5.7
MYSQL_VERSION=5.7.38-1debian10
HOME=/root

➜ kubernetes git:(main) kubectl exec -it database-env -- mysql -u default -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.7.38 MySQL Community Server (GPL)

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| bootcamp           |
+--------------------+
2 rows in set (0.00 sec)
```

## Define a Commands and Args for a Container

When you create a Pod, you can define a command and arguments for the containers that run in the Pod. To define a command, include the `command` field in the configuration file. To define arguments for the command, include the `args` field in the configuration file. The command and arguments that you define cannot be changed after the Pod is created.

The command and arguments that you define in the configuration file override the default command and arguments provided by the container image. If you define args, but do not define a command, the default command is used with your new arguments.

> Note: The `command` field corresponds to `entrypoint` in some container runtimes.

For example:

{% gist page.gist "03d-pod-command-args.yaml" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ kubectl -f .\02-workloads\01-pod\pod-command-args.yaml apply
pod/override-command-arg created

➜ kubectl get pod
NAME                   READY   STATUS      RESTARTS   AGE
override-command-arg   0/1     Completed   0          25s

➜ kubernetes git:(main) kubectl logs override-command-arg
Hai aku lagi belajar kubernetes

➜ kubernetes git:(main) kubectl describe pod/override-command-arg
Name:         override-command-arg
Namespace:    default
Priority:     0
Node:         minikube/192.168.49.2
Start Time:   Fri, 29 Apr 2022 19:32:21 +0700
Labels:       app=override-command-arg
Annotations:  <none>
Status:       Succeeded
IP:           172.17.0.3
IPs:
  IP:  172.17.0.3
Containers:
  override-command-arg:
    Image:         alpine
    Port:          <none>
    Host Port:     <none>
    Command:
      echo
    Args:
      Hai aku lagi belajar kubernetes
    State:          Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Fri, 29 Apr 2022 19:32:22 +0700
      Finished:     Fri, 29 Apr 2022 19:32:22 +0700
    Ready:          False
    Restart Count:  0
    Environment:    <none>
Conditions:
  Type              Status
  Initialized       True
  Ready             False
  ContainersReady   False
  PodScheduled      True
s
Events:
  Type     Reason       Age                From               Message
  ----     ------       ----               ----               -------
  Normal   Scheduled    98s                default-scheduler  Successfully assigned def
ault/override-command-arg to minikube
  Normal   Pulled       97s                kubelet            Container image "alpine"
already present on machine
  Normal   Created      97s                kubelet            Created container overrid
e-command-arg
  Normal   Started      97s                kubelet            Started container overrid
e-command-arg
  Warning  FailedMount  95s (x3 over 97s)  kubelet            MountVolume.SetUp failed
for volume "kube-api-access-xtgbq" : object "default"/"kube-root-ca.crt" not registered

```

## Using `ports` in containers

This array, defined in `spec.containers[].ports`, provides a list of ports that get exposed by the container. You don’t really need to specify this list—even if it’s empty, as long as your containers are listening on the port, they’ll still be available for network access. This just provides some extra information to Kubernetes.

For examples:

{% gist page.gist "03d-pod-containers-port.yaml" %}

Jadi pada container `nginx` kita tahu bahwa container tersebut akan menggunakan port `80` dan `443` sedangkan untuk container `mysql` akan menggunakan port `3306`

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ kubectl -f .\02-workloads\01-pod\pod-containers-ports.yaml apply
pod/container-ports created

➜ kubectl get pod
NAME              READY   STATUS    RESTARTS   AGE
container-ports   2/2     Running   0          7s

➜ kubectl describe pod/container-ports
Name:         container-ports
Namespace:    default
Priority:     0
Node:         minikube/192.168.49.2
Start Time:   Sat, 30 Apr 2022 04:33:58 +0700
Labels:       app=container-ports
Annotations:  <none>
Status:       Running
IP:           172.17.0.3
IPs:
  IP:  172.17.0.3
Containers:
  nginx:
    Image:          nginx
    Ports:          80/TCP, 443/TCP
    Host Ports:     0/TCP, 0/TCP
    State:          Running
      Started:      Sat, 30 Apr 2022 04:33:59 +0700
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-w9rc5 (ro
)
  mysql:
    Image:          mysql:5.7
    Port:           3306/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Sat, 30 Apr 2022 04:33:59 +0700
    Ready:          True
    Restart Count:  0
    Environment:
      MYSQL_ROOT_PASSWORD:  password
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
```