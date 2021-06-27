---
layout: post
title: "Studi Kasus: Build Docker Image for Java Webapp"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/
youtube: 
comments: true
image_path: /resources/posts/docker/08a-build-java-web-tomcat
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di studi kasus yang pertama kita akan membahas tentang build docker image untuk project Java Webapp dengan menggunakan build-tools Apache Maven. Diantaranya kita akan membahas

1. Create project dengan Apache Maven
2. Deployment using Tomcat Web Server
3. Build Docker Images
4. Running Web Application
5. Conclusion
6. Cleanup

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

Kemudian, silahkan tambahkan feature webnya seperti form tambah, edit, list dan sebagainya. kita gak akan terlalu detail di bagian ini klo temen-temen mau belajar tentang Java Web boleh baca roadmap **Java Web Developer**

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