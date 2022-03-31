---
layout: post
title: "Springboot - Using Database"
date: 2021-07-02T21:22:13+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Dockerfile
- Study-Cases
refs: 
- https://docs.spring.io/spring-boot/docs/current/reference/html/howto.html#howto.data-access
- https://docs.spring.io/spring-boot/docs/current/reference/html/howto.html#howto.data-initialization
youtube: HO_gGVu7V7I
comments: true
catalog_key: study-cases-dockerfile
image_path: /resources/posts/docker/08f-spring-boot-db
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas studi kasus menggunakan Database pada framework spring-boot, serta best practice dalam membuat aplikasi berbasis Containers. Diantaranya yang akan kita bahas yaitu

1. Setup Database & JDBC using spring-boot
2. Using Database migration for automation & versioning
3. Don't Store Database Credential in your source-code
4. Best practice for local development and containerization
5. Cleanup

<!--more-->

## Setup Database & JDBC using spring-boot

Suatu aplikasi bisnis, gak akan jauh-jauh dengan namanya database management system khsususnya Relation Database Management System (RDBMS). sekarang kita akan menggunakan Database PostgreSQL yang di koneksikan ke project `spring-boot` sebelumnya dengan 

1. Tambahkan dependency pada `pom.xml`, seperti `org.springframework.boot:spring-boot-starter-data-jpa` dan `org.postgresql:postgresql` seperti berikut:

    {% gist page.gist "08f-setup-jdbc-pom.xml" %}

2. Tambahkan property untuk connect ke database pada `application.properties` seperti berikut:

    {% gist page.gist "08f-setup-jdbc-application.properties" %}

3. Buat entity class baru pada package `com.maryanto.dimas.udemy.entity` dengan nama `Mahasiswa.java` seperti berikut:

    {% gist page.gist "08f-Mahasiswa.java" %}

4. Kemudian buat repository class baru pada package `com.maryanto.dimas.udemy.repository` dengan nama `MahasiswaRepository.java` seperti berikut:

    {% gist page.gist "08f-MahasiswaRepository.java" %}

5. Kemudian buat controller class baru pada package `com.maryanto.dimas.udemy.controller` dengan nama `MahasiswaController` seperti berikut:

    {% gist page.gist "08f-MahasiswaController.java" %}

6. Dan yang terakhir kita tambahkan http request file nya dengan nama `MahasiswaController.http` seperti berikut:

    {% gist page.gist "08f-MahasiswaController.http" %}

Kemudian kita coba jalankan imagenya postgres seperti berikut:

```powershell
➜ docker-springboot git:(master) docker run -p 5432:5432 -e POSTGRES_PASSWORD=password -e POSTGRES_DB=udemy_docker -d postgres:12.6
57f16d8aff1cb505e00942151d35cf55a6df260f8426f287a9c51b33c9de4582

➜ docker-springboot git:(master) mvn clean spring-boot:run
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v2.5.2)

2021-07-02 19:27:58.461  INFO 3196 --- [  restartedMain] c.m.d.u.UdemySpringbootDockerApplication : Starting UdemySpringbootDockerApplication using Java 11.0.9 on MSI-z390-pro with PID 3196 (C:\Users\dimasm93\Workspaces\youtube\dock
er\08-studi-kasus\docker-springboot\target\classes started by dimasm93 in C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot)
2021-07-02 19:27:58.463  INFO 3196 --- [  restartedMain] c.m.d.u.UdemySpringbootDockerApplication : No active profile set, falling back to default profiles: default
2021-07-02 19:27:58.496  INFO 3196 --- [  restartedMain] .e.DevToolsPropertyDefaultsPostProcessor : Devtools property defaults active! Set 'spring.devtools.add-properties' to 'false' to disable
2021-07-02 19:27:58.496  INFO 3196 --- [  restartedMain] .e.DevToolsPropertyDefaultsPostProcessor : For additional web related logging consider setting the 'logging.level.web' property to 'DEBUG'
2021-07-02 19:27:58.997  INFO 3196 --- [  restartedMain] .s.d.r.c.RepositoryConfigurationDelegate : Bootstrapping Spring Data JPA repositories in DEFAULT mode.
2021-07-02 19:27:59.025  INFO 3196 --- [  restartedMain] .s.d.r.c.RepositoryConfigurationDelegate : Finished Spring Data repository scanning in 23 ms. Found 1 JPA repository interfaces.
2021-07-02 19:27:59.540  INFO 3196 --- [  restartedMain] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8080 (http)
2021-07-02 19:27:59.547  INFO 3196 --- [  restartedMain] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2021-07-02 19:27:59.548  INFO 3196 --- [  restartedMain] org.apache.catalina.core.StandardEngine  : Starting Servlet engine: [Apache Tomcat/9.0.48]
2021-07-02 19:27:59.612  INFO 3196 --- [  restartedMain] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
2021-07-02 19:27:59.612  INFO 3196 --- [  restartedMain] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 1115 ms
2021-07-02 19:27:59.756  INFO 3196 --- [  restartedMain] o.hibernate.jpa.internal.util.LogHelper  : HHH000204: Processing PersistenceUnitInfo [name: default]
2021-07-02 19:27:59.781  INFO 3196 --- [  restartedMain] org.hibernate.Version                    : HHH000412: Hibernate ORM core version 5.4.32.Final
2021-07-02 19:27:59.846  INFO 3196 --- [  restartedMain] o.hibernate.annotations.common.Version   : HCANN000001: Hibernate Commons Annotations {5.1.2.Final}
2021-07-02 19:27:59.905  INFO 3196 --- [  restartedMain] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Starting...
2021-07-02 19:27:59.959  INFO 3196 --- [  restartedMain] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Start completed.
2021-07-02 19:27:59.968  INFO 3196 --- [  restartedMain] org.hibernate.dialect.Dialect            : HHH000400: Using dialect: org.hibernate.dialect.PostgreSQL95Dialect
Hibernate:

    create table mahasiswa (
       id varchar(64) not null,
        nama varchar(50),
        nim varchar(10) not null,
        smt int4 not null,
        primary key (id)
    )
Hibernate:

    alter table if exists mahasiswa
       drop constraint if exists UK_kvm6yjgxjs9vo3qhqsjog1a1p
2021-07-02 19:28:00.320  WARN 3196 --- [  restartedMain] o.h.engine.jdbc.spi.SqlExceptionHelper   : SQL Warning Code: 0, SQLState: 00000
2021-07-02 19:28:00.320  WARN 3196 --- [  restartedMain] o.h.engine.jdbc.spi.SqlExceptionHelper   : constraint "uk_kvm6yjgxjs9vo3qhqsjog1a1p" of relation "mahasiswa" does not exist, skipping
Hibernate:

    alter table if exists mahasiswa
       add constraint UK_kvm6yjgxjs9vo3qhqsjog1a1p unique (nim)
2021-07-02 19:28:00.326  INFO 3196 --- [  restartedMain] o.h.e.t.j.p.i.JtaPlatformInitiator       : HHH000490: Using JtaPlatform implementation: [org.hibernate.engine.transaction.jta.platform.internal.NoJtaPlatform]
2021-07-02 19:28:00.332  INFO 3196 --- [  restartedMain] j.LocalContainerEntityManagerFactoryBean : Initialized JPA EntityManagerFactory for persistence unit 'default'
2021-07-02 19:28:00.485  WARN 3196 --- [  restartedMain] JpaBaseConfiguration$JpaWebConfiguration : spring.jpa.open-in-view is enabled by default. Therefore, database queries may be performed during view rendering. Explicitly config
ure spring.jpa.open-in-view to disable this warning
2021-07-02 19:28:00.624  WARN 3196 --- [  restartedMain] ion$DefaultTemplateResolverConfiguration : Cannot find template location: classpath:/templates/ (please add some templates or check your Thymeleaf configuration)
2021-07-02 19:28:00.704  INFO 3196 --- [  restartedMain] o.s.b.d.a.OptionalLiveReloadServer       : LiveReload server is running on port 35729
2021-07-02 19:28:00.707  INFO 3196 --- [  restartedMain] o.s.b.a.e.web.EndpointLinksResolver      : Exposing 1 endpoint(s) beneath base path '/actuator'
2021-07-02 19:28:00.736  INFO 3196 --- [  restartedMain] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
2021-07-02 19:28:00.746  INFO 3196 --- [  restartedMain] c.m.d.u.UdemySpringbootDockerApplication : Started UdemySpringbootDockerApplication in 2.549 seconds (JVM running for 2.881)
```

## Using Database migration for automation & versioning

Salah satu syarat dari aplikasi yang dikatakan siap container haruslah mudah di drop, satulagi yang harus di perhatikan adalah harus mudah di start juga. Contohnya klo ada dependency seperti database yang membutuhkan schema tabel, view, sequences dan lain-lain harus bisa di otomatisasi. 

Untuk aplikasi yang disiapkan untuk production kita membutuhkan tools seperti database track, version and control seperti klo di Java ada namanya [flyway](https://flywaydb.org/), [Liquibase](https://www.liquibase.org/) dan masih banyak lagi yang lainnya. Misalnya kta akan menggunakan flyway pada project `spring-boot` sebelumnya dengan menambahkan config seperti berikut:

1. Tambah dependency `org.flywaydb:flyway-core` pada `pom.xml` seperti berikut:

    {% gist page.gist "08f-flyway-pom.xml" %}

2. Tambah/Edit config pada `application.properties` seperti berikut:

    {% gist page.gist "08f-flyway-application.properties" %}

3. Kemudian buat file sql untuk table yang kita butuhkan pada folder `src/resources/db/migration` dengan nama `V1__schema-awal.sql` seperti berikut:

    {% gist page.gist "08f-v1__schema-awal.sql" %}

Sekarang coba jalankan project `spring-boot` dengan perintah berikut:

```powershell
➜ docker-springboot git:(master) mvn clean spring-boot:run
[INFO] Attaching agents: []

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v2.5.2)

2021-07-02 20:07:52.434  INFO 27828 --- [  restartedMain] c.m.d.u.UdemySpringbootDockerApplication : Starting UdemySpringbootDockerApplication using Java 11.0.9 on MSI-z390-pro with PID 27828 (C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot\target\classes started by dimasm93 in C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot)
2021-07-02 20:07:52.436  INFO 27828 --- [  restartedMain] c.m.d.u.UdemySpringbootDockerApplication : No active profile set, falling back to default profiles: default
2021-07-02 20:07:52.472  INFO 27828 --- [  restartedMain] .e.DevToolsPropertyDefaultsPostProcessor : Devtools property defaults active! Set 'spring.devtools.add-properties' to 'false' to disable
2021-07-02 20:07:52.472  INFO 27828 --- [  restartedMain] .e.DevToolsPropertyDefaultsPostProcessor : For additional web related logging consider setting the 'logging.level.web' property to 'DEBUG'
2021-07-02 20:07:53.005  INFO 27828 --- [  restartedMain] .s.d.r.c.RepositoryConfigurationDelegate : Bootstrapping Spring Data JPA repositories in DEFAULT mode.
2021-07-02 20:07:53.033  INFO 27828 --- [  restartedMain] .s.d.r.c.RepositoryConfigurationDelegate : Finished Spring Data repository scanning in 23 ms. Found 1 JPA repository interfaces.
2021-07-02 20:07:53.564  INFO 27828 --- [  restartedMain] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8080 (http)
2021-07-02 20:07:53.570  INFO 27828 --- [  restartedMain] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2021-07-02 20:07:53.571  INFO 27828 --- [  restartedMain] org.apache.catalina.core.StandardEngine  : Starting Servlet engine: [Apache Tomcat/9.0.48]
2021-07-02 20:07:53.648  INFO 27828 --- [  restartedMain] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
2021-07-02 20:07:53.649  INFO 27828 --- [  restartedMain] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 1175 ms
2021-07-02 20:07:53.778  INFO 27828 --- [  restartedMain] o.f.c.internal.license.VersionPrinter    : Flyway Community Edition 7.7.3 by Redgate
2021-07-02 20:07:53.782  INFO 27828 --- [  restartedMain] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Starting...
2021-07-02 20:07:53.835  INFO 27828 --- [  restartedMain] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Start completed.
2021-07-02 20:07:53.854  INFO 27828 --- [  restartedMain] o.f.c.i.database.base.DatabaseType       : Database: jdbc:postgresql://localhost:5432/udemy_docker (PostgreSQL 12.6)
2021-07-02 20:07:53.885  INFO 27828 --- [  restartedMain] o.f.core.internal.command.DbValidate     : Successfully validated 1 migration (execution time 00:00.012s)
2021-07-02 20:07:53.895  INFO 27828 --- [  restartedMain] o.f.c.i.s.JdbcTableSchemaHistory         : Creating Schema History table "public"."flyway_schema_history" with baseline ...
2021-07-02 20:07:53.912  INFO 27828 --- [  restartedMain] o.f.c.i.s.DefaultSqlScriptExecutor       : 0 rows affected
2021-07-02 20:07:53.914  INFO 27828 --- [  restartedMain] o.f.c.i.s.DefaultSqlScriptExecutor       : 1 rows affected
2021-07-02 20:07:53.918  INFO 27828 --- [  restartedMain] o.f.c.i.s.DefaultSqlScriptExecutor       : 0 rows affected
2021-07-02 20:07:53.921  INFO 27828 --- [  restartedMain] o.f.c.i.s.DefaultSqlScriptExecutor       : 0 rows affected
2021-07-02 20:07:53.926  INFO 27828 --- [  restartedMain] o.f.core.internal.command.DbBaseline     : Successfully baselined schema with version: 1
2021-07-02 20:07:53.934  INFO 27828 --- [  restartedMain] o.f.core.internal.command.DbMigrate      : Current version of schema "public": 1
2021-07-02 20:07:53.935  INFO 27828 --- [  restartedMain] o.f.core.internal.command.DbMigrate      : Schema "public" is up to date. No migration necessary.
2021-07-02 20:07:53.984  INFO 27828 --- [  restartedMain] o.hibernate.jpa.internal.util.LogHelper  : HHH000204: Processing PersistenceUnitInfo [name: default]
2021-07-02 20:07:54.012  INFO 27828 --- [  restartedMain] org.hibernate.Version                    : HHH000412: Hibernate ORM core version 5.4.32.Final
2021-07-02 20:07:54.082  INFO 27828 --- [  restartedMain] o.hibernate.annotations.common.Version   : HCANN000001: Hibernate Commons Annotations {5.1.2.Final}
2021-07-02 20:07:54.150  INFO 27828 --- [  restartedMain] org.hibernate.dialect.Dialect            : HHH000400: Using dialect: org.hibernate.dialect.PostgreSQL95Dialect
2021-07-02 20:07:54.480  INFO 27828 --- [  restartedMain] o.h.e.t.j.p.i.JtaPlatformInitiator       : HHH000490: Using JtaPlatform implementation: [org.hibernate.engine.transaction.jta.platform.internal.NoJtaPlatform]
2021-07-02 20:07:54.485  INFO 27828 --- [  restartedMain] j.LocalContainerEntityManagerFactoryBean : Initialized JPA EntityManagerFactory for persistence unit 'default'
2021-07-02 20:07:54.644  WARN 27828 --- [  restartedMain] JpaBaseConfiguration$JpaWebConfiguration : spring.jpa.open-in-view is enabled by default. Therefore, database queries may be performed during view rendering. Explicitly configure spring.jpa.open-in-view to disable this warning
2021-07-02 20:07:54.776  WARN 27828 --- [  restartedMain] ion$DefaultTemplateResolverConfiguration : Cannot find template location: classpath:/templates/ (please add some templates or check your Thymeleaf configuration)
2021-07-02 20:07:54.863  INFO 27828 --- [  restartedMain] o.s.b.d.a.OptionalLiveReloadServer       : LiveReload server is running on port 35729
2021-07-02 20:07:54.867  INFO 27828 --- [  restartedMain] o.s.b.a.e.web.EndpointLinksResolver      : Exposing 1 endpoint(s) beneath base path '/actuator'
2021-07-02 20:07:54.892  INFO 27828 --- [  restartedMain] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
2021-07-02 20:07:54.904  INFO 27828 --- [  restartedMain] c.m.d.u.UdemySpringbootDockerApplication : Started UdemySpringbootDockerApplication in 2.791 seconds (JVM running for 3.204)
```

Jadi dengan configurasi project `spring-boot` seperti berikut, kita sudah bisa automation database schema serta mengontrol table yang akan dibuat.

## Don't Store Database Credential in your source-code

Selain itu, salah satu kunci sukses membuat aplikasi dikatakan ready containerization adalah jangan simpan informasi credential di sources tapi bisa di override. kenapa?

1. Yang jelas, klo kita publish source-code kita ke repository. yang review akan melihat informasi credential dan itu akan rentan di hack
2. Setiap kita ganti-ganti deployment (server), kita harus rubah source-code. Sebaiknya gunakan Environtment Variable / `.env` (dotenv) files
3. Gunakan encription pada `application.properties` jika aplikasinya sudah/akan naik production, contohnya seperti [jasypt.org](http://www.jasypt.org/)

## Build docker image

Sekarang kita akan buat docker imagenya, seperti biasa kita modif file `Dockerfile` untuk menambahkan beberapa env seperti berikut:

{% gist page.gist "08f-Dockerfile" %}

Sekarang kita build imagenya dengan menggunakan perintah:

{% highlight bash %}
mvn clean -DskipTests package dockerfile:build
{% endhighlight %}

Jika dijalankan hasilnya seperti berikut:

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
[INFO] Step 1/23 : ARG JDK_VERSION=11-oraclelinux8
[INFO]
[INFO] Step 2/23 : FROM openjdk:${JDK_VERSION}
[INFO]
[INFO] Pulling from library/openjdk
[INFO] Digest: sha256:ddb1de39c73130e1df9da5877abbe23aff0564e7383ce02700196dcbe1d6dc8c
[INFO] Status: Image is up to date for openjdk:11-oraclelinux8
[INFO]  ---> 95cfb60ac29c
[INFO] Step 3/23 : LABEL maintainer="Dimas Maryanto <software.dimas_m@icloud.com>"
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> a4f895b3bf2f
[INFO] Step 4/23 : RUN groupadd www-data && adduser -r -g www-data www-data
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> 1d880f93b0ef
[INFO] Step 5/23 : ENV FILE_UPLOAD_STORED=/var/lib/spring-boot/data
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> d5352e3149b1
[INFO] Step 6/23 : RUN mkdir -p ${FILE_UPLOAD_STORED} && chmod -R 777 ${FILE_UPLOAD_STORED}/
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> fd407a853df4
[INFO] Step 7/23 : WORKDIR /usr/local/share/applications
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> 8d3930cf7cfe
[INFO] Step 8/23 : USER www-data
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> 1138fe60ab72
[INFO] Step 9/23 : ARG JAR_FILE="udemy-springboot-docker-0.0.1-SNAPSHOT.jar"
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> 6c92058c3bc9
[INFO] Step 10/23 : ADD --chown=www-data:www-data target/$JAR_FILE spring-boot.jar
[INFO]
[INFO]  ---> 83a4aa6449fc
[INFO] Step 11/23 : ENV APPLICATION_PORT=80
[INFO]
[INFO]  ---> Running in 6ff7030edf59
[INFO] Removing intermediate container 6ff7030edf59
[INFO]  ---> f075880230ee
[INFO] Step 12/23 : ENV PROFILE=default
[INFO]
[INFO]  ---> Running in ce8bd7b677e0
[INFO] Removing intermediate container ce8bd7b677e0
[INFO]  ---> c70045d4ea21
[INFO] Step 13/23 : ENV DATABASE_USER=postgres
[INFO]
[INFO]  ---> Running in 4e4cc0383649
[INFO] Removing intermediate container 4e4cc0383649
[INFO]  ---> 46b44578957e
[INFO] Step 14/23 : ENV DATABASE_PASSWORD=postgres
[INFO]
[INFO]  ---> Running in 37408dd9960a
[INFO] Removing intermediate container 37408dd9960a
[INFO]  ---> 9ee3f6d62000
[INFO] Step 15/23 : ENV DATABASE_HOST=localhost
[INFO]
[INFO]  ---> Running in 192ef08ebf7b
[INFO] Removing intermediate container 192ef08ebf7b
[INFO]  ---> 22d97dcbb6b9
[INFO] Step 16/23 : ENV DATABASE_NAME=postgres
[INFO]
[INFO]  ---> Running in b8ca773c8bb5
[INFO] Removing intermediate container b8ca773c8bb5
[INFO]  ---> e005032e19f8
[INFO] Step 17/23 : ENV DATABASE_PORT=5432
[INFO]
[INFO]  ---> Running in cec64d672df8
[INFO] Removing intermediate container cec64d672df8
[INFO]  ---> adee6c579e78
[INFO] Step 18/23 : ENV FLYWAY_ENABLED=true
[INFO]
[INFO]  ---> Running in c2aab4d07344
[INFO] Removing intermediate container c2aab4d07344
[INFO]  ---> c4211b69e582
[INFO] Step 19/23 : VOLUME ${FILE_UPLOAD_STORED}/
[INFO]
[INFO]  ---> Running in 7065069f5bab
[INFO] Removing intermediate container 7065069f5bab
[INFO]  ---> 1eef21a784e4
[INFO] Step 20/23 : ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "spring-boot.jar"]
[INFO]
[INFO]  ---> Running in a3be34ce17a8
[INFO] Removing intermediate container a3be34ce17a8
[INFO]  ---> c36d527b3ceb
[INFO] Step 21/23 : CMD ["--server.port=${APPLICATION_PORT}", "--spring.profiles.active=${PROFILE}"]
[INFO]
[INFO]  ---> Running in f1f1b46cf3e1
[INFO] Removing intermediate container f1f1b46cf3e1
[INFO]  ---> df32dfdf5a65
[INFO] Step 22/23 : EXPOSE ${APPLICATION_PORT}
[INFO]
[INFO]  ---> Running in d67a9c4cc7c7
[INFO] Removing intermediate container d67a9c4cc7c7
[INFO]  ---> 4b4a9e79720e
[INFO] Step 23/23 : HEALTHCHECK --interval=5m --timeout=3s   CMD curl -f http://localhost:${APPLICATION_PORT}/actuator || exit 1
[INFO]
[INFO]  ---> Running in 30629fefe031
[INFO] Removing intermediate container 30629fefe031
[INFO]  ---> 78d35db235fc
[INFO] Successfully built 78d35db235fc
[INFO] Successfully tagged dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
[INFO]
[INFO] Detected build of image with id 78d35db235fc
[INFO] Building jar: C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-springboot\target\udemy-springboot-docker-0.0.1-SNAPSHOT-docker-info.jar
[INFO] Successfully built docker.io/dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  01:09 min
[INFO] Finished at: 2021-07-02T20:38:05+07:00
[INFO] ------------------------------------------------------------------------
```

Sekarang misalnya kita akan jalankan containernya di docker, tpi sebelum itu kita buat file `.env` seperti berikut:

{% gist page.gist "08f-dotenv" %}

Kemudian jalankan perintah berikut

For Bash script:

{% gist page.gist "08f-docker-run.bash" %}

For Powershell script:

{% gist page.gist "08f-docker-run.ps1" %}

Jika dijalankan seperti berikut:

```powershell
➜ docker-springboot git:(master) docker network create backend | `
>> docker run --name postgresdb `
>> --network backend `
>> --env-file .env `
>> -d postgres:12.6 | `
>> docker run --name spring-db `
>> --network backend `
>> --env-file .env `
>> -e DATABASE_HOST=postgresdb `
>> -p 8080:80 `
>> -d dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT

➜ docker-springboot git:(master) docker container ls
CONTAINER ID   IMAGE                                                  COMMAND                  CREATED         STATUS                            PORTS                                   NAMES
97a8675407f1   dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT   "java -Djava.securit…"   5 seconds ago   Up 4 seconds (health: starting)   0.0.0.0:8080->80/tcp, :::8080->80/tcp   spring-db
c33f7e900c00   postgres:12.6                                          "docker-entrypoint.s…"   5 seconds ago   Up 4 seconds                      5432/tcp                                postgresdb


➜ docker-springboot git:(master) docker logs spring-db

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v2.5.2)

2021-07-02 13:55:59.072  INFO 1 --- [           main] c.m.d.u.UdemySpringbootDockerApplication : Starting UdemySpringbootDockerApplication v0.0.1-SNAPSHOT using Java 11.0.11 on 97a8675407f1 with PID 1 (/usr/local/share/applications/spring-boot.jar started by www-data in /usr/local/share/applications)
2021-07-02 13:55:59.074  INFO 1 --- [           main] c.m.d.u.UdemySpringbootDockerApplication : The following profiles are active: default
2021-07-02 13:56:00.149  INFO 1 --- [           main] .s.d.r.c.RepositoryConfigurationDelegate : Bootstrapping Spring Data JPA repositories in DEFAULT mode.
2021-07-02 13:56:00.210  INFO 1 --- [           main] .s.d.r.c.RepositoryConfigurationDelegate : Finished Spring Data repository scanning in 46 ms. Found 1 JPA repository interfaces.
2021-07-02 13:56:00.678  INFO 1 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 80 (http)
2021-07-02 13:56:00.688  INFO 1 --- [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2021-07-02 13:56:00.688  INFO 1 --- [           main] org.apache.catalina.core.StandardEngine  : Starting Servlet engine: [Apache Tomcat/9.0.48]
2021-07-02 13:56:00.736  INFO 1 --- [           main] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
2021-07-02 13:56:00.736  INFO 1 --- [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 1605 ms
2021-07-02 13:56:01.029  INFO 1 --- [           main] o.f.c.internal.license.VersionPrinter    : Flyway Community Edition 7.7.3 by Redgate
2021-07-02 13:56:01.038  INFO 1 --- [           main] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Starting...
2021-07-02 13:56:01.137  INFO 1 --- [           main] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Start completed.
2021-07-02 13:56:01.168  INFO 1 --- [           main] o.f.c.i.database.base.DatabaseType       : Database: jdbc:postgresql://postgresdb:5432/example (PostgreSQL 12.6)
2021-07-02 13:56:01.199  INFO 1 --- [           main] o.f.core.internal.command.DbValidate     : Successfully validated 1 migration (execution time 00:00.014s)
2021-07-02 13:56:01.208  INFO 1 --- [           main] o.f.c.i.s.JdbcTableSchemaHistory         : Creating Schema History table "public"."flyway_schema_history" ...
2021-07-02 13:56:01.227  INFO 1 --- [           main] o.f.c.i.s.DefaultSqlScriptExecutor       : 0 rows affected
2021-07-02 13:56:01.231  INFO 1 --- [           main] o.f.c.i.s.DefaultSqlScriptExecutor       : 0 rows affected
2021-07-02 13:56:01.234  INFO 1 --- [           main] o.f.c.i.s.DefaultSqlScriptExecutor       : 0 rows affected
2021-07-02 13:56:01.241  INFO 1 --- [           main] o.f.core.internal.command.DbMigrate      : Current version of schema "public": << Empty Schema >>
2021-07-02 13:56:01.257  INFO 1 --- [           main] o.f.core.internal.command.DbMigrate      : Migrating schema "public" to version "1 - schema-awal"
2021-07-02 13:56:01.260  INFO 1 --- [           main] o.f.c.i.s.DefaultSqlScriptExecutor       : DB: table "mahasiswa" does not exist, skipping
2021-07-02 13:56:01.260  INFO 1 --- [           main] o.f.c.i.s.DefaultSqlScriptExecutor       : 0 rows affected
2021-07-02 13:56:01.269  INFO 1 --- [           main] o.f.c.i.s.DefaultSqlScriptExecutor       : 0 rows affected
2021-07-02 13:56:01.271  INFO 1 --- [           main] o.f.c.i.s.DefaultSqlScriptExecutor       : 1 rows affected
2021-07-02 13:56:01.285  INFO 1 --- [           main] o.f.core.internal.command.DbMigrate      : Successfully applied 1 migration to schema "public", now at version v1 (execution time 00:00.046s)
2021-07-02 13:56:01.357  INFO 1 --- [           main] o.hibernate.jpa.internal.util.LogHelper  : HHH000204: Processing PersistenceUnitInfo [name: default]
2021-07-02 13:56:01.405  INFO 1 --- [           main] org.hibernate.Version                    : HHH000412: Hibernate ORM core version 5.4.32.Final
2021-07-02 13:56:01.518  INFO 1 --- [           main] o.hibernate.annotations.common.Version   : HCANN000001: Hibernate Commons Annotations {5.1.2.Final}
2021-07-02 13:56:01.612  INFO 1 --- [           main] org.hibernate.dialect.Dialect            : HHH000400: Using dialect: org.hibernate.dialect.PostgreSQL95Dialect
2021-07-02 13:56:02.115  INFO 1 --- [           main] o.h.e.t.j.p.i.JtaPlatformInitiator       : HHH000490: Using JtaPlatform implementation: [org.hibernate.engine.transaction.jta.platform.internal.NoJtaPlatform]
2021-07-02 13:56:02.123  INFO 1 --- [           main] j.LocalContainerEntityManagerFactoryBean : Initialized JPA EntityManagerFactory for persistence unit 'default'
2021-07-02 13:56:02.397  WARN 1 --- [           main] JpaBaseConfiguration$JpaWebConfiguration : spring.jpa.open-in-view is enabled by default. Therefore, database queries may be performed during view rendering. Explicitly configure spring.jpa.open-in-view to disable this warning
2021-07-02 13:56:02.608  WARN 1 --- [           main] ion$DefaultTemplateResolverConfiguration : Cannot find template location: classpath:/templates/ (please add some templates or check your Thymeleaf configuration)
2021-07-02 13:56:02.739  INFO 1 --- [           main] o.s.b.a.e.web.EndpointLinksResolver      : Exposing 1 endpoint(s) beneath base path '/actuator'
2021-07-02 13:56:02.792  INFO 1 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 80 (http) with context path ''
2021-07-02 13:56:02.807  INFO 1 --- [           main] c.m.d.u.UdemySpringbootDockerApplication : Started UdemySpringbootDockerApplication in 4.278 seconds (JVM running for 4.784)
```

Sekarang kita coba execute http request untuk file `MahasiswaController.http` seperti berikut:

1. `/api/mahasiswa/list` hasilnya seperti berikut:

    ![mahasiswa list]({{ page.image_path | prepend: site.baseurl }}/01-list.png)

2. `/api/mahasiswa/save` hasilnya seperti berikut:

    ![mahasiswa save]({{ page.image_path | prepend: site.baseurl }}/02-save.png)

3. `/api/mahasiswa/01` hasilnya seperti berikut:

    ![mahasiswa find by id]({{ page.image_path | prepend: site.baseurl }}/03-find-by-id.png)

4. `/api/mahasiswa/list` hasilnya seperti berikut:

    ![mahasiswa list]({{ page.image_path | prepend: site.baseurl }}/04-list.png)

## Best practice for local development and containerization

Untuk **best practice dalam development** aplikasi, biasanya menggunakan service seperti database atau service springboot lain itu biasanya akan aku jalankan dalam container tetapi jika memunkinkan adanya perubahan code biasanya akan saya jalankan seperti development biasanya yaitu dengan perintahah `mvn clean spring-boot:run`

Untuk **best practice dalam membuat docker image**, seperti yang telah saya sampaikan pada [materi sebelumnya]({% post_url docker/06-build-images/2021-06-24-07m-best-practice-dockerfile %}) sebaikanya kita memfokuskan pada satu program saja. Jadi dari contoh kasus di atas, kita menjalankan aplikasi Java springboot dan menggunakan database, Nah database postgresql ini akan menjadi dependency (required), apakah harus kita install dalam satu image?? tergantung kalo saya lebih seneng untuk di pisah karena lebih scaleable, portable dan masih banyak alasan lainnya. 

## Cleanup

Seperti biasa, setelah kita mencoba schenario diatas kita bersih-bersih dulu ya berikut scriptnya:

For Bash script:

{% gist page.gist "08f-cleanup.bash" %}

For Powershell script:

{% gist page.gist "08f-cleanup.ps1" %}