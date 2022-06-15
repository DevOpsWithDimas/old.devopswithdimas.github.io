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
2. When should you use liveness probe?
3. Configure liveness probe in a Pod
4. When should you use readiness probe?
5. Configure readiness probe in a Pod
6. When should you use startup probe?
7. Configure startup probe in a Pod
8. Motivation for using Container Probe

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
    Container starting          :           containerStart,     12:00,                  10second
    Startup probe               :           startupTry1,        after containerStart,   1min
    Container started           :done,      containerStarted,   after startupTry1,      10second
    section Readiness Probe
    Check container is ready?   :           checkReady,     after containerStarted,     10second
    Container Ready             :           containerReady, after checkReady,           30second
    section Liveness Probe
    Check container is live?    :           checkLive,      after containerReady,       10second
    Container Running           :           containerRun,   after checkLive,            30second
{% endmermaid %}