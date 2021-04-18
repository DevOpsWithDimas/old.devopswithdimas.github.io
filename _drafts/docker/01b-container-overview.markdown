---
layout: post
title: "What is Container"
date: 2021-04-11T08:52:06+07:00
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://www.docker.com/resources/what-container
- https://www.docker.com/products/container-runtime
- https://en.wikipedia.org/wiki/Docker_(software)
youtube: 
comments: true
image_path: /resources/posts/docker/01b-container
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini, kita akan membahas `Apa itu Container?`, tpi sebelum itu saya mau ceritain dulu sejarahnya Docker. 

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
