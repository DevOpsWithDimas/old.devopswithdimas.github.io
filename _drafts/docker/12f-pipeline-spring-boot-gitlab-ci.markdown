---
layout: post
title: "Pipeline: spring-boot deploy with Gitlab CI"
lang: docker
categories:
- DevOps
- Docker
- ci
- Study-Cases
- Gitlab-CI
refs: 
- https://docs.docker.com/
- https://docs.spring.io/spring-framework/docs/current/reference/html/testing.html#integration-testing
- https://docs.gitlab.com/ee/ci/unit_test_reports.html
- https://docs.gitlab.com/ee/ci/pipelines/job_artifacts.html
- https://docs.gitlab.com/ee/ci/yaml/#needs
youtube: 
comments: true
catalog_key: study-cases-docker-ci
image_path: /resources/posts/docker/12f-pipeline-springboot
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, di materi study kasus kali ini kita akan membahas Gitlab CI untuk spring-boot berdasarkan source-code [berikut]({% post_url docker/09-study-cases/2021-09-14-10c-compose-springboot-study-case %}). Jadi karena pembahasan lumayan panjang kita akan bagi menjadi beberapa bagian yaitu

1. Create unit/integration testing run locally
2. Run unit/integration test using Gitlab CI
3. Build jar archived to gitlab
4. Build & push docker image using archived artifact

Ok langsung bahas yang pertama yaitu

## Create unit/integration testing and run locally

Testing is an integral part of enterprise software development. The benefits of the Spring Framework’s support for [integration testing](https://docs.spring.io/spring-framework/docs/current/reference/html/testing.html#integration-testing). 

Ada banyak hal sebetulnya yang kita bisa bahas disini tetapi, untuk sekarang kita bahas yang paling penting dulu ya yaitu Run Unit Testing menggunakan pipeline Gitlab CI. Tapi sebelum itu kita akan buat dulu simple Integration Testing untuk melakukan check data yang dikembalikan Rest API seperti berikut:

1. Buat file `MahasiswaControllerRestTest` dalam folder `src/test/java` menggunakan package `com.maryanto.dimas.udemy.controller` seperti berikut:

    {% gist page.gist "12f-MahasiswaControllerRestTest.java" %}

2. Selanjutnya, karena unit/integration testing tersebut membutuhkan Database PostgreSQL, sekarang kita jalankan postgresql servicenya menggunakan docker-compose seperti berikut

    {% highlight bash %}
    docker-compose up -d postgres
    {% endhighlight %}

3. Setelah database postgresql running, kita bisa coba jalankan unit/integration test dengan peritah `mvn` seperti berikut:

{% highlight bash %}
mvn clean test
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```bash
➜  docker git:(ci/spring-boot) mvn clean test
[WARNING]
[INFO] Scanning for projects...
[INFO]
[INFO] -------------< com.maryanto.dimas.udemy:docker-springboot >-------------
[INFO] Building Dockerize Springboot Apps 2021.07.05.00.18-release
[INFO] --------------------------------[ jar ]---------------------------------
[INFO]
[INFO] --- maven-clean-plugin:3.1.0:clean (default-clean) @ docker-springboot ---
[INFO] Deleting /mnt/c/Users/dimasm93/Workspaces/udemy/docker/target
[INFO]
[INFO] --- maven-resources-plugin:3.2.0:resources (default-resources) @ docker-springboot ---
[INFO] -------------------------------------------------------
[INFO]  T E S T S
[INFO] -------------------------------------------------------
[INFO] Running com.maryanto.dimas.udemy.controller.MahasisaControllerRestTest
04:59:59.606 [main] DEBUG org.springframework.test.context.BootstrapUtils - Instantiating CacheAwareContextLoaderDelegate from class [org.springframework.test.context.cache.DefaultCacheAwareContextLoaderDelegate]
04:59:59.637 [main] DEBUG org.springframework.test.context.BootstrapUtils - Instantiating BootstrapContext using constructor [public org.springframework.test.context.support.DefaultBootstrapContext(java.lang.Class,org.springframework.test.context.CacheAwareContextLoaderDelegate)]
04:59:59.705 [main] DEBUG org.springframework.test.context.BootstrapUtils - Instantiating TestContextBootstrapper for test class [com.maryanto.dimas.udemy.controller.MahasisaControllerRestTest] from class [org.springframework.boot.test.context.SpringBootTestContextBootstrapper]
04:59:59.735 [main] INFO org.springframework.boot.test.context.SpringBootTestContextBootstrapper - Neither @ContextConfiguration nor @ContextHierarchy found for test class [com.maryanto.dimas.udemy.controller.MahasisaControllerRestTest], using SpringBootContextLoader

2021-12-04 05:00:01.154  INFO 254 --- [           main] c.m.d.u.c.MahasisaControllerRestTest     : Starting MahasisaControllerRestTest using Java 11.0.11 on MSI-Z390 with PID 254 (started by dimasm93 in /mnt/c/Users/dimasm93/Workspaces/udemy/docker)
2021-12-04 05:00:03.492  INFO 254 --- [           main] .s.d.r.c.RepositoryConfigurationDelegate : Finished Spring Data repository scanning in 234 ms. Found 1 JPA repository interfaces.
2021-12-04 05:00:04.528  INFO 254 --- [           main] o.f.c.internal.license.VersionPrinter    : Flyway Community Edition 7.7.3 by Redgate
2021-12-04 05:00:04.557  INFO 254 --- [           main] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Starting...
2021-12-04 05:00:04.790  INFO 254 --- [           main] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Start completed.
2021-12-04 05:00:04.885  INFO 254 --- [           main] o.f.c.i.database.base.DatabaseType       : Database: jdbc:postgresql://localhost:5432/udemy_docker (PostgreSQL 12.6)
2021-12-04 05:00:05.026  INFO 254 --- [           main] o.f.core.internal.command.DbValidate     : Successfully validated 1 migration (execution time 00:00.078s)
2021-12-04 05:00:05.039  INFO 254 --- [           main] o.f.core.internal.command.DbMigrate      : Current version of schema "public": 1
2021-12-04 05:00:05.040  INFO 254 --- [           main] o.f.core.internal.command.DbMigrate      : Schema "public" is up to date. No migration necessary.
2021-12-04 05:00:05.368  INFO 254 --- [           main] o.hibernate.jpa.internal.util.LogHelper  : HHH000204: 
2021-12-04 05:00:11.572  INFO 254 --- [           main] c.m.d.u.c.MahasisaControllerRestTest     : Started MahasisaControllerRestTest in 11.052 seconds (JVM running for 12.787)
Hibernate:
    select
        mahasiswa0_.id as id1_0_0_,
        mahasiswa0_.nama as nama2_0_0_,
        mahasiswa0_.nim as nim3_0_0_,
        mahasiswa0_.smt as smt4_0_0_
    from
        mahasiswa mahasiswa0_
    where
        mahasiswa0_.id=?
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 12.838 s - in com.maryanto.dimas.udemy.controller.MahasisaControllerRestTest
DockerizeSpringbootAppsApplicationTests in 3.511 seconds (JVM running for 17.122)
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 3.566 s - in com.maryanto.dimas.udemy.DockerizeSpringbootAppsApplicationTests
2021-12-04 05:00:15.945  INFO 254 --- [ionShutdownHook] j.LocalContainerEntityManagerFactoryBean : Closing JPA EntityManagerFactory for persistence unit 'default'
2021-12-04 05:00:15.949  INFO 254 --- [ionShutdownHook] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Shutdown initiated...
2021-12-04 05:00:15.957  INFO 254 --- [ionShutdownHook] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Shutdown completed.
2021-12-04 05:00:15.962  INFO 254 --- [ionShutdownHook] j.LocalContainerEntityManagerFactoryBean : Closing JPA EntityManagerFactory for persistence unit 'default'
2021-12-04 05:00:15.963  INFO 254 --- [ionShutdownHook] com.zaxxer.hikari.HikariDataSource       : HikariPool-2 - Shutdown initiated...
2021-12-04 05:00:15.975  INFO 254 --- [ionShutdownHook] com.zaxxer.hikari.HikariDataSource       : HikariPool-2 - Shutdown completed.
[INFO]
[INFO] Results:
[INFO]
[INFO] Tests run: 2, Failures: 0, Errors: 0, Skipped: 0
[INFO]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  22.789 s
[INFO] Finished at: 2021-12-04T05:00:16+07:00
[INFO] ------------------------------------------------------------------------
```

Jika outputnya seperti di atas, artinya kita sudah bisa terkoneksi ke database dengan cara memanggil service MahasiswaController melalui RestAPI dengan endpoint `/api/mahasiswa/{id}` pada method GET.

## Run unit/integration test using Gitlab CI

Ok setelah kita coba di local, sekarang kita akan buat automation menggunakan Pipeline di gitlab-ci. Kenapa kita buat automationnya?

Jadi unit/integration testing ini berguna jika programer males jalanin testnya jadi kita bisa make sure source-code yang kita buat jauh dari bugs atau klo misalnya ada penambahan feature tidak ngenggol feature yang existing. Ok langsung ja kita buat pipelinenya untuk menjalankan unit/integration testing

1. Pertama kita buat file `.gitlab-ci.yml` seperti berikut:

    {% gist page.gist "12f-gitlab-ci.test.yml" %}

2. Setelah itu, kita coba commit menggunakan perintah `git commit -m 'init project'`
3. Dan kemudian coba buat repository baru, misalnya buat dengan nama `udemy-springboot`
4. Dan yang terakhir coba buat tags dan push sourcenya. kemudian coba check status pipelinenya seperti berikut:

![pipeline-status]({{ page.image_path | prepend: site.baseurl }}/01-pipeline-job-detail.png)

Jika kita mau lihat junit report dari gitlab, kita bisa check yang unit test mana saja yang succussed dan failed seperti berikut:

![pipeline-report-status]({{ page.image_path | prepend: site.baseurl }}/02-pipeline-job-report.png)

kita juga bisa lihat detail dari reportnya seperti berikut:

![pipeline-report-detail-status]({{ page.image_path | prepend: site.baseurl }}/03-pipeline-job-report-detail.png)

## Build jar and archived to gitlab

Next step adalah kita akan membuild jar file menggunakan Pipeline Gitlab CI, Java web dengan Springboot framework jaman sekarang di deploy menggunakan format `jar` yang di running sebagai service. Dengan kita membuat pipeline build jar ini akan sangat berguna untuk tahap selanjutnya jika kita mau menggunakan Continues Delivery ataupun deploy secara manual. Ok lansung aja kita buat pipelinenya 

1. update file `.gitlab-ci.yml` menjadi seperti berikut:

    {% gist page.gist "12f-gitlab-ci.build-jar.yml" %}

2. Selanjutnya, kita buat tags dan push source-codenya. Kita coba check pipelinenuya seperti berikut:

![pipeline-build-status]({{ page.image_path | prepend: site.baseurl }}/04-pipeline-status.png)

Jadi di pipeline tersebut, akan menjalankan `test:unit` jika sudah success maka jalankan job `build:jar`, sekarang kita coba check detail job untuk `build:jar` seperti berikut:

![pipeline-build-jar-job-detail-status]({{ page.image_path | prepend: site.baseurl }}/05-pipeline-build-job-detail-status.png)

Jika sudah success, maka kita bisa download artifact nya yang kita build tadi. atau kita bisa juga browse filenya seperti berikut:

![pipeline-artifact-download]({{ page.image_path | prepend: site.baseurl }}/06-job-artifact-downloads.png)

## Build docker image using dependencies

Ok selanjutnya dan terkahir, kita akan build docker image menggunakan Pipeline Gitlab CI. Untuk build docker image kali ini berbeda dengan yang sebelumnya yaitu menggunaman `maven-dockerfile-plugin` sekarang kita akan membuat dengan docker client sebagai executor-nya. Ok langsung ja berikut pipelinenya

1. Kita edit file `.gitlab-ci.yml` untuk job `build:jar` dan buat job baru dengan nama `build:docker` dalam stage `build` seperti berikut:

    {% gist page.gist "12f-gitlab-ci.build-docker.yml" %}

2. Selanjutnya, kita buat tags dan push source-codenya. Kita coba check pipelinenuya seperti berikut:

![pipeline-build-status]({{ page.image_path | prepend: site.baseurl }}/07-pipeline-docker-status.png)

Jadi dengan script pipeline tersebut, workflownya `test` -> `build:jar` -> `build:docker` jika kita lihat dari sisi dependencies seperti berikut:

![pipeline-depends]({{ page.image_path | prepend: site.baseurl }}/08-pipeline-docker-job-depends-status.png)

Sekarang kita coba check job detailnya untuk `build:docker` seperti berikut:

![pipeline-depends]({{ page.image_path | prepend: site.baseurl }}/09-pipeline-docker-job-detail-status.png)

Jika kita perhatikan di job detail tersebut, disitu mendownload dari artifact dari build:jar sebelumnya dan push docker image ke insecure registry seperti berikut:

![pipeline-docker-image-push]({{ page.image_path | prepend: site.baseurl }}/10-docker-image-pushed.png)
