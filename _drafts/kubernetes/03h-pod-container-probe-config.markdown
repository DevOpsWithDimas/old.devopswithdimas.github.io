---
layout: post
title: "Configure liveness, readiness, and startup probes"
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
3. Configure liveness probe in a Pod
4. Configure readiness probe in a Pod
5. Configure startup probe in a Pod
6. Motivation for using Container Probe

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
    axisFormat %H:%M
    section Startup Probe
    Container starting          :           containerStart,     12:00,                      10second
    Startup probe               :           startupTry1,        after containerStart,       1min
    Container started           :done,      containerStarted,   after startupTry1,          10second
    section Readiness Probe
    Check container is ready?   :           checkReady,         after containerStarted,     10second
    Container Ready             :done,      containerReady,     after checkReady,           30second
    section Liveness Probe
    Check container is live?    :           checkLive,          after containerReady,       10second
    Container Running           :           containerRun,       after checkLive,            30second
    Container Healty            :done,      containerHealty,    after containerRun,         10second
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

## Configure liveness command in a Pod

Description here!

## Configure TCP liveness in a Pod

Description here!

## Configure liveness HTTP in a Pod

Description here!

## Configure grpc liveness in a Pod

Description here!

## Use a named port

Description here!

## Protect slow starting container with startup probe

Description here!

## Configure readiness probes

Description here!

## Motivation for using Container Probe