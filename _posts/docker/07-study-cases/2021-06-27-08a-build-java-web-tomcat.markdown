---
layout: post
title: "Study Kasus: Build Docker Image for Java Webapp"
date: 2021-06-27T18:39:39+07:00
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/
youtube: ZFPexpD1lcg
comments: true
image_path: /resources/posts/docker/08a-build-javaweb
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, di studi kasus yang pertama kita akan membahas tentang build docker image untuk project Java Webapp dengan menggunakan build-tools Apache Maven. Diantaranya kita akan membahas

1. Create project dengan Apache Maven
2. Deployment using Tomcat Web Server
3. Build Docker Images
4. Running Web Application
5. Cleanup

Ok langsung aja, kita bahas ke materi yang pertama

## Create project dengan Apache Maven

Untuk membuat project Java Web, sebetulnya temen-temen bebas tpi kalo jaman sekarang paling gampang ya pake Apache Maven. Berikut adalah perintah untuk membuat projectnya dan mengatur dependencynya:

For Bash script:

{% gist page.gist "08a-create-project-maven.bash" %}

For Powershell script:

{% gist page.gist "08a-create-project-maven.ps1" %}

Jika di jalankan maka outputnya seperti berikut:

```powershell
➜ 08-studi-kasus ✗  mvn archetype:generate `
>> -DgroupId='com.maryanto.dimas.udemy' `
>> -DartifactId='docker-javaweb' `
>> -Dversion='1.0.0-release' `
>> -DarchetypeCatalog='internal' `
>> -DarchetypeGroupId='org.apache.maven.archetypes' `
>> -DarchetypeArtifactId='maven-archetype-webapp'
[WARNING]
[INFO] Scanning for projects...
[INFO]
[INFO] ------------------< org.apache.maven:standalone-pom >-------------------
[INFO] Building Maven Stub Project (No POM) 1
[INFO] --------------------------------[ pom ]---------------------------------
[INFO] --- maven-archetype-plugin:3.2.0:generate (default-cli) @ standalone-pom ---
[INFO] Generating project in Interactive mode
[INFO] Archetype [org.apache.maven.archetypes:maven-archetype-webapp:1.0] found in catalog internal
[INFO] Using property: groupId = com.maryanto.dimas.udemy
[INFO] Using property: artifactId = docker-javaweb
[INFO] Using property: version = 1.0.0-release
[INFO] Using property: package = com.maryanto.dimas.udemy
Confirm properties configuration:
groupId: com.maryanto.dimas.udemy
artifactId: docker-javaweb
version: 1.0.0-release
package: com.maryanto.dimas.udemy
 Y: :
[INFO] ----------------------------------------------------------------------------
[INFO] Using following parameters for creating project from Old (1.x) Archetype: maven-archetype-webapp:1.0
[INFO] ----------------------------------------------------------------------------
[INFO] Parameter: basedir, Value: C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus
[INFO] Parameter: package, Value: com.maryanto.dimas.udemy
[INFO] Parameter: groupId, Value: com.maryanto.dimas.udemy
[INFO] Parameter: artifactId, Value: docker-javaweb
[INFO] Parameter: packageName, Value: com.maryanto.dimas.udemy
[INFO] Parameter: version, Value: 1.0.0-release
[INFO] project created from Old (1.x) Archetype in dir: C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-javaweb
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  5.768 s
[INFO] Finished at: 2021-06-27T16:35:15+07:00
[INFO] ------------------------------------------------------------------------
```

Kemudian coba edit file `pom.xml` dalam project tersebut tambahkan dependencies dan plugin seperti berikut:

{% gist page.gist "08a-pom.xml" %}

Kemudian, silahkan tambahkan feature webnya seperti form tambah, edit, list dan sebagainya. Sebagai contoh disini kita akan membuat servlet berikut classnya:

{% gist page.gist "08a-IndexController.java" %}

kita gak akan terlalu detail di bagian ini klo temen-temen mau belajar tentang Java Web boleh baca roadmap [Java Web Developer]({{ '/pages/roadmap.html#java-web-developer' | prepend: site.baseurl }})

## Deployment using Tomcat Web Server

Untuk deployment Java web, juga sebetulnya udah saya bahas di [article berikut]({% post_url java-web/2020-12-15-032-deploy-java-webapp %})

Jadi yang kita butuhkan sebetulnya yaitu 

1. Web Server Tomcat
2. file `.war` (hasil build dari java web sources)

Untuk melakukan build kita bisa mengunakan perintah berikut:

{% gist page.gist "08a-maven-build.bash" %}

Jika kita jalankan maka hasilnya seperti berikut:

```powershell
➜ docker-javaweb  mvn clean -DskipTests package
[WARNING]
[WARNING] Some problems were encountered while building the effective settings
[WARNING] Unrecognised tag: 'releases' (position: START_TAG seen ...</url>\n         <releases>... @9:20)  @ C:\Users\dimasm93\.m2\settings.xml, line 9, column 20
[WARNING]
[INFO] Scanning for projects...
[INFO]
[INFO] --------------< com.maryanto.dimas.udemy:docker-javaweb >---------------
[INFO] Building docker-javaweb Maven Webapp 1.0.0-release
[INFO] --------------------------------[ war ]---------------------------------
[INFO]
[INFO] --- maven-clean-plugin:2.5:clean (default-clean) @ docker-javaweb ---
[INFO] Deleting C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-javaweb\target
[INFO]
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ docker-javaweb ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] Copying 0 resource
[INFO]
[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ docker-javaweb ---
[INFO] No sources to compile
[INFO]
[INFO] --- maven-resources-plugin:2.6:testResources (default-testResources) @ docker-javaweb ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-javaweb\src\test\resources
[INFO]
[INFO] --- maven-compiler-plugin:3.1:testCompile (default-testCompile) @ docker-javaweb ---
[INFO] No sources to compile
[INFO]
[INFO] --- maven-surefire-plugin:2.12.4:test (default-test) @ docker-javaweb ---
[INFO] Tests are skipped.
[INFO]
[INFO] --- maven-war-plugin:3.2.3:war (default-war) @ docker-javaweb ---
[INFO] Packaging webapp
[INFO] Assembling webapp [docker-javaweb] in [C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-javaweb\target\docker-javaweb]
[INFO] Processing war project
[INFO] Copying webapp resources [C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-javaweb\src\main\webapp]
[INFO] Webapp assembled in [43 msecs]
[INFO] Building war: C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-javaweb\target\docker-javaweb.war
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  0.938 s
[INFO] Finished at: 2021-06-27T16:53:59+07:00
[INFO] ------------------------------------------------------------------------
```

Nah sekarang file `.war` nya sudah terbentuk dalam folder `target`. Selanjutnya kita deploy ke Tomcat Web Server dengan mencopy file `docker-javaweb.war` ke folder `webapp` dalam Tomcat Installation.

## Build docker images

Setelah kita coba manual deployment dan memahami flow dari deploymentnya. Sekarang kita akan build docker image untuk project tersebut. Tahap pertama kita tentukan dulu base image yang kita akan gunakan, untuk base image temen-temen bisa build image sendiri atau mau menggunakan image yang sudah tersedia di [hub.docker.com](https://hub.docker.com) seperti 

1. [Apache Tomcat](https://hub.docker.com/_/tomcat), 
2. [Apache TomEE](https://hub.docker.com/_/tomee), 
3. [Oracle WebLogic](https://hub.docker.com/_/oracle-weblogic-server-12c), 
4. [payara](https://hub.docker.com/u/payara) 
5. dan lain-lain.

Misalnya kita akan menggunakan Apache Tomcat v8.5 jdk8 image yang akan kita gunakan jadi `tomcat:8.5-jdk8-openjdk-slim` Maka berikut adalah file `Dockerfile`:

{% gist page.gist "08a-dockerfile" %}

Dan juga berikut adalah `.dockerignore` 

{% gist page.gist "08a-dockerignore" %}

Sekarang kita coba build docker imagenya, berikut perintahnya:

{% gist page.gist "08a-docker-build-command.bash" %}

Jika di jalankan maka outputnya seperti berikut:

```powershell
➜ docker-javaweb  docker build -t dimmaryanto93/jawaweb:2021.06.26.17.19-release .
[+] Building 0.2s (7/7) FINISHED
 => [internal] load build definition from Dockerfile                                                               0.0s
 => => transferring dockerfile: 189B                                                                               0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 34B                                                                                   0.0s
 => [internal] load metadata for docker.io/library/tomcat:8.5-jdk8-openjdk-slim                                    0.0s
 => [internal] load build context                                                                                  0.0s
 => => transferring context: 415.83kB                                                                              0.0s
 => CACHED [1/2] FROM docker.io/library/tomcat:8.5-jdk8-openjdk-slim                                               0.0s
 => [2/2] ADD target/ webapps/                                                                                     0.0s
 => exporting to image                                                                                             0.1s
 => => exporting layers                                                                                            0.0s
 => => writing image sha256:5e6ca5878c6a43710dde9b812ac62186ad0786842d08cba17e3c012abcf57986                       0.0s
 => => naming to docker.io/dimmaryanto93/jawaweb:2021.06.26.17.19-release
```

## Running Web Application

Setelah kita build, sekarang kita coba run dengan perintah berikut:

For Bash Script:

{% gist page.gist "08a-docker-run.bash" %}

For Powershell script:

{% gist page.gist "08a-docker-run.ps1" %}

Jika kita jalalankan maka hasilnya seperti berikut:

```powershell
➜ docker-javaweb  docker run -d -p 80:8080 --name javaweb dimmaryanto93/jawaweb:2021.06.26.17.19-release
3c6f5de772c42927062b139b639b15edc2fce5237dbe897bb1638711a12e4fc7

➜ docker-javaweb  docker container ls
CONTAINER ID   IMAGE                                            COMMAND             CREATED         STATUS         PORTS                                   NAMES
3c6f5de772c4   dimmaryanto93/jawaweb:2021.06.26.17.19-release   "catalina.sh run"   3 minutes ago   Up 3 minutes   0.0.0.0:80->8080/tcp, :::80->8080/tcp   javaweb

➜ docker-javaweb  docker top javaweb
UID                 PID                 PPID                C                   STIME               TTY
TIME                CMD
root                4519                4499                1                   11:07               ?
00:00:02            /usr/local/openjdk-8/bin/java -Djava.util.logging.config.file=/usr/local/tomcat/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djdk.tls.ephemeralDHKeySize=2048 -Djava.protocol.handler.pkgs=org.apache.catalina.webresources -Dorg.apache.catalina.security.SecurityListener.UMASK=0027 -Dignore.endorsed.dirs= -classpath /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar -Dcatalina.base=/usr/local/tomcat -Dcatalina.home=/usr/local/tomcat -Djava.io.tmpdir=/usr/local/tomcat/temp org.apache.catalina.startup.Bootstrap start

➜ docker-javaweb  docker stats --no-stream javaweb
CONTAINER ID   NAME      CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O   PIDS
3c6f5de772c4   javaweb   0.07%     125.4MiB / 3.842GiB   3.19%     5.29kB / 3.07kB   0B / 0B     30

➜ docker-javaweb  docker logs javaweb
27-Jun-2021 11:07:06.134 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server version name:   Apache Tomcat/8.5.68
27-Jun-2021 11:07:06.136 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server built:          Jun 11 2021 13:32:01 UTC
27-Jun-2021 11:07:06.136 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server version number: 8.5.68.0
27-Jun-2021 11:07:06.136 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log OS Name:               Linux
27-Jun-2021 11:07:06.136 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log OS Version:            4.19.128-microsoft-standard
27-Jun-2021 11:07:06.136 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Architecture:          amd64
27-Jun-2021 11:07:06.136 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Java Home:             /usr/local/openjdk-8/jre
27-Jun-2021 11:07:06.137 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log JVM Version:           1.8.0_292-b10
27-Jun-2021 11:07:06.137 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log JVM Vendor:            Oracle Corporation
27-Jun-2021 11:07:06.137 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log CATALINA_BASE:         /usr/local/tomcat
27-Jun-2021 11:07:06.137 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log CATALINA_HOME:         /usr/local/tomcat
27-Jun-2021 11:07:06.137 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.util.logging.config.file=/usr/local/tomcat/conf/logging.properties
27-Jun-2021 11:07:06.137 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager
27-Jun-2021 11:07:06.138 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djdk.tls.ephemeralDHKeySize=2048
27-Jun-2021 11:07:06.138 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.protocol.handler.pkgs=org.apache.catalina.webresources
27-Jun-2021 11:07:06.138 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dorg.apache.catalina.security.SecurityListener.UMASK=0027
27-Jun-2021 11:07:06.138 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dignore.endorsed.dirs=
27-Jun-2021 11:07:06.140 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dcatalina.base=/usr/local/tomcat
27-Jun-2021 11:07:06.140 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dcatalina.home=/usr/local/tomcat
27-Jun-2021 11:07:06.140 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.io.tmpdir=/usr/local/tomcat/temp
27-Jun-2021 11:07:06.140 INFO [main] org.apache.catalina.core.AprLifecycleListener.lifecycleEvent Loaded Apache Tomcat Native library [1.2.30] using APR version [1.6.5].
27-Jun-2021 11:07:06.140 INFO [main] org.apache.catalina.core.AprLifecycleListener.lifecycleEvent APR capabilities: IPv6 [true], sendfile [true], accept filters [false], random [true].
27-Jun-2021 11:07:06.140 INFO [main] org.apache.catalina.core.AprLifecycleListener.lifecycleEvent APR/OpenSSL configuration: useAprConnector [false], useOpenSSL [true]
27-Jun-2021 11:07:06.142 INFO [main] org.apache.catalina.core.AprLifecycleListener.initializeSSL OpenSSL successfully initialized [OpenSSL 1.1.1d  10 Sep 2019]
27-Jun-2021 11:07:06.183 INFO [main] org.apache.coyote.AbstractProtocol.init Initializing ProtocolHandler ["http-nio-8080"]
27-Jun-2021 11:07:06.189 INFO [main] org.apache.tomcat.util.net.NioSelectorPool.getSharedSelector Using a shared selector for servlet write/read
27-Jun-2021 11:07:06.196 INFO [main] org.apache.catalina.startup.Catalina.load Initialization processed in 386 ms
27-Jun-2021 11:07:06.213 INFO [main] org.apache.catalina.core.StandardService.startInternal Starting service [Catalina]
27-Jun-2021 11:07:06.213 INFO [main] org.apache.catalina.core.StandardEngine.startInternal Starting Servlet engine: [Apache Tomcat/8.5.68]
27-Jun-2021 11:07:06.223 INFO [localhost-startStop-1] org.apache.catalina.startup.HostConfig.deployWAR Deploying web application archive [/usr/local/tomcat/webapps/ROOT.war]
27-Jun-2021 11:07:06.447 INFO [localhost-startStop-1] org.apache.catalina.startup.HostConfig.deployWAR Deployment of web application archive [/usr/local/tomcat/webapps/ROOT.war] has finished in [223] ms
27-Jun-2021 11:07:06.459 INFO [main] org.apache.coyote.AbstractProtocol.start Starting ProtocolHandler ["http-nio-8080"]
27-Jun-2021 11:07:06.466 INFO [main] org.apache.catalina.startup.Catalina.start Server startup in 269 ms

➜ docker-javaweb  docker image ls
REPOSITORY              TAG                        IMAGE ID       CREATED         SIZE
dimmaryanto93/jawaweb   2021.06.26.17.19-release   5e6ca5878c6a   5 minutes ago   308MB
tomcat                  8.5-jdk8-openjdk-slim      de9773520e0d   30 hours ago    307MB
```

Sekarang coba akses lewat browser, dengan alamat [localhost/servlet](http://localhost/servlet) maka hasilnya seperti berikut:

![hasilnya]({{ page.image_path | prepend: site.baseurl }}/result.png)

## Cleanup

Seperti biasa, setelah kita mencoba schenari diatas sekarang kita bersih-bersih dulu ya. berikut perintahnya

For Bash script:

{% gist page.gist "08a-cleanup.bash" %}

For Powershell script:

{% gist page.gist "08a-cleanup.ps1" %}