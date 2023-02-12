---
layout: post
title: "Study cases: Microservice apps (Springboot Rest API)"
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Pods
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/home/
- https://spring.io/projects/spring-boot
youtube: 
comments: true
catalog_key: pod-container
image_path: /resources/posts/kubernetes/04b-study-cases-microservice-apps
gist: dimMaryanto93/c8e8b75d52f1266a6bd7c8f5939c91f4
downloads: []
---

Hai semuanya, di materi study cases untuk Pod and Container specification kali ini adalah lanjutan dari sebelumnya yang lebih advanced lagi yaitu Create and build microservices dengan framework Springboot Rest API dengan architecture seperti berikut:

![architecture-deploy]({{ page.image_path | prepend: site.baseurl }}/microservice-architecture.png)

Okay nah terlihat sedikit berbeda dengan application monolith sebelumnya, disini setiap service akan saling berkomunikasi dengan menggunakan protocol yang lightwith (ringan) seperti Rest API, grpc, messaging bus, database shared dan lain-lain. Pada study kasus kali ini terlihat pada diagram tersebut masih menggunakan physical / virtual-machine deployement kita akan migrasikan menggunakan orchestration container system dengan Kubernetes. Adapun tahap-tahap yang perlu kita lakukan yaitu

1. Develop aplikasi
2. Containerize apps
3. Deploy to Kubernetes
    1. Running as a Pod with namespace
    2. Specify resource request and limit
    3. Using configmap and secret for connect to backing service
    3. Specify container probes (health check)
4. Implement API Gateway using nginx reverse proxy

Ok tanpa berlama-lama yuk langsung aja kita bahas materi yang pertama:

<!--more-->

## Development aplikasi

Dalam mendevelop aplikasi, ada beberapa hal yang perlu di persiapakan yaitu Software Development Kit dan backing service seperti Database, source-code version control dan DevTools yaitu

1. Git
2. Java Development Kit (JDK) versi 17 keatas
3. MySQL Database
4. PostgreSQL Database
5. Apache Maven
6. Text editor seperti InteliJ IDEA, Visual Studio Code dan lain-lain
7. Rest API client seperti Postman, curl dan lain-lain

Jadi temen-temen perlu install software development kita tersebut untuk cara installnya sudah pernah saya bahas di kelas [DevOps - Docker untuk Pemula s/d Mahir](https://youtube.dimas-maryanto.com/posts/devops/docker/dockerfile/study-cases/08c-build-springboot). Jika sudah temen bisa check dengan command seperti berikut:

```bash
~ » java -version
java version "19.0.1" 2022-10-18
Java(TM) SE Runtime Environment (build 19.0.1+10-21)
Java HotSpot(TM) 64-Bit Server VM (build 19.0.1+10-21, mixed mode, sharing)

~ » mvn -v
Apache Maven 3.9.0 (9b58d2bad23a66be161c4664ef21ce219c2c8584)
Maven home: /usr/local/Cellar/maven/3.9.0/libexec
Java version: 19.0.1, vendor: Oracle Corporation, runtime: /Library/Java/JavaVirtualMachines/jdk-19.jdk/Contents/Home
Default locale: en_ID, platform encoding: UTF-8
OS name: "mac os x", version: "13.2", arch: "x86_64", family: "mac"

~ » psql --version
psql (PostgreSQL) 14.7 (Homebrew)

~ » mysql --version
mysql  Ver 8.0.32 for macos13.0 on x86_64 (Homebrew)

~ » curl --version
curl 7.86.0 (x86_64-apple-darwin22.0) libcurl/7.86.0 (SecureTransport) LibreSSL/3.3.6 zlib/1.2.11 nghttp2/1.47.0
Release-Date: 2022-10-26
```

Setelah temen-temen menginstall semua Software Development Kit, kemudian yang kita butuhkan adalah source-code. Untuk source-code temen-temen bisa clone dari [github repo berikut](https://github.com/DevOpsWithDimas/kubernetes-springboot-microservice-apps) perintahnya seperti berikut:

{% highlight bash %}
git clone git@github.com:DevOpsWithDimas/kubernetes-springboot-microservice-apps.git
{% endhighlight %}