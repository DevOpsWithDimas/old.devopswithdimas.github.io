---
layout: post
title: "Configure liveness, readiness, and startup probes"
date: 2022-06-19T16:26:26+07:00
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Workloads
refs: 
- https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/
youtube: 
comments: true
catalog_key: pod-container
image_path: /resources/posts/kubernetes/03g-container-probe
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas lebih detail tentang Container probe diantaranya Liveness, Readiness and Startup Probes dalam suatu Pod Specification. Diantaranya:

1. What the different between liveness, readiness and startup probe?
2. When should you use container probe?
3. Container probes of fields
4. Configure liveness probe in a Pod
5. Configure readiness probe in a Pod
6. Configure startup probe in a Pod

Ok langsung aja kita bahas materi yang pertama

<!--more-->

## What the different between liveness, readiness and startup probe?

Sebelum kita menggunakan atau men-configure container probe untuk liveness, readiness dan startup kita bahas dulu perbedaannya ya. Ok kita mulai bahas satu-per-satu mulai dari yang paling umum digunakan yaitu liveness probe.

The kubelet uses liveness probes to know when to restart a container. For example, liveness probes could catch a deadlock, where an application is running, but unable to make progress. Restarting a container in such a state can help to make the application more available despite bugs.

The kubelet uses readiness probes to know when a container is ready to start accepting traffic. A Pod is considered ready when all of its containers are ready. One use of this signal is to control which Pods are used as backends for Services. When a Pod is not ready, it is removed from Service load balancers.

The kubelet uses startup probes to know when a container application has started. If such a probe is configured, it disables liveness and readiness checks until it succeeds, making sure those probes don't interfere with the application startup. This can be used to adopt liveness checks on slow starting containers, avoiding them getting killed by the kubelet before they are up and running.

Untuk lebih memahami berikut adalah diagram timeline state managementnya:

{% mermaid %}
gantt
    title Container Probe state managements
    dateFormat HH:mm
    axisFormat %H:%m
    section Startup Probe
    Container creating          :active,    containerCreate,    12:00,                      1s
    Container starting          :           containerStart,     after containerCreate,      2s
    Startup probe               :           startupTry1,        after containerStart,       10s
    Container started           :done,      containerStarted,   after startupTry1,          3s
    section Readiness Probe
    Check container is ready?   :           checkReady,         after containerStarted,     2s
    Container Ready             :done,      containerReady,     after checkReady,           10s
    section Liveness Probe
    Check container is live?    :           checkLive,          after containerReady,       2s
    Container Running           :           containerRun,       after checkLive,            10s
    Container Healty            :done,      containerHealty,    after containerRun,         2s
{% endmermaid %}

## When should you use container probe?

Nah ini juga bagian penting dari section sebelumnya, kapansih kita harus menggunakan container probes khususnya untuk Liveness, Readiness dan Startup Probe. Yukk kita bahas satu-per-satu, mulai dari **Liveness Probe**:

If the process in your container is able to crash on its own whenever it encounters an issue or becomes unhealthy, you do not necessarily need a liveness probe; the kubelet will automatically perform the correct action in accordance with the Pod's `restartPolicy`.

If you'd like your container to be killed and restarted if a probe fails, then specify a liveness probe, and specify a `restartPolicy` of `Always` or `OnFailure`.

Kemudian kita bahas **Readiness Probe**:

If you'd like to start sending traffic to a Pod only when a probe succeeds, specify a readiness probe. In this case, the readiness probe might be the same as the liveness probe, but the existence of the readiness probe in the spec means that the Pod will start without receiving any traffic and only start receiving traffic after the probe starts succeeding.

If you want your container to be able to take itself down for maintenance, you can specify a readiness probe that checks an endpoint specific to readiness that is different from the liveness probe.

If your app has a strict dependency on back-end services, you can implement both a liveness and a readiness probe. The liveness probe passes when the app itself is healthy, but the readiness probe additionally checks that each required back-end service is available. This helps you avoid directing traffic to Pods that can only respond with error messages.

Dan finally yang terakhir yaitu **Startup Probe**:

Startup probes are useful for Pods that have containers that take a long time to come into service. Rather than set a long liveness interval, you can configure a separate configuration for probing the container as it starts up, allowing a time longer than the liveness interval would allow.

If your container usually starts in more than `initialDelaySeconds + failureThreshold × periodSeconds`, you should specify a startup probe that checks the same endpoint as the liveness probe. The default for `periodSeconds` is `10s`. You should then set its `failureThreshold` high enough to allow the container to start, without changing the default values of the liveness probe. This helps to protect against deadlocks.

## Container probes of fields

**Probes** have a number of fields that you can use to more precisely control the behavior of liveness and readiness checks:

1. `initialDelaySeconds`: Number of seconds after the container has started before liveness or readiness probes are initiated. Defaults to `0 seconds`. Minimum value is `0`.
2. `periodSeconds`: How often (in seconds) to perform the probe. Default to `10 seconds`. Minimum value is `1`.
3. `timeoutSeconds`: Number of seconds after which the probe times out. Defaults to `1 second`. Minimum value is `1`.
4. `successThreshold`: Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to `1`. Must be `1` for liveness and startup Probes. Minimum value is `1`.
5. `failureThreshold`: When a probe fails, Kubernetes will try failureThreshold times before giving up. Giving up in case of liveness probe means restarting the container. In case of readiness probe the Pod will be marked Unready. Defaults to `3`. Minimum value is `1`.

**HTTP probes** have additional fields that can be set on `httpGet`:

1. `host`: Host name to connect to, defaults to the pod IP. You probably want to set "Host" in httpHeaders instead.
2. `scheme`: Scheme to use for connecting to the host (HTTP or HTTPS). Defaults to HTTP.
3. `path`: Path to access on the HTTP server. Defaults to `/`.
4. `httpHeaders`: Custom headers to set in the request. HTTP allows repeated headers.
5. `port`: Name or number of the port to access on the container. Number must be in the range `1 to 65535`.

For a **TCP probe**, the kubelet makes the probe connection at the node, not in the pod, which means that you can not use a service name in the host parameter since the kubelet is unable to resolve it.

## Configure liveness command in a Pod

Many applications running for long periods of time eventually transition to broken states, and cannot recover except by being restarted. Kubernetes provides liveness probes to detect and remedy such situations.

Contoh sederhannya seperti, misalnya kita menjalankan program yang sifatnya running di background / service. Untuk mendeteksi program tersebut tetap berjalan kita bisa check menggunakan output yang di keluarkan oleh program tersebut seperti log file dan lain-lain. Jadi klo kita coba buat configurasinya seperti berikut:

{% gist page.gist "03h-pod-probe-liveness-command.yaml" %}

In the configuration file, you can see that the Pod has a single Container. The `periodSeconds` field specifies that the kubelet should perform a liveness probe every `5 seconds`. The `initialDelaySeconds` field tells the kubelet that it should wait `5 seconds` before performing the first probe. To perform a probe, the kubelet executes the command cat `/tmp/healthy` in the target container. If the command succeeds, it `returns 0`, and the kubelet considers the container to be alive and healthy. If the command returns a `non-zero value`, the kubelet kills the container and restarts it.

When the container starts, it executes this command:

{% highlight bash %}
/bin/sh -c "touch /tmp/healthy; sleep 30; rm -f /tmp/healthy; sleep 600"
{% endhighlight %}

Jika di jalankan hasilnya seperti berikut:

```bash
» kubectl apply -f 02-workloads/01-pod/pod-probe-liveness-command.yaml 
pod/pod-probe-liveness-command created

» kubectl get pod
NAME                         READY   STATUS    RESTARTS   AGE
pod-probe-liveness-command   1/1     Running   0          19s

» kubectl describe pod pod-probe-liveness-command                     
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  12s   default-scheduler  Successfully assigned default/pod-probe-liveness-command to latihan
  Normal  Pulling    12s   kubelet            Pulling image "k8s.gcr.io/busybox"
  Normal  Pulled     11s   kubelet            Successfully pulled image "k8s.gcr.io/busybox" in 986.394876ms
  Normal  Created    10s   kubelet            Created container pod-probe-liveness-command
  Normal  Started    10s   kubelet            Started container pod-probe-liveness-command

## wait 30s then exeucute again, then see the container restated because failed container probe
» kubectl describe pod pod-probe-liveness-command
Events:
  Type     Reason     Age                From               Message
  ----     ------     ----               ----               -------
  Normal   Scheduled  74s                default-scheduler  Successfully assigned default/pod-probe-liveness-command to latihan
  Normal   Pulling    74s                kubelet            Pulling image "k8s.gcr.io/busybox"
  Normal   Pulled     73s                kubelet            Successfully pulled image "k8s.gcr.io/busybox" in 986.394876ms
  Normal   Created    72s                kubelet            Created container pod-probe-liveness-command
  Normal   Started    72s                kubelet            Started container pod-probe-liveness-command
  Warning  Unhealthy  29s (x3 over 39s)  kubelet            Liveness probe failed: cat: cant open '/tmp/healthy': No such file or directory
  Normal   Killing    29s                kubelet            Container pod-probe-liveness-command failed liveness probe, will be restarted

» kubectl get pod
NAME                         READY   STATUS    RESTARTS   AGE
pod-probe-liveness-command   1/1     Running   1          30s
```

## Configure liveness HTTP in a Pod

Another kind of liveness probe uses an HTTP GET request. Untuk menggunakan liveness probe HTTP GET request ini bisa menggunakan 2 cara yaitu number of port and named port. Karena pembahasan menggunakan number of port sudah kita bahas di materi sebelumnya jadi kita bahas menggunakan Named Port ya. Berikut adalah sample configurationnya:

{% gist page.gist "03h-pod-probe-liveness-http-named-port.yaml" %}

In the configuration file, you can see that the Pod has a single container. The `periodSeconds` field specifies that the kubelet should perform a liveness probe every `5 seconds`. The `initialDelaySeconds` field tells the kubelet that it should wait `5 seconds` before performing the first probe. To perform a probe, the kubelet sends an HTTP GET request to the server that is running in the container and listening on `port 80`. If the handler for the server's `/status` path returns a success code, the kubelet considers the container to be alive and healthy. If the handler returns a failure code, the kubelet kills the container and restarts it.

Any code greater than or equal to `200` and less than `400` indicates success. Any other code indicates failure.

Jika dijalankan hasilnya seperti berikut:

```bash
» kubectl apply -f 02-workloads/01-pod/pod-probe-liveness-http-named-port.yaml 
pod/pod-probe-liveness-http-named-port created

» kubectl get pod
NAME                                 READY   STATUS    RESTARTS   AGE
pod-probe-liveness-http-named-port   1/1     Running   0          6s

» kubectl describe pod pod-probe-liveness-http-named-port
Events:
  Type     Reason     Age               From               Message
  ----     ------     ----              ----               -------
  Normal   Scheduled  22s               default-scheduler  Successfully assigned default/pod-probe-liveness-http-named-port to latihan
  Normal   Pulled     17s               kubelet            Successfully pulled image "nginx" in 3.177382341s
  Normal   Created    17s               kubelet            Created container pod-probe-liveness-http-named-port
  Normal   Started    17s               kubelet            Started container pod-probe-liveness-http-named-port
  Normal   Pulling    2s (x2 over 21s)  kubelet            Pulling image "nginx"
  Warning  Unhealthy  2s (x3 over 12s)  kubelet            Liveness probe failed: HTTP probe failed with statuscode: 404
  Normal   Killing    2s                kubelet            Container pod-probe-liveness-http-named-port failed liveness probe, will be restarted

» kubectl get pod
NAME                                 READY   STATUS    RESTARTS   AGE
pod-probe-liveness-http-named-port   1/1     Running   1          25s
```

## Configure TCP liveness in a Pod

A third type of liveness probe uses a TCP socket. With this configuration, the kubelet will attempt to open a socket to your container on the specified port. If it can establish a connection, the container is considered healthy, if it can't it is considered a failure.

Berikut adalah sample configurationnya:

{% gist page.gist "03h-pod-probe-liveness-tcp.yaml" %}

As you can see, configuration for a TCP check is quite similar to an HTTP check. The kubelet will send the first readiness probe `5 seconds` after the container starts. This will attempt to connect to the nginx container on port `8080`. If the probe succeeds, the Pod will be marked as ready. The kubelet will continue to run this check every `10 seconds`.

Jika kita coba jalankan hasilnya seperti berikut:

```bash
» kubectl apply -f 02-workloads/01-pod/pod-probe-liveness-tcp.yaml 
pod/pod-probe-liveness-tcp created

» kubectl get pod
NAME                     READY   STATUS    RESTARTS   AGE
pod-probe-liveness-tcp   1/1     Running   0          7s

» kubectl describe pod pod pod-probe-liveness-tcp
Events:
  Type     Reason     Age   From               Message
  ----     ------     ----  ----               -------
  Normal   Scheduled  22s   default-scheduler  Successfully assigned default/pod-probe-liveness-tcp to latihan
  Normal   Pulling    21s   kubelet            Pulling image "nginx"
  Normal   Pulled     17s   kubelet            Successfully pulled image "nginx" in 3.868622684s
  Normal   Created    17s   kubelet            Created container pod-probe-liveness-tcp
  Normal   Started    17s   kubelet            Started container pod-probe-liveness-tcp
  Warning  Unhealthy  2s    kubelet            Liveness probe failed: dial tcp 172.17.0.3:8080: connect: connection refused
Error from server (NotFound): pods "pod" not found

» kubectl get pod
NAME                     READY   STATUS    RESTARTS      AGE
pod-probe-liveness-tcp   1/1     Running   1 (40s ago)   80s
```

## Configure grpc liveness in a Pod

If your application implements [gRPC Health Checking Protocol](https://github.com/grpc/grpc/blob/master/doc/health-checking.md), kubelet can be configured to use it for application liveness checks. You must enable the `GRPCContainerProbe` [feature gate](https://kubernetes.io/docs/reference/command-line-tools-reference/feature-gates/) in order to configure checks that rely on gRPC.

Karena kami belum punya workload untuk menggunakan gRPC ini, jika menggunakan temen-temen boleh checkout di [dokumentasi resminya](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-a-grpc-liveness-probe) ya 

Jadi kita skip aja ya untuk liveness menggunakan gRPC ini.

## Configure readiness probes

Sometimes, applications are temporarily unable to serve traffic. For example, an application might need to load large data or configuration files during startup, or depend on external services after startup. In such cases, you don't want to kill the application, but you don't want to send it requests either. Kubernetes provides readiness probes to detect and mitigate these situations. A pod with containers reporting that they are not ready does not receive traffic through Kubernetes Services.

Readiness probes are configured similarly to liveness probes. The only difference is that you use the `readinessProbe` field instead of the `livenessProbe` field.

**Caution:** Liveness probes do not wait for readiness probes to succeed. If you want to wait before executing a liveness probe you should use `initialDelaySeconds` or a `startupProbe`.

Berikut contoh implementasinya:

{% gist page.gist "03h-pod-probe-readiness-http.yaml" %}

This example uses both readiness and liveness probes. The kubelet will send the first readiness probe `5 seconds` after the container starts. This will attempt to connect to the nginx container on port 80. If the probe succeeds, the Pod will be marked as ready. The kubelet will continue to run this check every `10 seconds`.

Readiness and liveness probes can be used in parallel for the same container. Using both can ensure that traffic does not reach a container that is not ready for it, and that containers are restarted when they fail.

Jika kita jalankan hasilnya seperti berikut:

```bash
» kubectl apply -f 02-workloads/01-pod/pod-probe-readiness-http.yaml  
pod/pod-probe-readiness-http created

» kubectl get pod
NAME                       READY   STATUS    RESTARTS   AGE
pod-probe-readiness-http   0/1     Running   0          6s

» kubectl describe pod pod-probe-readiness-http
Events:
  Type     Reason     Age   From               Message
  ----     ------     ----  ----               -------
  Normal   Scheduled  17s   default-scheduler  Successfully assigned default/pod-probe-readiness-http to latihan
  Normal   Pulling    16s   kubelet            Pulling image "nginx"
  Normal   Pulled     12s   kubelet            Successfully pulled image "nginx" in 3.272050844s
  Normal   Created    12s   kubelet            Created container pod-probe-readiness-http
  Normal   Started    12s   kubelet            Started container pod-probe-readiness-http
  Warning  Unhealthy  2s    kubelet            Liveness probe failed: HTTP probe failed with statuscode: 404

# wait 15s, then execute again
» kubectl describe pod pod-probe-readiness-http
Events:
  Type     Reason     Age               From               Message
  ----     ------     ----              ----               -------
  Normal   Scheduled  99s               default-scheduler  Successfully assigned default/pod-probe-readiness-http to latihan
  Normal   Pulled     94s               kubelet            Successfully pulled image "nginx" in 3.272050844s
  Normal   Pulled     50s               kubelet            Successfully pulled image "nginx" in 3.156701616s
  Warning  Unhealthy  9s (x6 over 84s)  kubelet            Liveness probe failed: HTTP probe failed with statuscode: 404
  Normal   Killing    9s (x2 over 54s)  kubelet            Container pod-probe-readiness-http failed liveness probe, will be restarted
  Normal   Pulling    9s (x3 over 98s)  kubelet            Pulling image "nginx"
  Normal   Created    5s (x3 over 94s)  kubelet            Created container pod-probe-readiness-http
  Normal   Started    5s (x3 over 94s)  kubelet            Started container pod-probe-readiness-http
  Normal   Pulled     5s                kubelet            Successfully pulled image "nginx" in 3.490931597s

» kubectl get pod
NAME                       READY   STATUS    RESTARTS      AGE
pod-probe-readiness-http   1/1     Running   1 (31s ago)   2m1s
```

## Protect slow starting container with startup probe

Sometimes, you have to deal with legacy applications that might require an additional startup time on their first initialization. In such cases, it can be tricky to set up liveness probe parameters without compromising the fast response to deadlocks that motivated such a probe. The trick is to set up a startup probe with the same command, HTTP or TCP check, with a `failureThreshold * periodSeconds` long enough to cover the worse case startup time.

So, the example would become:

{% gist page.gist "03h-pod-probe-startup-http.yaml" %}

Thanks to the startup probe, the application will have a maximum of 5 minutes (`30 * 10 = 300s`) to finish its startup. Once the startup probe has succeeded once, the liveness probe takes over to provide a fast response to container deadlocks. If the startup probe never succeeds, the container is killed after `300s` and subject to the pod's `restartPolicy`.

Jika dijalankan hasilnya seperti berikut:

```bash
» kubectl apply -f 02-workloads/01-pod/pod-probe-startup-http.yaml 
pod/pod-probe-startup-http created

» kubectl get pod
NAME                     READY   STATUS    RESTARTS   AGE
pod-probe-startup-http   0/1     Running   0          7s

» kubectl describe pod pod-probe-startup-http
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  22s   default-scheduler  Successfully assigned default/pod-probe-startup-http to latihan
  Normal  Pulling    21s   kubelet            Pulling image "nginx"
  Normal  Pulled     18s   kubelet            Successfully pulled image "nginx" in 3.397200655s
  Normal  Created    18s   kubelet            Created container pod-probe-startup-http
  Normal  Started    18s   kubelet            Started container pod-probe-startup-http

## wait 30s, then execute again and see the result
» kubectl describe pod pod-probe-startup-http
Events:
  Type     Reason     Age                 From               Message
  ----     ------     ----                ----               -------
  Normal   Scheduled  113s                default-scheduler  Successfully assigned default/pod-probe-startup-http to latihan
  Normal   Pulled     109s                kubelet            Successfully pulled image "nginx" in 3.397200655s
  Normal   Pulling    53s (x2 over 112s)  kubelet            Pulling image "nginx"
  Normal   Killing    53s                 kubelet            Container pod-probe-startup-http failed liveness probe, will be restarted
  Normal   Created    50s (x2 over 109s)  kubelet            Created container pod-probe-startup-http
  Normal   Pulled     50s                 kubelet            Successfully pulled image "nginx" in 3.373582023s
  Normal   Started    49s (x2 over 109s)  kubelet            Started container pod-probe-startup-http
  Warning  Unhealthy  8s (x5 over 83s)    kubelet            Liveness probe failed: HTTP probe failed with statuscode: 404

» kubectl get pod
NAME                     READY   STATUS    RESTARTS      AGE
pod-probe-startup-http   1/1     Running   2 (23s ago)   2m23s
```