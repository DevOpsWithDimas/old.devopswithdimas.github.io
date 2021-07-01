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
image_path: /resources/posts/docker/08e-spring-boot-upload
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