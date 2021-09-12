---
layout: post
title: "Study Kasus: Springboot deployment using compose file"
lang: docker
categories:
- DevOps
- Docker
refs: 
- https://docs.docker.com/
youtube: 
comments: true
image_path: /resources/posts/docker/10d-compose-springboot-study-case
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, di materi study kasus kali ini kita akan membahas Spring-Boot deployment menggunakan compose file. Diantaranya kita akan membahas

1. Development on local environment using compose file
2. Development on docker environment using compose file
3. Deployment using compose file for production ready

## Dev on local environment

Untuk development pada local environment pada dasarnya kita perlu install 

1. JDK (Java Development Kit)
2. Apache Maven
3. PostgreSQL Database

Jadi biasanya, untuk sifatnya Software Development Kit atau SDK kita install di host kita sedangkan untuk yang sifatnya service seperti PostgreSQL Database kita jalankan di docker untuk memudahkan. Maka berikut adalah configuration `docker-compose.yaml`

{% gist page.gist "10d-local.docker-compose.yaml" %}

Serta berikut adalah file `.env` 

{% gist page.gist "10d-local.env" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ docker git:(compose/spring-boot) docker-compose -p local up -d
Creating network "local_default" with the default driver
Creating volume "local_pg_data" with default driver
Creating local_postgres_1 ... done

➜ docker git:(compose/spring-boot) docker-compose -p local ps
      Name                    Command              State                    Ports
---------------------------------------------------------------------------------------------------
local_postgres_1   docker-entrypoint.sh postgres   Up      0.0.0.0:5432->5432/tcp,:::5432->5432/tcp

➜ docker git:(compose/spring-boot) mvn clean spring-boot:run
[INFO] Scanning for projects...
[INFO]
[INFO] -------------< com.maryanto.dimas.udemy:docker-springboot >-------------
[INFO] Building Dockerize Springboot Apps 2021.07.05.00.18-release
[INFO] --------------------------------[ jar ]---------------------------------

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v2.5.2)

2021-09-12 20:45:20.931  INFO 29932 --- [  restartedMain] m.d.u.DockerizeSpringbootAppsApplication : Starting DockerizeSpringbootAppsApplication using Java 11.0.9 on MSI-z390-pro with PID 29932 (C:\Users\dimasm93\Workspaces\udemy\docker\target\classes started by dimasm93 in C:\Users\dimasm93\Workspaces\udemy\docker)
2021-09-12 20:45:20.933  INFO 29932 --- [  restartedMain] m.d.u.DockerizeSpringbootAppsApplication : No active profile set, falling back to default profiles: default
2021-09-12 20:45:20.958  INFO 29932 --- [  restartedMain] .e.DevToolsPropertyDefaultsPostProcessor : Devtools property defaults active! Set 'spring.devtools.add-properties' to 'false' to disable
2021-09-12 20:45:20.958  INFO 29932 --- [  restartedMain] .e.DevToolsPropertyDefaultsPostProcessor : For additional web related logging consider setting the 'logging.level.web' property to 'DEBUG'
2021-09-12 20:45:21.473  INFO 29932 --- [  restartedMain] .s.d.r.c.RepositoryConfigurationDelegate : Bootstrapping Spring Data JPA repositories in DEFAULT mode.
2021-09-12 20:45:21.501  INFO 29932 --- [  restartedMain] .s.d.r.c.RepositoryConfigurationDelegate : Finished Spring Data repository scanning in 23 ms. Found 1 JPA repository interfaces.
2021-09-12 20:45:22.017  INFO 29932 --- [  restartedMain] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8080 (http)
2021-09-12 20:45:22.023  INFO 29932 --- [  restartedMain] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2021-09-12 20:45:22.023  INFO 29932 --- [  restartedMain] org.apache.catalina.core.StandardEngine  : Starting Servlet engine: [Apache Tomcat/9.0.48]
2021-09-12 20:45:22.093  INFO 29932 --- [  restartedMain] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
2021-09-12 20:45:22.093  INFO 29932 --- [  restartedMain] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 1135 ms
2021-09-12 20:45:22.225  INFO 29932 --- [  restartedMain] o.f.c.internal.license.VersionPrinter    : Flyway Community Edition 7.7.3 by Redgate
2021-09-12 20:45:22.229  INFO 29932 --- [  restartedMain] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Starting...
2021-09-12 20:45:22.278  INFO 29932 --- [  restartedMain] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Start completed.
2021-09-12 20:45:22.294  INFO 29932 --- [  restartedMain] o.f.c.i.database.base.DatabaseType       : Database: jdbc:postgresql://localhost:5432/udemy_docker (PostgreSQL 12.6)
2021-09-12 20:45:22.325  INFO 29932 --- [  restartedMain] o.f.core.internal.command.DbValidate     : Successfully validated 1 migration (execution time 00:00.015s)
2021-09-12 20:45:22.335  INFO 29932 --- [  restartedMain] o.f.core.internal.command.DbMigrate      : Current version of schema "public": 1
2021-09-12 20:45:22.336  INFO 29932 --- [  restartedMain] o.f.core.internal.command.DbMigrate      : Schema "public" is up to date. No migration necessary.
2021-09-12 20:45:22.378  INFO 29932 --- [  restartedMain] o.hibernate.jpa.internal.util.LogHelper  : HHH000204: Processing PersistenceUnitInfo [name: default]
2021-09-12 20:45:22.404  INFO 29932 --- [  restartedMain] org.hibernate.Version                    : HHH000412: Hibernate ORM core version 5.4.32.Final
2021-09-12 20:45:22.473  INFO 29932 --- [  restartedMain] o.hibernate.annotations.common.Version   : HCANN000001: Hibernate Commons Annotations {5.1.2.Final}
2021-09-12 20:45:22.534  INFO 29932 --- [  restartedMain] org.hibernate.dialect.Dialect            : HHH000400: Using dialect: org.hibernate.dialect.PostgreSQL95Dialect
2021-09-12 20:45:22.858  INFO 29932 --- [  restartedMain] o.h.e.t.j.p.i.JtaPlatformInitiator       : HHH000490: Using JtaPlatform implementation: [org.hibernate.engine.transaction.jta.platform.internal.NoJtaPlatform]
2021-09-12 20:45:22.863  INFO 29932 --- [  restartedMain] j.LocalContainerEntityManagerFactoryBean : Initialized JPA EntityManagerFactory for persistence unit 'default'
2021-09-12 20:45:23.016  WARN 29932 --- [  restartedMain] JpaBaseConfiguration$JpaWebConfiguration : spring.jpa.open-in-view is enabled by default. Therefore, database queries may be performed during view rendering. Explicitly configure spring.jpa.open-in-view to disable this warning
2021-09-12 20:45:23.147  WARN 29932 --- [  restartedMain] ion$DefaultTemplateResolverConfiguration : Cannot find template location: classpath:/templates/ (please add some templates or check your Thymeleaf configuration)
2021-09-12 20:45:23.232  INFO 29932 --- [  restartedMain] o.s.b.d.a.OptionalLiveReloadServer       : LiveReload server is running on port 35729
2021-09-12 20:45:23.235  INFO 29932 --- [  restartedMain] o.s.b.a.e.web.EndpointLinksResolver      : Exposing 1 endpoint(s) beneath base path '/actuator'
2021-09-12 20:45:23.261  INFO 29932 --- [  restartedMain] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
2021-09-12 20:45:23.272  INFO 29932 --- [  restartedMain] m.d.u.DockerizeSpringbootAppsApplication : Started DockerizeSpringbootAppsApplication in 2.599 seconds (JVM running for 2.932)
```

## Dev on docker environment

Untuk development di docker environment, pertama kita siapkan dulu environment seperti JDK, Apache Maven dan PostgreSQL dengan configuration seperti berikut:

Update file `docker-compose.yaml` seperti berikut:

{% gist page.gist "10d-docker-env.docker-compose.yaml" %}

Kemudian buat file baru `docker-compose.override.yaml` seperti berikut:

{% gist page.gist "10d-docker-env.docker-compose.override.yaml" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ docker git:(compose/spring-boot) docker-compose -p docker config
services:
  postgres:
    environment:
      POSTGRES_DB: udemy_docker
      POSTGRES_PASSWORD: password
      POSTGRES_USER: postgres
    image: postgres:12.6
    ports:
    - published: 5432
      target: 5432
    volumes:
    - pg_data:/var/lib/postgresql/data:rw
  spring-boot:
    command:
    - mvn
    - clean
    - spring-boot:run
    depends_on:
      postgres:
        condition: service_started
    environment:
      DATABASE_HOST: postgres
      DATABASE_NAME: udemy_docker
      DATABASE_PASSWORD: password
      DATABASE_PORT: '5432'
      DATABASE_USER: postgres
    image: maven:3.8-jdk-11-slim
    ports:
    - published: 8080
      target: 8080
    profiles:
    - dev
    volumes:
    - C:\Users\dimasm93\.m2:/root/.m2:rw
    - C:\Users\dimasm93\Workspaces\udemy\docker:/var/lib/spring-boot:rw
    working_dir: /var/lib/spring-boot
version: '3.9'
volumes:
  pg_data: {}

➜ docker git:(compose/spring-boot) docker-compose -p docker --profile dev up -d
Creating network "docker_default" with the default driver
Creating volume "docker_pg_data" with default driver
Creating docker_postgres_1 ... done
Creating docker_spring-boot_1 ... done

➜ docker git:(compose/spring-boot) docker-compose -p docker --profile dev logs -f spring-boot
Attaching to docker_spring-boot_1

spring-boot_1  | [INFO] Scanning for projects...
spring-boot_1  | [INFO]
spring-boot_1  | [INFO] -------------< com.maryanto.dimas.udemy:docker-springboot >-------------
spring-boot_1  | [INFO] Building Dockerize Springboot Apps 2021.07.05.00.18-release
spring-boot_1  | [INFO] --------------------------------[ jar ]---------------------------------
spring-boot_1  | [INFO]
spring-boot_1  |
spring-boot_1  |   .   ____          _            __ _ _
spring-boot_1  |  /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
spring-boot_1  | ( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
spring-boot_1  |  \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
spring-boot_1  |     |____| .__|_| |_|_| |_\__, | / / / /
spring-boot_1  |  =========|_|==============|___/=/_/_/_/
spring-boot_1  |  :: Spring Boot ::                (v2.5.2)
spring-boot_1  |
spring-boot_1  | 2021-09-12 14:21:04.641  INFO 50 --- [  restartedMain] m.d.u.DockerizeSpringbootAppsApplication : Starting DockerizeSpringbootAppsApplication using Java 11.0.12 on 6cae8183fb58 with PID 50 (/var/lib/spring-boot/target/classes started by root in /var/lib/spring-boot)
spring-boot_1  | 2021-09-12 14:21:04.647  INFO 50 --- [  restartedMain] m.d.u.DockerizeSpringbootAppsApplication : No active profile set, falling back to default profiles: default
spring-boot_1  | 2021-09-12 14:21:04.754  INFO 50 --- [  restartedMain] .e.DevToolsPropertyDefaultsPostProcessor : Devtools property defaults active! Set 'spring.devtools.add-properties' to 'false' to disable
spring-boot_1  | 2021-09-12 14:21:04.755  INFO 50 --- [  restartedMain] .e.DevToolsPropertyDefaultsPostProcessor : For additional web related logging consider setting the 'logging.level.web' property to 'DEBUG'
spring-boot_1  | 2021-09-12 14:21:07.677  INFO 50 --- [  restartedMain] .s.d.r.c.RepositoryConfigurationDelegate : Bootstrapping Spring Data JPA repositories in DEFAULT mode.
spring-boot_1  | 2021-09-12 14:21:07.985  INFO 50 --- [  restartedMain] .s.d.r.c.RepositoryConfigurationDelegate : Finished Spring Data repository scanning in 283 ms. Found 1 JPA repository interfaces.
spring-boot_1  | 2021-09-12 14:21:09.440  INFO 50 --- [  restartedMain] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8080 (http)
spring-boot_1  | 2021-09-12 14:21:09.461  INFO 50 --- [  restartedMain] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
spring-boot_1  | 2021-09-12 14:21:09.461  INFO 50 --- [  restartedMain] org.apache.catalina.core.StandardEngine  : Starting Servlet engine: [Apache Tomcat/9.0.48]
spring-boot_1  | 2021-09-12 14:21:09.720  INFO 50 --- [  restartedMain] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
spring-boot_1  | 2021-09-12 14:21:09.720  INFO 50 --- [  restartedMain] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 4964 ms
spring-boot_1  | 2021-09-12 14:21:10.162  INFO 50 --- [  restartedMain] o.f.c.internal.license.VersionPrinter    : Flyway Community Edition 7.7.3 by Redgate
spring-boot_1  | 2021-09-12 14:21:10.193  INFO 50 --- [  restartedMain] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Starting...
spring-boot_1  | 2021-09-12 14:21:10.408  INFO 50 --- [  restartedMain] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Start completed.
spring-boot_1  | 2021-09-12 14:21:10.472  INFO 50 --- [  restartedMain] o.f.c.i.database.base.DatabaseType       : Database: jdbc:postgresql://postgres:5432/udemy_docker (PostgreSQL 12.6)
spring-boot_1  | 2021-09-12 14:21:10.565  INFO 50 --- [  restartedMain] o.f.core.internal.command.DbValidate     : Successfully validated 1 migration (execution time 00:00.050s)
spring-boot_1  | 2021-09-12 14:21:10.578  INFO 50 --- [  restartedMain] o.f.c.i.s.JdbcTableSchemaHistory         : Creating Schema History table "public"."flyway_schema_history" ...
spring-boot_1  | 2021-09-12 14:21:10.619  INFO 50 --- [  restartedMain] o.f.c.i.s.DefaultSqlScriptExecutor       : 0 rows affected
spring-boot_1  | 2021-09-12 14:21:10.622  INFO 50 --- [  restartedMain] o.f.c.i.s.DefaultSqlScriptExecutor       : 0 rows affected
spring-boot_1  | 2021-09-12 14:21:10.625  INFO 50 --- [  restartedMain] o.f.c.i.s.DefaultSqlScriptExecutor       : 0 rows affected
spring-boot_1  | 2021-09-12 14:21:10.635  INFO 50 --- [  restartedMain] o.f.core.internal.command.DbMigrate      : Current version of schema "public": << Empty Schema >>
spring-boot_1  | 2021-09-12 14:21:10.666  INFO 50 --- [  restartedMain] o.f.core.internal.command.DbMigrate      : Migrating schema "public" to version "1 - schema-awal"
spring-boot_1  | 2021-09-12 14:21:10.675  INFO 50 --- [  restartedMain] o.f.c.i.s.DefaultSqlScriptExecutor       : DB: table "mahasiswa" does not exist, skipping
spring-boot_1  | 2021-09-12 14:21:10.676  INFO 50 --- [  restartedMain] o.f.c.i.s.DefaultSqlScriptExecutor       : 0 rows affected
spring-boot_1  | 2021-09-12 14:21:10.682  INFO 50 --- [  restartedMain] o.f.c.i.s.DefaultSqlScriptExecutor       : 0 rows affected
spring-boot_1  | 2021-09-12 14:21:10.683  INFO 50 --- [  restartedMain] o.f.c.i.s.DefaultSqlScriptExecutor       : 1 rows affected
spring-boot_1  | 2021-09-12 14:21:10.698  INFO 50 --- [  restartedMain] o.f.core.internal.command.DbMigrate      : Successfully applied 1 migration to schema "public", now at version v1 (execution time 00:00.068s)
spring-boot_1  | 2021-09-12 14:21:10.934  INFO 50 --- [  restartedMain] o.hibernate.jpa.internal.util.LogHelper  : HHH000204: Processing PersistenceUnitInfo [name: default]
spring-boot_1  | 2021-09-12 14:21:11.104  INFO 50 --- [  restartedMain] org.hibernate.Version                    : HHH000412: Hibernate ORM core version 5.4.32.Final
spring-boot_1  | 2021-09-12 14:21:11.569  INFO 50 --- [  restartedMain] o.hibernate.annotations.common.Version   : HCANN000001: Hibernate Commons Annotations {5.1.2.Final}
spring-boot_1  | 2021-09-12 14:21:11.980  INFO 50 --- [  restartedMain] org.hibernate.dialect.Dialect            : HHH000400: Using dialect: org.hibernate.dialect.PostgreSQL95Dialect
spring-boot_1  | 2021-09-12 14:21:13.817  INFO 50 --- [  restartedMain] o.h.e.t.j.p.i.JtaPlatformInitiator       : HHH000490: Using JtaPlatform implementation: [org.hibernate.engine.transaction.jta.platform.internal.NoJtaPlatform]
spring-boot_1  | 2021-09-12 14:21:13.854  INFO 50 --- [  restartedMain] j.LocalContainerEntityManagerFactoryBean : Initialized JPA EntityManagerFactory for persistence unit 'default'
spring-boot_1  | 2021-09-12 14:21:14.623  WARN 50 --- [  restartedMain] JpaBaseConfiguration$JpaWebConfiguration : spring.jpa.open-in-view is enabled by default. Therefore, database queries may be performed during view rendering. Explicitly configure spring.jpa.open-in-view to disable this warning
spring-boot_1  | 2021-09-12 14:21:15.218  WARN 50 --- [  restartedMain] ion$DefaultTemplateResolverConfiguration : Cannot find template location: classpath:/templates/ (please add some templates or check your Thymeleaf configuration)
spring-boot_1  | 2021-09-12 14:21:15.694  INFO 50 --- [  restartedMain] o.s.b.d.a.OptionalLiveReloadServer       : LiveReload server is running on port 35729
spring-boot_1  | 2021-09-12 14:21:15.701  INFO 50 --- [  restartedMain] o.s.b.a.e.web.EndpointLinksResolver      : Exposing 1 endpoint(s) beneath base path '/actuator'
spring-boot_1  | 2021-09-12 14:21:15.759  INFO 50 --- [  restartedMain] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
spring-boot_1  | 2021-09-12 14:21:15.777  INFO 50 --- [  restartedMain] m.d.u.DockerizeSpringbootAppsApplication : Started DockerizeSpringbootAppsApplication in 12.181 seconds (JVM running for 13.579)

➜ docker git:(compose/spring-boot)✗  curl http://localhost:8080/api/environment/placeholder
StatusCode        : 200
StatusDescription :
Content           : {"password":"password","url":"jdbc:postgresql://postgres:5432/
                    udemy_docker","username":"postgres"}
RawContent        : HTTP/1.1 200
                    Transfer-Encoding: chunked
                    Content-Type: application/json
                    Date: Sun, 12 Sep 2021 14:22:28 GMT

                    {"password":"password","url":"jdbc:postgresql://postgres:5432/
                    udemy_docker","username"...
```