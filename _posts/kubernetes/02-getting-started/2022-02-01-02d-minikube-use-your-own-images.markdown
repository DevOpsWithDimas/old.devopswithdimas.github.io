---
layout: post
title: "Using your own image into Minikube cluster"
date: 2022-02-01T23:12:50+07:00
lang: k8s
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
4. Publish to private/insecure registry

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

Dengan menggunakan minikube kita juga bisa menggunakan Private registry seperti 

1. Google Container Registry (GCR),
2. Amazon’s EC2 Container Registry (ECR)
3. Azure Container Registry (ACR)
4. Private Docker registries

You will need to run `addons configure registry-creds` and `addons enable registry-creds` to get up and running. Tapi sebelum itu kita akan coba push dulu image yang telah kita build ke private registry. Contohnya disini kita akan menggunakan [Docker Hub](https://hub.docker.com)

Sekarang kita coba push imagenya, dan kita buat visiblitynya menjadi private

{% highlight bash %}
docker login

docker push dimmaryanto93/kubernetes-cource:1.0
{% endhighlight %}

Seperti berikut hasilnya:

![docker-private-registry]({{ page.image_path | prepend: site.baseurl }}/01-private-registry-docker.png)

Sekarang kita coba deploy podnya dengan perintah seperti berikut:

{% highlight bash %}
kubectl run nginx-private-app --image dimmaryanto93/kubernetes-cource:1.0
{% endhighlight %}

Jika kita jalankan maka hasilnya seperti berikut:

```powershell
➜  ~ kubectl run nginx-private-app --image dimmaryanto93/kubernetes-cource:1.0
pod/nginx-private-app created

➜  ~ kubectl get pods
NAME                READY   STATUS         RESTARTS   AGE
nginx-private-app   0/1     ErrImagePull   0          13s

➜  ~ kubectl describe pod/nginx-private-app
Name:         nginx-private-app
Namespace:    default
Priority:     0
Node:         minikube/192.168.59.116
Start Time:   Tue, 01 Feb 2022 21:45:13 +0700
Labels:       run=nginx-private-app
Annotations:  <none>
Status:       Pending
IP:           172.17.0.3
IPs:
  IP:  172.17.0.3
Containers:
  nginx-private-app:
    Container ID:
    Image:          dimmaryanto93/kubernetes-cource:1.0
    Image ID:
    Port:           <none>
    Host Port:      <none>
    State:          Waiting
      Reason:       ErrImagePull
    Ready:          False
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-4v2zm (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             False
  ContainersReady   False
  PodScheduled      True
Volumes:
  kube-api-access-4v2zm:
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
  Type     Reason     Age                From               Message
  ----     ------     ----               ----               -------
  Normal   Scheduled  43s                default-scheduler  Successfully assigned default/nginx-private-app to minikube
  Normal   Pulling    22s (x2 over 42s)  kubelet            Pulling image "dimmaryanto93/kubernetes-cource:1.0"
  Warning  Failed     18s (x2 over 38s)  kubelet            Failed to pull image "dimmaryanto93/kubernetes-cource:1.0": rpc error: code = Unknown desc = Error response from daemon: pull access denied for dimmaryanto93/kubernetes-cource, repository does not exist or may require 'docker login': denied: requested access to the resource is denied
  Warning  Failed     18s (x2 over 38s)  kubelet            Error: ErrImagePull
  Normal   BackOff    6s (x2 over 37s)   kubelet            Back-off pulling image "dimmaryanto93/kubernetes-cource:1.0"
  Warning  Failed     6s (x2 over 37s)   kubelet            Error: ImagePullBackOff
```

Nah jika temen-temen perhatikan di Events column, terdapat error message `Failed to pull image "dimmaryanto93/kubernetes-cource:1.0": rpc error: code = Unknown desc = Error response from daemon: pull access denied for dimmaryanto93/kubernetes-cource, repository does not exist or may require 'docker login': denied: requested access to the resource is denied`

Artinya si kubernetes perlu credential untuk access repository tersebut, di minikube kita bisa menggunakan perintah berikut:

{% gist page.gist "02d-minikube-config-registry-creds.bash" %}

Dan setelah kita configure, kita gunakan perintah berikut untuk menaktifkan registry credentialnya:

{% gist page.gist "02d-minikube-enable-registry-creds.bash" %}

Jika dijalankan maka hasilnya seperti berikut:

```bash
➜  ~ minikube addons configure registry-creds

Do you want to enable AWS Elastic Container Registry? [y/n]: n
Do you want to enable Google Container Registry? [y/n]: n
Do you want to enable Docker Registry? [y/n]: y
-- Enter docker registry server url: https://index.docker.io/v1/
-- Enter docker registry username: dimmaryanto93
-- Enter docker registry password:
Do you want to enable Azure Container Registry? [y/n]: n
✅  registry-creds was successfully configured

➜  ~ minikube addons enable registry-creds
    ▪ Using image upmcenterprises/registry-creds:1.10
🌟  The 'registry-creds' addon is enabled

## credential store in secret as below
➜  ~ kubectl get secrets -n kube-system
NAME                                             TYPE                                  DATA   AGE
registry-creds-acr                               Opaque                                3      52s
registry-creds-dpr                               Opaque                                3      52s
registry-creds-ecr                               Opaque                                6      52s
registry-creds-gcr                               Opaque                                2      52s

➜  ~ kubectl delete pods --all
pod "nginx-private-app" deleted

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

## Publish to private/insecure registry

minikube allows users to configure the docker engine’s `--insecure-registry` flag. 

You can use the `--insecure-registry` flag on the `minikube start` command to enable insecure communication between the docker engine and registries listening to requests from the CIDR range.

Insecure Registry ini adalah alternative jika container image mau di simpan di on-premis, Ada beberapa container registry yang kita bisa gunakan seperti

1. [Nexus OSS](https://www.sonatype.com/products/repository-oss)
2. [JFrog Artifactory](https://jfrog.com/artifactory/)
3. [Gitlab Container Registry](https://docs.gitlab.com/ee/administration/packages/container_registry.html)
4. dan masih banyak lagi.

Disini saya sudah install insecure-registry menggunakan Nexus dan untuk cara installnya saya sudah pernah bahas di [artikel berikut]({% post_url docker/02-registries/2021-04-24-03c-install-nexus-oss %}) untuk registry urlnya seperti berikut:

1. Hosted registry: `192.168.88.50:8087`
2. Group registry: `192.168.88.50:8086`

Jadi jika kita mau menggunakan insecure registry tersebut kita bisa menggunakan perintah berikut:

{% gist page.gist "02d-minikube-start-with-insecure-registry.bash" %}

Sebelum kita coba, kita coba push dulu ke registry tersebut:

{% highlight bash %}
docker tag dimmaryanto93/kubernetes-cource:1.0 192.168.88.50:8087/udemy/kubernetes/nginx-app:1.0

docker push 192.168.88.50:8087/udemy/kubernetes/nginx-app:1.0
{% endhighlight %}

Maka hasilnya seperti berikut:

![image-insecure-registry]({{ page.image_path | prepend: site.baseurl }}/02-insecure-registry-docker.png)

Sekarang kita coba jalankan:

```bash
➜  ~ minikube start --memory 4g --driver virtualbox \
> --insecure-registry="192.168.88.50:8087,192.168.88.50:8086" \
> -p insecure-registry
😄  [insecure-registry] minikube v1.25.1 on Darwin 12.2
✨  Using the virtualbox driver based on user configuration
👍  Starting control plane node insecure-registry in cluster insecure-registry
🔥  Creating virtualbox VM (CPUs=2, Memory=4096MB, Disk=20000MB) ...
🐳  Preparing Kubernetes v1.23.1 on Docker 20.10.12 ...
    ▪ kubelet.housekeeping-interval=5m
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🔎  Verifying Kubernetes components...
🌟  Enabled addons: storage-provisioner, default-storageclass
🏄  Done! kubectl is now configured to use "insecure-registry" cluster and "default" namespace by default

➜  ~ minikube profile insecure-registry
✅  minikube profile was successfully set to insecure-registry

➜  ~ minikube ssh
                         _             _
            _         _ ( )           ( )
  ___ ___  (_)  ___  (_)| |/')  _   _ | |_      __
/' _ ` _ `\| |/' _ `\| || , <  ( ) ( )| '_`\  /'__`\
| ( ) ( ) || || ( ) || || |\`\ | (_) || |_) )(  ___/
(_) (_) (_)(_)(_) (_)(_)(_) (_)`\___/'(_,__/'`\____)

$ docker info
Client:
 Context:    default
 Debug Mode: false

Server:
 Containers: 14
  Running: 14
  Paused: 0
  Stopped: 0
 Images: 10
 Server Version: 20.10.12
 Storage Driver: overlay2
  Backing Filesystem: extfs
  Supports d_type: true
  Native Overlay Diff: true
  userxattr: false
 Logging Driver: json-file
 Cgroup Driver: systemd
 Cgroup Version: 1
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
 Swarm: inactive
 Runtimes: io.containerd.runc.v2 io.containerd.runtime.v1.linux runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: 7b11cfaabd73bb80907dd23182b9347b4245eb5d
 runc version: 52b36a2dd837e8462de8e01458bf02cf9eea47dd
 init version: de40ad0
 Security Options:
  seccomp
   Profile: default
 Kernel Version: 4.19.202
 Operating System: Buildroot 2021.02.4
 OSType: linux
 Architecture: x86_64
 CPUs: 2
 Total Memory: 3.847GiB
 Name: insecure-registry
 ID: PY6R:ATXB:YQKK:QLMW:PNBD:UV2I:YJ4Q:2XVC:K4BF:WMYX:PB6J:GLRZ
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 Registry: https://index.docker.io/v1/
 Labels:
  provider=virtualbox
 Experimental: false
 Insecure Registries:
  192.168.88.50:8086
  192.168.88.50:8087
  10.96.0.0/12
  127.0.0.0/8
 Live Restore Enabled: false
 Product License: Community Engine
```

Nah sekarang jika kita lihat, pada container runtime sudah terkonfigurasi Insecure Registry. Sekarang kita bisa lakukan registry-creds menggunakan `addons configure registry-creds` atau menggunakan cara manual yaitu `imagePullSecret` object pada podSpec atau deploySpec (Recommended). 

Karena supaya simple kita akan bahas dulu pake `minikube addons configure registry-creds` seperti berikut:

{% gist page.gist "02d-minikube-config-registry-creds.bash" %}

Dan setelah kita configure, kita gunakan perintah berikut untuk menaktifkan registry credentialnya:

{% gist page.gist "02d-minikube-enable-registry-creds.bash" %}

Jika dijalankan maka hasilnya seperti berikut:

```bash
➜  ~ minikube addons configure registry-creds

Do you want to enable AWS Elastic Container Registry? [y/n]: n
Do you want to enable Google Container Registry? [y/n]: n
Do you want to enable Docker Registry? [y/n]: y
-- Enter docker registry server url: 192.168.88.50:8087
-- Enter docker registry username: admin
-- Enter docker registry password:
Do you want to enable Azure Container Registry? [y/n]: n
✅  registry-creds was successfully configured

➜  ~ minikube addons enable registry-creds
    ▪ Using image upmcenterprises/registry-creds:1.10
🌟  The 'registry-creds' addon is enabled

➜  ~ kubectl get secrets -n kube-system
NAME                                             TYPE                                  DATA   AGE
registry-creds-acr                               Opaque                                3      75s
registry-creds-dpr                               Opaque                                3      75s
registry-creds-ecr                               Opaque                                6      75s
registry-creds-gcr                               Opaque                                2      75s

➜  ~ kubectl run nginx-insecure-app --image 192.168.88.50:8087/udemy/kubernetes/nginx-app:1.0
pod/nginx-insecure-app created

➜  ~ kubectl get pods
NAME                 READY   STATUS    RESTARTS   AGE
nginx-insecure-app   1/1     Running   0          13s

➜  ~ kubectl describe pods nginx-insecure-app
Name:         nginx-insecure-app
Namespace:    default
Priority:     0
Node:         insecure-registry/192.168.59.117
Start Time:   Tue, 01 Feb 2022 23:07:49 +0700
Labels:       run=nginx-insecure-app
Annotations:  <none>
Status:       Running
IP:           172.17.0.4
IPs:
  IP:  172.17.0.4
Containers:
  nginx-insecure-app:
    Container ID:   docker://fce02061f60ffda073afd25df53e06d4312931f5dc7be79f872f7582af0458d8
    Image:          192.168.88.50:8087/udemy/kubernetes/nginx-app:1.0
    Image ID:       docker-pullable://192.168.88.50:8087/udemy/kubernetes/nginx-app@sha256:bce870a1cfc768aa9cb6affe71e18ac7dc3c6997ad016d3ce44af0e8ecae50c9
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Tue, 01 Feb 2022 23:07:57 +0700
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-n9ww5 (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  kube-api-access-n9ww5:
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
  Normal  Scheduled  33s   default-scheduler  Successfully assigned default/nginx-insecure-app to insecure-registry
  Normal  Pulling    32s   kubelet            Pulling image "192.168.88.50:8087/udemy/kubernetes/nginx-app:1.0"
  Normal  Pulled     26s   kubelet            Successfully pulled image "192.168.88.50:8087/udemy/kubernetes/nginx-app:1.0" in 6.294481617s
  Normal  Created    25s   kubelet            Created container nginx-insecure-app
  Normal  Started    25s   kubelet            Started container nginx-insecure-app
```