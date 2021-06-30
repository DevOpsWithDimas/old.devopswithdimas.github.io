---
layout: post
title: "Studi Kasus: Build docker image for spring-boot"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/
youtube: 
comments: true
image_path: /resources/posts/docker/08c-spring-boot-part1
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas studi kasus menggunakan Java Framework yaitu [spring-boot](https://spring.io/projects/spring-boot). Java spring-boot framework ini udah menjadi mature di beberapa corporate/startup di indonesia, jadi saya putuskan untuk membahas juga untuk dibuatkan containerization-nya. Berikut yang akan kita bahas yaitu

1. Create project spring-boot
2. Build docker image
3. Development lifecycle and Containerization
4. Cleanup

Ok langsung ja, kita bahas materi pertama 

## Create project `spring-boot`

Untuk membuat project `spring-boot`, kita bisa menggunakan [start.spring.io](https://start.spring.io/) seperti berikut:

![start.spring.io]({{ page.image_path | prepend: site.baseurl }}/start-spring-io.png)

Dengan setting properties:

1. Project: `Maven Project`
2. Spring Boot: `2.5.2`, ini adalah spring-boot version yang digunakan.
3. Project Metadata:
    1. Group: `com.maryanto.dimas.udemy`, untuk ini silahkan isi dengan alamat email kalian tetapi penulisannya di balik dan tanpa character khusus.
    2. Artifact: `udemy-springboot-docker`, untuk field ini di isi dengan nama aplikasi kalian
    3. Name: `udemy-springboot-docker`, untuk field ini di isi dengan nama aplikasi kalian sebagai description
    4. Package name: `com.maryanto.dimas.udemy`, untuk field ini di isi sama dengan group name
    5. Packaging: `Jar`, untuk field ini kita pilih `jar` supaya bisa di jalankan secara standalone/service 
    6. Java: `11`, untuk field ini temen-temen bebas versinya java. Untuk jaman sekarang `2021` kita pilih ja versi `11`
4. Dependencies:
    1. `Spring Boot DevTools`
    2. `Lombok`
    3. `Spring Web`
    4. `Spring Boot Actuator`
    5. `Thymeleaf`

Setelah itu klick button `GENERATE`, maka kita akan di berikan compressed file `.zip` untuk template projectnya. Setelah itu kita buka menggunakan text editor seperti 

1. Visual Studio Code
2. IntelliJ IDEA
3. Netbeans
4. Eclipse

Silahkan temen-temen pilih salah satu ja. Setelah itu buka projectnya dan untuk development environtment yang perlu kita install yaitu 

1. [Java JDK 11](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html)
2. [Apache Maven](https://maven.apache.org/download.cgi)

Untuk menjalankan project development mode dengan perintah:

{% highlight bash %}
mvn clean spring-boot:run
{% endhighlight %}

Jika kita jalankan maka outputnya seperti berikut:

```powershell
➜ udemy-springboot-docker git:(master) mvn clean spring-boot:run
[INFO] Scanning for projects...
[INFO]
[INFO] ----------< com.maryanto.dimas.udemy:udemy-springboot-docker >----------
[INFO] Building udemy-springboot-docker 0.0.1-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v2.5.2)

2021-06-29 06:25:41.548  INFO 6152 --- [  restartedMain] c.m.d.u.UdemySpringbootDockerApplication : Starting UdemySpringbootDockerApplication using Java 11.0.9 on MSI-z390-pro with PID 6152 (C:\Users\dimasm93\Workspaces\Example\udem
y-springboot-docker\target\classes started by dimasm93 in C:\Users\dimasm93\Workspaces\Example\udemy-springboot-docker)
2021-06-29 06:25:41.550  INFO 6152 --- [  restartedMain] c.m.d.u.UdemySpringbootDockerApplication : No active profile set, falling back to default profiles: default
2021-06-29 06:25:41.580  INFO 6152 --- [  restartedMain] .e.DevToolsPropertyDefaultsPostProcessor : Devtools property defaults active! Set 'spring.devtools.add-properties' to 'false' to disable
2021-06-29 06:25:41.581  INFO 6152 --- [  restartedMain] .e.DevToolsPropertyDefaultsPostProcessor : For additional web related logging consider setting the 'logging.level.web' property to 'DEBUG'
2021-06-29 06:25:42.422  INFO 6152 --- [  restartedMain] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8080 (http)
2021-06-29 06:25:42.429  INFO 6152 --- [  restartedMain] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2021-06-29 06:25:42.429  INFO 6152 --- [  restartedMain] org.apache.catalina.core.StandardEngine  : Starting Servlet engine: [Apache Tomcat/9.0.48]
2021-06-29 06:25:42.473  INFO 6152 --- [  restartedMain] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
2021-06-29 06:25:42.473  INFO 6152 --- [  restartedMain] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 892 ms
2021-06-29 06:25:42.690  WARN 6152 --- [  restartedMain] ion$DefaultTemplateResolverConfiguration : Cannot find template location: classpath:/templates/ (please add some templates or check your Thymeleaf configuration)
2021-06-29 06:25:42.748  INFO 6152 --- [  restartedMain] o.s.b.d.a.OptionalLiveReloadServer       : LiveReload server is running on port 35729
2021-06-29 06:25:42.751  INFO 6152 --- [  restartedMain] o.s.b.a.e.web.EndpointLinksResolver      : Exposing 1 endpoint(s) beneath base path '/actuator'
2021-06-29 06:25:42.777  INFO 6152 --- [  restartedMain] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
2021-06-29 06:25:42.787  INFO 6152 --- [  restartedMain] c.m.d.u.UdemySpringbootDockerApplication : Started UdemySpringbootDockerApplication in 1.502 seconds (JVM running for 1.801)
```

Sekarang klo kita coba akses menggunakan browser [localhost:8080/actuator](http://localhost:8080/actuator) seperti berikut:

![springboot-actuator]({{ page.image_path | prepend: site.baseurl }}/spring-actuator.png)

## Build docker image

Untuk membuat docker image menggunakan `spring-boot` framework yang kita butuhkan yaitu 

1. `Dockerfile`
2. `.dockerignore`
3. `dockerfile-maven` plugin
4. `setting.xml` for Authentication
5. `jar` file hasil dari `mvn clean -DskipTests package`

Berikut adalah setup `Dockerfile` untuk `spring-boot` framework yang di jalankan sebagai executeable:

{% gist page.gist "08c-dockerfile" %}

Selanjutnya buat file dengan nama `.dockerignore` seperti berikut:

{% gist page.gist "08c-dockerignore" %}

Tahap selanjutnya temen-temen boleh coba test dulu sebelum menggunakan plugin dengan `mvn package` command dan `docker build` command

Seperti berikut:

{% highlight bash %}
mvn clean -DskipTests package && \
docker build -t dimmaryanto93/spring-boot:0.0.1-snapshot && \
docker run --name springapp -p 8080:8080 -d dimmaryanto93/spring-boot:0.0.1-snapshot
{% endhighlight %}

Jika dijalankan hasilnya seperti berikut:

```powershell
➜ udemy-springboot-docker git:(master) mvn clean -DskipTests package
[INFO]
[INFO] --- maven-jar-plugin:3.2.0:jar (default-jar) @ udemy-springboot-docker ---
[INFO] Building jar: C:\Users\dimasm93\Workspaces\Example\udemy-springboot-docker\target\udemy-springboot-docker-0.0.1-SNAPSHOT.jar
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  2.734 s
[INFO] Finished at: 2021-06-29T07:57:06+07:00
[INFO] ------------------------------------------------------------------------

➜ udemy-springboot-docker git:(master) docker build -t dimmaryanto93/spring-boot:0.0.1-snapshot .
[+] Building 1.3s (10/10) FINISHED
 => [internal] load build definition from Dockerfile                                                               0.0s
 => => transferring dockerfile: 32B                                                                                0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 35B                                                                                   0.0s
 => [internal] load metadata for docker.io/library/openjdk:11-oraclelinux8                                         1.2s
 => [1/5] FROM docker.io/library/openjdk:11-oraclelinux8@sha256:11d0c95d44779dc85efd958fce96f86f7338508de347ea000  0.0s
 => [internal] load build context                                                                                  0.0s
 => => transferring context: 99B                                                                                   0.0s
 => CACHED [2/5] RUN groupadd www-data && adduser -r -g www-data www-data                                          0.0s
 => CACHED [3/5] WORKDIR /usr/local/share/apps                                                                     0.0s
 => CACHED [4/5] COPY --chown=www-data target/ .                                                                   0.0s
 => CACHED [5/5] RUN mv *.jar application.jar                                                                      0.0s
 => exporting to image                                                                                             0.0s
 => => exporting layers                                                                                            0.0s
 => => writing image sha256:604f0c0a765fb32101af6ad6ed99e5a24e94c91b834d3fbe35eed57911724794                       0.0s
 => => naming to docker.io/dimmaryanto93/spring-boot:0.0.1-snapshot

➜ udemy-springboot-docker git:(master) docker run --name springapp -p 8080:8080 -d dimmaryanto93/spring-boot:0.0.1-snapshot
86fe9e12f66a51c8d7ef6f2cde90521f335e9f7cbf2ee645f30bd78bc54fc23b

➜ udemy-springboot-docker git:(master) docker container ls
CONTAINER ID   IMAGE                                      COMMAND                  CREATED         STATUS                            PORTS                                       NAMES
86fe9e12f66a   dimmaryanto93/spring-boot:0.0.1-snapshot   "java -jar -Djava.se…"   3 seconds ago   Up 3 seconds (health: starting)   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   springapp

➜ udemy-springboot-docker git:(master)✗  docker stats --no-stream springapp
CONTAINER ID   NAME        CPU %     MEM USAGE / LIMIT     MEM %     NET I/O     BLOCK I/O   PIDS
86fe9e12f66a   springapp   0.09%     227.9MiB / 3.842GiB   5.79%     906B / 0B   0B / 0B     33

➜ udemy-springboot-docker git:(master) docker top springapp
UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
999                 10690               10669               8                   00:59               ?                   00:00:05            java -jar -Djava.security.egd=file:/dev/./urandom application.jar
```

Setelah semuanya aman, kita bisa tambahkan `dockerfile-maven` plugin dengan meng-edit file `pom.xml` seperti berikut:

{% gist page.gist "08c-pom.xml" %}

Sekarang coba jalankan perintah buildnya, seperti berikut:

{% highlight bash %}
mvn clean -DskipTests package dockerfile:build
{% endhighlight %}

Jika dijalankan maka outputnya seperti berikut:

```powershell
➜ docker-springboot git:(master) mvn clean -DskipTests package dockerfile:build
[WARNING]
[WARNING] Some problems were encountered while building the effective settings
[WARNING] Unrecognised tag: 'releases' (position: START_TAG seen ...</url>\n         <releases>... @9:20)  @ C:\Users\dimasm93\.m2\settings.xml, line 9, column 20
[WARNING]
[INFO] Scanning for projects...
[INFO]
[INFO] ----------< com.maryanto.dimas.udemy:udemy-springboot-docker >----------
[INFO] Building udemy-springboot-docker 0.0.1-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] --- dockerfile-maven-plugin:1.4.13:build (default-cli) @ udemy-springboot-docker ---
[INFO] dockerfile: C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot\Dockerfile
[INFO] contextDirectory: C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot
[INFO] Building Docker context C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot
[INFO] Path(dockerfile): C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot\Dockerfile
[INFO] Path(contextDirectory): C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot
[INFO]
[INFO] Image will be built as docker.io/dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
[INFO]
[INFO] Step 1/12 : ARG JDK_VERSION=11-oraclelinux8
[INFO]
[INFO] Step 2/12 : FROM openjdk:${JDK_VERSION}
[INFO]
[INFO] Pulling from library/openjdk
[INFO] Digest: sha256:11d0c95d44779dc85efd958fce96f86f7338508de347ea000e71576c3f4c7c68
[INFO] Status: Image is up to date for openjdk:11-oraclelinux8
[INFO]  ---> 80cf0467be4a
[INFO] Step 3/12 : LABEL maintainer="Dimas Maryanto <software.dimas_m@icloud.com>"
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> 8f1df0b9a7eb
[INFO] Step 4/12 : RUN groupadd www-data && adduser -r -g www-data www-data
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> 343199548c78
[INFO] Step 5/12 : WORKDIR /usr/local/share/apps
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> e7f5639afc7b
[INFO] Step 6/12 : USER www-data
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> e06a53b40957
[INFO] Step 7/12 : ARG JAR_FILE="udemy-springboot-docker-0.0.1-SNAPSHOT.jar"
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> e888ad93fe08
[INFO] Step 8/12 : ADD --chown=www-data:www-data target/$JAR_FILE application.jar
[INFO]
[INFO]  ---> 30d03329e425
[INFO] Step 9/12 : ENTRYPOINT ["java"]
[INFO]
[INFO]  ---> Running in 6a225ffacc3f
[INFO] Removing intermediate container 6a225ffacc3f
[INFO]  ---> 5cdc3d362313
[INFO] Step 10/12 : CMD ["-jar", "-Djava.security.egd=file:/dev/./urandom", "application.jar"]
[INFO]
[INFO]  ---> Running in d2b458ec83cd
[INFO] Removing intermediate container d2b458ec83cd
[INFO]  ---> 8520ab8519bf
[INFO] Step 11/12 : EXPOSE 8080
[INFO]
[INFO]  ---> Running in de769a8dfb24
[INFO] Removing intermediate container de769a8dfb24
[INFO]  ---> 705117e860de
[INFO] Step 12/12 : HEALTHCHECK --interval=5m --timeout=3s   CMD curl -f http://localhost:8080/actuator || exit 1
[INFO]
[INFO]  ---> Running in 5d7e1c5c194c
[INFO] Removing intermediate container 5d7e1c5c194c
[INFO]  ---> 95be4e9e2c39
[INFO] Successfully built 95be4e9e2c39
[INFO] Successfully tagged dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
[INFO]
[INFO] Detected build of image with id 95be4e9e2c39
[INFO] Building jar: C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot\target\udemy-springboot-docker-0.0.1-SNAPSHOT-docker-info.jar
[INFO] Successfully built docker.io/dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  46.816 s
[INFO] Finished at: 2021-06-29T09:05:15+07:00
[INFO] ------------------------------------------------------------------------

➜ docker-springboot git:(master) docker scan --file .\Dockerfile dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT

Testing dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT...
Package manager:   rpm
Target file:       .\Dockerfile
Project name:      docker-image|dimmaryanto93/udemy-springboot-docker
Docker image:      dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
Platform:          linux/amd64
Base image:        openjdk:11-oraclelinux8
✓ Tested 112 dependencies for known vulnerabilities, no vulnerable paths found.
According to our scan, you are currently using the most secure version of the selected base image

➜ docker-springboot git:(master) docker run --name springweb -p 8080:8080 -d dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
626e8559d34fa5279b263c03ad0394d3e8aa94e84fc203032de9bfcdca727735

➜ docker-springboot git:(master) docker container ls
CONTAINER ID   IMAGE                                                  COMMAND                  CREATED         STATUS                            PORTS                                       NAMES
626e8559d34f   dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT   "java -jar -Djava.se…"   5 seconds ago   Up 4 seconds (health: starting)   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   springweb

➜ docker-springboot git:(master)✗  docker stats --no-stream springweb
CONTAINER ID   NAME        CPU %     MEM USAGE / LIMIT     MEM %     NET I/O     BLOCK I/O   PIDS
626e8559d34f   springweb   0.09%     236.7MiB / 3.842GiB   6.02%     906B / 0B   0B / 0B     33

➜ docker-springboot git:(master) docker top springweb
UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
999                 1615                1595                11                  02:06               ?                   00:00:05            java -jar -Djava.security.egd=file:/dev/./urandom application.jar
```

## Cleanup

Seperti biasa, setelah kita mencoba schenario tersebut kita bersih-bersih dulu ya. Berikut scriptnya:

For Bash script:

{% gist page.gist "08c-cleanup.bash" %}

For Powershell script:

{% gist page.gist "08c-cleanup.ps1" %}