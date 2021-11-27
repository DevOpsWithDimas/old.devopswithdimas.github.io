---
layout: post
title: "Pipeline: PHP deployment using Gitlab CI"
lang: docker
categories:
- DevOps
- Docker
- Context
- Study-Cases
- Gitlab-CI
refs: 
- https://docs.docker.com/
youtube: 
comments: true
catalog_key: study-cases-docker-ci
image_path: /resources/posts/docker/12c-pipeline-php
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, di materi study kasus kali ini kita akan membahas Build Pipeline untuk PHP menggunakan Gitlab CI, source-code yang kita gunakan berdasarkan study kasus sebelumnya yaitu [seperti berikut]({% post_url docker/09-study-cases/2021-09-10-10a-compose-php-study-case %}). 

Pipeline yang kita akan buat diantaranya:

1. Build Docker image
2. Push to docker registry

Ok langsung aja, kita buat file `.gitlab-ci.yml` seperti berikut:

{% gist page.gist "12c-gitlab-ci.yml" %}

Setelah itu, kita buat repository baru di Gitlab dan kemudian push source-code kita ke sana. maka hasilnya seperti berikut:

![source-code]({{ page.image_path | prepend: site.baseurl }}/01-push-code.png)

Kemudian, kita buat `git tag` bisa melalui command line atau pun gitlab seperti berikut:

{% highlight git %}
git tag -a <tag-version> -m "your-tag-message"

git push origin main --tags
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ docker git:(main)✗  git tag -a 2021.11.27.14.01-release -m "first deploy with gitlab ci"

➜ docker git:(main) git push demo main --tags
info: detecting host provider for 'http://192.168.88.10/'...
Enumerating objects: 11, done.
Counting objects: 100% (11/11), done.
Delta compression using up to 16 threads
Compressing objects: 100% (8/8), done.
Writing objects: 100% (10/10), 2.46 KiB | 2.46 MiB/s, done.
Total 10 (delta 0), reused 6 (delta 0), pack-reused 0
To http://192.168.88.10/root/udemy-php.git
 * [new tag]         2021.11.27.14.01-release -> 2021.11.27.14.01-release
```

Setelah itu kita bisa check di pipeline, apakah buildnya sukses?? seperti berikut

![success-build-docker-image]({{ page.image_path | prepend: site.baseurl }}/02-success-build.png)

Kemudian jika kita coba check di Nexus OSS, maka docker imagenya sudah tersimpan/pushed seperti berikut

![nexus-image]({{ page.image_path | prepend: site.baseurl }}/03-image-pushed.png)

Sekarang jika kita coba running, imagenya dengan perintah seperti berikut:

{% highlight bash %}
docker run -d -p 8080:80 192.168.88.9:8086/udemy/study-cases/php:latest
{% endhighlight %}

Maka hasilnya seperti berikut:

![docker-run]({{ page.image_path | prepend: site.baseurl }}/04-docker-run.png)
