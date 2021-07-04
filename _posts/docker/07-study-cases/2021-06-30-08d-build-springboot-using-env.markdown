---
layout: post
title: "Studi Kasus: Springboot using Environtment"
date: 2021-06-30T22:42:36+07:00
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.external-config
youtube: 3huDmWMI2hs
comments: true
image_path: /resources/posts/docker/08d-springboot-env
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


Hai semuanya, di materi kali ini kita akan membahas tentang Externalized Configuration pada Springboot sebagai salah satu syarat Containerization. Diantaranya yang kita akan bahas

1. Externalized Configuration
2. Command line arguments.
3. Using Config data (such as `application.properties` files)
4. Property Placeholders

Ok langsung aja sekarang kita ke pembahasan yang pertama yaitu 

## Externalized Configuration

Spring Boot lets you externalize your configuration so that you can work with the same application code in different environments. You can use a variety of external configuration sources, include Java properties files, YAML files, environment variables, and command-line arguments.

Property values can be injected directly into your beans by using the `@Value` annotation, accessed through Spring’s Environment abstraction, or be bound to structured objects through `@ConfigurationProperties`. 

Spring Boot uses a very particular PropertySource order that is designed to allow sensible overriding of values. Properties are considered in the following order (with values from lower items overriding earlier ones):

1. Default properties (specified by setting `SpringApplication.setDefaultProperties`).
2. Config data (such as `application.properties` files)
3. OS environment variables.
4. Java System properties (`System.getProperties()`).
5. Properties from `SPRING_APPLICATION_JSON` (inline JSON embedded in an environment variable or system property).
6. Command line arguments.

## Using Command line arguments

By default, SpringApplication converts any command line option arguments (that is, arguments starting with `--`, such as `--server.port=9000`) to a property and adds them to the Spring `Environment`. As mentioned previously, command line properties always take precedence over file based property sources.

If you do not want command line properties to be added to the Environment, you can disable them by using `SpringApplication.setAddCommandLineProperties(false)`.

Contoh penggunaanya seperti berikut:

{% gist page.gist "08d-commandline-args-dockerfile" %}

Jika kita coba jalankan maka outputnya seperti berikut:

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
[INFO] Step 1/13 : ARG JDK_VERSION=11-oraclelinux8
[INFO]
[INFO] Step 2/13 : FROM openjdk:${JDK_VERSION}
[INFO]
[INFO] Pulling from library/openjdk
[INFO] Digest: sha256:11d0c95d44779dc85efd958fce96f86f7338508de347ea000e71576c3f4c7c68
[INFO] Status: Image is up to date for openjdk:11-oraclelinux8
[INFO]  ---> 80cf0467be4a
[INFO] Step 3/13 : LABEL maintainer="Dimas Maryanto <software.dimas_m@icloud.com>"
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> 096f925b7243
[INFO] Step 4/13 : RUN groupadd www-data && adduser -r -g www-data www-data
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> 86e96bfd959a
[INFO] Step 5/13 : WORKDIR /usr/local/share/apps
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> d960d8ad8f41
[INFO] Step 6/13 : USER www-data
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> c7ac24b6f2d7
[INFO] Step 7/13 : ARG JAR_FILE="udemy-springboot-docker-0.0.1-SNAPSHOT.jar"
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> 20745232a2db
[INFO] Step 8/13 : ADD --chown=www-data:www-data target/$JAR_FILE application.jar
[INFO]
[INFO]  ---> c24aaeabef04
[INFO] Step 9/13 : ENV APPLICATION_PORT=80
[INFO]
[INFO]  ---> Running in 9ba6f6d602e5
[INFO] Removing intermediate container 9ba6f6d602e5
[INFO]  ---> ed6fcf243a5e
[INFO] Step 10/13 : ENTRYPOINT ["java"]
[INFO]
[INFO]  ---> Running in e15bd1259922
[INFO] Removing intermediate container e15bd1259922
[INFO]  ---> 142444633dea
[INFO] Step 11/13 : CMD ["-jar", "-Djava.security.egd=file:/dev/./urandom", "application.jar", "--server.port=${APPLICATION_PORT}"]
[INFO]
[INFO]  ---> Running in b043a8da6957
[INFO] Removing intermediate container b043a8da6957
[INFO]  ---> 56261655519b
[INFO] Step 12/13 : EXPOSE ${APPLICATION_PORT}
[INFO]
[INFO]  ---> Running in 82b5822bad08
[INFO] Removing intermediate container 82b5822bad08
[INFO]  ---> e28396f11fd6
[INFO] Step 13/13 : HEALTHCHECK --interval=5m --timeout=3s   CMD curl -f http://localhost:8080/actuator || exit 1
[INFO]
[INFO]  ---> Running in b0b9ce0a578f
[INFO] Removing intermediate container b0b9ce0a578f
[INFO]  ---> 63f88e60bc42
[INFO] Successfully built 63f88e60bc42
[INFO] Successfully tagged dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
[INFO]
[INFO] Detected build of image with id 63f88e60bc42
[INFO] Building jar: C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot\target\udemy-springboot-docker-0.0.1-SNAPSHOT-docker-info.jar
[INFO] Successfully built docker.io/dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  31.222 s
[INFO] Finished at: 2021-06-30T21:15:20+07:00
[INFO] ------------------------------------------------------------------------

➜ docker-springboot git:(master) docker image inspect `
dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT `
-f '{% raw %}{{json .Config.Env }}{% endraw %}'

["PATH=/usr/java/openjdk-11/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
"JAVA_HOME=/usr/java/openjdk-11",
"LANG=C.UTF-8",
"JAVA_VERSION=11.0.11+9",
"APPLICATION_PORT=80"
]

➜ docker-springboot git:(master)  docker image inspect `
dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT `
-f '{% raw %}{{json .Config.ExposedPorts }}{% endraw %}'

{"80/tcp":{}}

➜ docker-springboot git:(master) docker run --name springboot-cli-args -p 80:80 -d dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
58b115dad9e9b63da532638cafc3529271030786900bf7651c8afc192713596f

➜ docker-springboot git:(master)  curl localhost/actuator
StatusCode        : 200
StatusDescription :
Content           : {123, 34, 95, 108...}
RawContent        : HTTP/1.1 200
                    Transfer-Encoding: chunked
                    Content-Type: application/vnd.spring-boot.actuator.v3+json
                    Date: Wed, 30 Jun 2021 14:20:22 GMT

                    {"_links":{"self":{"href":"http://localhost/actuator","tem..."
Headers           : {[Transfer-Encoding, chunked], [Content-Type, application/vnd.spring-boot.actuator.v3+json],
                    [Date, Wed, 30 Jun 2021 14:20:22 GMT]}
RawContentLength  : 228

➜ docker-springboot git:(master) docker container stop springboot-cli-args
springboot-cli-args
```

## Using Config data

Spring Boot will automatically find and load `application.properties` and `application.yaml` files from the following locations when your application starts:

1. From the classpath
2. From the current directory

Dalam suatu development spring-boot biasanya memiliki banyak profile sebagai contoh `dev`, `test`, `staging`, `prod` dan lain-lain. Jadi misalnya kita buat profile seperti berikut

1. `src/main/resources/application.properties`, digunakan untuk env development
    {% gist page.gist "08d-application.properties" %}

2. `src/main/resources/application-test.properties`, digunakan untuk env testing
    {% gist page.gist "08d-application-test.properties" %}

3. `src/main/resources/application-prod.properties`, digunakan untuk env production
    {% gist page.gist "08d-application-prod.properties" %}

Kemudian kita load environment variable tersebut kemudian kita tampilkan ke Rest API, dengan membuat controller seperti berikut:

{% gist page.gist "08d-EnvironmentController.java" %}

Dan berikut adalah file Dockerfile:

{% gist page.gist "08d-config-data-dockerfile" %}

Jika kita coba jalankan, berikut hasilnya:

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
[INFO] Step 1/13 : ARG JDK_VERSION=11-oraclelinux8
[INFO]
[INFO] Step 2/13 : FROM openjdk:${JDK_VERSION}
[INFO]
[INFO] Pulling from library/openjdk
[INFO] Digest: sha256:11d0c95d44779dc85efd958fce96f86f7338508de347ea000e71576c3f4c7c68
[INFO] Status: Image is up to date for openjdk:11-oraclelinux8
[INFO]  ---> 80cf0467be4a
[INFO] Step 3/13 : LABEL maintainer="Dimas Maryanto <software.dimas_m@icloud.com>"
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> 096f925b7243
[INFO] Step 4/13 : RUN groupadd www-data && adduser -r -g www-data www-data
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> 86e96bfd959a
[INFO] Step 5/13 : WORKDIR /usr/local/share/apps
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> d960d8ad8f41
[INFO] Step 6/13 : USER www-data
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> c7ac24b6f2d7
[INFO] Step 7/13 : ARG JAR_FILE="udemy-springboot-docker-0.0.1-SNAPSHOT.jar"
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> 20745232a2db
[INFO] Step 8/13 : ADD --chown=www-data:www-data target/$JAR_FILE application.jar
[INFO]
[INFO]  ---> 709e97db4c46
[INFO] Step 9/13 : ENV APPLICATION_PORT=80
[INFO]
[INFO]  ---> Running in 703a4c112e1c
[INFO] Removing intermediate container 703a4c112e1c
[INFO]  ---> 9aa701ae894b
[INFO] Step 10/13 : ENTRYPOINT ["java"]
[INFO]
[INFO]  ---> Running in 99a159da8206
[INFO] Removing intermediate container 99a159da8206
[INFO]  ---> 86a4b191a7a3
[INFO] Step 12/14 : CMD ["-jar", "-Djava.security.egd=file:/dev/./urandom", "application.jar", "--server.port=${APPLICATION_PORT}", "--spring.profiles.active=${PROFILE}"]
[INFO]
[INFO]  ---> Running in 312d0e9702b2
[INFO] Removing intermediate container 312d0e9702b2
[INFO]  ---> 75b873b85e7c
[INFO] Step 12/13 : EXPOSE ${APPLICATION_PORT}
[INFO]
[INFO]  ---> Running in 048abb7c1391
[INFO] Removing intermediate container 048abb7c1391
[INFO]  ---> a1bc22a06ae5
[INFO] Step 13/13 : HEALTHCHECK --interval=5m --timeout=3s   CMD curl -f http://localhost:8080/actuator || exit 1
[INFO]
[INFO]  ---> Running in 83dd1ee7f64e
[INFO] Removing intermediate container 83dd1ee7f64e
[INFO]  ---> 0d206cabe3a1
[INFO] Successfully built 0d206cabe3a1
[INFO] Successfully tagged dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
[INFO]
[INFO] Detected build of image with id 0d206cabe3a1
[INFO] Building jar: C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot\target\udemy-springboot-docker-0.0.1-SNAPSHOT-docker-info.jar
[INFO] Successfully built docker.io/dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  48.276 s
[INFO] Finished at: 2021-06-30T21:47:28+07:00
[INFO] ------------------------------------------------------------------------

➜ docker-springboot git:(master) docker run --name springboot-env-default -p 80:80 -d dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
855c027fef60272bf879804daf3a0453ed1e1d725e3e6b86e6462f6192868b67

➜ docker-springboot git:(master)  curl localhost/api/environment/message
StatusCode        : 200
StatusDescription :
Content           : "From Development Environment"
RawContent        : HTTP/1.1 200
                    Content-Length: 30
                    Content-Type: text/plain;charset=UTF-8
                    Date: Wed, 30 Jun 2021 14:48:28 GMT
Headers           : {[Content-Length, 30], [Content-Type, text/plain;charset=UTF-8], [Date, Wed, 30 Jun 2021 14:48:28 GMT]}
RawContentLength  : 30

➜ docker run --name springboot-env-test -e PROFILE=test -p 8080:80 -d dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
5c0ed897240c572f8051eae7cc45ce7fe3cd5182ab930a0ec7b531a453f5355e

➜ docker-springboot git:(master) curl localhost:8080/api/environment/message
StatusCode        : 200
StatusDescription :
Content           : "From Test Environment"
RawContent        : HTTP/1.1 200
                    Content-Length: 23
                    Content-Type: text/plain;charset=UTF-8
                    Date: Wed, 30 Jun 2021 15:03:53 GMT
Headers           : {[Content-Length, 23], [Content-Type, text/plain;charset=UTF-8], [Date, Wed, 30 Jun 2021 15:03:53 GMT]}
ParsedHtml        : System.__ComObject
RawContentLength  : 23

➜ docker-springboot git:(master) docker container stop springboot-env-test springboot-env-default
springboot-env-test
springboot-env-default
```

## Property Placeholders

The values in `application.properties` and `application.yml` are filtered through the existing Environment when they are used, so you can refer back to previously defined values (for example, from System properties). The standard `${name}` property-placeholder syntax can be used anywhere within a value.

{% highlight properties %}
app.name=MyApp
app.description=${app.name} is a Spring Boot application
{% endhighlight %}

Use ‘Short’ Command Line Arguments, Some people like to use (for example) `--PORT=9000` instead of `--server.port=9000` to set configuration properties on the command line. You can enable this behavior by using placeholders in `application.properties`, as shown in the following example:

{% highlight properties %}
server.port=${PORT:8080}
{% endhighlight %}

Variable `PORT` also you can used directly calling env without specified command `--PORT={value}`, for example here is `application.properties`

{% gist page.gist "08d-placeholder-application.properties" %}

Kemudian buat file `EnvPlaceholderController.java` dengan menambahkan api seperti berikut:

{% gist page.gist "08d-EnvPlaceholderController.java" %}

Dan berikut adalah dockerfilenya:

{% gist page.gist "08d-env-placeholder-dockerfile" %}

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
[INFO] Digest: sha256:11d0c95d44779dc85efd958fce96f86f7338508de347ea000e71576c3f4c7c68
[INFO] Status: Image is up to date for openjdk:11-oraclelinux8
[INFO]  ---> 80cf0467be4a
[INFO] Step 3/16 : LABEL maintainer="Dimas Maryanto <software.dimas_m@icloud.com>"
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> 096f925b7243
[INFO] Step 4/16 : RUN groupadd www-data && adduser -r -g www-data www-data
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> 86e96bfd959a
[INFO] Step 5/16 : WORKDIR /usr/local/share/apps
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> d960d8ad8f41
[INFO] Step 6/16 : USER www-data
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> c7ac24b6f2d7
[INFO] Step 7/16 : ARG JAR_FILE="udemy-springboot-docker-0.0.1-SNAPSHOT.jar"
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> 20745232a2db
[INFO] Step 8/16 : ADD --chown=www-data:www-data target/$JAR_FILE application.jar
[INFO]
[INFO]  ---> 8f807935336d
[INFO] Step 9/16 : ENV APPLICATION_PORT=80
[INFO]
[INFO]  ---> Running in 071b138f862b
[INFO] Removing intermediate container 071b138f862b
[INFO]  ---> 0d3a285bb4b4
[INFO] Step 10/16 : ENV PROFILE=default
[INFO]
[INFO]  ---> Running in 8125901078b6
[INFO] Removing intermediate container 8125901078b6
[INFO]  ---> d8792a263bc4
[INFO] Step 11/16 : ENV DATABASE_USER=mysql
[INFO]
[INFO]  ---> Running in c5325a62885f
[INFO] Removing intermediate container c5325a62885f
[INFO]  ---> 3b91b8f73b5d
[INFO] Step 12/16 : ENV DATABASE_PASSWORD=testing
[INFO]
[INFO]  ---> Running in 98720dda80e5
[INFO] Removing intermediate container 98720dda80e5
[INFO]  ---> cb73f56ba21d
[INFO] Step 13/16 : ENTRYPOINT ["java"]
[INFO]
[INFO]  ---> Running in 2d53f4ef1123
[INFO] Removing intermediate container 2d53f4ef1123
[INFO]  ---> 63de3550a107
[INFO] Step 14/16 : CMD ["-jar", "-Djava.security.egd=file:/dev/./urandom", "application.jar", "--server.port=${APPLICATION_PORT}", "--spring.profiles.active=${PROFILE}"]
[INFO]
[INFO]  ---> Running in 81e1506ebfea
[INFO] Removing intermediate container 81e1506ebfea
[INFO]  ---> 0d4f08ee3aa8
[INFO] Step 15/16 : EXPOSE ${APPLICATION_PORT}
[INFO]
[INFO]  ---> Running in 304117b5a7b5
[INFO] Removing intermediate container 304117b5a7b5
[INFO]  ---> e662b079f9df
[INFO] Step 16/16 : HEALTHCHECK --interval=5m --timeout=3s   CMD curl -f http://localhost:8080/actuator || exit 1
[INFO]
[INFO]  ---> Running in 4f7ded4165c2
[INFO] Removing intermediate container 4f7ded4165c2
[INFO]  ---> 7e7dd9d55a61
[INFO] Successfully built 7e7dd9d55a61
[INFO] Successfully tagged dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
[INFO]
[INFO] Detected build of image with id 7e7dd9d55a61
[INFO] Building jar: C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot\target\udemy-springboot-docker-0.0.1-SNAPSHOT-docker-info.jar
[INFO] Successfully built docker.io/dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  37.411 s
[INFO] Finished at: 2021-06-30T22:28:53+07:00
[INFO] ------------------------------------------------------------------------

➜ docker run --name springboot-env-placeholder-default -p 9090:80 -d dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
80e9c8a71948ba1bf385f26327cd13a8c8f3a85f261cc8890d42bbe7001acac1

➜ docker-springboot git:(master) curl http://localhost:9090/api/environment/placeholder
StatusCode        : 200
StatusDescription :
Content           : {"password":"testing","username":"mysql"}
RawContent        : HTTP/1.1 200
                    Transfer-Encoding: chunked
                    Keep-Alive: timeout=60
                    Connection: keep-alive
                    Content-Type: application/json
                    Date: Wed, 30 Jun 2021 15:30:02 GMT
Headers           : {[Transfer-Encoding, chunked], [Keep-Alive, timeout=60], [Connection, keep-alive], [Content-Type,
                    application/json]...}
ParsedHtml        : System.__ComObject
RawContentLength  : 41

➜ docker-springboot git:(master)✗  docker run --name springboot-env-placeholder-changed -e DATABASE_USER=postgres -p 9091:80 -d dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
778d5fc8b2df16e879cb62ef80e345380898a08be93a199027068c3ab45a8e20

➜ docker-springboot git:(master) curl http://localhost:9091/api/environment/placeholder
StatusCode        : 200
StatusDescription :
Content           : {"password":"testing","username":"postgres"}
RawContent        : HTTP/1.1 200
                    Transfer-Encoding: chunked
                    Keep-Alive: timeout=60
                    Connection: keep-alive
                    Content-Type: application/json
                    Date: Wed, 30 Jun 2021 15:32:20 GMT
Headers           : {[Transfer-Encoding, chunked], [Keep-Alive, timeout=60], [Connection, keep-alive], [Content-Type,
                    application/json]...}
ParsedHtml        : System.__ComObject
RawContentLength  : 44

➜ docker-springboot git:(master) docker container stop springboot-env-placeholder-changed springboot-env-placeholder-default
springboot-env-placeholder-changed
springboot-env-placeholder-default
```

Jadi kesimpulanya, dengan menggunakan external configuration ini kita gak perlu rubah-rubah koding lagi jika ganti environtment.

## Cleanup

Seperti biasa, setelah kita mencoba kita saatnya bersih-bersih dulu ya, berikut scriptnya:

For Bash script:

{% gist page.gist "08d-cleanup.bash" %}

For Powershell script:

{% gist page.gist "08d-cleanup.ps1" %}