---
layout: post
title: "Pipeline: Angular deploy with Gitlab CI"
lang: docker
categories:
- DevOps
- Docker
- ci
- Study-Cases
- Gitlab-CI
refs: 
- https://help.sonatype.com/repomanager3/nexus-repository-administration/formats/npm-registry
- https://docs.npmjs.com/cli/v8/configuring-npm/npmrc
- https://www.base64encode.org/
- https://www.base64decode.org/
- https://help.sonatype.com/repomanager3/nexus-repository-administration/access-control/realms
youtube: 
comments: true
catalog_key: study-cases-docker-ci
image_path: /resources/posts/docker/12f-pipeline-angular
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, di Study Kasus kali ini kita akan membahas pipeline untuk Angular application berdasarkan source-code [berikut]({% post_url docker/09-study-cases/2021-09-26-10d-compose-angular-study-case %}). Seperti biasa karena pembahasan artikel kali ini akan lumayan panjang maka kita akan bagi-bagi menjadi beberapa bagian, Diantaranya:

1. Build source-code to html, js, css resouces using Gitlab CI
2. Add cache/proxy npm using Nexus OSS to Gitlab CI
3. Build docker image using Gitlab CI
4. Testing run containers

Ok lansung aja kita ke materi yang pertama

## Build source-code to html, js, css Resouces

Dalam deployment angular application, pada dasarnya kita harus melakukan compilasi dari Typescript menjadi static resource web seperti `html`, `js` dan `css`. Untuk workflownya 

1. Install dependency menggunakan `npm`
2. Build source-code menggunakan `ng build`
3. Copy hasil build ke web server seperti nginx atau apache httpd

Tahap pertama kita build dulu menggunakan Gitlab CI, kemudian simpan dalam archived sebagai Gitlab artifact supaya bisa di gunakan next job seperti berikut

1. Buat file `.gitlab-ci.yml` seperti berikut:

    {% gist page.gist "12f-gitlab-ci.build-ng.yml" %}

2. Setelah itu, kita coba commit menggunakan perintah `git commit -m 'init project'` 

3. Kemudian coba buat repository baru, misalnya buat dengan nama `udemy-angular` dan yang terakhir coba buat tags dan push sourcenya. 

4. kemudian coba check status pipelinenya seperti berikut:

    ![pipeline-status]({{ page.image_path | prepend: site.baseurl }}/01-build-ng-pipeline.png)

5. Jika job build menggunakan `ng build` selesai, seperti berikut:

    ![pipeline-job-detail]({{ page.image_path | prepend: site.baseurl }}/02-build-ng-pipeline-job-detail.png)

6. Maka kita biasa check archived Gitlab Artifactnya seperti berikut:

    ![pipeline-artifact]({{ page.image_path | prepend: site.baseurl }}/03-build-ng-job-artifacts.png)

Dengan artifact tersebut kita bisa deploy manual atau lakukan next jobnya.

## Add cache/proxy npm using Nexus OSS

Selanjutnya kita akan bahas untuk mempercepat proses build time di Angular dengan npm, Proses download dependencies memang tergantung dari kecepatan dan bandwidth koneksi internet kita tetapi akan lebih optimal jika kita menambahkan local caching/proxy registry pada project yang berbasis NPM atau keluargannya.

Untuk project angular sendiri, biasanya isi dari dependenciesnya bisa menghabiskan lebih dari `200MB` sendiri banyangkan saja kita kita melakukan 10x build artinya kita membutuhkan quota hampir `1GB` dengan koneksi yg stable jika ingin hasilnya cepat. Ok sekarang kita akan configure dulu membuat registry npm di Nexus OSS seperti berikut:

1. Login sebagai Admin di Nexus OSS dengan akses alamat `http://192.168.88.9:8081`
2. click `Server administration & configuration`, kemudian click `Repository` dan click `Repositories`
3. Kemudian click button `Create Repository`, kemudian pilih `npm (Proxy)` untuk membuat proxy dari npm registry central. Dengan configurasi seperti berikut:
    1. Define Name e.g `npm-registry-central`
    2. Define URL for Remote storage e.g. `https://registry.npmjs.org`
    3. Select Blob store for Storage
    4. Click `Create Repository`

    ![add-npm-proxy-registry]({{ page.image_path | prepend: site.baseurl }}/04-add-npm-proxy-registry.png)

4. Kemudian kita buat group repositorynya dengan cara, Click `Create Repository` kemudian pilih `npm (Group)` dengan Configurasi seperti berikut:
    1. Define Name e.g `npm-local-group`
    2. Select Blob store for Storage
    3. Add npm repositories to the Members list in the desired order
    4. Click `Create Repository`

    ![add-npm-proxy-registry]({{ page.image_path | prepend: site.baseurl }}/05-add-npm-group-registry.png)

5. Selanjutnya kita akan apply registry config tersebut ke project kita dengan membuat file `.npmrc` pada root project kita dengan property seperti berikut:
    1. `registry` adalah url yang kita bisa dapatkan dari repository group kita buat sebelumnya contoh `http://192.168.88.9:8081/repository/npm-local-group/`
    2. `email` kita bisa isi dengan email temen-temen contoh `software.dimas_m@icloud.com`
    3. `_auth` kita bisa isi dengan user dan password nexus kita, jika user dan password adalah `admin/admin123` maka kita buat menjadi `admin:default_password` yang di format `base64` hasilnya seperti berikut: `YWRtaW46ZGVmYXVsdF9wYXNzd29yZAo=`
    4. Berikut adalah contoh selengkapnya:

        {% gist page.gist "12f-npmrc" %}

6. Selanjutnya, file tersebut kita akan simpan dalam CI/CD Variables di Gitlab dalam bentuk file dengan nama `NPM_PROXY` seperti berikut:

    ![add-variable-npm-proxy]({{ page.image_path | prepend: site.baseurl }}/06-add-variables-npm-registry.png)

7. Kemudian kita tambahkan bearer token untuk npm, dengan cara masuk ke menu `Security` kemudian pilih `Realms` dan tambahkan `npm Bearer Token Realm` ke list Active supaya bisa authenticate ke nexus

    ![add-bearer-token-realm]({{ page.image_path | prepend: site.baseurl }}/06-add-bearer-token-realm.png)

8. Kemudian kita modifikasi file `.gitlab-ci.yml` dengan menambahkan `cat $NPM_PROXY > .npmrc` pada section `before_script` seperti berikut:

    {% gist page.gist "12f-gitlab-ci.add-proxy.yml" %}

Jika sudah sekarang seperti biasa kita commit perubahanya dan push ke repository. Kemudian check pipelinenya maka hasilnya seperti berikut:

![pipeline-status]({{ page.image_path | prepend: site.baseurl }}/01-build-ng-pipeline.png)

Jika kita lihat, build pertama hasilnya akan seperti berikut:

![first-build]({{ page.image_path | prepend: site.baseurl }}/07-first-build-proxy-registry.png)

Sekarang coba retry, untuk menjalankan build ke 2, maka hasilnya seperti berikut:

![first-build]({{ page.image_path | prepend: site.baseurl }}/08-second-build-proxy-registry.png)

## Build docker image using Gitlab CI

Setelah kita compile/build source-code project Angular, kita akan build docker image menggunakan Gitlab CI.

Ok sekarang kita akan buat/modifikasi file `Dockerfile` supaya tidak menganggu tutorial sebelumnya karena kita hanya akan copy dari hasil build pipeline `build:ng` dan serve to nginx web server seperti berikut:

{% gist page.gist "12f-dockerfile-ci" %}

Setelah itu kita juga modifkasi file `.dockerignore` dengan meng-exlude folder `dist` seperti berikut:

{% gist page.gist "12f-dockerignore" %}

Dan yang terakhir, kita update/modifikasi file `.gitlab-ci.yml` seperti berikut:

{% gist page.gist "12f-gitlab-ci.build-docker.yml" %}

Jika sudah sekarang seperti biasa kita commit perubahanya dan push ke repository. Kemudian check pipelinenya maka hasilnya seperti berikut:

![pipeline-status]({{ page.image_path | prepend: site.baseurl }}/09-build-docker-pipeline.png)

Sekarang kita lihat detail jobnya seperti berikut:

![pipeline-job-build-docker]({{ page.image_path | prepend: site.baseurl }}/10-build-docker-pipeline-job-detail.png)

Dan yang terakhir, kita bisa check di private docker registry nexus seperti berikut:

![docker-image-pushed]({{ page.image_path | prepend: site.baseurl }}/11-docker-image-pushed.png)

## Testing run containers

Ok setelah kita berhasil build docker image serta mem-push ke docker insecure registry (Nexus OSS) sekarang kita coba jalankan ya containernya menggunakan compose file

Buat file `docker-compose.yaml` seperti berikut:

{% gist page.gist "12f-docker-compose.yaml" %}

Buat file `.env` seperti berikut:

{% gist page.gist "12f.env" %}

Sekarang kita jalankan dengan perintah seperti berikut:

```bash
docker-compose --env-file .env up -d
```