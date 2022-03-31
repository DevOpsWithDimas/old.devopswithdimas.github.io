---
layout: post
title: "Pipeline: Java Web deployment using Gitlab CI"
date: 2021-11-27T19:09:57+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- ci
- Study-Cases
- Gitlab-CI
refs: 
- https://docs.docker.com/
youtube: bxXUfcbS9qU
comments: true
catalog_key: study-cases-docker-ci
image_path: /resources/posts/docker/12d-pipeline-javaweb
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, di materi study kasus kali ini kita akan membahas Build pipeline untuk Java Web menggunakan Gitlab CI, source-code yang kita gunakan berdasarkan study kasus sebelumnya yaitu [seperti berikut]({% post_url docker/07-study-cases/2021-06-29-08b-using-maven-docker-plugin %}):

Pipeline yang kita buat diantaranya:

1. Build docker image using `maven-dockerfile-plugin`
2. Push to docker registry
3. Add proxy / local caching from maven registry using Nexus OSS

<!--more-->

Ok langusung aja kita buat file `.gitlab-ci.yml` seperti berikut:

{% gist page.gist "12d-gitlab-ci.yml" %}

Setelah itu, kita buat repository baru di Gitlab dan kemudian push source-code kita ke sana. maka hasilnya seperti berikut:

![source-code]({{ page.image_path | prepend: site.baseurl }}/01-push-code.png)

Sebelum kita deploy, kita buat variable dulu di CI/CD di level Project / Group

name: `M2_PROXY`, 
type: `file`, 
protected: `no`
value: 

```xml
<?xml version="1.0" encoding="UTF-8"?>
<settings>
   <servers>
      <server>
         <id>192.168.88.9:8086</id>
         <username>admin</username>
         <password>default_password</password>
      </server>
      <server>
         <id>192.168.88.9:8087</id>
         <username>admin</username>
         <password>default_password</password>
      </server>
   </servers>
</settings>
```

Seperti berikut:

![m2-proxy-variables]({{ page.image_path | prepend: site.baseurl }}/02-variables-m2proxy.png)

Kemudian, kita buat `git tag` bisa melalui command line atau pun gitlab seperti berikut:

{% highlight git %}
git tag -a <tag-version> -m "your-tag-message"

git push origin main --tags
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ docker git:(main) git tag -a 2021.11.27.17.23-release -m "first build javaweb using gitlab ci"

➜ docker git:(main) git push -u demo main --tags
info: detecting host provider for 'http://192.168.88.10/'...
Enumerating objects: 48, done.
Counting objects: 100% (48/48), done.
Delta compression using up to 16 threads
Compressing objects: 100% (34/34), done.
Writing objects: 100% (45/45), 6.79 KiB | 3.39 MiB/s, done.
Total 45 (delta 15), reused 23 (delta 7), pack-reused 0
To http://192.168.88.10/root/udemy-javaweb.git
 * [new tag]         2021.11.27.17.23-release -> 2021.11.27.17.23-release
Branch 'main' set up to track remote branch 'main' from 'demo'.
```

Pada pipeline di tersebut agak sedikit berbeda dengan sebelum-sebelumnya. Jadi disini kita menggunakan docker image `maven:maven:3.6.3-jdk-11` untuk melakukan build docker image dan service `docker:18.09-dind`

Nah sekarang kita bisa check pada pipeline, jika sukses maka hasilnya seperti berikut:

![pipeline-success]({{ page.image_path | prepend: site.baseurl }}/03-image-pushed.png)

## Add caching from maven registry using Nexus OSS

Selanjutnya kita akan bahas untuk mempercepat proses build di maven, jika temen-temen perhatikan dalam hasil build sebelumnya membutuhkan waktu lebih dari 5 menit dalam mendownload dependency dan plugin dari maven repository. Kita sudah menggunakan local caching gitlab tpi akan lebih cepet lagi menggunakan proxy repository maven dengan bantuan Nexus OSS.

Ok langusung ja, update configurasi variable untuk `M2_PROXY` seperti berikut:

{% gist page.gist "12d-m2-proxy.xml" %}

Sekarang kita coba build ulang, dengan klik button retry kita liat first run seperti berikut:

![cache-first-run]({{ page.image_path | prepend: site.baseurl }}/04-caching-first-run.png)

Sekarang kita coba lagi untuk second run, semoga terlihat perbedaannya seperti berikut hasilnya:

![cache-2nd-run]({{ page.image_path | prepend: site.baseurl }}/05-caching-2nd-run.png)

Nah sekarang terlihat ya perbedaanya dari `1 menit lebih` ke `5 detik` build timenya.