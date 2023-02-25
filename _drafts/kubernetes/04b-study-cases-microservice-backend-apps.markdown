---
layout: post
title: "Study cases: Microservice apps (Springboot Rest API)"
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Pods
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/home/
- https://spring.io/projects/spring-boot
youtube: 
comments: true
catalog_key: pod-container
image_path: /resources/posts/kubernetes/04b-study-cases-microservice-apps
gist: dimMaryanto93/c8e8b75d52f1266a6bd7c8f5939c91f4
downloads: []
---

Hai semuanya, di materi study cases untuk Pod and Container specification kali ini adalah lanjutan dari sebelumnya yang lebih advanced lagi yaitu Create and build microservices dengan framework Springboot Rest API dengan architecture seperti berikut:

![architecture-deploy]({{ page.image_path | prepend: site.baseurl }}/microservice-architecture.png)

Okay nah terlihat sedikit berbeda dengan application monolith sebelumnya, disini setiap service akan saling berkomunikasi dengan menggunakan protocol yang lightwith (ringan) seperti Rest API, grpc, messaging bus, database shared dan lain-lain. Pada study kasus kali ini terlihat pada diagram tersebut masih menggunakan physical / virtual-machine deployement kita akan migrasikan menggunakan orchestration container system dengan Kubernetes. Adapun tahap-tahap yang perlu kita lakukan yaitu

1. Develop aplikasi
2. How code works (Code Review)
3. The new architecture for orchestration container system
4. Containerize apps
5. Deploy to Kubernetes
    1. Running as a Pod with namespace
    2. Connecting other service from the another namespace
    3. Specify resource request and limit
    4. Specify container probes (health check)
6. Implement API Gateway using nginx reverse proxy

Ok tanpa berlama-lama yuk langsung aja kita bahas materi yang pertama:

<!--more-->

## Development aplikasi

Dalam mendevelop aplikasi, ada beberapa hal yang perlu di persiapakan yaitu Software Development Kit dan backing service seperti Database, source-code version control dan DevTools yaitu

1. Git
2. Java Development Kit (JDK) versi 17 keatas
3. MySQL Database
4. PostgreSQL Database
5. Apache Maven
6. Text editor seperti InteliJ IDEA, Visual Studio Code dan lain-lain
7. Rest API client seperti Postman, curl dan lain-lain
8. Docker

Jadi temen-temen perlu install software development kita tersebut untuk cara installnya sudah pernah saya bahas di kelas [DevOps - Docker untuk Pemula s/d Mahir](https://youtube.dimas-maryanto.com/posts/devops/docker/dockerfile/study-cases/08c-build-springboot). Jika sudah temen bisa check dengan command seperti berikut:

```bash
~ » java -version
java version "19.0.1" 2022-10-18
Java(TM) SE Runtime Environment (build 19.0.1+10-21)
Java HotSpot(TM) 64-Bit Server VM (build 19.0.1+10-21, mixed mode, sharing)

~ » mvn -v
Apache Maven 3.9.0 (9b58d2bad23a66be161c4664ef21ce219c2c8584)
Maven home: /usr/local/Cellar/maven/3.9.0/libexec
Java version: 19.0.1, vendor: Oracle Corporation, runtime: /Library/Java/JavaVirtualMachines/jdk-19.jdk/Contents/Home
Default locale: en_ID, platform encoding: UTF-8
OS name: "mac os x", version: "13.2", arch: "x86_64", family: "mac"

~ » psql --version
psql (PostgreSQL) 14.7 (Homebrew)

~ » mysql --version
mysql  Ver 8.0.32 for macos13.0 on x86_64 (Homebrew)

~ » curl --version
curl 7.86.0 (x86_64-apple-darwin22.0) libcurl/7.86.0 (SecureTransport) LibreSSL/3.3.6 zlib/1.2.11 nghttp2/1.47.0
Release-Date: 2022-10-26
```

Setelah temen-temen menginstall semua Software Development Kit, kemudian yang kita butuhkan adalah source-code. Untuk source-code temen-temen bisa clone dari [github repo berikut](https://github.com/DevOpsWithDimas/kubernetes-springboot-microservice-apps) perintahnya seperti berikut:

{% highlight bash %}
git clone git@github.com:DevOpsWithDimas/kubernetes-springboot-microservice-apps.git
{% endhighlight %}

Setelah di clone kita coba jalankan projectnya, tetapi pertama kita perlu configure dulu databasenya. supaya gak ribet kita akan menggunakan `docker-compose.yaml` seperti berikut:

{% gist page.gist "04b-docker-compose.depedency.yaml" %}

Kemudian coba jalankan dengan perintah berikut:

{% highlight bash %}
docker compose up -d && \
docker compose ps
{% endhighlight %}

Maka hasilnya seperti berikut:

```bash
devops/k8s-springboot-microservice [main●] » docker compose ps
NAME                                     IMAGE               COMMAND                  SERVICE             CREATED             STATUS              PORTS
k8s-springboot-microservice-mysql-1      mysql:8.0           "docker-entrypoint.s…"   mysql               47 seconds ago      Up 41 seconds       0.0.0.0:3306->3306/tcp, 33060/tcp
k8s-springboot-microservice-postgres-1   postgres:15         "docker-entrypoint.s…"   postgres            47 seconds ago      Up 42 seconds       0.0.0.0:5432->5432/tcp
```

Setelah semua database running, sekarang kita jalankan masing-masing service dengan menggunakan perintah `mvn clean -pl <module-name> spring-boot:run` seperti berikut

{% highlight bash %}
mvn clean -pl customer spring-boot:run
{% endhighlight %}

maka outputnya seperti berikut:

```bash
devops/k8s-springboot-microservice [main●] » mvn clean -pl customer spring-boot:run
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v3.0.2)

2023-02-12T12:05:11.295+07:00  INFO 9448 --- [  restartedMain] c.m.d.udemy.customer.MainApplication     : Starting MainApplication using Java 19.0.1 with PID 9448 (/Users/dimasm93/Developer/dimas-maryanto.com/youtube/_projects/devops/k8s-springboot-microservice/customer/target/classes started by dimasm93 in /Users/dimasm93/Developer/dimas-maryanto.com/youtube/_projects/devops/k8s-springboot-microservice/customer)
2023-02-12T12:05:11.298+07:00  INFO 9448 --- [  restartedMain] c.m.d.udemy.customer.MainApplication     : No active profile set, falling back to 1 default profile: "default"
2023-02-12T12:05:11.392+07:00  INFO 9448 --- [  restartedMain] .e.DevToolsPropertyDefaultsPostProcessor : Devtools property defaults active! Set 'spring.devtools.add-properties' to 'false' to disable

2023-02-12T12:05:13.303+07:00  INFO 9448 --- [  restartedMain] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 9090 (http)
2023-02-12T12:05:13.319+07:00  INFO 9448 --- [  restartedMain] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2023-02-12T12:05:13.319+07:00  INFO 9448 --- [  restartedMain] o.apache.catalina.core.StandardEngine    : Starting Servlet engine: [Apache Tomcat/10.1.5]
2023-02-12T12:05:13.400+07:00  INFO 9448 --- [  restartedMain] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
2023-02-12T12:05:13.402+07:00  INFO 9448 --- [  restartedMain] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 2007 ms
2023-02-12T12:05:13.612+07:00  INFO 9448 --- [  restartedMain] o.f.c.internal.license.VersionPrinter    : Flyway Community Edition 9.5.1 by Redgate
2023-02-12T12:05:14.208+07:00  INFO 9448 --- [  restartedMain] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Start completed.
2023-02-12T12:05:14.248+07:00  INFO 9448 --- [  restartedMain] o.f.c.i.database.base.BaseDatabaseType   : Database: jdbc:mysql://localhost:3306/customer4p1 (MySQL 8.0)
2023-02-12T12:05:14.373+07:00  INFO 9448 --- [  restartedMain] o.f.core.internal.command.DbValidate     : Successfully validated 1 migration (execution time 00:00.030s)
2023-02-12T12:05:14.435+07:00  INFO 9448 --- [  restartedMain] o.f.c.i.s.JdbcTableSchemaHistory         : Creating Schema History table `customer4p1`.`flyway_schema_history` ...
2023-02-12T12:05:14.575+07:00  INFO 9448 --- [  restartedMain] o.f.core.internal.command.DbMigrate      : Current version of schema `customer4p1`: << Empty Schema >>
2023-02-12T12:05:14.590+07:00  INFO 9448 --- [  restartedMain] o.f.core.internal.command.DbMigrate      : Migrating schema `customer4p1` to version "20230211170102 - schema-customer"
2023-02-12T12:05:14.694+07:00  INFO 9448 --- [  restartedMain] o.f.core.internal.command.DbMigrate      : Successfully applied 1 migration to schema `customer4p1`, now at version v20230211170102 (execution time 00:00.131s)
2023-02-12T12:05:14.806+07:00  INFO 9448 --- [  restartedMain] o.hibernate.jpa.internal.util.LogHelper  : HHH000204: Processing PersistenceUnitInfo [name: default]
2023-02-12T12:05:16.662+07:00  INFO 9448 --- [  restartedMain] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 9090 (http) with context path ''
2023-02-12T12:05:16.666+07:00  INFO 9448 --- [  restartedMain] o.s.b.d.a.OptionalLiveReloadServer       : LiveReload server is running on port 35729
2023-02-12T12:05:16.686+07:00  WARN 9448 --- [  restartedMain] JpaBaseConfiguration$JpaWebConfiguration : spring.jpa.open-in-view is enabled by default. Therefore, database queries may be performed during view rendering. Explicitly configure spring.jpa.open-in-view to disable this warning
2023-02-12T12:05:16.706+07:00  INFO 9448 --- [  restartedMain] c.m.d.udemy.customer.MainApplication     : Started MainApplication in 6.034 seconds (process running for 6.653)
```

Sekarang kita coba check service custemer bisa meresponse api yang kita request dengan menggunakan perintah curl seperti berikut:

{% highlight bash %}
curl --location --request GET 'localhost:9090/api/customer/v1/findById/cust01'
{% endhighlight %}

Maka jika dijalankan outputnya seperti berikut:

```bash
Last login: Sun Feb 12 11:33:28 on ttys002
~ » curl --location --request GET 'localhost:9090/api/customer/v1/findById/cust01' -v
Note: Unnecessary use of -X or --request, GET is already inferred.
*   Trying 127.0.0.1:9090...
* Connected to localhost (127.0.0.1) port 9090 (#0)
> GET /api/customer/v1/findById/cust01 HTTP/1.1
< HTTP/1.1 200
< Content-Type: application/json
< Transfer-Encoding: chunked
< Date: Sun, 12 Feb 2023 05:12:26 GMT

{"id":"cust01","userId":"dimasm93","fullname":"Dimas Maryanto","alamat":"Bandung, Jawa Barat"}%
```

Itu artinya sudah ok, selanjutnya kita coba jalankan service order dengan perintah seperti berikut:

{% highlight bash %}
mvn clean -pl orders spring-boot:run
{% endhighlight %}

Maka outputnya seperti berikut:

```bash
devops/k8s-springboot-microservice [main●] » mvn clean -pl orders spring-boot:run
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::                (v3.0.2)

2023-02-12T12:16:07.346+07:00  INFO 11255 --- [  restartedMain] c.m.dimas.udemy.orders.MainApplication   : Starting MainApplication using Java 19.0.1 with PID 11255 (/Users/dimasm93/Developer/dimas-maryanto.com/youtube/_projects/devops/k8s-springboot-microservice/orders/target/classes started by dimasm93 in /Users/dimasm93/Developer/dimas-maryanto.com/youtube/_projects/devops/k8s-springboot-microservice/orders)
2023-02-12T12:16:07.350+07:00  INFO 11255 --- [  restartedMain] c.m.dimas.udemy.orders.MainApplication   : No active profile set, falling back to 1 default profile: "default"
2023-02-12T12:16:09.296+07:00  INFO 11255 --- [  restartedMain] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 9091 (http)
2023-02-12T12:16:09.322+07:00  INFO 11255 --- [  restartedMain] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
2023-02-12T12:16:09.608+07:00  INFO 11255 --- [  restartedMain] o.f.c.internal.license.VersionPrinter    : Flyway Community Edition 9.5.1 by Redgate
2023-02-12T12:16:10.187+07:00  INFO 11255 --- [  restartedMain] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Start completed.
2023-02-12T12:16:10.217+07:00  INFO 11255 --- [  restartedMain] o.f.c.i.database.base.BaseDatabaseType   : Database: jdbc:postgresql://localhost:5432/order4p1 (PostgreSQL 15.2)
2023-02-12T12:16:10.364+07:00  INFO 11255 --- [  restartedMain] o.f.core.internal.command.DbValidate     : Successfully validated 1 migration (execution time 00:00.047s)
2023-02-12T12:16:10.460+07:00  INFO 11255 --- [  restartedMain] o.f.c.i.s.JdbcTableSchemaHistory         : Creating Schema History table "public"."flyway_schema_history" ...
2023-02-12T12:16:10.605+07:00  INFO 11255 --- [  restartedMain] o.f.core.internal.command.DbMigrate      : Current version of schema "public": << Empty Schema >>
2023-02-12T12:16:10.627+07:00  INFO 11255 --- [  restartedMain] o.f.core.internal.command.DbMigrate      : Migrating schema "public" to version "20230211171555 - create-order"
2023-02-12T12:16:10.696+07:00  INFO 11255 --- [  restartedMain] o.f.core.internal.command.DbMigrate      : Successfully applied 1 migration to schema "public", now at version v20230211171555 (execution time 00:00.107s)
2023-02-12T12:16:12.807+07:00  INFO 11255 --- [  restartedMain] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 9091 (http) with context path ''
2023-02-12T12:16:12.813+07:00  WARN 11255 --- [  restartedMain] o.s.b.d.a.OptionalLiveReloadServer       : Unable to start LiveReload server
2023-02-12T12:16:12.866+07:00  INFO 11255 --- [  restartedMain] c.m.dimas.udemy.orders.MainApplication   : Started MainApplication in 6.225 seconds (process running for 6.76)
```

Sekarang kita coba check service order dengan menggunakan perintah curl berikut:

{% highlight bash %}
curl --location --request POST 'localhost:9091/api/order/v1/checkout' \
--header 'Content-Type: application/json' \
--data-raw '{
    "userId": "cust01",
    "item": "Macbook Pro 13\" (A1723)",
    "qty": "2"
}' -v

Note: Unnecessary use of -X or --request, POST is already inferred.
*   Trying 127.0.0.1:9091...
* Connected to localhost (127.0.0.1) port 9091 (#0)
> POST /api/order/v1/checkout HTTP/1.1
> Content-Type: application/json
> Content-Length: 82
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200
< Content-Type: application/json
< Date: Sun, 12 Feb 2023 05:19:32 GMT

{"id":"1a02d9bd-8413-43f8-b6ac-bf3b7f8f3438","createdDate":"2023-02-12T12:19:31.905439","customer":{"id":"cust01","userId":"dimasm93","fullname":"Dimas Maryanto","alamat":"Bandung, Jawa Barat"},"item":"Macbook Pro 13\" (A1723)","qty":2}%
{% endhighlight %}

Ok ini artinya sudah okay semua.

## How code works (Code Review)

Setelah kita mencoba menjalankan program tersebut tahap selanjutnya adalah memahami bagaimana aplikasi bisa running dengan cara code review. Hal ini juga menjadi yang terpenting ketika proses deliver dari Programmer/Developer ke DevOps Engineer untuk di deploy ke environment.

Sebagai seorang DevOps kita harus mengetahui dan mengerti setiap service dari microservice yang telah di deliver oleh programmer untuk di implementasikan, Dengan cara melakukan assesment, diskusi, atau technical meeting dengan team Developer/Programmer. Salah satu prosedure yang biasanya saya lakukan adalah 

1. Developer/Programmer menjelaskan overview architecture service
2. Developer/Programmer menjelaskan service communication
3. Developer/Programmer menjelaskan how to configure communication between service
4. DevOps menyimpulkan & Memberikan saran terkait perancangan architecture baru
5. DevOps mengimplementasikan perancangan architecture tersebut ke environment
6. Developer/Programmer dan DevOps melakukan Testing functional secara berdampingan
7. DevOps melakukan Performance/Stress testing

Okay kita tidak akan membahas semuanya ya, karena keterbatasan waktu. Jadi kita bahas beberapa yang dirasa penting seperti point no `1`, `2`, `3`, dan `4`. Pada point no 1, kita sudah bahas dibahas section awal jadi kita skip. Selanjutnya kita bahas point no 2 yaitu Service Communication.

Service communication ini pada dasarnya menjelaskan setiap service memiliki dependency ke mana saja dan seperti apa komunikasinya. Pada dasarnya service communication ada beberapa cara yaitu menggunakan Shared Database, Rest API, RPC (khususnya grpc), dan Messaging bus. Untuk service `customer` dan `orders` ini basicly kita menggunakan Rest API, Okay untuk lebih jelas kita lihat diagram berikut:

1. Customer API - find by id
  ![customer-findbyid]({{ page.image_path | prepend: site.baseurl }}/01-flow-customer-findbyid.png)

2. Orders API - create new order
  ![create-new-order]({{ page.image_path | prepend: site.baseurl }}/02-flow-create-new-orders.png)

Jadi klo kita perhatikan diagram no 1, flownya sangat simple hanya menggunakan database tetapi untuk no 2 selain database perlu call service customerAPI melalui Rest API. Yang jadi pertanyaan selanjutnya bagaimana konfigurasi koneksinya? Okay sekarang kita coba bedah kodingnya / code review.

Kalo kita lihat di project `orders` seperti berikut:

{% highlight java %}
// orders/src/main/java/com/maryanto/dimas/udemy/orders/controller/OrderController.java
package com.maryanto.dimas.udemy.orders.controller;

@Slf4j
@RestController
@RequestMapping("/api/order/v1")
public class OrderController {

  @PostMapping("/checkout")
    public ResponseEntity<?> placeOrder(@RequestBody RequestOrderDTO order) {
        ResponseEntity<CustomerDTO> responseCustomer = this.serviceCustomer.findById(order.getUserId());
        if (responseCustomer.getStatusCode() != HttpStatus.OK) {
            return ResponseEntity.badRequest().body("Customer not found!");
        }

        CustomerDTO customer = responseCustomer.getBody();
        Order purchaseOrder = new Order();
        // set value here!
        try {
          purchaseOrder = this.repo.save(purchaseOrder);
          OrderDTO output = new OrderDTO();
          // set value here!
          return ResponseEntity.ok(output);
        } catch (Exception ex) {
            log.error("Can't proses checkout", ex);
            return ResponseEntity.internalServerError()
              .body("Transaction can't be processed!!! \nPlease report to adminstrator");
        }
    }
}

// orders/src/main/java/com/maryanto/dimas/udemy/orders/service/CustomerService.java
package com.maryanto.dimas.udemy.orders.service;

@Service
public class CustomerService {
  @Autowired
  public CustomerService(
          RestTemplate rest,
          @Value("${services.customer.host}") String host,
          @Value("${services.customer.port}") String port,
          @Value("${services.customer.proto}") String proto,
          @Value("${services.customer.context-path}") String contextPath) {
      this.customerHost = host;
      this.customerPort = port;
      this.customerProto = proto;
      this.customerContextPath = contextPath;
      this.rest = rest;
  }

  public ResponseEntity<CustomerDTO> findById(String id) {
      String baseUrl = String.format(
              "%s://%s:%s%s/api/customer/v1/findById/",
              this.customerProto, this.customerHost, this.customerPort, this.customerContextPath);
      return this.rest.getForEntity(baseUrl + "{userId}", CustomerDTO.class, id);
  }
}
{% endhighlight %}

Dan selain itu juga, berikut adalah file `application.yaml` untuk menyimpan semua environment variable yang dipanggil pada source code tersebut:

{% highlight yaml %}
# orders/src/main/resources/application.yaml
services:
  customer:
    host: ${SERVICE_CUSTOMER_HOST:localhost}
    port: ${SERVICE_CUSTOMER_PORT:9090}
    context-path: ${SERVICE_CUSTOMER_CONTEXT_PATH:}
    proto: ${SERVICE_CUSTOMER_PROTO:http}
{% endhighlight %}

Okay sekarang perhatikan penggalan code diatas, jadi cara kita mengconfigurasi koneksi ke service `customerAPI` yaitu menggunakan envionment variable yang tertera pada `application.yaml` seperti `SERVICE_CUSTOMER_HOST`, `SERVICE_CUSTOMER_PORT`, `SERVICE_CUSTOMER_CONTEXT_PATH`, `SERVICE_CUSTOMER_PROTO` So kita bisa pasang/override nilainya pada saat dijalankan diatas container.

Nah setelah kita breakdown cara kerja atau code review, semoga temen-temen bisa memahami dan mulai merumuskan architecture yang bisa menunjang workload tersebut.

## The new architecture

Setelah kita melihat, diskusi, technical meeting, serta code review tahap selanjutnya adalah merumuskan architecture yang sesuai dengan workload dari service tersebut. 

Karena aplikasi yang dibuat merupakan microservice architecture yang memiliki backing service (dependency) seperti database, atau bahkan service lainnya Maka kita perlu buat scope dan boundaries dari services tersebut. Adapun scope dan boundaries tersebut dibagi menjadi Primary dan Secondary backing service

> **Primary backing service** yaitu Aplikasi yang tidak akan bisa startup ketika di running dalam suatu environment jika tanpa/menggunakan service tersebut (Mandatory), sedangkan **Secondary backing service** yaitu Aplikasi masih bisa berjalan tetapi secara functional belum lengkap.

Karena tujuan kita adalah deploy ke orchestration container system menggunakan kubernetes jadi, langsung aja disini saya gambarkan menggunakan pendekatan kubernetes object resource seperti berikut:

![architecture-k8s-objects]({{ page.image_path | prepend: site.baseurl }}/03-architecture-k8s-object.png)

Berdasarkan diagram tersebut kita akan bagi menjadi 3 namespace yaitu `default`, `orders` dan `customer`. Dalam masing-masing namespace memiliki service yang kita pisahkan berdasarkan scopenya yaitu

1. Namespace `default`, terdiri dari pod dengan workload: `nginx` berfungsi untuk routing (API Gateway) ke service-service seperti `order` dan `customer`
2. Namespace `customer`, terdiri dari pod dengan workload: `customerAPI` dan `MySQL` sebagai primary backing service
3. Namespace `order`, terdiri dari pod dengan workload: `orderAPI` dan `PostgreSQL` sebagai primary backing service.

## Containerize apps

Setelah kita men-design architecturenya untuk deploy ke orchestration container system seperti kubernetes. Tahap awal meng-implementasikan semua konsep tersebut adalah melakukan kontainerisasi (container image). Di tahap ini adalah paling dasar sebelum kita deploy diatas kubernetes, jika service/aplikasi tidak bisa dibuild ke container image maka sudah dipastikan tidak akan bisa lanjut ke tahap selanjutnya.

Okay langsung aja kita mulai buat containernya. Tetapi sebelum itu kita lihat lagi bagaimana cara deploy manual seperti section sebelumnya. Apa yang kita perlukan untuk menjalankan service tersebut???

1. Java Development Kit (jdk-17 or later)
2. Binary execute (jar)

Untuk vendor JDK yang kita gunakan di local environment menggunakan Oracle JDK 19, nah ini sebisa mungkin untuk versi dari SDK harus sama persis dengan yang terdapat di container. Karena Oracle JDK tidak tersedia secara public di docker hub, kita akan menggunakan vendor yang open-source yaitu OpenJDK dengan version yang sama yaitu [openjdk-19](https://hub.docker.com/_/openjdk/tags?page=1&name=19-oracle)

Sedangkan untuk binary execute atau file bundle yang telah dicomple kita bisa peroleh dengan menjalankan perintah:

{% highlight bash %}
mvn clean -DskipTests package
{% endhighlight %}

Jika dijalankan hasilnya seperti berikut:

```bash
devops/k8s-springboot-microservice [main] » mvn clean -DskipTests package
[INFO] Reactor Summary for springboot-microservice 0.0.1-SNAPSHOT:
[INFO] 
[INFO] springboot-microservice ............................ SUCCESS [  1.777 s]

[INFO] --- jar:3.3.0:jar (default-jar) @ customer-api ---
[INFO] Building jar: /Users/dimasm93/Developer/dimas-maryanto.com/youtube/_projects/devops/k8s-springboot-microservice/customer/target/customer-api.jar
[INFO] customer-api ....................................... SUCCESS [  6.182 s]

[INFO] --- jar:3.3.0:jar (default-jar) @ orders-api ---
[INFO] Building jar: /Users/dimasm93/Developer/dimas-maryanto.com/youtube/_projects/devops/k8s-springboot-microservice/orders/target/orders-api.jar
[INFO] orders-api ......................................... SUCCESS [  2.735 s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
```

Okay setelah semua kebutuhan terpenuhi, tahap selanjutnya kita buat `Dockerfile` seperti berikut:

1. Dockerfile untuk customerAPI, simpan dalam folder `customer/Dockerfile` seperti berikut:
  {% gist page.gist "04b-dockerfile-customer-api" %}

2. Dockerfile untuk orderAPI, simpan dalam folder `order/Dockerfile` seperti berikut:
  {% gist page.gist "04b-dockerfile-order-api" %}

3. Dan yang terakhir, tambahkan service `customerAPI` dan `orderAPI` dalam `docker-compose.yaml` seperti berikut:
  {% gist page.gist "04b-docker-compose-build.yaml" %}

Sekerang coba jalankan perintah berikut: 

{% highlight bash %}
docker compose build
{% endhighlight %}

Jika dijalankan hasilnya seperti berikut:

```bash
devops/k8s-springboot-microservice [main] » docker compose build customerAPI orderAPI
[+] Building 5.1s (7/7) FINISHED
=> [internal] load metadata for docker.io/library/openjdk:19-oraclelinux8                                                                  4.7s
 => [1/2] FROM docker.io/library/openjdk:19-oraclelinux8@sha256:a5f2327c217367af3729670628c7ad66799cd890bde4e14fad02c2ae59552424           0.0s
 => [internal] load build context                                                                                                          0.0s
 => => transferring context: 145B                                                                                                          0.0s
 => CACHED [2/2] ADD target/orders-api.jar spring-boot.jar                                                                                 0.0s
 => exporting to image                                                                                                                     0.1s
 => => naming to repository.dimas-maryanto.com:8087/dimmaryanto93/example/order-api:latest

=> [internal] load metadata for docker.io/library/openjdk:19-oraclelinux8                                                                  4.7s
 => [1/2] FROM docker.io/library/openjdk:19-oraclelinux8@sha256:a5f2327c217367af3729670628c7ad66799cd890bde4e14fad02c2ae59552424           0.0s
 => [internal] load build context                                                                                                          0.0s
 => => transferring context: 145B  
=> CACHED [2/2] ADD target/customer-api.jar spring-boot.jar                                                                                0.0s
 => exporting to image                                                                                                                     1.8s
 => => naming to repository.dimas-maryanto.com:8087/dimmaryanto93/example/customer-api:latest

devops/k8s-springboot-microservice [main] » docker images
REPOSITORY                                                              TAG           IMAGE ID       CREATED          SIZE
repository.dimas-maryanto.com:8087/dimmaryanto93/example/order-api      latest        f27ba96797db   17 minutes ago   522MB
repository.dimas-maryanto.com:8087/dimmaryanto93/example/customer-api   latest        9d589fe904f0   26 minutes ago   523MB
```

Setelah container image di build, sekarang coba jalankan dengan perintah berikut:

{% highlight bash %}
docker compose up -d
{% endhighlight %}

Maka seperti berikut outputnya:

```bash
devops/k8s-springboot-microservice [main] » docker compose up -d
[+] Running 7/7
 ⠿ Network k8s-springboot-microservice_default          Created        0.2s
 ⠿ Volume "k8s-springboot-microservice_pg_data"         Created        0.0s
 ⠿ Volume "k8s-springboot-microservice_mysql_data"      Created        0.0s
 ⠿ Container k8s-springboot-microservice-mysql-1        Started        3.2s
 ⠿ Container k8s-springboot-microservice-postgres-1     Started        3.0s
 ⠿ Container k8s-springboot-microservice-customerAPI-1  Started        4.9s
 ⠿ Container k8s-springboot-microservice-orderAPI-1     Started        4.9s

devops/k8s-springboot-microservice [main] » docker compose ps
NAME                                     IMAGE                                                                       COMMAND                  SERVICE             CREATED              STATUS              PORTS
k8s-springboot-microservice-mysql-1      repository.dimas-maryanto.com:8086/mysql:8.0                                "docker-entrypoint.s…"   mysql               About a minute ago   Up 58 seconds       0.0.0.0:3306->3306/tcp, 33060/tcp
k8s-springboot-microservice-orderAPI-1   repository.dimas-maryanto.com:8087/dimmaryanto93/example/order-api:latest   "java -Djava.securit…"   orderAPI            About a minute ago   Up 56 seconds       0.0.0.0:9091->9091/tcp
k8s-springboot-microservice-postgres-1   repository.dimas-maryanto.com:8086/postgres:15                              "docker-entrypoint.s…"   postgres            About a minute ago   Up 58 seconds       0.0.0.0:5432->5432/tcp
```

Jika semua service sudah running dengan baik, sekarang coba temen-temen test lagi service tersebut apakah berjalan dengan baik di atas single container? jika sudah ok. Yeeey selamat temen-temen udah melewati level 1.

Berikutnya adalah temen-temen bisa push ke container registry. boleh ke DockerHub atau private registry dengan menggunakan perintah berikut:

{% highlight bash %}
docker compose push customerAPI && \
docker compose push orderAPI 
{% endhighlight %}

## Deploy to kubernetes cluster

Setelah container image di-build dan publish ke container registry, tahap selanjutnya adalah deploy ke kubernetes cluster. Tetapi sebelum itu siapkan dulu kubernetes cluster untuk workload tersebut. Settingan cluster untuk microservice ini agak berbeda dengan sebelumnya yaitu seperti berikut:

```yaml
nodes: 
  controlplane: 
    cpus: '2 cores'
    memory: '2 GB'
  worker-1:
    cpus: '2 cores'
    memory: '4 GB'
  worker-2:
    cpus: '2 cores'
    memory: '4 GB'
```

Jadi kita akan buat menggunakan perintah berikut:

{% highlight bash %}
minikube start -p springboot-microservice \
--cpus 2 \
--memory 4G \
--insecure-registry 192.168.88.50:8086 \
--nodes 3

minikube profile springboot-microservice

minikube addons enable registry-creds && \
minikube addons configure registry-creds
{% endhighlight %}

Jika dijalankan hasilnya seperti berikut:

```bash
~ » minikube start -p springboot-microservice \
--cpus 2 \
--memory 4G \
--insecure-registry 192.168.88.50:8086 \
--nodes 3
😄  [springboot-microservice] minikube v1.29.0 on Darwin 13.2.1
✨  Using the hyperkit driver based on user configuration
👍  Starting control plane node springboot-microservice in cluster springboot-microservice
🔥  Creating hyperkit VM (CPUs=2, Memory=4096MB, Disk=20000MB) ...
📦  Preparing Kubernetes v1.26.1 on containerd 1.6.15 ...
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🔗  Configuring CNI (Container Networking Interface) ...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🔎  Verifying Kubernetes components...
🌟  Enabled addons: default-storageclass, storage-provisioner

👍  Starting worker node springboot-microservice-m02 in cluster springboot-microservice
🔥  Creating hyperkit VM (CPUs=2, Memory=4096MB, Disk=20000MB) ...

👍  Starting worker node springboot-microservice-m03 in cluster springboot-microservice
🔥  Creating hyperkit VM (CPUs=2, Memory=4096MB, Disk=20000MB) ...

🔎  Verifying Kubernetes components...
🏄  Done! kubectl is now configured to use "springboot-microservice" cluster and "default" namespace by default

~ » minikube profile springboot-microservice
✅  minikube profile was successfully set to springboot-microservice

~ » minikube addons enable registry-creds
❗  registry-creds is a 3rd party addon and is not maintained or verified by minikube maintainers, enable at your own risk.
❗  registry-creds does not currently have an associated maintainer.
    ▪ Using image docker.io/upmcenterprises/registry-creds:1.10
🌟  The 'registry-creds' addon is enabled

~ » minikube addons configure registry-creds
Do you want to enable AWS Elastic Container Registry? [y/n]: n

Do you want to enable Google Container Registry? [y/n]: n

Do you want to enable Docker Registry? [y/n]: y
-- Enter docker registry server url: 192.168.88.50:8086
-- Enter docker registry username: admin
-- Enter docker registry password:

Do you want to enable Azure Container Registry? [y/n]: n
✅  registry-creds was successfully configured

~ » kubectl get node
NAME                          STATUS   ROLES           AGE     VERSION
springboot-microservice       Ready    control-plane   4m52s   v1.26.1
springboot-microservice-m02   Ready    <none>          3m4s    v1.26.1
springboot-microservice-m03   Ready    <none>          86s     v1.26.1
```

Setelah cluster kubernetes ready, kita coba membuat simple 2 pod yang simple menggunakan `nginx` dan `httpd` setelah itu kita coba test cni antara ke dua pod tersebut dengan perintah seperti berikut:

{% highlight bash %}
kubectl run web1 --image 192.168.88.50:8086/nginx:mainline --port 80 && \
kubectl expose pod/web1 --port 80 --type ClusterIP

kubectl run web2 --image 192.168.88.50:8086/httpd:latest --port 80 && \
kubectl expose pod/web2 --port 80 --type ClusterIP

kubectl exec web1 -- curl http://web2
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```bash
~ » kubectl run web1 --image 192.168.88.50:8086/nginx:mainline --port 80 && \
kubectl expose pod/web1 --port 80 --type ClusterIP
pod/web1 created
service/web1 exposed

~ » kubectl get pod
NAME   READY   STATUS              RESTARTS   AGE
web1   1/1     Running             0          56s

~ » kubectl run web2 --image 192.168.88.50:8086/httpd:latest --port 80 && \
kubectl expose pod/web2 --port 80 --type ClusterIP
pod/web2 created
service/web2 exposed

~ » kubectl get pod
NAME   READY   STATUS              RESTARTS   AGE
web1   1/1     Running             0          71s
web2   1/1     Running             0          30s

~ » kubectl exec web1 -- curl http://web2
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    45  100    45    0     0    918      0 --:--:-- --:--:<html><body><h1>It works!</h1></body></html>
-- --:--:--   918
```

Jika temen-temen perhatikan pada saat membuat cluster, mengapa cluster ini menggunakan memory yang lebih besar yaitu `4G` di setiap nodenya, Jadi menentukan resource tidak hanya di sisi Pod dan Containernya saja tetapi juga pada cluster nodenya juga kita harus sesuaikan.