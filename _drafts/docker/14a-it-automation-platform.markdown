---
layout: post
title: "IT Automation Platform for Docker Operations"
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
2. How IT automation works and affects processes
3. What IT automation is used for
4. What kind a tools for IT automation

Ok langsung aja kita bahas materi yang pertama:

<!--more-->

## What is IT Automation

Profesi Operation / Infrastructure mungkin udah gak aneh lagi dengan istilah IT Automation, tapi buat saya yang berawal Programmer atau Developer ini adalah hal baru buat saya. So yuk langsung aja kita bahas 

> IT automation is the use of instructions to create a repeated process that replaces an IT professional's manual work in data centers, off-premise (cloud) or on-premise deployment. 

In this cases Software tools, frameworks and appliances conduct the tasks with minimum administrator intervention. The scope of IT automation ranges from single actions to discrete sequences and, ultimately, to an autonomous IT deployment that takes actions based on user behavior and other event triggers. 

For example: jika dalam suatu project membutuhkan beberapa software seperti Database, Programming SDK (sofware development kit), Libraries maka ada beberapa task yang perlu kita lakukan yaitu

1. Menyiapkan environment seperti server, vm, networking dan lain-lain
2. Installing operation system dalam server tersebut
3. Download dan Install software, dependency tersebut
4. Maintanance & monitoring software tersebut 
5. dan masih banyak hal lainnya yang biasanya di lakukan oleh IT Operation

Dengan menggunakan IT Operation kita bisa me-replace task/job tersebut yang tadinya di execute manual menjadi automated bisa menggunakan Scripting atau UI (user interface)

## How IT automation works and affects processes