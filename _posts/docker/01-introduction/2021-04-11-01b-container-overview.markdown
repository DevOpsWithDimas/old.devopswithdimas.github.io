---
layout: post
title: "What is Container"
date: 2021-04-11T08:52:06+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
refs: 
- https://www.docker.com/resources/what-container
- https://www.docker.com/products/container-runtime
- https://en.wikipedia.org/wiki/Docker_(software)
youtube: tKeSqHp57Uc
comments: true
catalog_key: introduction
image_path: /resources/posts/docker/01b-container
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini, kita akan membahas `Apa itu Container?`, tpi sebelum itu saya mau ceritain dulu sejarahnya Docker. 

<!--more-->

> Docker Inc. was founded by Kamel Founadi, Solomon Hykes, and Sebastien Pahl during the Y Combinator Summer 2010 startup incubator group and launched in 2011. The startup was also one of the 12 startups in Founder's Den first cohort. Hykes started the Docker project in France as an internal project within dotCloud, a platform-as-a-service company. Docker debuted to the public in Santa Clara at PyCon in 2013. It was released as open-source in March 2013.

Adoption:

1. **September 19, 2013**: Red Hat and Docker announced a collaboration around Fedora, Red Hat Enterprise Linux (RHEL), and OpenShift.
2. **October 15, 2014**: Microsoft announced the integration of the Docker engine into Windows Server
3. **November 2014**: Docker container services were announced for the Amazon Elastic Compute Cloud (EC2)
4. **December 4, 2014**: IBM announced a strategic partnership with Docker that enables Docker to integrate more closely with the IBM Cloud.
5. **June 8, 2016**: Microsoft announced that Docker could now be used natively on Windows 10.
6. **May 6, 2019**: Microsoft announced the second version of Windows Subsystem for Linux (WSL). Docker, Inc. announced that it has started working on a version of Docker for Windows that runs on WSL 2.[59] In particular, this means Docker can run on Windows 10 Home (previously it was limited to Windows Pro and Enterprise since it used Hyper-V).
7. **August 2020**: Microsoft announced backport of WSL2 to Windows 10 versions 1903 and 1909 (previously WSL2 was available only on version 2004)

## Virtualization container terminology

Sebelum era container, Virtual-machine sangat merajai dunia infrastructure mulai dari Oracle Virtualbox, VMware, QEMU ,Citrix Hypervisor, Microsoft Hyper-V dan lain-lain. Jika digambarkan maka seperti berikut kurang-lebih architecturenya:

![vm-containers]({{ page.image_path | prepend: site.baseurl }}/vm.png)

> Virtual machines (VMs) are an abstraction of physical hardware turning one server into many servers. The hypervisor allows multiple VMs to run on a single machine. Each VM includes a full copy of an operating system, the application, necessary binaries and libraries - taking up tens of GBs. VMs can also be slow to boot.

## Docker Container terminology

![container]({{ page.image_path | prepend: site.baseurl }}/container.png)

> Containers are an abstraction at the app layer that packages code and dependencies together. Multiple containers can run on the same machine and share the OS kernel with other containers, each running as isolated processes in user space. Containers take up less space than VMs (container images are typically tens of MBs in size), can handle more applications and require fewer VMs and Operating systems.

> Containers and virtual machines have similar resource isolation and allocation benefits, but function differently because containers virtualize the operating system instead of hardware. Containers are more portable and efficient.

Docker containers that run on Docker Engine:

1. **Standard**: Docker created the industry standard for containers, so they could be portable anywhere
2. **Lightweight**: Containers share the machine’s OS system kernel and therefore do not require an OS per application, driving higher server efficiencies and reducing server and licensing costs
3. **Secure**: Applications are safer in containers and Docker provides the strongest default isolation capabilities in the industry

## Docker Engine

![docker-engine]({{ page.image_path | prepend: site.baseurl }}/docker-runtime.png)

> Docker Engine is the industry’s de facto container runtime that runs on various Linux (CentOS, Debian, Fedora, Oracle Linux, RHEL, SUSE, and Ubuntu) and Windows Server operating systems. Docker creates simple tooling and a universal packaging approach that bundles up all application dependencies inside a container which is then run on Docker Engine. Docker Engine enables containerized applications to run anywhere consistently on any infrastructure, solving “dependency hell” for developers and operations teams, and eliminating the “it works on my laptop!” problem.