---
layout: post
title: "Study Kasus: Angular project access Rest API"
date: 2021-07-11T14:00:50+07:00
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://angular.io/guide/http
- https://angular.io/guide/build#configuring-application-environments
youtube: 
comments: true
image_path: /resources/posts/docker/08h-angular-httpclient
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, di materi kali kita akan membahas tentang Access Rest API dari project SpringBoot sebelumnya menggunakan Angular project. Diantaranya yang kita bahas yaitu

1. Create service `http/client`
2. Using Environment
3. Build & run docker images
4. Cleanup

Ok langsung aja kita ke pembahasan yang partama

## Create service `http/client`

Pada materi [sebelumnya]({% post_url docker/07-study-cases/2021-07-09-08g-build-angular-project %}) kita udah membuat angular project dan membuat Rest API service dengan [spring-boot]({% post_url docker/07-study-cases/2021-07-02-08f-build-springboot-using-db %}) yang sudah menjadi docker image, sekarang kita lanjutkan untuk mengakses Rest API tersebut menggunakan angular project ya. 

Kita buat dulu feature list dan tambah `Mahasiswa` serta service untuk mengakses Rest API seperti berikut:

1. Create Model mahasiswa, `ng generate class model/mahasiswa --skip-tests` seperti berikut:
    {% gist page.gist "08h-ng-gclass-mahasiswa-model.ts" %}
2. Create Service mahasiswa, `ng generate service service/mahasiswa-service --skip-tests` seperti berikut:
    {% gist page.gist "08h-ng-gs-mahasiswa-service.ts" %}
3. Enable `HttpClientModule` dan `ReactiveFormsModule` pada `app.module.ts` seperti berikut:
    {% gist page.gist "08h-enable-http-client-module.ts" %}
4. Create List Mahasiswa, `ng generate component pages/mahasiswa-list --skip-tests` seperti berikut:
    {% gist page.gist "08h-ng-gc-mahasiswa-list.ts" %}
    {% gist page.gist "08h-ng-gc-mahasiswa-list.html" %}
5. Setelah itu kita modif file `app.component.html` seperti berikut:
    {% gist page.gist "08h-app-component.html" %}

Ok sebelum kita running project angularnya, sekarang kita jalankan dlu container spring-boot yang telah di buat sebelumnya dengan perintah seperti berikut:

Untuk menjalankan service spring-boot sebelunya kita gunakan file `.env` seperti berikut:

{% gist page.gist "08f-dotenv" %}

Kemudian jalankan perintah berikut 

For Bash script:

{% gist page.gist "08f-docker-run.bash" %}

For Powershell script: 

{% gist page.gist "08f-docker-run.ps1" %}

Jika di jalankan outputnya seperti berikut:

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

7f536ecdead1ebbb4264188c47b330ddeabd6f4ecbf90b70062eee85e741a5c1


➜ docker-springboot git:(master)✗  docker container ls
CONTAINER ID   IMAGE                                                  COMMAND                  CREATED         STATUS                            PORTS                                   NAMES
7f536ecdead1   dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT   "java -Djava.securit…"   5 seconds ago   Up 3 seconds (health: starting)   0.0.0.0:8080->80/tcp, :::8080->80/tcp   spring-db
0705865b827b   postgres:12.6                                          "docker-entrypoint.s…"   6 seconds ago   Up 4 seconds                      5432/tcp                                postgresdb

➜ docker-springboot git:(master) docker logs -f spring-db

  .   ____          _            __ _ _
 /\\ / ___''_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v2.5.2)


2021-07-11 05:36:31.399  INFO 1 --- [           main] o.f.c.internal.license.VersionPrinter    : Flyway Community Edition 7.7.3 by Redgate
2021-07-11 05:36:31.407  INFO 1 --- [           main] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Starting...
2021-07-11 05:36:31.544  INFO 1 --- [           main] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Start completed.
2021-07-11 05:36:31.580  INFO 1 --- [           main] o.f.c.i.database.base.DatabaseType       : Database: jdbc:postgresql://postgresdb:5432/example (PostgreSQL 12.6)
2021-07-11 05:36:31.607  INFO 1 --- [           main] o.f.core.internal.command.DbValidate     : Successfully validated 1 migration (execution time 00:00.011s)
2021-07-11 05:36:31.616  INFO 1 --- [           main] o.f.c.i.s.JdbcTableSchemaHistory         : Creating Schema History table "public"."flyway_schema_history" ...
2021-07-11 05:36:31.653  INFO 1 --- [           main] o.f.core.internal.command.DbMigrate      : Current version of schema "public": << Empty Schema >>
2021-07-11 05:36:31.657  INFO 1 --- [           main] o.f.core.internal.command.DbMigrate      : Migrating schema "public" to version "1 - schema-awal"
2021-07-11 05:36:31.659  INFO 1 --- [           main] o.f.c.i.s.DefaultSqlScriptExecutor       : DB: table "mahasiswa" does not exist, skipping
2021-07-11 05:36:31.677  INFO 1 --- [           main] o.f.core.internal.command.DbMigrate      : Successfully applied 1 migration to schema "public", now at version v1 (execution time 00:00.027s)
2021-07-11 05:36:31.750  INFO 1 --- [           main] o.hibernate.jpa.internal.util.LogHelper  : HHH000204: Processing PersistenceUnitInfo [name: default]
2021-07-11 05:36:31.795  INFO 1 --- [           main] org.hibernate.Version                    : HHH000412: Hibernate ORM core version 5.4.32.Final
2021-07-11 05:36:31.909  INFO 1 --- [           main] o.hibernate.annotations.common.Version   : HCANN000001: Hibernate Commons Annotations {5.1.2.Final}
2021-07-11 05:36:32.014  INFO 1 --- [           main] org.hibernate.dialect.Dialect            : HHH000400: Using dialect: org.hibernate.dialect.PostgreSQL95Dialect
2021-07-11 05:36:32.528  INFO 1 --- [           main] o.h.e.t.j.p.i.JtaPlatformInitiator       : HHH000490: Using JtaPlatform implementation: [org.hibernate.engine.transaction.jta.platform.internal.NoJtaPlatform]
2021-07-11 05:36:32.539  INFO 1 --- [           main] j.LocalContainerEntityManagerFactoryBean : Initialized JPA EntityManagerFactory for persistence unit 'default'
2021-07-11 05:36:32.794  WARN 1 --- [           main] JpaBaseConfiguration$JpaWebConfiguration : spring.jpa.open-in-view is enabled by default. Therefore, database queries may be performed during view rendering. Explicitly configure spring.jpa.open-in-view to disable this warning
2021-07-11 05:36:33.003  WARN 1 --- [           main] ion$DefaultTemplateResolverConfiguration : Cannot find template location: classpath:/templates/ (please add some templates or check your Thymeleaf configuration)
2021-07-11 05:36:33.106  INFO 1 --- [           main] o.s.b.a.e.web.EndpointLinksResolver      : Exposing 1 endpoint(s) beneath base path '/actuator'
2021-07-11 05:36:33.137  INFO 1 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 80 (http) with context path ''
2021-07-11 05:36:33.149  INFO 1 --- [           main] c.m.d.u.UdemySpringbootDockerApplication : Started UdemySpringbootDockerApplication in 4.474 seconds (JVM running for 5.024)
2021-07-11 05:37:04.787  INFO 1 --- [p-nio-80-exec-1] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring DispatcherServlet 'dispatcherServlet'
2021-07-11 05:37:04.788  INFO 1 --- [p-nio-80-exec-1] o.s.web.servlet.DispatcherServlet        : Initializing Servlet 'dispatcherServlet'
2021-07-11 05:37:04.789  INFO 1 --- [p-nio-80-exec-1] o.s.web.servlet.DispatcherServlet        : Completed initialization
```

Kemudian coba jalankan aplikasi angular dengan perintah

{% highlight bash %}
ng serve --disable-host-check
{% endhighlight %}

Kemudian access browser ke alamat [localhost:4200](http://localhost:4200), hasilnya seperti berikut:

![access-rest-api]({{ page.image_path | prepend: site.baseurl }}/access-rest-api.png)

## Using Environment

Untuk menjalankan pada container, kita tidak bisa meng-access HttpClient dengan menembak `localhost:8080` seperti pada service tersebut, jadi kita harus membuatnya url tersebut secara dynamic. Salah satu solusinya adalah dengan menggunakan Environtment bawaan dari Angular.

By default, kita diberikan environtment `environments/environment.ts` dan `environtments/environtment.prod.ts`. Jadi ketika filenya di build akan menggunakan env `environment/prod.ts` terlihat dari file `angular.json` pada configurasi seperti berikut:

{% highlight json %}
{
    "projects" : {
        "docker-angular": {
            "architect" : {
                "build" : {
                    "configurations" : {
                        "production": {
                            "fileReplacements": [
                                {
                                    "replace": "src/environments/environment.ts",
                                    "with": "src/environments/environment.prod.ts"
                                }
                            ],
                        }
                    }
                }
            }
        }
    }
}
{% endhighlight %}

Nah untuk deploy ke docker container, kita bisa tambahkan satu profile lagi misalkan nama profilenya `docker` jadi kita buat dan modifikasi file seperti berikut

1. Buat file baru dengan nama `environtments/environment.docker.ts` seperti berikut:
    {% gist page.gist "08h-environment.docker.ts" %}
2. Edit file `environments/environment.ts` seperti berikut:
    {% gist page.gist "08h-environment.ts" %}
3. Edit file `environments/environment.prod.ts` seperti berikut:
    {% gist page.gist "08h-environment.prod.ts" %}
4. Kita edit file `service/mahasiswa.service.ts` seperti berikut:
    {% gist page.gist "08h-env-mahasiswa.service.ts" %}
5. Yang terakhir kita buat confignya di `angular.json` seperti berikut:
    {% gist page.gist "08h-docker-env-angular.json" %}

Setelah itu kita edit file `Dockerfile` untuk membuild angular dengan profile `docker` seperti berikut:

{% gist page.gist "08h-angular-env-dockerfile" %}

Setelah itu kita bisa coba, untuk build docker imagenya menggunakan perintah:

{% highlight bash %}
docker build -t dimmaryanto93/docker-angular:0.0.1-SNAPSHOT .
{% endhighlight %}

Jika dijalankan hasilnya seperti berikut:

```powershell
➜ docker-angular  docker build -t dimmaryanto93/docker-angular:0.0.1-SNAPSHOT .
[+] Building 103.3s (16/16) FINISHED
 => [internal] load build definition from Dockerfile                                                       0.0s
 => => transferring dockerfile: 1.15kB                                                                     0.0s
 => [internal] load .dockerignore                                                                          0.0s
 => => transferring context: 34B                                                                           0.0s
 => [internal] load metadata for docker.io/library/nginx:latest                                            4.5s
 => [internal] load metadata for docker.io/library/node:14.15-alpine                                       3.3s
 => [auth] library/nginx:pull token for registry-1.docker.io                                               0.0s
 => [auth] library/node:pull token for registry-1.docker.io                                                0.0s
 => [npm_install 1/5] FROM docker.io/library/node:14.15-alpine@sha256:5edad160011cc8cfb69d990e9ae1cb2681c  0.0s
 => CACHED [stage-1 1/3] FROM docker.io/library/nginx:latest@sha256:353c20f74d9b6aee359f30e8e4f69c3d7eaea  0.0s
 => => resolve docker.io/library/nginx:latest@sha256:353c20f74d9b6aee359f30e8e4f69c3d7eaea2f610681c4a9584  0.0s
 => [internal] load build context                                                                          0.0s
 => => transferring context: 12.47kB                                                                       0.0s
 => CACHED [npm_install 2/5] WORKDIR /var/www                                                              0.0s
 => [npm_install 3/5] COPY . .                                                                             0.0s
 => [npm_install 4/5] RUN npm install --prod --silent && npm install @angular-devkit/build-angular --sil  69.6s
 => [npm_install 5/5] RUN ./node_modules/@angular/cli/bin/ng build --aot --build-optimizer --configurati  28.5s
 => [stage-1 2/3] COPY --from=npm_install /var/www/dist/docker-angular /var/www/html                       0.1s
 => [stage-1 3/3] RUN sed -i 's|/usr/share/nginx/html|/var/www/html|g' /etc/nginx/conf.d/default.conf      0.3s
 => exporting to image                                                                                     0.1s
 => => exporting layers                                                                                    0.1s
 => => writing image sha256:b66da521e8365803a540579b62ed04430c04e5b57e92751dbfd5fc02df18dc59               0.0s
 => => naming to docker.io/dimmaryanto93/docker-angular:0.0.1-SNAPSHOT
```

Sekarang kita bisa coba test jalankan containernya, dengan perintah seperti berikut:

{% gist page.gist "08h-angular-env-docker-run.bash" %}

Hasilnya seperti berikut:

```powershell
➜ docker-angular ✗  docker run -p 80:80 --name angular-nginx --network backend -d dimmaryanto93/docker-angular:0.0.1-SNAPSHOT
cd0827fa8fa771164ce8df9b6b1fa405ce7ca6af761a3615027f2606ebd7828d

➜ docker-angular  docker container ls
CONTAINER ID   IMAGE                                                  COMMAND                  CREATED             STATUS                             PORTS                                   NAMES
daf395365d71   dimmaryanto93/docker-angular:0.0.1-SNAPSHOT            "/docker-entrypoint.…"   33 seconds ago      Up 32 seconds (health: starting)   0.0.0.0:80->80/tcp, :::80->80/tcp       angular-nginx
7f536ecdead1   dimmaryanto93/udemy-springboot-docker:0.0.1-SNAPSHOT   "java -Djava.securit…"   About an hour ago   Up About an hour (healthy)         0.0.0.0:8080->80/tcp, :::8080->80/tcp   spring-db
0705865b827b   postgres:12.6                                          "docker-entrypoint.s…"   About an hour ago   Up About an hour                   5432/tcp                                postgresdb
```

Kemudian coba access dengan browser [http://localhost](http://localhost:80) hasilnya seperti berikut:

![access-api]({{ page.image_path | prepend: site.baseurl }}/access-env.png)

## Cleanup

Seperti biasa, setelah kita mencoba schenario di atas sekarang kita bersih-bersih dulu ya. Berikut perintahnya:

For Bash script:

{% gist page.gist "08h-cleanup.bash" %}

For Powershell script:

{% gist page.gist "08h-cleanup.ps1" %}