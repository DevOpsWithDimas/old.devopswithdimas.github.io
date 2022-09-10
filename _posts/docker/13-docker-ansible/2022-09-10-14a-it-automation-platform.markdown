---
layout: post
title: "IT Automation Platform for Docker Operations"
date: 2022-09-10T17:18:51+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
refs: 
- https://docs.docker.com/
- https://www.redhat.com/en/technologies/management/ansible
youtube: 
comments: true
catalog_key: study-cases-ansible
image_path: /resources/posts/docker/14a-it-automation-platform
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini kita akan membahas salah satu topic yang lumayan menarik dikalangan DevOps yaitu IT Automation khususnya untuk Docker Operation diantaranya:

1. What is IT Automation?
2. What IT automation is used for?
3. What kind a tools for IT automation?
4. What is RedHat Ansible?

Ok langsung aja kita bahas materi yang pertama:

<!--more-->

## What is IT Automation

Profesi Operation / Infrastructure mungkin udah gak aneh lagi dengan istilah IT Automation, tapi buat saya yang berawal Programmer atau Developer ini adalah hal baru buat saya. So yuk langsung aja kita bahas 

> IT automation is the use of instructions to create a repeated process that replaces an IT professional's manual work in data centers, off-premise (cloud) or on-premise deployment. 

In this cases Software tools, frameworks and appliances conduct the tasks with minimum administrator intervention. The scope of IT automation ranges from single actions to discrete sequences and, ultimately, to an autonomous IT deployment that takes actions based on user behavior and other event triggers. 

For example: jika dalam suatu project membutuhkan beberapa software seperti Database, Programming language SDK (sofware development kit), Libraries maka ada beberapa task yang perlu kita lakukan yaitu

1. Menyiapkan environment seperti server, virtual-machine, network dan lain-lain yang sifatnya infrastructure
2. Installing Operation System (OS) dalam server tersebut
3. Download dan Install software, dependency tersebut
4. Maintanance & Monitoring hardware dan software 
5. Update & Patch software.
6. dan masih banyak hal lainnya yang biasanya di lakukan oleh IT Operation

Dengan menggunakan IT automation kita bisa me-replace task/job tersebut yang tadinya di execute manual menjadi automated bisa menggunakan Scripting atau UI (user interface)

## What IT automation is used for

IT operations managers can use IT automation for several tasks, including:

1. **Incident management**. Although organizations can't avoid all major incidents, IT automation can help companies deal with them when they happen. Using automation to respond to major incidents helps enterprises restore service faster and with fewer errors.
2. **Application deployment**. Whether organizations use traditional or continuous integration and continuous application deployment approaches, automating essential tasks and capabilities, particularly during testing, can help them successfully deploy their applications.
3. **Security and compliance**: IT operations managers can use IT automation to define and enforce security, compliance and risk management policies as well as remediate any issues by building them as automated steps throughout their infrastructures. For example apply firewall in any server inside infrastructure

Every day, IT operations managers struggle to get more work done with fewer people. IT automation offers several benefits to help them streamline IT operations, including:

1. **Reduced costs**. Automating repeatable operational tasks, such as application deployment and service fulfillment, change and release management and patch management, can help IT operations save money by operating more efficiently, making fewer errors and reducing headcount.
2. **Increased productivity**. Automating workflows eliminates manual work, including manual testing, boosting output and freeing up workers to focus on more important projects. In addition, employees can do more work every day.
3. **Increased availability**. One of IT operations' most important priorities is to ensure the highest level of system availability. By automating save and recovery systems, as well as system monitoring and remote communication, IT operations can significantly reduce downtime and facilitate disaster recovery more quickly.
4. **Greater reliability**. Automating tedious, repetitive tasks reduces costly errors by eliminating the human factor. This is particularly beneficial in larger networks with numerous operating systems. By automating repetitive, manual business processes, IT operations managers can greatly improve reliability while at the same time relieve workers of these mundane, manual tasks.
5. **Better performance**. Not only are IT operations managers being asked to do more work, they're being asked to perform these tasks more quickly and more efficiently. IT automation tools can help them improve performance without having to add more staff.

## What kind a tools for IT automation

Ada banyak sekali tools IT autommation, dengan berbagai macam kategori seperti:

1. Automate Endpoint Tasks
2. Workload Automation
3. Job scheduling
4. Infrastructure configuration
5. Event-Driven automation
6. Application Deployment, Configuration Management, and Continuous Delivery

Jadi kali ini kita akan membahas tentang Application Deploymment, Configuration Management, and Continuous Delivery yaitu menggunakan Tools RedHat Ansible.

Ansible is an IT Automation platform that provides the simplest way to automate apps and IT infrastructure. It can be used for Application Deployment, Configuration Management, and Continuous Delivery. It is designed for multi-tire deployments. 

Ansible has an efficient architecture. It will connect to your nodes and push out small programs called “Ansible Modules” to them. These programs will be the resource models of the desired state of the system. These modules will be executed by the Ansible and will remove them when finished. No servers, daemons, or databases will be required.

## What is RedHat Ansible

Ansible is an agentless automation tool that you install on a single host (referred to as the control node). From the control node, Ansible can manage an entire fleet of machines and other devices (referred to as managed nodes) remotely with SSH, Powershell remoting, and numerous other transports, all from a simple command-line interface with no databases or daemons required.

For your control node (the machine that runs Ansible), you can use nearly any UNIX-like machine with Python 3.8 or newer installed. This includes Red Hat, Debian, Ubuntu, macOS, BSDs, and Windows under a Windows Subsystem for Linux (WSL) distribution. Windows without WSL is not natively supported as a control node;