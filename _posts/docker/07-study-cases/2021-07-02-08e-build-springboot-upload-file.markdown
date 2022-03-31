---
layout: post
title: "Springboot - where data such as files/images we stored?"
date: 2021-07-02T13:47:46+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Dockerfile
- Study-Cases
refs: 
- https://docs.docker.com/
youtube: 39cBoIZviag
comments: true
catalog_key: study-cases-dockerfile
image_path: /resources/posts/docker/08e-spring-boot-upload
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, pada studi kasus kali ini kita akan membahas salah satu syarat menggunakan container yaitu dimana kita menyimpan data seperti files, media dan lain-lain. Diantaranya yang akan kita bahas yaitu

1. Don't store data inside containers
2. Using External storage provider
3. Using local volume
4. Using bind-mount
5. Cleanup

Ok langsung aja kita ke pembahasan yang pertama

<!--more-->

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

Untuk file `Dockerfile` kita masih menggunakan versi yang sebelumnya, sekarang kita coba build imagenya menggunakan perintah:

{% highlight bash %}
mvn clean -DskipTests package dockerfile:build
{% endhighlight %}

Jika dijalankan maka outputnya seperti berikut:

```powershell
➜ docker-springboot git:(master) mvn clean -DskipTests package dockerfile:build
[INFO] --- dockerfile-maven-plugin:1.4.13:build (default-cli) @ udemy-springboot-docker ---
[INFO] dockerfile: C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot\Dockerfile
[INFO] contextDirectory: C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot
[INFO] Building Docker context C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot
[INFO] Path(dockerfile): C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot\Dockerfile
[INFO] Path(contextDirectory): C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot
[INFO]
[INFO] Image will be built as docker.io/dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
[INFO]
[INFO] Step 1/16 : ARG JDK_VERSION=11-oraclelinux8
[INFO]
[INFO] Step 2/16 : FROM openjdk:${JDK_VERSION}
[INFO]
[INFO] Pulling from library/openjdk
[INFO] Digest: sha256:ddb1de39c73130e1df9da5877abbe23aff0564e7383ce02700196dcbe1d6dc8c
[INFO] Status: Image is up to date for openjdk:11-oraclelinux8
[INFO]  ---> 95cfb60ac29c
[INFO] Step 3/16 : LABEL maintainer="Dimas Maryanto <software.dimas_m@icloud.com>"
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> a4f895b3bf2f
[INFO] Step 4/16 : RUN groupadd www-data && adduser -r -g www-data www-data
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> 1d880f93b0ef
[INFO] Step 5/16 : WORKDIR /usr/local/share/applications
[INFO]
[INFO]  ---> Running in 1b0a33a3828c
[INFO] Removing intermediate container 1b0a33a3828c
[INFO]  ---> 8a644ce4d577
[INFO] Step 6/16 : USER www-data
[INFO]
[INFO]  ---> Running in 13e9c7fc9078
[INFO] Removing intermediate container 13e9c7fc9078
[INFO]  ---> 8bfa4c079b05
[INFO] Step 7/16 : ARG JAR_FILE="udemy-springboot-docker-0.0.1-SNAPSHOT.jar"
[INFO]
[INFO]  ---> Running in e3209732bdbd
[INFO] Removing intermediate container e3209732bdbd
[INFO]  ---> d37f8ff9dc03
[INFO] Step 8/16 : ADD --chown=www-data:www-data target/$JAR_FILE spring-boot.jar
[INFO]
[INFO]  ---> fec402e62740
[INFO] Step 9/16 : ENV APPLICATION_PORT=80
[INFO]
[INFO]  ---> Running in 4315cd298e8f
[INFO] Removing intermediate container 4315cd298e8f
[INFO]  ---> 2b11c2b0b4c7
[INFO] Step 10/16 : ENV PROFILE=default
[INFO]
[INFO]  ---> Running in 870128f90b85
[INFO] Removing intermediate container 870128f90b85
[INFO]  ---> 733c4f684bed
[INFO] Step 11/16 : ENV DATABASE_USER=mysql
[INFO]
[INFO]  ---> Running in e4f3f67a4ccd
[INFO] Removing intermediate container e4f3f67a4ccd
[INFO]  ---> 7800e7d0f69a
[INFO] Step 12/16 : ENV DATABASE_PASSWORD=testing
[INFO]
[INFO]  ---> Running in f9d0e69d299a
[INFO] Removing intermediate container f9d0e69d299a
[INFO]  ---> f39edbc23728
[INFO] Step 13/16 : ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "spring-boot.jar"]
[INFO]
[INFO]  ---> Running in eddfa8b70554
[INFO] Removing intermediate container eddfa8b70554
[INFO]  ---> 48050fbe1ced
[INFO] Step 14/16 : CMD ["--server.port=${APPLICATION_PORT}", "--spring.profiles.active=${PROFILE}"]
[INFO]
[INFO]  ---> Running in 3b869e9d35f7
[INFO] Removing intermediate container 3b869e9d35f7
[INFO]  ---> 0a2bff91c151
[INFO] Step 15/16 : EXPOSE ${APPLICATION_PORT}
[INFO]
[INFO]  ---> Running in 99b40b4b4bff
[INFO] Removing intermediate container 99b40b4b4bff
[INFO]  ---> 5c6236a387b4
[INFO] Step 16/16 : HEALTHCHECK --interval=5m --timeout=3s   CMD curl -f http://localhost:${APPLICATION_PORT}/actuator || exit 1
[INFO]
[INFO]  ---> Running in 96d93a01ad96
[INFO] Removing intermediate container 96d93a01ad96
[INFO]  ---> 9f63db79f673
[INFO] Successfully built 9f63db79f673
[INFO] Successfully tagged dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
[INFO]
[INFO] Detected build of image with id 9f63db79f673
[INFO] Building jar: C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot\target\udemy-springboot-docker-0.0.1-SNAPSHOT-docker-info.jar
[INFO] Successfully built docker.io/dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  32.382 s
[INFO] Finished at: 2021-07-01T23:36:49+07:00
[INFO] ------------------------------------------------------------------------

➜ docker-springboot git:(master) docker run -p 80:80 --name spring-upload -d dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
2e69f8b17e0c25a5f0b2ebffd2925d9afe697c5dd8537a75c1a0eaabe0a20da1

➜ docker-springboot git:(master)✗  docker run -p 8080:80 --name spring-upload2 -d dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
b257786834bb062df2e5c7627b34a422527c07519a9a9743d76a286053564661

➜ docker-springboot git:(master) docker exec -it -u root spring-upload mkdir -p /usr/local/share/applications/target
➜ docker-springboot git:(master) docker exec -it -u root spring-upload2 mkdir -p /usr/local/share/applications/target
➜ docker-springboot git:(master) docker exec -it -u root spring-upload chmod -R 777 /usr/local/share/applications/target
➜ docker-springboot git:(master) docker exec -it -u root spring-upload2 chmod -R 777 /usr/local/share/applications/target
```

Sekarang kita coba untuk test Rest API yang telah kita buat untuk endpoint `/api/media/upload` dan `/api/media/list` dengan menjalankan http-request file `UploadFileController.http`

![upload-first-container]({{ page.image_path | prepend: site.baseurl }}/01-no-volume-upload.png)

Kemudian kita coba liat sekarang isinya pada container `spring-upload`, seperti berikut:

![upload-first-container]({{ page.image_path | prepend: site.baseurl }}/01-no-volume-list.png)

Kemudian kita coba upload untuk container `spring-upload2`

![upload-first-container]({{ page.image_path | prepend: site.baseurl }}/01-no-volume-upload2.png)

Kemudian kita liat isinya pada container `spring-upload2` seperti berikut:

![upload-first-container]({{ page.image_path | prepend: site.baseurl }}/01-no-volume-list2.png)

Jadi Solusinya seperti apa?

1. Using external storage provider
2. Using local volume
3. Using bind-mount

Yuk kita bahas satu-per-satu mulai dari external storage provider

## Using External storage provider

Salah satu solusi untuk mepermudah manage content adalah menggunakan External storage provider seperti 

1. [amazon s3](https://aws.amazon.com/products/storage/?hp=tile&tile=solutions), 
2. [cloudinary.com](https://cloudinary.com/)
3. [imagekit.io](https://imagekit.io/)
4. Masih banyak lagi provider-provider lainnya

Jadi pada dasarnya kita nanti akan di sediankan API baik free, berbayar atau langganan, kita refactor codenya untuk diarakan ke provider tersebut masalah selesai!.

## Using local volume

Tetapi sometime and some cases, kita perlu store data di internal network. how to deal with that?

Menggunakan volume adalah salah satu solusi untuk menghandle share data tetapi disini untuk menghandle single node/machine. yap let's try it then modified file `Dockerfile` :

{% gist page.gist "08e-volume-dockerfile" %}

Kemudian kita build docker imagenya, dengan perintah:

{% highlight bash %}
mvn clean -DskipTests package dockerfile:build
{% endhighlight %}

Jika di jalankan berikut outputnya:

```powershell
➜ docker-springboot git:(master) mvn clean -DskipTests package dockerfile:build
[INFO] --- dockerfile-maven-plugin:1.4.13:build (default-cli) @ udemy-springboot-docker ---
[INFO] dockerfile: C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot\Dockerfile
[INFO] contextDirectory: C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot
[INFO] Building Docker context C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot
[INFO] Path(dockerfile): C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot\Dockerfile
[INFO] Path(contextDirectory): C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot
[INFO]
[INFO] Image will be built as docker.io/dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
[INFO]
[INFO] Step 1/19 : ARG JDK_VERSION=11-oraclelinux8
[INFO]
[INFO] Step 2/19 : FROM openjdk:${JDK_VERSION}
[INFO]
[INFO] Pulling from library/openjdk
[INFO] Digest: sha256:ddb1de39c73130e1df9da5877abbe23aff0564e7383ce02700196dcbe1d6dc8c
[INFO] Status: Image is up to date for openjdk:11-oraclelinux8
[INFO]  ---> 95cfb60ac29c
[INFO] Step 3/19 : LABEL maintainer="Dimas Maryanto <software.dimas_m@icloud.com>"
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> a4f895b3bf2f
[INFO] Step 4/19 : RUN groupadd www-data && adduser -r -g www-data www-data
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> 1d880f93b0ef
[INFO] Step 5/19 : ENV FILE_UPLOAD_STORED=/var/lib/spring-boot/data
[INFO]
[INFO]  ---> Running in e089b8bf7cf3
[INFO] Removing intermediate container e089b8bf7cf3
[INFO]  ---> d5352e3149b1
[INFO] Step 6/19 : RUN mkdir -p ${FILE_UPLOAD_STORED} && chmod -R 777 ${FILE_UPLOAD_STORED}/
[INFO]
[INFO]  ---> Running in 087266023bac
[INFO] Removing intermediate container 087266023bac
[INFO]  ---> fd407a853df4
[INFO] Step 7/19 : WORKDIR /usr/local/share/applications
[INFO]
[INFO]  ---> Running in 55dda47c736a
[INFO] Removing intermediate container 55dda47c736a
[INFO]  ---> 8d3930cf7cfe
[INFO] Step 8/19 : USER www-data
[INFO]
[INFO]  ---> Running in ec6a7bb1a929
[INFO] Removing intermediate container ec6a7bb1a929
[INFO]  ---> 1138fe60ab72
[INFO] Step 9/19 : ARG JAR_FILE="udemy-springboot-docker-0.0.1-SNAPSHOT.jar"
[INFO]
[INFO]  ---> Running in 0c52b6a9be73
[INFO] Removing intermediate container 0c52b6a9be73
[INFO]  ---> 6c92058c3bc9
[INFO] Step 10/19 : ADD --chown=www-data:www-data target/$JAR_FILE spring-boot.jar
[INFO]
[INFO]  ---> 9d5090afb679
[INFO] Step 11/19 : ENV APPLICATION_PORT=80
[INFO]
[INFO]  ---> Running in 39f98f886b92
[INFO] Removing intermediate container 39f98f886b92
[INFO]  ---> 6f02d9434959
[INFO] Step 12/19 : ENV PROFILE=default
[INFO]
[INFO]  ---> Running in c3c175b2b5b8
[INFO] Removing intermediate container c3c175b2b5b8
[INFO]  ---> ec906b273d2f
[INFO] Step 13/19 : ENV DATABASE_USER=mysql
[INFO]
[INFO]  ---> Running in 1c9f989f9c77
[INFO] Removing intermediate container 1c9f989f9c77
[INFO]  ---> 7c9302f098e1
[INFO] Step 14/19 : ENV DATABASE_PASSWORD=testing
[INFO]
[INFO]  ---> Running in 0967b0a5782b
[INFO] Removing intermediate container 0967b0a5782b
[INFO]  ---> 9811aaf100df
[INFO] Step 15/19 : VOLUME ${FILE_UPLOAD_STORED}/
[INFO]
[INFO]  ---> Running in 034818d0badf
[INFO] Removing intermediate container 034818d0badf
[INFO]  ---> 0cde1ce1f983
[INFO] Step 16/19 : ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "spring-boot.jar"]
[INFO]
[INFO]  ---> Running in f95dd22923fd
[INFO] Removing intermediate container f95dd22923fd
[INFO]  ---> 447321b3a636
[INFO] Step 17/19 : CMD ["--server.port=${APPLICATION_PORT}", "--spring.profiles.active=${PROFILE}"]
[INFO]
[INFO]  ---> Running in 4107c6ca6c5f
[INFO] Removing intermediate container 4107c6ca6c5f
[INFO]  ---> 04845cc1caf4
[INFO] Step 18/19 : EXPOSE ${APPLICATION_PORT}
[INFO]
[INFO]  ---> Running in 59171386e7a9
[INFO] Removing intermediate container 59171386e7a9
[INFO]  ---> f8fad5c84d73
[INFO] Step 19/19 : HEALTHCHECK --interval=5m --timeout=3s   CMD curl -f http://localhost:${APPLICATION_PORT}/actuator || exit 1
[INFO]
[INFO]  ---> Running in 5b586a6a2e3f
[INFO] Removing intermediate container 5b586a6a2e3f
[INFO]  ---> 754a978158fa
[INFO] Successfully built 754a978158fa
[INFO] Successfully tagged dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
[INFO]
[INFO] Detected build of image with id 754a978158fa
[INFO] Building jar: C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot\target\udemy-springboot-docker-0.0.1-SNAPSHOT-docker-info.jar
[INFO] Successfully built docker.io/dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  01:03 min
[INFO] Finished at: 2021-07-02T11:23:35+07:00
[INFO] ------------------------------------------------------------------------

➜ docker-springboot git:(master) docker image inspect dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT -f '{% raw %}{{json .Config.Volumes}}{% endraw %}'
{"/var/lib/spring-boot/data/":{}}

➜ docker-springboot git:(master) docker run -p 80:80 -v spring-upload:/var/lib/spring-boot/data --name spring-upload3 -d dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
7bdfef7ab8da5463a63738611da06d45601a0e40be01e6cfd1bf74e06e1ae9c3

➜ docker-springboot git:(master)✗  docker run -p 8080:80 -v spring-upload:/var/lib/spring-boot/data --name spring-upload4 -d dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
1571c831b3b549bd2952094f2505330356dea49e775a20c284018b10c81a7a31

➜ docker-springboot git:(master) docker volume ls
DRIVER    VOLUME NAME
local     spring-upload

➜ docker-springboot git:(master) docker container ls
CONTAINER ID   IMAGE                                                  COMMAND                  CREATED         STATUS                            PORTS                                   NAMES
1571c831b3b5   dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT   "java -Djava.securit…"   4 seconds ago   Up 4 seconds (health: starting)   0.0.0.0:8080->80/tcp, :::8080->80/tcp   spring-upload4
814130132d5f   dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT   "java -Djava.securit…"   4 minutes ago   Up 4 minutes (health: starting)   0.0.0.0:80->80/tcp, :::80->80/tcp       spring-upload3
```

Sekarang kita coba untuk test Rest API yang telah kita buat untuk endpoint `/api/media/upload` dan `/api/media/list` dengan menjalankan http-request file `UploadFileController.http`

![upload-first-container]({{ page.image_path | prepend: site.baseurl }}/02-volume-upload.png)

Kemudian kita coba liat sekarang isinya pada container `spring-upload3`, seperti berikut:

![upload-first-container]({{ page.image_path | prepend: site.baseurl }}/02-volume-list.png)

Kemudian kita coba upload untuk container `spring-upload2`

![upload-first-container]({{ page.image_path | prepend: site.baseurl }}/02-volume-upload2.png)

Kemudian kita liat isinya pada container `spring-upload4` seperti berikut:

![upload-first-container]({{ page.image_path | prepend: site.baseurl }}/02-volume-list2.png)

## Using bind-mount

Selain menggunakan local volume kita juga menggunakan bind-mount volume, jalankan image yang telah kita build sebelumnya. yaitu dengan perintah berikut:

For Bash script:

{% gist page.gist "08e-docker-run-bind-mount.bash" %}

For Powershell script:

{% gist page.gist "08e-docker-run-bind-mount.ps1" %}

Jika dijalankan maka outputnya seperti berikut:

```powershell
➜ docker-springboot git:(master) docker run --name spring-upload5 `
>> -p 80:80 `
>> --mount type=bind,source="$(pwd)"/files,destination=/var/lib/spring-boot/data `
>> -d dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
8a8638663c4fdf6cbc967a7018a1dade6c20466c0b26c119fa936ac2bdd84043

➜ docker-springboot git:(master) ls .\files\
```

Sekarang kita coba untuk test Rest API yang telah kita buat untuk endpoint `/api/media/upload` dan `/api/media/list` dengan menjalankan http-request file `UploadFileController.http`

![upload-first-container]({{ page.image_path | prepend: site.baseurl }}/03-bind-mount-upload.png)

Kemudian kita coba liat sekarang isinya pada container `spring-upload5`, seperti berikut:

![upload-first-container]({{ page.image_path | prepend: site.baseurl }}/03-bind-mount-list.png)

Sekarang kita check di local file menggunakan exploler seperti berikut:

![upload-first-container]({{ page.image_path | prepend: site.baseurl }}/03-bind-mount-list2.png)

## Cleanup

Seperti biasa, setelah kita mencoba schenario diatas sekarang kita bersih-bersih dulu ya, berikut perintahnya:

For Bash script:

{% gist page.gist "08e-cleanup.bash" %}

For Powershell script:

{% gist page.gist "08e-cleanup.ps1" %}