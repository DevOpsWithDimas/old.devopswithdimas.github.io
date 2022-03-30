---
layout: post
title: "What is Kubernetes (k8s) ?"
date: 2021-12-21T03:27:42+07:00
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/
- https://minikube.sigs.k8s.io/docs/
youtube: 
comments: true
catalog_key: introduction
image_path: /resources/posts/kubernetes/01a-what-is-kubernetes
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi pertama kali ini kita akan membahas tentang pengangar untuk belajar Kubernetes (k8s). Diantaranya

1. What is Kubernetes?
2. Traditional deploy era vs Virtualized deploy era vs Container deploy era?
3. Why you need Kubernetes and What it can do?
4. What Kubernetes is not?

Ok langsung ja kita bahas materi pertama yaitu

## What is Kubernetes?

Kubernetes is a portable, extensible, open-source platform for managing containerized workloads and services, that facilitates both declarative configuration and automation. It has a large, rapidly growing ecosystem. Kubernetes services, support, and tools are widely available.

Kubernetes, also known as K8s, is an open-source system for automating deployment, scaling, and management of containerized applications. It groups containers that make up an application into logical units for easy management and discovery. Kubernetes giving you the freedom to take advantage of on-premises, hybrid, or public cloud infrastructure, letting you effortlessly move workloads to where it matters to you.

The name Kubernetes originates from Greek, meaning helmsman or pilot. K8s as an abbreviation results from counting the eight letters between the "K" and the "s". Google open-sourced the Kubernetes project in 2014. Kubernetes combines over 15 years of Google's experience running production workloads at scale with best-of-breed ideas and practices from the community.

## Traditional deploy era vs Virtualized deploy era vs Container deploy era?

Let's take a look at why Kubernetes is so useful by going back in time.

![era-comparison]({{ page.image_path | prepend: site.baseurl }}/deployments-era.png)

**Traditional deployment era**: Early on, organizations ran applications on physical servers. There was no way to define resource boundaries for applications in a physical server, and this caused resource allocation issues. For example, if multiple applications run on a physical server, there can be instances where one application would take up most of the resources, and as a result, the other applications would underperform. A solution for this would be to run each application on a different physical server. But this did not scale as resources were underutilized, and it was expensive for organizations to maintain many physical servers.

**Virtualized deployment era**: As a solution, virtualization was introduced. It allows you to run multiple Virtual Machines (VMs) on a single physical server's CPU. Virtualization allows applications to be isolated between VMs and provides a level of security as the information of one application cannot be freely accessed by another application.

Virtualization allows better utilization of resources in a physical server and allows better scalability because an application can be added or updated easily, reduces hardware costs, and much more. With virtualization you can present a set of physical resources as a cluster of disposable virtual machines.

Each VM is a full machine running all the components, including its own operating system, on top of the virtualized hardware.

**Container deployment era**: Containers are similar to VMs, but they have relaxed isolation properties to share the Operating System (OS) among the applications. Therefore, containers are considered lightweight. Similar to a VM, a container has its own filesystem, share of CPU, memory, process space, and more. As they are decoupled from the underlying infrastructure, they are portable across clouds and OS distributions.

Containers have become popular because they provide extra benefits, such as:

1. **Agile application creation and deployment**: increased ease and efficiency of container image creation compared to VM image use.
2. **Continuous development, integration, and deployment**: provides for reliable and frequent container image build and deployment with quick and efficient rollbacks (due to image immutability).
3. **Dev and Ops separation of concerns**: create application container images at build/release time rather than deployment time, thereby decoupling applications from infrastructure.
4. **Observability**: not only surfaces OS-level information and metrics, but also application health and other signals.
5. **Environmental consistency across development, testing, and production**: Runs the same on a laptop as it does in the cloud.
6. **Cloud and OS distribution portability**: Runs on Ubuntu, RHEL, CoreOS, on-premises, on major public clouds, and anywhere else.
6. **Application-centric management**: Raises the level of abstraction from running an OS on virtual hardware to running an application on an OS using logical resources.
7. Loosely coupled, distributed, elastic, liberated micro-services: applications are broken into smaller, independent pieces and can be deployed and managed dynamically – not a monolithic stack running on one big single-purpose machine.
8. **Resource isolation**: predictable application performance.
9. **Resource utilization**: high efficiency and density.

## Why you need Kubernetes and What it can do?

Containers are a good way to bundle and run your applications. In a production environment, you need to manage the containers that run the applications and ensure that there is no downtime. For example, if a container goes down, another container needs to start. Wouldn't it be easier if this behavior was handled by a system?

That's how Kubernetes comes to the rescue! Kubernetes provides you with a framework to run distributed systems resiliently. It takes care of scaling and failover for your application, provides deployment patterns, and more. For example, Kubernetes can easily manage a canary deployment for your system.

Kubernetes provides you with:

1. **Service discovery and load balancing**, No need to modify your application to use an unfamiliar service discovery mechanism. Kubernetes gives Pods their own IP addresses and a single DNS name for a set of Pods, and can load-balance across them.
2. **Automated rollouts and rollbacks**, Kubernetes progressively rolls out changes to your application or its configuration, while monitoring application health to ensure it doesn't kill all your instances at the same time. If something goes wrong, Kubernetes will rollback the change for you.
3. **Storage orchestration**, Automatically mount the storage system of your choice, whether from local storage, a public cloud provider such as GCP or AWS, or a network storage system such as NFS, iSCSI, Gluster, Ceph, Cinder, or Flocker.
4. **Secret and configuration management**, Deploy and update secrets and application configuration without rebuilding your image and without exposing secrets in your stack configuration.
5. **Batch execution**, In addition to services, Kubernetes can manage your batch and CI workloads, replacing containers that fail, if desired.
6. **Self-healing**, Restarts containers that fail, replaces and reschedules containers when nodes die, kills containers that don't respond to your user-defined health check, and doesn't advertise them to clients until they are ready to serve.
7. **Horizontal scaling**, Scale your application up and down with a simple command, with a UI, or automatically based on CPU usage.

## What Kubernetes is not?

**Kubernetes is not a traditional**, all-inclusive PaaS (Platform as a Service) system. Since Kubernetes operates at the container level rather than at the hardware level, it provides some generally applicable features common to PaaS offerings, such as deployment, scaling, load balancing, and lets users integrate their logging, monitoring, and alerting solutions. However, Kubernetes is not monolithic, and these default solutions are optional and pluggable. Kubernetes provides the building blocks for building developer platforms, but preserves user choice and flexibility where it is important.

1. Does not limit the types of applications supported. Kubernetes aims to support an extremely diverse variety of workloads, including stateless, stateful, and data-processing workloads. If an application can run in a container, it should run great on Kubernetes.
2. Does not deploy source code and does not build your application. Continuous Integration, Delivery, and Deployment (CI/CD) workflows are determined by organization cultures and preferences as well as technical requirements.
3. Does not provide application-level services, such as middleware (for example, message buses), data-processing frameworks (for example, [Spark](https://spark.apache.org/)), databases (for example, [MySQL](https://www.mysql.com/)), caches, nor cluster storage systems (for example, [Ceph](https://ceph.io/en/)) as built-in services. Such components can run on Kubernetes, and/or can be accessed by applications running on Kubernetes through portable mechanisms, such as the Open Service Broker.
4. Does not dictate logging, monitoring, or alerting solutions. It provides some integrations as proof of concept, and mechanisms to collect and export metrics.
5. Does not provide nor mandate a configuration language/system (for example, [Jsonnet](https://jsonnet.org/)). It provides a declarative API that may be targeted by arbitrary forms of declarative specifications.
6. Does not provide nor adopt any comprehensive machine configuration, maintenance, management, or self-healing systems.
7. Additionally, Kubernetes is not a mere orchestration system. In fact, it eliminates the need for orchestration. The technical definition of orchestration is execution of a defined workflow: first do A, then B, then C. In contrast, Kubernetes comprises a set of independent, composable control processes that continuously drive the current state towards the provided desired state. It shouldn't matter how you get from A to C. Centralized control is also not required. This results in a system that is easier to use and more powerful, robust, resilient, and extensible.