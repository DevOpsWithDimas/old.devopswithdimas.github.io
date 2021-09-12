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