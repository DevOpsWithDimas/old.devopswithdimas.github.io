---
layout: post
title: "Minikube addons features"
lang: k8s
categories:
- DevOps
- Orchestration
- Kubernetes
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/home/
- https://minikube.sigs.k8s.io/docs/commands/addons/
youtube: 
comments: true
catalog_key: minikube
image_path: /resources/posts/kubernetes/02f-minikube-addons
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Minikube Addons for added functionality features of Kubernetes. Diantaranya yang akan kita bahas adalah

1. Basic usage `addons` command
2. Enable Dashboard & metrics-server using minikube addons
3. Enable Registry-Creds for Private Registry
4. Enable Registry-Creds for Insecure Docker Registry
5. Enable Load balancer service using minikube addons
6. Enable Ingress Controller using minikube addons
7. Enable Storage Provisioning using minikube addons

Ok langsung aja kita ke pembahasan yang pertama

## Basic usage `addons` command

Minikube has a built-in list of applications and services that may be easily deployed, such as Istio or Ingress. Untuk lebih detail temen-temen bisa lihat dokumentasinya menggunakan perintah

{% highlight bash %}
minikube addons --help
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```bash
➜ ~  minikube addons --help
addons modifies minikube addons files using subcommands like `minikube addons enable dashboard`

Available Commands:
  configure   Configures the addon w/ADDON_NAME within minikube (example: `minikube addons configure registry-creds`). For a list of available addons use: minikube addons list
  disable     Disables the addon w/ADDON_NAME within minikube (example: `minikube addons disable dashboard`). For a list of available addons use: minikube addons list
  enable      Enables the addon w/ADDON_NAME within minikube. For a list of available addons use: `minikube addons list`
  images      List image names the addon w/ADDON_NAME used. For a list of available addons use: `minikube addons list`
  list        Lists all available minikube addons as well as their current statuses (enabled/disabled)
  open        Opens the addon w/ADDON_NAME within minikube (example: `minikube addons open dashboard`). For a list of available addons use: minikube addons list

Usage:
  minikube addons SUBCOMMAND [flags] [options]

Use "minikube <command> --help" for more information about a given command.
Use "minikube options" for a list of global command-line options (applies to all commands).
```

To list the available addons for your version of minikube:

{% highlight bash %}
minikube addons list
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```bash
➜ ~  minikube addons list
|-----------------------------|--------------------------------|
|         ADDON NAME          |           MAINTAINER           |
|-----------------------------|--------------------------------|
| ambassador                  | third-party (ambassador)       |
| auto-pause                  | google                         |
| csi-hostpath-driver         | kubernetes                     |
| dashboard                   | kubernetes                     |
| default-storageclass        | kubernetes                     |
| efk                         | third-party (elastic)          |
| freshpod                    | google                         |
| gcp-auth                    | google                         |
| gvisor                      | google                         |
| helm-tiller                 | third-party (helm)             |
| ingress                     | unknown (third-party)          |
| ingress-dns                 | google                         |
| istio                       | third-party (istio)            |
| istio-provisioner           | third-party (istio)            |
| kubevirt                    | third-party (kubevirt)         |
| logviewer                   | unknown (third-party)          |
| metallb                     | third-party (metallb)          |
| metrics-server              | kubernetes                     |
| nvidia-driver-installer     | google                         |
| nvidia-gpu-device-plugin    | third-party (nvidia)           |
| olm                         | third-party (operator          |
|                             | framework)                     |
| pod-security-policy         | unknown (third-party)          |
| portainer                   | portainer.io                   |
| registry                    | google                         |
| registry-aliases            | unknown (third-party)          |
| registry-creds              | third-party (upmc enterprises) |
| storage-provisioner         | google                         |
| storage-provisioner-gluster | unknown (third-party)          |
| volumesnapshots             | kubernetes                     |
|-----------------------------|--------------------------------|
```

To enable an add-on, see:

{% highlight bash %}
minikube addons enable <name>
{% endhighlight %}

To enable an addon at start-up, where `–-addons` option can be specified multiple times:

{% highlight bash %}
minikube start --addons <name> --addons <name2>
{% endhighlight %}

For addons that expose a browser endpoint, you can quickly open them with:

{% highlight bash %}
minikube addons open <name>
{% endhighlight %}

To disable an addon:

{% highlight bash %}
minikube addons disable <name>
{% endhighlight %}

## Enable Dashboard & metrics-server

minikube has integrated support for the [Kubernetes Dashboard UI](https://github.com/kubernetes/dashboard).

The Dashboard is a web-based Kubernetes user interface. You can use it to:

1. deploy containerized applications to a Kubernetes cluster
2. troubleshoot your containerized application
3. manage the cluster resources
4. get an overview of applications running on your cluster
5. creating or modifying individual Kubernetes resources (such as `Deployments`, `Jobs`, `DaemonSets`, etc)

To access the dashboard:

{% gist page.gist "02f-minikube-dashboard.bash" %}

This will enable the dashboard add-on, and open the proxy in the default web browser. seperti berikut:

![minikube-dashboard]({{ page.image_path | prepend: site.baseurl }}/01-minikube-dashboard.png)

## Enable Registry-Creds for Private Registry

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

minikube cluster membutuhkan credential untuk account dari Docker HUB kita bisa menggunakan perintah berikut:

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

## Enable Registry-Creds for Insecure Docker Registry

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
  ___ ___  (_)  ___  (_)| |/ )  _   _ | |_      __
/  _   _  \| |/  _  \| || , <  ( ) ( )|  _ \  / __ \
| ( ) ( ) || || ( ) || || |\ \ | (_) || |_) )(  ___/
(_) (_) (_)(_)(_) (_)(_)(_) (_) \___/ (_,__/  \____)

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

## Enable Load balancer service

A LoadBalancer service is the standard way to expose a service to the internet. With this method, each service gets its own IP address.

Services of type `LoadBalancer` can be exposed via the `minikube tunnel` command. It must be run in a separate terminal window to keep the `LoadBalancer` running. But first you need enable LoadBalencer it self using 

{% gist page.gist "02f-minikube-enable-loadbalancer.bash" %}

Jika di jalankan seperti berikut:

```bash
➜ ~  minikube addons enable metallb
    ▪ Using image metallb/speaker:v0.9.6
    ▪ Using image metallb/controller:v0.9.6
🌟  The 'metallb' addon is enabled

## you should know range ip minikube using this command
➜ ~  minikube node list
minikube        192.168.59.102

➜ ~  minikube addons configure metallb
-- Enter Load Balancer Start IP: 192.168.59.100
-- Enter Load Balancer End IP: 192.168.59.110
    ▪ Using image metallb/speaker:v0.9.6
    ▪ Using image metallb/controller:v0.9.6
✅  metallb was successfully configured
```

Setelah kita kita coba deploy aplikasinya dan expose menggunakan LoadBalancer service seperti berikut:

```bash
➜ ~  kubectl run nginx-app --image nginx:mainline --port 80
pod/nginx-app created

➜ ~  kubectl expose pod nginx-app --type=LoadBalancer --port 80
service/nginx-app exposed

➜ ~  kubectl get service
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)        AGE
kubernetes   ClusterIP      10.96.0.1       <none>           443/TCP        4m58s
nginx-app    LoadBalancer   10.108.206.69   192.168.59.100   80:31341/TCP   10s

➜ ~  curl 192.168.59.100
StatusCode        : 200
StatusDescription : OK
Content           : <!DOCTYPE html>
                    <html>
                    <head>
                    <title>Welcome to nginx!</title>
                    <style>
                    html { color-scheme: light dark; }
                    body { width: 35em; margin: 0 auto;
                    font-family: Tahoma, Verdana, Arial, sans-serif; }
                    </style...
Headers           : {[Connection, keep-alive], [Accept-Ranges, bytes], [Content-Length, 615],
                    [Content-Type, text/html]...}
```

## Enable Ingress Controller