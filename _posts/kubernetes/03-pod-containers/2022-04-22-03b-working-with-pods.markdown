---
layout: post
title: "Working with Pods"
date: 2022-04-22T15:41:53+07:00
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Workloads
refs: 
- https://kubernetes.io/docs/concepts/workloads/pods/#working-with-pods
youtube: 
comments: true
catalog_key: pod-container
image_path: /resources/posts/kubernetes/03b-working-with-pods
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas Working with pods in kubernetes cluster. Seperti yang telah kita bahas di artikel sebelumnya mekipun kita sebetulnnya akan jarang sekali membuat pods secara explicit tpi tidak ada salahnya untuk kita bahas lebih detail ya tentang pod ini. 

Pods are designed as relatively ephemeral, disposable entities. When a Pod gets created (directly by you, or indirectly by a controller), the new Pod is scheduled to run on a Node in your cluster. The Pod remains on that node until the Pod finishes execution, the Pod object is deleted, the Pod is evicted for lack of resources, or the node fails.

> Note: Restarting a container in a Pod should not be confused with restarting a Pod. A Pod is not a process, but an environment for running container(s). A Pod persists until it is deleted.

When you create the manifest for a Pod object, make sure the name specified is a valid DNS subdomain name.

Untuk pembahasan lebih lanjutnya, seperti biasa kita akan bagi menjadi beberapa bagian diantaranya:

1. Pods and Controllers
2. Pod templates
3. Pod update and replacement
4. Pod networking
5. Resource sharing in pods
6. Privileged mode for containers
7. Static pods
8. Container probes

Ok langsung ja kita bahas materi yang pertama

<!--more-->

## Pods and Controllers

Pods are designed as relatively ephemeral, disposable entities. 

You can use workload resources to create and manage multiple Pods for you. A controller for the resource handles replication and rollout and automatic healing in case of Pod failure. For example, if a Node fails, a controller notices that Pods on that Node have stopped working and creates a replacement Pod. The scheduler places the replacement Pod onto a healthy Node.

Here are some examples of workload resources that manage one or more Pods:

1. **Deployment**, managed replicated application on your cluster
2. **StatefulSet**, managed deployment and scalling of a set of Pods with durable storage and persisten identifiers for each Pod.
3. **DaemonSet**, Ensures a copy of a Pod is running accress a set of nodes in a cluster 

## Pod templates

Controllers for workload resources create Pods from a pod template and manage those Pods on your behalf. 

PodTemplates are specifications for creating Pods, and are included in workload resources such as **Deployments**, **Jobs**, and **DaemonSets**.

Each controller for a workload resource uses the `PodTemplate` inside the workload object to make actual Pods. The `PodTemplate` is part of the desired state of whatever workload resource you used to run your app.

The sample below is a manifest for a simple Job with a `template` that starts one container. The container in that Pod prints a message then pauses.

{% highlight yaml %}
apiVersion: batch/v1
kind: Job
metadata:
  name: hello
spec:
  template:
    # This is the pod template
    spec:
      containers:
      - name: hello
        image: busybox:1.28
        command: ['sh', '-c', 'echo "Hello, Kubernetes!" && sleep 3600']
      restartPolicy: OnFailure
    # The pod template ends here
{% endhighlight %}

Modifying the pod template or switching to a new pod template has no direct effect on the Pods that already exist. If you change the pod template for a workload resource, that resource needs to create replacement Pods that use the updated template.

For example, the StatefulSet controller ensures that the running Pods match the current pod template for each StatefulSet object. If you edit the StatefulSet to change its pod template, the StatefulSet starts to create new Pods based on the updated template. Eventually, all of the old Pods are replaced with new Pods, and the update is complete.

> Note: Each workload resource implements its own rules for handling changes to the Pod template.

## Pod update and replacement

As mentioned in the previous section, when the Pod template for a workload resource is changed, the controller creates new Pods based on the updated template instead of updating or patching the existing Pods.

Kubernetes doesn't prevent you from managing Pods directly. It is possible to update some fields of a running Pod, in place. However, Pod update operations like `patch`, and `replace` have some limitations:

1. Most of the metadata about a Pod is immutable. For example, you cannot change the `namespace`, `name`, `uid`, or `creationTimestamp` fields; the `generation` field is unique. It only accepts updates that increment the field's current value.

2. If the `metadata.deletionTimestamp` is set, no new entry can be added to the `metadata.finalizers` list.

3. Pod updates may not change fields other than `spec.containers[*].image`, `spec.initContainers[*].image`, `spec.activeDeadlineSeconds` or `spec.tolerations`. For `spec.tolerations`, you can only add new entries.

Jika kita coba seperti berikut:

```powershell
➜ ~  kubectl run nginx --image nginx:mainline --port 80
pod/nginx created

➜ ~  kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          33s

➜ ~ kubectl patch pod nginx --type='json' -p='[{"op": "replace", "path": "/spec/containers/0/image", "value": "nginx:latest"}]'
pod/nginx patched

➜ ~  kubectl describe pod nginx
Name:         nginx
Namespace:    default
Priority:     0
Node:         minikube/192.168.49.2
Start Time:   Fri, 22 Apr 2022 06:54:59 +0700
Labels:       run=nginx
Annotations:  <none>
Status:       Running
IP:           172.17.0.3
IPs:
  IP:  172.17.0.3
Containers:
  nginx:
    Container ID:   docker://02537095696f9ddcb0075dc26267004fbf71ed50cdd419ce3ca576d372fb519e
    Image:          nginx:latest
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Fri, 22 Apr 2022 07:13:10 +0700
    Last State:     Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Fri, 22 Apr 2022 06:58:34 +0700
      Finished:     Fri, 22 Apr 2022 07:13:10 +0700
    Ready:          True
    Restart Count:  2
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-b8jcq (ro)
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
  Type    Reason     Age                  From               Message
  ----    ------     ----                 ----               -------
  Normal  Scheduled  21m                  default-scheduler  Successfully assigned default/nginx to minikube
  Normal  Pulling    21m                  kubelet            Pulling image "nginx:mainline"
  Normal  Pulled     21m                  kubelet            Successfully pulled image "nginx:mainline" in 5.4689168s
  Normal  Pulled     18m                  kubelet            Container image "nginx" already present on machine
  Normal  Created    3m33s (x3 over 21m)  kubelet            Created container nginx
  Normal  Started    3m33s (x3 over 21m)  kubelet            Started container nginx
  Normal  Killing    3m33s (x2 over 18m)  kubelet            Container nginx definition changed, will be restarted
  Normal  Pulled     3m33s                kubelet            Container image "nginx:latest" already present on machine
```

## Pod networking

Each Pod is assigned a unique IP address for each address family. Every container in a Pod shares the network namespace, including the IP address and network ports. Inside a Pod (and only then), the containers that belong to the Pod can communicate with one another using `localhost`. When containers in a Pod communicate with entities outside the Pod, they must coordinate how they use the shared network resources (such as ports). Within a Pod, containers share an IP address and port space, and can find each other via `localhost`.

For example if you run multiple containers with same image it will failed to start

{% gist page.gist "03b-failed-port-same-binding.yaml" %}

Jika di jalankan seperti berikut:

```powershell
➜ kubernetes  kubectl apply -f .\03-workloads\01-working-pods\failed-port-same-binding.yaml
pod/webapps-same-image created

➜ kubernetes  kubectl get pods webapps-same-image
NAMESPACE     NAME                               READY   STATUS    RESTARTS        AGE
default       webapps-same-image                 1/2     Error     1 (8s ago)      12s

➜ kubernetes  kubectl describe pod webapps-same-image
Name:         webapps-same-image
Namespace:    default
Priority:     0
Node:         minikube/192.168.49.2
Start Time:   Fri, 22 Apr 2022 10:53:31 +0700
Labels:       app=webapps-same-image
Annotations:  <none>
Status:       Running
IP:           172.17.0.4
IPs:
  IP:  172.17.0.4
Containers:
  nginx1:
    Image:          nginx:mainline
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Fri, 22 Apr 2022 10:53:32 +0700
    Ready:          True
    Restart Count:  0
  nginx2:
    Image:          nginx
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Waiting
      Reason:       CrashLoopBackOff
    Last State:     Terminated
      Reason:       Error
      Exit Code:    1
      Started:      Fri, 22 Apr 2022 10:59:50 +0700
      Finished:     Fri, 22 Apr 2022 10:59:52 +0700
    Ready:          False
    Restart Count:  7

➜ kubernetes ✗  kubectl logs webapps-same-image -c nginx2
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2022/04/22 03:54:25 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
nginx: [emerg] bind() to [::]:80 failed (98: Address already in use)
2022/04/22 03:54:25 [notice] 1#1: try again to bind() after 500ms
2022/04/22 03:54:25 [emerg] 1#1: still could not bind()
```

Sekarang jika kita coba ganti imagenya dengan `bitnami/nginx` yang meng-expose port `8080` dengan perintah seperti berikut:

{% highlight bash %}
kubectl patch pods webapps-same-image --type='json' -p '[{"op": "replace", "path": "/spec/containers/1/image", "value": "bitnami/nginx"}]'
{% endhighlight %}

Sekarang jika kita jalankan dan lihat hasilnya seperti berikut:

```powershell
➜ kubernetes ✗  kubectl patch pods webapps-same-image --type='json' -p '[{"op": "replace", "path": "/
spec/containers/1/image", "value": "bitnami/nginx"}]'
pod/webapps-same-image patched

➜ kubernetes  kubectl get pods webapps-same-image
NAME                 READY   STATUS    RESTARTS        AGE
webapps-same-image   2/2     Running   8 (2m55s ago)   9m16s

➜ 01-working-pods  kubectl exec pod/webapps-same-image -c nginx1 -- curl localhost
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   615  100   615    0     0   600k      0 --:--:-- --:--:-- --:--:--  600k
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>

➜ 01-working-pods  kubectl exec pod/webapps-same-image -c nginx1 -- curl localhost:8080
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   615  100   615    0     0   600k      0 --:--:-- --:--:-- --:--:--  600k
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

## Resource sharing in pods

Pods enable data sharing among their containers. A Pod can specify a set of shared storage volumes. All containers in the Pod can access the shared volumes, allowing those containers to share data. Volumes also allow persistent data in a Pod to survive in case one of the containers within needs to be restarted. See Storage for more information on how Kubernetes implements shared storage and makes it available to Pods.

For example we'll create 2 containers using same volumes using `hostPath` driver, yang perlu kita siapkan adalah file `index.html` dan `pods.yaml` seperti berikut:

{% gist page.gist "03b-index.html" %}

{% gist page.gist "03b-pods-share-volumes.yaml" %}

Jika kita jalankan seperti berikut:

```powershell
➜ kubernetes  minikube ssh
Last login: Fri Apr 22 00:41:21 2022 from 192.168.49.1

docker@minikube:~$ sudo mkdir -p /data/nginx/html

docker@minikube:~$ sudo chmod -R 777 /data/nginx/html

docker@minikube:~$ exit

➜ kubernetes  minikube cp .\03-workloads\01-working-pods\index.html minikube:/data/nginx/html/index
.html

➜ kubernetes  minikube ssh
Last login: Fri Apr 22 00:44:38 2022 from 192.168.49.1

docker@minikube:~$ ls /data/nginx/html/
index.html

docker@minikube:~$ exit

➜ kubernetes  kubectl apply -f .\03-workloads\01-working-pods\pod-storage-volume.yaml
pod/webapps created

➜ kubernetes  kubectl describe pod webapps
Name:         webapps
Namespace:    default
Priority:     0
Node:         minikube/192.168.49.2
Start Time:   Fri, 22 Apr 2022 08:18:40 +0700
Labels:       app=webapps
Annotations:  <none>
Status:       Running
IP:           172.17.0.3
IPs:
  IP:  172.17.0.3
Containers:
  nginx:
    Container ID:   docker://5d38a4c5ec182e594499560130cd621e4e5111196db63181f41269fa9665ed1e
    Image:          nginx:mainline
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Fri, 22 Apr 2022 08:18:41 +0700
    Ready:          True
    Restart Count:  0
    Environment:
      NGINX_PORT:  80
    Mounts:
      /usr/share/nginx/html/index.html from index-html-file (ro,path="index.html")
  bitnami:
    Container ID:   docker://21d739a004cddc6659892d3e8921950c4a7df4e6431804046f39d4b99717737b
    Image:          bitnami/nginx
    Port:           90/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Fri, 22 Apr 2022 08:18:58 +0700
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /app/index.html from index-html-file (ro,path="index.html")
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  index-html-file:
    Type:          HostPath (bare host directory volume)
    Path:          /data/nginx/html
    HostPathType:  DirectoryOrCreate
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  85s   default-scheduler  Successfully assigned default/webapps to minikube
  Normal  Pulled     84s   kubelet            Container image "nginx:mainline" already present on mac
hine
  Normal  Created    84s   kubelet            Created container nginx
  Normal  Started    84s   kubelet            Started container nginx
  Normal  Pulling    84s   kubelet            Pulling image "bitnami/nginx"
  Normal  Pulled     67s   kubelet            Successfully pulled image "bitnami/nginx" in 16.8660425
s
  Normal  Created    67s   kubelet            Created container bitnami
  Normal  Started    67s   kubelet            Started container bitnami

➜ kubernetes ✗  kubectl exec -it pod/webapps -c nginx -- curl localhost
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimu
m-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Belajar Kubernetes</title>
</head>
<body>
<h3>Halo from kubernetes same volume</h3>
</body>
</html>

➜ kubernetes  kubectl exec -it pod/webapps -c bitnami -- curl localhost:8080
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimu
m-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Belajar Kubernetes</title>
</head>
<body>
<h3>Halo from kubernetes same volume</h3>
</body>
</html>
```

## Privileged mode for containers

In Linux, any container in a Pod can enable privileged mode using the `privileged` (Linux) flag on the [security context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) of the container spec. This is useful for containers that want to use operating system administrative capabilities such as manipulating the network stack or accessing hardware devices.

If your cluster has the `WindowsHostProcessContainers` feature enabled, you can create a [Windows HostProcess pod](https://kubernetes.io/docs/tasks/configure-pod-container/create-hostprocess-pod) by setting the `windowsOptions.hostProcess` flag on the security context of the pod spec. All containers in these pods must run as Windows HostProcess containers. HostProcess pods run directly on the host and can also be used to perform administrative tasks as is done with Linux privileged containers.

Untuk lebih detailnya nanti kita bahas di section security.

## Static pods

Static Pods are managed directly by the kubelet daemon on a specific node, without the API server observing them. Whereas most Pods are managed by the control plane (for example, a Deployment), for static Pods, the kubelet directly supervises each static Pod (and restarts it if it fails).

Static Pods are always bound to one Kubelet on a specific node. The main use for static Pods is to run a self-hosted control plane: in other words, using the kubelet to supervise the individual [control plane components](https://kubernetes.io/docs/concepts/overview/components/#control-plane-components).

For examples:

```powershell
➜ ~  kubectl get pods -n kube-system
NAME                               READY   STATUS    RESTARTS     AGE
coredns-64897985d-ltz54            1/1     Running   0            9h
etcd-minikube                      1/1     Running   0            9h
kube-apiserver-minikube            1/1     Running   0            9h
kube-controller-manager-minikube   1/1     Running   0            9h
kube-proxy-6l2r2                   1/1     Running   0            9h
kube-scheduler-minikube            1/1     Running   0            9h
storage-provisioner                1/1     Running   1 (9h ago)   9h
```

## Container probes

A probe is a diagnostic performed periodically by the kubelet on a container. To perform a diagnostic, the kubelet can invoke different actions:

1. `ExecAction` (performed with the help of the container runtime)
2. `TCPSocketAction` (checked directly by the kubelet)
3. `HTTPGetAction` (checked directly by the kubelet)

Untuk lebih detailnya nanti kita akan bahas di materi selanjutnya.