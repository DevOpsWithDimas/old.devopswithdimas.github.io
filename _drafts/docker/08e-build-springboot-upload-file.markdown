---
layout: post
title: "Studi Kasus: Springboot where data such as files/images we stored?"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/
youtube: 
comments: true
image_path: /resources/posts/docker/08f-build-springboot-upload
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, pada studi kasus kali ini kita akan membahas salah satu syarat menggunakan container yaitu dimana kita menyimpan data seperti files, media dan lain-lain. Diantaranya yang akan kita bahas yaitu

1. Don't store data inside containers
2. Using External storage
3. Using local volume
4. Using bind-mount
5. Using shared volume

Ok langsung aja kita ke pembahasan yang pertama

## Don't store data inside containers

Jika temen-temen masih ingat pada materi sebelumya tentang [persistence volume]({% post_url docker/05-docker-volume/2021-06-01-06-docker-volume %}), kita tidak disarankan untuk menyimpan data ke dalam suatu container karena 

1. Akan membuat image semakin lama, semakin besar
2. Container yang kita jalankan tidak boleh di destroy, karena data yang kita simpan akan hilang.
3. Membuat aplikasi tidak scaleble, karena container akan menggunakan storage masing-masing.

Contohnya, sekarang kita tambahkan feature pada project `spring-boot` yang telah kita buat sebelumnya untuk melakukan upload-file dan view list files. Dengan menambahkan file berikut:

1. `pom.xml`, tambahkan dependency untuk `commons-io:commons-io`, `commons-fileupload:commons-fileupload` dan `org.springframework.boot:spring-boot-starter-validation` seperti berikut:

    {% gist page.gist "08e-pom.xml" %}

2. `application.properties`, tambahkan env variable lokasi file upload seperti berikut:

    {% gist page.gist "08e-application.properties" %}

3. Buat class java baru dalam package `com.maryanto.dimas.udemy.controller` dengan nama `UploadFileController` seperti berikut:

    {% gist page.gist "08e-UploadFileController.java" %}

4. Dan yang terakhir, untuk melakukan testnya kita buat http-request file pada folder `src/test/resources` dengan contohnya `UploadFileControler.http` seperti berikut:

    {% gist page.gist "08e-UploadFileController.http" %}

5. Serta untuk env pada file `UploadFileController.http` buat file env dengan nama `http-client.json` seperti berikut:

    {% gist page.gist "08e-http-client.env.json" %}
