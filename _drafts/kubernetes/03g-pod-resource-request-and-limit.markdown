---
layout: post
title: "Configure Request and Limit of Resources (CPUs & Memory)"
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Workloads
refs: 
- https://kubernetes.io/docs/tasks/configure-pod-container/assign-memory-resource/
- https://kubernetes.io/docs/tasks/configure-pod-container/assign-cpu-resource/
- https://github.com/kubernetes/minikube/issues/13969#issuecomment-1101588469
youtube: 
comments: true
catalog_key: pod-container
image_path: /resources/posts/kubernetes/03h-pod-resource-request-and-limit
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita membahas tentang Resources Limit and Request pada suatu containers dalam Pod. Diantaranya:

1. What is Resource Request and Limit?
2. What is Resource types?
3. What is Resource units?
4. How Kubernetes applies resource requests and limits?
5. Install prerequisite, Before you begin
6. Specify a memory request and a memory limit
7. Exceed a Container's memory limit 
8. Specify a memory request that is too big for your Nodes
9. If you do not specify a memory limit?
10. Specify a CPU request and a CPU limit
11. Specify a CPU request that is too big for your Nodes
12. If you do not specify a CPU limit?
13. Motivation for requests and limits

Ok langsung aja kita bahas materi yang pertama

<!--more-->

## What is Resource Request and Limit?

When you specify a Pod, you can optionally specify how much of each resource a container needs. The most common resources to specify are CPU and memory (RAM); there are others.

When you specify the resource request for containers in a Pod, the kube-scheduler uses this information to decide which node to place the Pod on. When you specify a resource limit for a container, the kubelet enforces those limits so that the running container is not allowed to use more of that resource than the limit you set. The kubelet also reserves at least the request amount of that system resource specifically for that container to use.

If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more resource than its `request` for that resource specifies. However, a container is not allowed to use more than its resource `limit`.

For example, if you set a memory request of `256 MiB` for a container, and that container is in a Pod scheduled to a Node with `8GiB` of memory and no other Pods, then the container can try to use more RAM.

If you set a memory limit of `4GiB` for that container, the kubelet (and container runtime) enforce the limit. The runtime prevents the container from using more than the configured resource limit. For example: when a process in the container tries to consume more than the allowed amount of memory, the system kernel terminates the process that attempted the allocation, with an out of memory (OOM) error.

Limits can be implemented either reactively (the system intervenes once it sees a violation) or by enforcement (the system prevents the container from ever exceeding the limit). Different runtimes can have different ways to implement the same restrictions.

## What is Resource types?

CPU and memory are each a resource type. A resource type has a base unit. CPU represents compute processing and is specified in units of Kubernetes CPUs. Memory is specified in units of bytes. For Linux workloads, you can specify huge page resources. Huge pages are a Linux-specific feature where the node kernel allocates blocks of memory that are much larger than the default page size.

For example, on a system where the default page size is `4KiB`, you could specify a limit, `hugepages-2Mi: 80Mi`. If the container tries allocating over 40 `2MiB` huge pages (a total of 80 MiB), that allocation fails.

CPU and memory are collectively referred to as compute resources, or resources. Compute resources are measurable quantities that can be requested, allocated, and consumed. They are distinct from API resources. API resources, such as Pods and Services are objects that can be read and modified through the Kubernetes API server.

For each container, you can specify resource limits and requests, including the following:

{% highlight yaml %}
spec:
  containers:
    - resources:
        requests:
          memory: "<memory-unit>"
          cpu: "<cpu-unit>"
        limits:
          memory: "<memory-unit>"
          cpu: "<cpu-unit>"
{% endhighlight %}

Although you can only specify requests and limits for individual containers, it is also useful to think about the overall resource requests and limits for a Pod. For a particular resource, a Pod resource request/limit is the sum of the resource requests/limits of that type for each container in the Pod.

## What is Resource units?

Limits and requests for CPU resources are measured in cpu units. In Kubernetes, 1 CPU unit is equivalent to **1 physical CPU core**, or **1 virtual core**, depending on whether the node is a physical host or a virtual machine running inside a physical machine.

Fractional requests are allowed. When you define a container with `spec.containers[].resources.requests.cpu` set to `0.5`, you are requesting half as much CPU time compared to if you asked for `1.0` CPU. For CPU resource units, the quantity expression `0.1` is equivalent to the expression `100m`, which can be read as "one hundred millicpu". Some people say "one hundred millicores", and this is understood to mean the same thing.

CPU resource is always specified as an absolute amount of resource, never as a relative amount. For example, `500m` CPU represents the roughly same amount of computing power whether that container runs on a single-core, dual-core, or 48-core machine.

Limits and requests for `memory` are measured in bytes. You can express memory as a plain integer or as a fixed-point number using one of these quantity suffixes: `E`, `P`, `T`, `G`, `M`, `k`. You can also use the power-of-two equivalents: `Ei`, `Pi`, `Ti`, `Gi`, `Mi`, `Ki`. For example, the following represent roughly the same value:

{% highlight csv %}
128974848, 129e6, 129M,  128974848000m, 123Mi
{% endhighlight %}

Pay attention to the case of the suffixes. If you request `400m` of memory, this is a request for `0.4 bytes`. Someone who types that probably meant to ask for `400 mebibytes (400Mi)` or `400 megabytes (400M)`.

## How Kubernetes applies resource requests and limits?

When the kubelet starts a container as part of a Pod, the kubelet passes that container's requests and limits for memory and CPU to the container runtime.

On Linux, the container runtime typically configures kernel cgroups that apply and enforce the limits you defined.

1. The CPU limit defines a hard ceiling on how much CPU time that the container can use. During each scheduling interval (time slice), the Linux kernel checks to see if this limit is exceeded; if so, the kernel waits before allowing that cgroup to resume execution.
2. The CPU request typically defines a weighting. If several different containers (cgroups) want to run on a contended system, workloads with larger CPU requests are allocated more CPU time than workloads with small requests.
3. The memory request is mainly used during (Kubernetes) Pod scheduling. On a node that uses `cgroups` v2, the container runtime might use the memory request as a hint to set `memory.min` and `memory.low`.
4. The memory limit defines a memory limit for that cgroup. If the container tries to allocate more memory than this limit, the Linux kernel out-of-memory subsystem activates and, typically, intervenes by stopping one of the processes in the container that tried to allocate memory. If that process is the container's PID 1, and the container is marked as restartable, Kubernetes restarts the container.
5. The memory limit for the Pod or container can also apply to pages in memory backed volumes, such as an `emptyDir`. The kubelet tracks tmpfs `emptyDir` volumes as container memory use, rather than as local ephemeral storage.

If a container exceeds its memory request and the node that it runs on becomes short of memory overall, it is likely that the Pod the container belongs to will be evicted.

A container might or might not be allowed to exceed its CPU limit for extended periods of time. However, container runtimes don't terminate Pods or containers for excessive CPU usage.

The kubelet reports the resource usage of a Pod as part of the Pod `status`.

## Install prerequisite, Before you begin

You need to have a Kubernetes cluster, and the kubectl command-line tool must be configured to communicate with your cluster. If you do not already have a cluster, you can create one by using minikube or you can use one of these Kubernetes playgrounds.

Each node in your cluster must have at least `300 MiB` of memory. A few of the steps on this page require you to run the metrics-server service in your cluster. If you have the metrics-server running, you can skip those steps.

If you are running Minikube, run the following command to enable the metrics-server:

{% highlight bash %}
minikube start \
--driver=docker \
--memory=2G \
--nodes=2 \
--extra-config=kubelet.housekeeping-interval=10s \
--addons=metrics-server
{% endhighlight %}

To see whether the metrics-server is running, or another provider of the resource metrics API (`metrics.k8s.io`), run the following command:

{% highlight bash %}
kubectl get apiservices
{% endhighlight %}

If the resource metrics API is available, the output includes a reference to `metrics.k8s.io`.

{% highlight bash %}
NAME
v1beta1.metrics.k8s.io
{% endhighlight %}

And make sure, you have to access `kubectl top node` and `kubectl top pod`: 

```powershell
➜ ~  kubectl top node
NAME           CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
minikube       213m         10%    694Mi           17%
minikube-m02   51m          2%     169Mi           4%

➜ ~  kubectl run webapp --image nginx --port 80
pod/webapp created

➜ ~  kubectl get pod
NAME     READY   STATUS    RESTARTS   AGE
webapp   1/1     Running   0          9s

➜ ~  kubectl top pod webapp
NAME     CPU(cores)   MEMORY(bytes)
webapp   0m           0Mi
```

## Specify a memory request and a memory limit

To specify a memory request for a Container, include the `resources:requests` field in the Container's resource manifest. To specify a memory limit, include `resources:limits`. For example, you create a Pod that has one Container. The Container has a memory request of `100 MiB` and a memory limit of `200 MiB`. Here's the configuration file for the Pod:

{% gist page.gist "03g-pod-resource-memory.yaml" %}

Jika dijalankan hasilnya seperti berikut:

```powershell
➜ kubectl apply -f .\02-workloads\01-pod\pod-resource-memory.yaml
pod/pod-resource-memory created

➜ kubectl get pod
NAME                  READY   STATUS    RESTARTS   AGE
pod-resource-memory   1/1     Running   0          90s

➜ kubectl describe pod pod-resource-memory
Name:         pod-resource-memory
Namespace:    default
Priority:     0
Node:         minikube-m02/192.168.49.3
Start Time:   Tue, 07 Jun 2022 05:43:20 +0700
Labels:       app=pod-resource-memory
Annotations:  <none>
Status:       Running
IP:           10.244.1.2
IPs:
  IP:  10.244.1.2
Containers:
  pod-resource-memory:
    Image:         polinux/stress
    Port:          <none>
    Host Port:     <none>
    Command:
      stress
    Args:
      --vm
      1
      --vm-bytes
      150M
      --vm-hang
      1
    State:          Running
      Started:      Tue, 07 Jun 2022 05:43:28 +0700
    Ready:          True
    Restart Count:  0
    Limits:
      memory:  200Mi
    Requests:
      memory:     100Mi
    Environment:  <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-dlp2d (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  2m4s  default-scheduler  Successfully assigned default/pod-resource-memory to minikube-m02
  Normal  Pulling    2m4s  kubelet            Pulling image "polinux/stress"
  Normal  Pulled     117s  kubelet            Successfully pulled image "polinux/stress" in 6.9189638s
  Normal  Created    117s  kubelet            Created container pod-resource-memory
  Normal  Started    117s  kubelet            Started container pod-resource-memory

➜ kubectl top node
NAME           CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
minikube       98m          4%     1285Mi          32%
minikube-m02   28m          1%     435Mi           11%

➜ kubectl top pod pod-resource-memory
NAME                  CPU(cores)   MEMORY(bytes)
pod-resource-memory   16m          150Mi
```

The output shows that the Pod is using about `150 MiB`. This is greater than the Pod's `100 MiB` request, but within the Pod's `200 MiB` limit.

## Exceed a Container's memory limit

A Container can exceed its memory `request` if the Node has memory available. But a Container is not allowed to use more than its memory `limit`. If a Container allocates more memory than its limit, the Container becomes a candidate for termination. If the Container continues to consume memory beyond its limit, the Container is terminated. If a terminated Container can be restarted, the kubelet restarts it, as with any other type of runtime failure.

In this exercise, you create a Pod that attempts to allocate more memory than its limit. Here is the configuration file for a Pod that has one Container with a memory request of `50 MiB` and a memory limit of `100 MiB`:

{% gist page.gist "03g-pod-resource-memory-more-limit.yaml" %}

In the args section of the configuration file, you can see that the Container will attempt to allocate `250 MiB` of memory, which is well above the `100 MiB` limit.

Jika kita coba jalankan hasilnya seperti berikut:

```powershell
devops/kubernetes [main●] » kubectl apply -f 02-workloads/01-pod/pod-resource-memory-more-limit.yaml 
pod/pod-resource-memory-more-limit created

devops/kubernetes [main●] » kubectl get pod
NAME                             READY   STATUS             RESTARTS      AGE
pod-resource-memory-more-limit   0/1     CrashLoopBackOff   5 (19s ago)   3m43s

devops/kubernetes [main●] » kubectl describe pod
Name:         pod-resource-memory-more-limit
Namespace:    default
Priority:     0
Node:         minikube/192.168.59.101
Start Time:   Sat, 11 Jun 2022 09:59:23 +0700
Labels:       <none>
Annotations:  <none>
Status:       Running
IP:           172.17.0.4
IPs:
  IP:  172.17.0.4
Containers:
  pod-resource-memory-more-limit:
    Image:         polinux/stress
    Port:          <none>
    Host Port:     <none>
    Command:
      stress
    Args:
      --vm
      1
      --vm-bytes
      250M
      --vm-hang
      1
    State:          Waiting
      Reason:       CrashLoopBackOff
    Last State:     Terminated
      Reason:       OOMKilled
      Exit Code:    1
      Started:      Sat, 11 Jun 2022 10:02:47 +0700
      Finished:     Sat, 11 Jun 2022 10:02:47 +0700
    Ready:          False
    Restart Count:  5
    Limits:
      memory:  100Mi
    Requests:
      memory:     50Mi
    Environment:  <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-cg4sj (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             False 
  ContainersReady   False 
  PodScheduled      True 
Volumes:
  kube-api-access-cg4sj:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
Events:
  Type     Reason     Age                    From               Message
  ----     ------     ----                   ----               -------
  Normal   Scheduled  4m6s                   default-scheduler  Successfully assigned default/pod-resource-memory-more-limit to minikube
  Normal   Pulled     3m57s                  kubelet            Successfully pulled image "polinux/stress" in 7.376668096s
  Normal   Pulled     3m53s                  kubelet            Successfully pulled image "polinux/stress" in 3.19955887s
  Normal   Pulled     3m36s                  kubelet            Successfully pulled image "polinux/stress" in 3.142850674s
  Normal   Created    3m10s (x4 over 3m57s)  kubelet            Created container pod-resource-memory-more-limit
  Normal   Started    3m10s (x4 over 3m57s)  kubelet            Started container pod-resource-memory-more-limit
  Normal   Pulled     3m10s                  kubelet            Successfully pulled image "polinux/stress" in 3.17531734s
  Warning  BackOff    2m34s (x8 over 3m52s)  kubelet            Back-off restarting failed container
  Normal   Pulling    2m19s (x5 over 4m5s)   kubelet            Pulling image "polinux/stress"
```

The output shows that the Container was killed because it is out of memory (OOM):

```powershell
Last State:     Terminated
  Reason:       OOMKilled
  Exit Code:    1
  Started:      Sat, 11 Jun 2022 10:02:47 +0700
  Finished:     Sat, 11 Jun 2022 10:02:47 +0700
```

The output shows that the Container is killed, restarted, killed again, restarted again, and so on:

```powershell
devops/kubernetes [main] » kubectl get pod -w
NAME                             READY   STATUS             RESTARTS      AGE
pod-resource-memory-more-limit   0/1     CrashLoopBackOff   1 (10s ago)   24s
pod-resource-memory-more-limit   0/1     OOMKilled          2 (20s ago)   34s
pod-resource-memory-more-limit   0/1     CrashLoopBackOff   2 (11s ago)   45s
pod-resource-memory-more-limit   0/1     OOMKilled          3 (30s ago)   64s
pod-resource-memory-more-limit   0/1     CrashLoopBackOff   3 (14s ago)   78s
```

cleanup:

```powershell
kubectl delete pod --all
```

## Specify a memory request that is too big for your Nodes

Memory requests and limits are associated with Containers, but it is useful to think of a Pod as having a memory request and limit. The memory request for the Pod is the sum of the memory requests for all the Containers in the Pod. Likewise, the memory limit for the Pod is the sum of the limits of all the Containers in the Pod.

Pod scheduling is based on requests. A Pod is scheduled to run on a Node only if the Node has enough available memory to satisfy the Pod's memory request.

In this exercise, you create a Pod that has a memory request so big that it exceeds the capacity of any Node in your cluster. Here is the configuration file for a Pod that has one Container with a request for `2 GiB` of memory, which likely exceeds the capacity of any Node in your cluster:

{% gist page.gist "03g-pod-resource-memory-request-big-then-node.yaml" %}

Jika dijalankan seperti berikut:

```powershell
devops/kubernetes [main●] » kubectl apply -f 02-workloads/01-pod/pod-resource-memory-request-big-then-node.yaml
pod/pod-resource-memory-more-limit created

devops/kubernetes [main●] » kubectl get pod
NAME                             READY   STATUS    RESTARTS   AGE
pod-resource-memory-more-limit   0/1     Pending   0          15s

devops/kubernetes [main●] » kubectl get pod
NAME                             READY   STATUS    RESTARTS   AGE
pod-resource-memory-more-limit   0/1     Pending   0          15s

devops/kubernetes [main●] » kubectl describe pod pod-resource-memory-more-limit
Name:         pod-resource-memory-more-limit
Namespace:    default
Priority:     0
Node:         <none>
Labels:       <none>
Annotations:  <none>
Status:       Pending
IP:           
IPs:          <none>
Containers:
  pod-resource-memory-more-limit:
    Image:      polinux/stress
    Port:       <none>
    Host Port:  <none>
    Command:
      stress
    Args:
      --vm
      1
      --vm-bytes
      250M
      --vm-hang
      1
    Requests:
      memory:     2Gi
    Environment:  <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-9wpjn (ro)
Conditions:
  Type           Status
  PodScheduled   False 
QoS Class:                   Burstable
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  34s   default-scheduler  0/1 nodes are available: 1 Insufficient memory
```

The output shows that the Pod status is PENDING. That is, the Pod is not scheduled to run on any Node, and it will remain in the PENDING state indefinitely