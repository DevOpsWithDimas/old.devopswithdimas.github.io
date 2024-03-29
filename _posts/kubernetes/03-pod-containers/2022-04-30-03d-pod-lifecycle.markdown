---
layout: post
title: "Pod & Container Lifecycle"
date: 2022-04-30T05:41:45+07:00
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Pods
refs: 
- https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/
youtube: 
comments: true
catalog_key: pod-container
image_path: /resources/posts/kubernetes/03c-pod-lifecycle
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Pod Lifecycle. Pods follow a defined lifecycle, starting in the `Pending` phase, moving through `Running` if at least one of its primary containers starts OK, and then through either the `Succeeded` or `Failed` phases depending on whether any container in the Pod terminated in failure.

Whilst a Pod is `running`, the kubelet is able to `restart` containers to handle some kind of faults. Within a Pod, Kubernetes tracks different container `states` and determines what action to take to make the Pod healthy again.

In the Kubernetes API, Pods have both a specification and an actual status. The status for a Pod object consists of a set of Pod conditions. You can also inject custom readiness information into the condition data for a Pod, if that is useful to your application.

Pods are only scheduled once in their lifetime. Once a Pod is scheduled (assigned) to a Node, the Pod runs on that Node until it stops or is terminated.

Ok untuk lebih detailnya kita akan bagi-bagi menjadi beberapa section yaitu:

1. Pod lifetime
2. Pod phase
3. Container states
4. Container restart policy
5. Container probes
6. Termination of Pods

Ok lansung aja kita bahas materi yang pertama

<!--more-->

## Pod lifetime

Like individual application containers, Pods are considered to be relatively ephemeral (rather than durable) entities. Pods are created, assigned a unique ID (`UID`), and scheduled to nodes where they remain until termination (according to restart policy) or deletion. If a Node dies, the Pods scheduled to that node are scheduled for deletion after a timeout period.

Pods do not, by themselves, self-heal. If a Pod is scheduled to a node that then fails, the Pod is deleted; likewise, a Pod won't survive an eviction due to a lack of resources or Node maintenance. Kubernetes uses a higher-level abstraction, called a controller, that handles the work of managing the relatively disposable Pod instances.

A given Pod (as defined by a UID) is never "rescheduled" to a different node; instead, that Pod can be replaced by a new, near-identical Pod, with even the same name if desired, but with a different UID.

When something is said to have the same lifetime as a Pod, such as a volume, that means that the thing exists as long as that specific Pod (with that exact UID) exists. If that Pod is deleted for any reason, and even if an identical replacement is created, the related thing (a volume, in this example) is also destroyed and created anew.

## Pod phase

A Pod's `status` field is a [PodStatus](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#podstatus-v1-core) object, which has a `phase` field.

The phase of a Pod is a simple, high-level summary of where the Pod is in its lifecycle. The phase is not intended to be a comprehensive rollup of observations of container or Pod state, nor is it intended to be a comprehensive state machine.

The number and meanings of Pod phase values are tightly guarded. Other than what is documented here, nothing should be assumed about Pods that have a given `phase` value.

Here are the possible values for `phase`:

1. `Pending`, The Pod has been accepted by the Kubernetes cluster, but one or more of the containers has not been set up and made ready to run. This includes time a Pod spends waiting to be scheduled as well as the time spent downloading container images over the network.

2. `Running`, The Pod has been bound to a node, and all of the containers have been created. At least one container is still running, or is in the process of starting or restarting.

3. `Succeeded`, All containers in the Pod have terminated in success, and will not be restarted.

4. `Failed`, All containers in the Pod have terminated, and at least one container has terminated in failure. That is, the container either exited with non-zero status or was terminated by the system.

5. `Unknown`, For some reason the state of the Pod could not be obtained. This phase typically occurs due to an error in communicating with the node where the Pod should be running.

> Note: When a Pod is being deleted, it is shown as `Terminating` by some `kubectl` commands. This `Terminating` status is not one of the Pod phases

Jika kita gambarkan workflownya seperti berikut:

{% mermaid %}
flowchart LR
    Pending --> Running --> IsRunning{ Is Running? }
    IsRunning -- Yes --> Succeeded
    IsRunning -- No --> Failed --> IsRestartable{ Restarted? } 
    IsRunning -- No reason --> Unknown --> Terminating

    IsRestartable -- Yes --> Running
    IsRestartable -- No --> Terminating
{% endmermaid %}

## Container states

As well as the phase of the Pod overall, Kubernetes tracks the state of each container inside a Pod.

Once the scheduler assigns a Pod to a Node, the kubelet starts creating containers for that Pod using a container runtime. There are three possible container states: `Waiting`, `Running`, and `Terminated`.

To check the state of a Pod's containers, you can use `kubectl describe pod <name-of-pod>`. The output shows the state for each container within that Pod.

Each state has a specific meaning:

1. `Waiting`, A container in the `Waiting` state is still running the operations it requires in order to complete start up: for example, pulling the container image from a container image registry, or applying Secret data.

2. `Running`, The `Running` status indicates that a container is executing without issues.

3. `Terminated`, A container in the `Terminated` state began execution and then either ran to completion or failed for some reason. When you use `kubectl` to query a Pod with a container that is `Terminated`, you see a reason, an exit code, and the start and finish time for that container's period of execution.

Jika kita gambarkan workflownya seperti berikut:

{% mermaid %}
flowchart LR
    Waiting --> Running --> IsRunning{ Is Running? }
    IsRunning -- Yes --> Succeeded
    IsRunning -- Completed --> Terminated
    IsRunning -- Failed --> Terminated
{% endmermaid %}

## Container restart policy

The spec of a Pod has a restartPolicy field with possible values `Always`, `OnFailure`, and `Never`. The default value is `Always`.

The `restartPolicy` applies to all containers in the Pod. `restartPolicy` only refers to restarts of the containers by the kubelet on the same node. After containers in a Pod exit, the kubelet restarts them with an exponential back-off delay (`10s`, `20s`, `40s`, …), that is capped at five minutes. Once a container has executed for 10 minutes without any problems, the kubelet resets the restart backoff timer for that container.

For example:

{% gist page.gist "03c-container-restart-policy.yaml" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
> minikube start --driver docker --memory 2g


> kubectl apply -f .\02-workloads\01-pod\pod-restart-policy.yaml
pod/webapp created

> kubectl get pod
NAME     READY   STATUS    RESTARTS   AGE
webapp   1/1     Running   0          90s

> minikube stop
* Stopping node "minikube"  ...
* 1 node stopped.

> minikube start
* Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default

> kubectl get pod
NAME     READY   STATUS      RESTARTS   AGE
webapp   0/1     Completed   0          106s

> kubectl describe pod webapp
Name:         webapp
Namespace:    default
Priority:     0
Node:         minikube/192.168.49.2
Start Time:   Thu, 28 Apr 2022 03:33:11 +0700
Labels:       app=webapp
Annotations:  <none>
Status:       Succeeded
IP:
IPs:          <none>
Containers:
  webapp:
    Image:          nginx:mainline
    Port:           <none>
    Host Port:      <none>
    State:          Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Thu, 28 Apr 2022 03:33:41 +0700
      Finished:     Thu, 28 Apr 2022 03:33:56 +0700
    Ready:          False
    Restart Count:  0
    Environment:    <none>
Conditions:
  Type              Status
  Initialized       True
  Ready             False
  ContainersReady   False
  PodScheduled      True

Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  2m3s  default-scheduler  Successfully assigned default/webapp to minikube
  Normal  Pulling    2m3s  kubelet            Pulling image "nginx:mainline"
  Normal  Pulled     93s   kubelet            Successfully pulled image "nginx:mainline" in 29.1412459s
  Normal  Created    93s   kubelet            Created container webapp
  Normal  Started    93s   kubelet            Started container webapp
```

## Container probes

A probe is a diagnostic performed periodically by the kubelet on a container. To perform a diagnostic, the kubelet either executes code within the container, or makes a network request.

In Container probes, There are four different ways to check a container using a probe. Each probe must define exactly one of these four mechanisms:

1. `exec`, Executes a specified command inside the container. The diagnostic is considered successful if the command exits with a status code of `0`.
2. `grpc`, Performs a remote procedure call using gRPC. The target should implement gRPC health checks.
3. `httpGet`, Performs an HTTP GET request against the Pod's IP address on a specified port and path. The diagnostic is considered successful if the response has a status code greater than or equal to `200` and less than `400`.
4. `tcpSocket`, Performs a TCP check against the Pod's IP address on a specified port. The diagnostic is considered successful if the port is open. If the remote system (the container) closes the connection immediately after it opens, this counts as healthy.

Each probe has one of three results:

1. `Success`, The container passed the diagnostic.
2. `Failure`, The container failed the diagnostic.
3. `Unknown`, The diagnostic failed (no action should be taken, and the kubelet will make further checks).

Types of probe, The kubelet can optionally perform and react to three kinds of probes on running containers:

1. `livenessProbe`, Indicates whether the container is running. If the liveness probe fails, the kubelet kills the container, and the container is subjected to its restart policy. If a container does not provide a liveness probe, the default state is `Success`.
2. `readinessProbe`, Indicates whether the container is ready to respond to requests. If the readiness probe fails, the endpoints controller removes the Pod's IP address from the endpoints of all Services that match the Pod. The default state of readiness before the initial delay is Failure. If a container does not provide a readiness probe, the default state is `Success`.
3. `startupProbe`, Indicates whether the application within the container is started. All other probes are disabled if a startup probe is provided, until it succeeds. If the startup probe fails, the kubelet kills the container, and the container is subjected to its restart policy. If a container does not provide a startup probe, the default state is `Success`.

Implementasinya seperti berikut:

{% gist page.gist "03c-container-http-probes.yaml" %}

Jika dijalankan hasilnya seperti berikut:

```powershell
> kubectl apply -f .\02-workloads\01-pod\container-http-probes.yaml
pod/webapp created

> kubectl get pod
NAME     READY   STATUS    RESTARTS   AGE
webapp   1/1     Running   0          20s

> kubectl describe pod webapp
Name:         webapp
Namespace:    default
Priority:     0
Node:         minikube/192.168.49.2
Start Time:   Thu, 28 Apr 2022 05:06:36 +0700
Labels:       app=webapp
Annotations:  <none>
Status:       Running
IP:           172.17.0.3
IPs:
  IP:  172.17.0.3
Containers:
  webapp:
    Image:          nginx:mainline
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Thu, 28 Apr 2022 05:06:37 +0700
    Ready:          True
    Restart Count:  0
    Liveness:       http-get http://:8080/ delay=10s timeout=1s period=10s #success=1 #failure=3
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-x8q49 (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Events:
  Type     Reason     Age               From               Message
  ----     ------     ----              ----               -------
  Normal   Scheduled  34s               default-scheduler  Successfully assigned default/webapp to
 minikube
  Normal   Pulled     33s               kubelet            Container image "nginx:mainline" alread
y present on machine
  Normal   Created    33s               kubelet            Created container webapp
  Normal   Started    33s               kubelet            Started container webapp

## wait 30s

> kubectl get pod
NAME     READY   STATUS      RESTARTS   AGE
webapp   0/1     Completed   0          2m14s

> kubectl describe pod webapp
Name:         webapp
Namespace:    default
Priority:     0
Node:         minikube/192.168.49.2
Start Time:   Thu, 28 Apr 2022 05:06:36 +0700
Labels:       app=webapp
Annotations:  <none>
Status:       Succeeded
IP:           172.17.0.3
IPs:
  IP:  172.17.0.3
Containers:
  webapp:
    Image:          nginx:mainline
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Thu, 28 Apr 2022 05:06:37 +0700
      Finished:     Thu, 28 Apr 2022 05:07:16 +0700
    Ready:          False
    Restart Count:  0
    Liveness:       http-get http://:8080/ delay=10s timeout=1s period=10s #success=1 #failure=3
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-x8q49 (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             False
  ContainersReady   False
  PodScheduled      True
Events:
  Type     Reason       Age                From               Message
  ----     ------       ----               ----               -------
  Normal   Scheduled    87s                default-scheduler  Successfully assigned default/webapp
 to minikube
  Normal   Pulled       86s                kubelet            Container image "nginx:mainline" alr
eady present on machine
  Normal   Created      86s                kubelet            Created container webapp
  Normal   Started      86s                kubelet            Started container webapp
  Warning  Unhealthy    47s (x3 over 67s)  kubelet            Liveness probe failed: Get "http://1
72.17.0.3:8080/": dial tcp 172.17.0.3:8080: connect: connection refused
  Normal   Killing      47s                kubelet            Stopping container webapp
  Warning  FailedMount  14s (x7 over 46s)  kubelet            MountVolume.SetUp failed for volume
"kube-api-access-x8q49" : object "default"/"kube-root-ca.crt" not registered
```

## Termination of Pods

Because Pods represent processes running on nodes in the cluster, it is important to allow those processes to gracefully terminate when they are no longer needed (rather than being abruptly stopped with a `KILL` signal and having no chance to clean up).

The design aim is for you to be able to request deletion and know when processes terminate, but also be able to ensure that deletes eventually complete. When you request deletion of a Pod, the cluster records and tracks the intended grace period before the Pod is allowed to be forcefully killed. With that forceful shutdown tracking in place, the kubelet attempts graceful shutdown.

Typically, the container runtime sends a TERM signal to the main process in each container. Many container runtimes respect the STOPSIGNAL value defined in the container image and send this instead of TERM. Once the grace period has expired, the KILL signal is sent to any remaining processes, and the Pod is then deleted from the API Server. If the kubelet or the container runtime's management service is restarted while waiting for processes to terminate, the cluster retries from the start including the full original grace period.

An example flow:

1. You use the `kubectl` tool to manually delete a specific Pod, with the default grace period (30 seconds).
2. The Pod in the API server is updated with the time beyond which the Pod is considered "dead" along with the grace period. If you use `kubectl describe` to check on the Pod you're deleting, that Pod shows up as "Terminating". On the node where the Pod is running: as soon as the kubelet sees that a Pod has been marked as terminating (a graceful shutdown duration has been set), the kubelet begins the local Pod shutdown process.
3. At the same time as the kubelet is starting graceful shutdown, the control plane removes that shutting-down Pod from Endpoints (and, if enabled, EndpointSlice) objects where these represent a Service with a configured selector.
4. When the grace period expires, the kubelet triggers forcible shutdown. The container runtime sends `SIGKILL` to any processes still running in any container in the Pod. The kubelet also cleans up a hidden pause container if that container runtime uses one.
5. The kubelet triggers forcible removal of Pod object from the API server, by setting grace period to 0 (immediate deletion).
6. The API server deletes the Pod's API object, which is then no longer visible from any client.