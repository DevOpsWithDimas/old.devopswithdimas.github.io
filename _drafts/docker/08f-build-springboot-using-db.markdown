---
layout: post
title: "Studi Kasus: Springboot Using Database"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.spring.io/spring-boot/docs/current/reference/html/howto.html#howto.data-access
- https://docs.spring.io/spring-boot/docs/current/reference/html/howto.html#howto.data-initialization
youtube: 
comments: true
image_path: /resources/posts/docker/08d-
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas studi kasus menggunakan Database pada framework spring-boot, serta best practice dalam membuat aplikasi berbasis Containers. Diantaranya yang akan kita bahas yaitu

1. Setup Database & JDBC using spring-boot
2. Using Database migration for automation & versioning
3. Don't Store Database Credential in your source-code
4. Best practice for local development and containerization
5. Cleanup

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

## Best practice for local development and containerization