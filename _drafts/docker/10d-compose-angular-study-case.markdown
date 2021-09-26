---
layout: post
title: "Study Kasus: Angular deployment using compose file"
lang: docker
categories:
- DevOps
- Docker
- Compose
- Study-Cases
refs: 
- https://docs.docker.com/
youtube: 
comments: true
image_path: /resources/posts/docker/10e-compose-angular-study-case
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya di materi study kasus kali ini kita akan membahas tentang angular development & deployment menggunakan compose file. Diantaranya kita akan membahas

1. Development on local environment using compose file
2. Development on docker environment using compose file
3. Deployment using compose file for production ready

Untuk source-code angular saya ambil dari [study kasus sebelumnya]({% post_url docker/07-study-cases/2021-07-11-08i-build-angular-proxy-to-backend %})

Ok lansung aja kita ke pembahasan yang pertama

## Dev on local environment

Untuk development pada local environtment pada dasarnya kita membutuhkan software

1. NodeJS
2. angular-cli
3. Backend [spring-boot]({% post_url docker/09-study-cases/2021-09-14-10c-compose-springboot-study-case %})
4. Database PostgreSQL

Nah jadi dari beberapa software tersebut klo kita mau running di local, kita perlu install semua. tapi karena di sini misalnya role kita sebagai front-end developer (angular) jadi kita gak ada perlubahan di sisi backend (spring-boot) jadi kita jalankan di docker saja. dengan membuat docker compose seperti berikut:

{% gist page.gist "10d-local.docker-compose.yaml" %}

Jika kita ajalankan hasilnya seperti berikut:

```powershell
➜ docker git:(compose/angular) docker-compose -p local up -d
Creating network "local_default" with the default driver
Creating volume "local_pg_data" with default driver
Creating local_postgres_1 ... done
Creating local_spring-boot_1 ... done

➜ docker git:(compose/angular) docker-compose -p local ps
       Name                      Command                       State                             Ports
------------------------------------------------------------------------------------------------------------------------
local_postgres_1      docker-entrypoint.sh postgres    Up                      0.0.0.0:5432->5432/tcp,:::5432->5432/tcp
local_spring-boot_1   java -jar -Djava.security. ...   Up (health: starting)   80/tcp,
                                                                               0.0.0.0:8080->8080/tcp,:::8080->8080/tcp

➜ docker git:(compose/angular) docker-compose -p local logs spring-boot
Attaching to local_spring-boot_1
spring-boot_1  |
spring-boot_1  |   .   ____          _            __ _ _
spring-boot_1  |  /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
spring-boot_1  | ( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
spring-boot_1  |  \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
spring-boot_1  |   ''  |____| .__|_| |_|_| |_\__, | / / / /
spring-boot_1  |  =========|_|==============|___/=/_/_/_/
spring-boot_1  |  :: Spring Boot ::                (v2.5.2)
spring-boot_1  |
spring-boot_1  | 2021-09-26 05:00:54.135  INFO 1 --- [           main] m.d.u.DockerizeSpringbootAppsApplication : Starting DockerizeSpringbootAppsApplication v2021.07.05.00.18-release using Java 11.0.12 on 093b437aaa72 with PID 1 (/usr/local/share/applications/spring-boot.jar started by www-data in /usr/local/share/applications)
spring-boot_1  | 2021-09-26 05:00:54.142  INFO 1 --- [           main] m.d.u.DockerizeSpringbootAppsApplication : The following profiles are active: default
spring-boot_1  | 2021-09-26 05:00:55.586  INFO 1 --- [           main] .s.d.r.c.RepositoryConfigurationDelegate : Bootstrapping Spring Data JPA repositories in DEFAULT mode.
spring-boot_1  | 2021-09-26 05:00:55.627  INFO 1 --- [           main] .s.d.r.c.RepositoryConfigurationDelegate : Finished Spring Data repository scanning in 34 ms. Found 1 JPA repository interfaces.
spring-boot_1  | 2021-09-26 05:00:56.094  INFO 1 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8080 (http)
spring-boot_1  | 2021-09-26 05:00:56.103  INFO 1 --- [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
spring-boot_1  | 2021-09-26 05:00:56.103  INFO 1 --- [           main] org.apache.catalina.core.StandardEngine  : Starting Servlet engine: [Apache Tomcat/9.0.48]
spring-boot_1  | 2021-09-26 05:00:56.159  INFO 1 --- [           main] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
spring-boot_1  | 2021-09-26 05:00:56.160  INFO 1 --- [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 1940 ms
spring-boot_1  | 2021-09-26 05:00:56.420  INFO 1 --- [           main] o.f.c.internal.license.VersionPrinter    : Flyway Community Edition 7.7.3 by Redgate
spring-boot_1  | 2021-09-26 05:00:56.428  INFO 1 --- [           main] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Starting...
spring-boot_1  | 2021-09-26 05:00:56.575  INFO 1 --- [           main] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Start completed.
spring-boot_1  | 2021-09-26 05:00:56.605  INFO 1 --- [           main] o.f.c.i.database.base.DatabaseType       : Database: jdbc:postgresql://postgres:5432/example (PostgreSQL 12.6)
spring-boot_1  | 2021-09-26 05:00:56.639  INFO 1 --- [           main] o.f.core.internal.command.DbValidate     : Successfully validated 1 migration (execution time 00:00.016s)
spring-boot_1  | 2021-09-26 05:00:56.650  INFO 1 --- [           main] o.f.c.i.s.JdbcTableSchemaHistory         : Creating Schema History table "public"."flyway_schema_history" ...
spring-boot_1  | 2021-09-26 05:00:56.671  INFO 1 --- [           main] o.f.c.i.s.DefaultSqlScriptExecutor       : 0 rows affected
spring-boot_1  | 2021-09-26 05:00:56.674  INFO 1 --- [           main] o.f.c.i.s.DefaultSqlScriptExecutor       : 0 rows affected
spring-boot_1  | 2021-09-26 05:00:56.681  INFO 1 --- [           main] o.f.c.i.s.DefaultSqlScriptExecutor       : 0 rows affected
spring-boot_1  | 2021-09-26 05:00:56.701  INFO 1 --- [           main] o.f.core.internal.command.DbMigrate      : Current version of schema "public": << Empty Schema >>
spring-boot_1  | 2021-09-26 05:00:56.718  INFO 1 --- [           main] o.f.core.internal.command.DbMigrate      : Migrating schema "public" to version "1 - schema-awal"
spring-boot_1  | 2021-09-26 05:00:56.726  INFO 1 --- [           main] o.f.c.i.s.DefaultSqlScriptExecutor       : DB: table "mahasiswa" does not exist, skipping
spring-boot_1  | 2021-09-26 05:00:56.726  INFO 1 --- [           main] o.f.c.i.s.DefaultSqlScriptExecutor       : 0 rows affected
spring-boot_1  | 2021-09-26 05:00:56.733  INFO 1 --- [           main] o.f.c.i.s.DefaultSqlScriptExecutor       : 0 rows affected
spring-boot_1  | 2021-09-26 05:00:56.734  INFO 1 --- [           main] o.f.c.i.s.DefaultSqlScriptExecutor       : 1 rows affected
spring-boot_1  | 2021-09-26 05:00:56.744  INFO 1 --- [           main] o.f.core.internal.command.DbMigrate      : Successfully applied 1 migration to schema "public", now at version v1 (execution time 00:00.051s)
spring-boot_1  | 2021-09-26 05:00:56.809  INFO 1 --- [           main] o.hibernate.jpa.internal.util.LogHelper  : HHH000204: Processing PersistenceUnitInfo [name: default]
spring-boot_1  | 2021-09-26 05:00:56.857  INFO 1 --- [           main] org.hibernate.Version                    : HHH000412: Hibernate ORM core version 5.4.32.Final
spring-boot_1  | 2021-09-26 05:00:56.978  INFO 1 --- [           main] o.hibernate.annotations.common.Version   : HCANN000001: Hibernate Commons Annotations {5.1.2.Final}
spring-boot_1  | 2021-09-26 05:00:57.129  INFO 1 --- [           main] org.hibernate.dialect.Dialect            : HHH000400: Using dialect: org.hibernate.dialect.PostgreSQL95Dialect
spring-boot_1  | 2021-09-26 05:00:57.649  INFO 1 --- [           main] o.h.e.t.j.p.i.JtaPlatformInitiator       : HHH000490: Using JtaPlatform implementation: [org.hibernate.engine.transaction.jta.platform.internal.NoJtaPlatform]
spring-boot_1  | 2021-09-26 05:00:57.657  INFO 1 --- [           main] j.LocalContainerEntityManagerFactoryBean : Initialized JPA EntityManagerFactory for persistence unit 'default'
spring-boot_1  | 2021-09-26 05:00:57.909  WARN 1 --- [           main] JpaBaseConfiguration$JpaWebConfiguration : spring.jpa.open-in-view is enabled by default. Therefore, database queries may be performed during view rendering. Explicitly configure spring.jpa.open-in-view to disable this warning
spring-boot_1  | 2021-09-26 05:00:58.148  WARN 1 --- [           main] ion$DefaultTemplateResolverConfiguration : Cannot find template location: classpath:/templates/ (please add some templates or check your Thymeleaf configuration)
spring-boot_1  | 2021-09-26 05:00:58.302  INFO 1 --- [           main] o.s.b.a.e.web.EndpointLinksResolver      : Exposing 1 endpoint(s) beneath base path '/actuator'
spring-boot_1  | 2021-09-26 05:00:58.342  INFO 1 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
spring-boot_1  | 2021-09-26 05:00:58.356  INFO 1 --- [           main] m.d.u.DockerizeSpringbootAppsApplication : Started DockerizeSpringbootAppsApplication in 4.876 seconds (JVM running for 5.493)

➜ docker git:(compose/angular) npm install
npm WARN ajv-keywords@3.5.2 requires a peer of ajv@^6.9.1 but none is installed. You must install peer dependencies yourself.
npm WARN karma-jasmine-html-reporter@1.7.0 requires a peer of jasmine-core@>=3.8 but none is installed. You must install peer dependencies yourself.
npm WARN optional SKIPPING OPTIONAL DEPENDENCY: fsevents@2.3.2 (node_modules\fsevents):
npm WARN notsup SKIPPING OPTIONAL DEPENDENCY: Unsupported platform for fsevents@2.3.2: wanted {"os":"darwin","arch":"any"} (current: {"os":"win32","arch":"x64"})
npm WARN optional SKIPPING OPTIONAL DEPENDENCY: fsevents@1.2.13 (node_modules\webpack-dev-server\node_modules\fsevents):
npm WARN notsup SKIPPING OPTIONAL DEPENDENCY: Unsupported platform for fsevents@1.2.13: wanted {"os":"darwin","arch":"any"} (current: {"os":"win32","arch":"x64"})
removed 1 package in 3.866s
87 packages are looking for funding
  run `npm fund` for details

➜ docker git:(compose/angular) npm start
> docker-angular@0.0.0 start C:\Users\dimasm93\Workspaces\udemy\docker
> ng serve
⠋ Generating browser application bundles (phase: setup)...[HPM] Proxy created: /spring-boot  ->  http://localhost:8080
[HPM] Proxy rewrite rule created: "^/spring-boot" ~> ""
[HPM] Subscribed to http-proxy events:  [ 'error', 'close' ]
✔ Browser application bundle generation complete.

Initial Chunk Files   | Names         |      Size
vendor.js             | vendor        |   2.78 MB
polyfills.js          | polyfills     | 508.82 kB
styles.css, styles.js | styles        | 381.01 kB
main.js               | main          |  23.82 kB
runtime.js            | runtime       |   6.58 kB
                      | Initial Total |   3.68 MB

Build at: 2021-09-26T05:02:37.898Z - Hash: 73d216279733def625bc - Time: 5277ms
** Angular Live Development Server is listening on localhost:4200, open your browser on http://localhost:4200/ **
√ Compiled successfully.
```