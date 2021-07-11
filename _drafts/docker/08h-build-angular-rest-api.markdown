---
layout: post
title: "Study Cases: Angular project access Rest API"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://angular.io/guide/deployment
youtube: 
comments: true
image_path: /resources/posts/docker/08h-angular-httpclient
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali kita akan membahas tentang Access Rest API dari project SpringBoot sebelumnya menggunakan Angular project. Diantaranya yang kita bahas yaitu

1. Create service `http/client`
2. Using default Environment
3. Build & run docker images
4. Cleanup

Ok langsung aja kita ke pembahasan yang partama

## Create service `http/client`

Pada materi [sebelumnya]({% post_url docker/07-study-cases/2021-07-09-08g-build-angular-project %}) kita udah membuat angular project dan membuat Rest API service dengan [spring-boot]({% post_url docker/07-study-cases/2021-07-02-08f-build-springboot-using-db %}) yang sudah menjadi docker image, sekarang kita lanjutkan untuk mengakses Rest API tersebut menggunakan angular project ya. 

Kita buat dulu feature list dan tambah `Mahasiswa` serta service untuk mengakses Rest API seperti berikut:

1. Create Model mahasiswa, `ng generate class model/mahasiswa --skip-tests` seperti berikut:
    {% gist page.gist "08h-ng-gclass-mahasiswa-model.ts" %}
2. Create Service mahasiswa, `ng generate service service/mahasiswa-service --skip-tests` seperti berikut:
    {% gist page.gist "08h-ng-gs-mahasiswa-service.ts" %}
3. Enable `HttpClientModule` dan `ReactiveFormsModule` pada `app.module.ts` seperti berikut:
    {% gist page.gist "08h-enable-http-client-module.ts" %}
4. Create List Mahasiswa, `ng generate component pages/mahasiswa-list --skip-tests` seperti berikut:
    {% gist page.gist "08h-ng-gc-mahasiswa-list.ts" %}
    {% gist page.gist "08h-ng-gc-mahasiswa-list.html" %}