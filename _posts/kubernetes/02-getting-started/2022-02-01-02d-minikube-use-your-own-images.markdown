---
layout: post
title: "Using your own image into Minikube cluster"
date: 2022-02-01T23:12:50+07:00
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/home/
- https://minikube.sigs.k8s.io/docs/handbook/pushing/
youtube: 
comments: true
catalog_key: minikube
image_path: /resources/posts/kubernetes/02d-minikube-push-images
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---


Hai semuanya, di materi kali ini kita akan membahas Menggunakan image yang kita buat pada Kubernetes cluster dengan Minikube. Jadi selain menggunakan service yang di publish oleh official image docker/podman terkadang kita juga perlu menjalankan service docker/podman image yang kita buat sendiri. Ada beberapa cara yang bisa kita gunakan pada Minikube cluster

1. Save/Load from archive `.tar` files
2. Build container image in minikube cluster
3. Publish to public registry

Ok langsung aja kita ke pembahasan yang pertama

## Save/Load from archive `.tar` files

Untuk menggunakan Save/Load Container image pada minikube, kita perlu build dulu image yang akan kita gunakan, contohnya berikut adalah file `Dockerfile` 

{% gist page.gist "02d-dockerfile" %}

Dan berikut adalah file `index.html` yang digunakan pada `Dockerfile` diatas:

{% gist page.gist "02d-index.html" %}

Sekarang kita coba build dengan menggunakan perintah docker seperti berikut:

{% gist page.gist "02d-docker-build-context.bash" %}

Jika dirunning hasilnya seperti berikut:

```powershell
➜ 01-getting-started  docker build -t dimmaryanto93/kubernetes-cource:1.0 .
[+] Building 3.9s (7/7) FINISHED
 => [internal] load build definition from Dockerfile                                           0.0s
 => => transferring dockerfile: 31B                                                            0.0s
 => [internal] load .dockerignore                                                              0.0s
 => => transferring context: 2B                                                                0.0s
 => [internal] load metadata for docker.io/library/nginx:mainline                              3.8s
 => [internal] load build context                                                              0.0s
 => => transferring context: 32B                                                               0.0s
 => [1/2] FROM docker.io/library/nginx:mainline@sha256:2834dc507516af02784808c5f48b7cbe38b8ed  0.0s
 => CACHED [2/2] COPY index.html /usr/share/nginx/html/                                        0.0s
 => exporting to image                                                                         0.0s
 => => exporting layers                                                                        0.0s
 => => writing image sha256:7b1c3ff864355cd0c597c87ba6bf6bed73f8313bd30e9e2ce1ea9575bb749963   0.0s
 => => naming to docker.io/dimmaryanto93/kubernetes-cource:1.0
```

Sekarang setelah kita memiliki container image, kita akan load container image tersebut ke minikube cluster dengan menggunakan perintah `minikube image` 

```powershell
➜ 01-getting-started  minikube image -h
Manage images

Available Commands:
  build       Build a container image in minikube
  load        Load a image into minikube
  ls          List images
  pull        Pull images
  push        Push images
  rm          Remove one or more images
  save        Save a image from minikube
  tag         Tag images

Use "minikube <command> --help" for more information about a given command.
```

Pertama kita akan menggunakan perintah `image load` command pada minikube, Untuk perintah load kita bisa menggunakan 2 cara yaitu directly from docker image atau dengan load from file `.tar`. Nah kalau saya sendiri lebih sering menggunakan directly from docker image dengan perintah seperti berikut:

{% gist page.gist "02d-minikube-load-docker-image.bash" %}

Jika sudah selesai, kita bisa lihat dengan menggunakan perintah

{% gist page.gist "02d-minikube-image-list.bash" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ 01-getting-started  minikube image load dimmaryanto93/kubernetes-cource:1.0

➜ 01-getting-started  minikube image ls
...
docker.io/dimmaryanto93/kubernetes-cource:1.0
```

Nah sekarang setelah imagenya tersedia di cluster, kita bisa jalankan dengan menggunakan perintah `kubectl run --image-pull-policy='Never'` seperti berikut:

{% gist page.gist "02d-kubectl-run-load-image.bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ 01-getting-started  kubectl run nginx-app --image='dimmaryanto93/kubernetes-cource:1.0' --image-pull-policy='Never' --port=80
pod/nginx-app created

➜ 01-getting-started  kubectl get pod
NAME        READY   STATUS    RESTARTS   AGE
nginx-app   1/1     Running   0          10s
```

## Build container image in minikube cluster

Selain menggunakan Save/Load kita juga bisa menggunakan build directly ke minikube cluster menggunakan perintah `minikube image build` Untuk lebih detail kita bisa check dokumentasinya:

```powershell
➜ 01-getting-started  minikube image build -h
Build a container image, using the container runtime.

Examples:
minikube image build .

Options:
      --all=false: Build image on all nodes.
      --build-env=[]: Environment variables to pass to the build. (format: key=value)
      --build-opt=[]: Specify arbitrary flags to pass to the build. (format: key=value)
  -f, --file='': Path to the Dockerfile to use (optional)
  -n, --node='': The node to build on. Defaults to the primary control plane.
      --push=false: Push the new image (requires tag)
  -t, --tag='': Tag to apply to the new image (optional)

Usage:
  minikube image build PATH | URL | - [flags] [options]

Use "minikube options" for a list of global command-line options (applies to all commands).
```

Sekarang kita coba untuk build docker image yang sebelumnya, dengan perintah seperti berikut:

{% gist page.gist "02d-minikube-image-build-minikube.bash" %}

Jika dijalankan hasilnya seperti berikut:

```powershell
➜ 01-getting-started  minikube image build -t dimmaryanto93/kubernetes-cource:1.1 .
Sending build context to Docker daemon  9.216kB
Step 1/2 : FROM nginx:mainline
 ---> c316d5a335a5
Step 2/2 : COPY index.html /usr/share/nginx/html/
 ---> 9a6dfda72b33
Successfully built 9a6dfda72b33
Successfully tagged dimmaryanto93/kubernetes-cource:1.1

➜ 01-getting-started  minikube image ls dimmaryanto93/kubernetes-cource
...
docker.io/dimmaryanto93/kubernetes-cource:1.1
docker.io/dimmaryanto93/kubernetes-cource:1.0

➜ 01-getting-started ✗  kubectl set image pod/nginx-app nginx-app='dimmaryanto93/kubernetes-cource:1.1'
pod/nginx-app image updated

➜ 01-getting-started  kubectl get pod
NAME        READY   STATUS    RESTARTS      AGE
nginx-app   1/1     Running   1 (19s ago)   100s

➜ 01-getting-started  kubectl describe pod nginx-app
Name:         nginx-app
Namespace:    default
Priority:     0
Node:         minikube/192.168.59.119
Start Time:   Tue, 01 Feb 2022 18:48:23 +0700
Labels:       run=nginx-app
Annotations:  <none>
Status:       Running
IP:           172.17.0.3
IPs:
  IP:  172.17.0.3
Containers:
  nginx-app:
    Container ID:   docker://c78bf452350b1371120d1439bf7fff48a5f3f2115c336f4b8108ad3ae5f06f19
    Image:          dimmaryanto93/kubernetes-cource:1.1
    Image ID:       docker://sha256:9a6dfda72b3330b8725de35c6e8934e9b35fe1eef8393e2e0b5708a72b23b6c0
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Tue, 01 Feb 2022 18:49:44 +0700
    Last State:     Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Tue, 01 Feb 2022 18:48:25 +0700
      Finished:     Tue, 01 Feb 2022 18:49:44 +0700
    Ready:          True
    Restart Count:  1
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-s6dfp (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  kube-api-access-s6dfp:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age                 From               Message
  ----    ------     ----                ----               -------
  Normal  Scheduled  2m7s                default-scheduler  Successfully assigned default/nginx-app to minikube
  Normal  Pulled     2m6s                kubelet            Container image "dimmaryanto93/kubernetes-cource:1.0" already present on machine
  Normal  Created    46s (x2 over 2m6s)  kubelet            Created container nginx-app
  Normal  Started    46s (x2 over 2m5s)  kubelet            Started container nginx-app
  Normal  Killing    46s                 kubelet            Container nginx-app definition changed, will be restarted
  Normal  Pulled     46s                 kubelet            Container image "dimmaryanto93/kubernetes-cource:1.1" already present on machine
```

## Publish to public registry

Dengan menggunakan minikube kita juga bisa menggunakan Public Registry seperti [Docker HUB](https://hub.docker.com/), [Red Hat Quay](https://www.redhat.com/en/technologies/cloud-computing/quay) dan lain-lain.

Sekarang yang kita perlu lakukan adalah coba push imagenya ke Public Registry, misalnnya kita menggunakan Docker HUB dengan perintahnya seperti berikut:

{% highlight bash %}
docker login

docker push dimmaryanto93/kubernetes-cource:1.0
{% endhighlight %}

Seperti berikut hasilnya:

![docker-private-registry]({{ page.image_path | prepend: site.baseurl }}/01-registry-docker.png)

Jika dijalankan maka hasilnya seperti berikut:

```bash
➜  ~ kubectl run nginx-private-app --image dimmaryanto93/kubernetes-cource:1.0
pod/nginx-private-app created

➜  ~ kubectl get pod
NAME                READY   STATUS    RESTARTS   AGE
nginx-private-app   1/1     Running   0          71s

➜  ~ kubectl describe pod/nginx-private-app
Name:         nginx-private-app
Namespace:    default
Priority:     0
Node:         minikube/192.168.59.116
Start Time:   Tue, 01 Feb 2022 22:00:28 +0700
Labels:       run=nginx-private-app
Annotations:  <none>
Status:       Running
IP:           172.17.0.3
IPs:
  IP:  172.17.0.3
Containers:
  nginx-private-app:
    Container ID:   docker://7d7c24228450ec909bdff802bf7c3cfba856f95985b882f70f6f7f1e28424d44
    Image:          dimmaryanto93/kubernetes-cource:1.0
    Image ID:       docker-pullable://dimmaryanto93/kubernetes-cource@sha256:bce870a1cfc768aa9cb6affe71e18ac7dc3c6997ad016d3ce44af0e8ecae50c9
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Tue, 01 Feb 2022 22:01:09 +0700
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-7zv7k (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  kube-api-access-7zv7k:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  95s   default-scheduler  Successfully assigned default/nginx-private-app to minikube
  Normal  Pulling    94s   kubelet            Pulling image "dimmaryanto93/kubernetes-cource:1.0"
  Normal  Pulled     54s   kubelet            Successfully pulled image "dimmaryanto93/kubernetes-cource:1.0" in 39.727921156s
  Normal  Created    54s   kubelet            Created container nginx-private-app
  Normal  Started    54s   kubelet            Started container nginx-private-app
```