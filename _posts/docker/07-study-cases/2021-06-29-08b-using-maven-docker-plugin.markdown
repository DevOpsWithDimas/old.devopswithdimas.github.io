---
layout: post
title: "Study Kasus: Build Java Web using maven-docker-plugin"
date: 2021-06-29T04:35:37+07:00
lang: docker
categories:
- DevOps
- Docker
- Dockerfile
- Study-Cases
refs: 
- https://github.com/fabric8io/docker-maven-plugin
- https://github.com/spotify/docker-maven-plugin
- https://github.com/spotify/dockerfile-maven
youtube: ukR7clTSPm0
comments: true
image_path: /resources/posts/docker/08b-mvn-dockerfile
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas salah satu plugin `maven-docker-plugin` yang biasanya digunakan untuk meng-optimaze build docker untuk Java. Diantarnya yang akan kita bahas yaitu

1. Build docker image menggunakan `dockerfile-maven`
2. Publish docker image ke registry
    1. Setup Authenticate using `.m2/setting.xml`
    2. Docker HUB
    3. Insecure Registry
3. Cleanup

Ok langsung aja kita bahas pembahasan yang pertama 

## Build docker image menggunakan `dockerfile-maven`

Docker maven plugin ini pada dasarnya digunakan oleh spotify untuk building docker image untuk Internal maupun External Java Service mereka. Projectnya di initialisasi pada 2014 ketika memulai menggunakan Docker. Jadi tujuannya menggunakan [docker-maven-plugin](https://github.com/spotify/docker-maven-plugin) adalah men-generate `Dockerfile` menggunakan format `pom.xml`.

This example creates a new image named `example`, copies the project's jar file into the image, and sets an entrypoint which runs the jar. Change `VERSION GOES HERE` to the latest tagged version.

{% highlight xml %}
<build>
  <plugins>
    ...
    <plugin>
      <groupId>com.spotify</groupId>
      <artifactId>docker-maven-plugin</artifactId>
      <version>VERSION GOES HERE</version>
      <configuration>
        <imageName>example</imageName>
        <baseImage>java</baseImage>
        <entryPoint>["java", "-jar", "/${project.build.finalName}.jar"]</entryPoint>
        <!-- copy the service's jar file from target into the root directory of the image --> 
        <resources>
           <resource>
             <targetPath>/</targetPath>
             <directory>${project.build.directory}</directory>
             <include>${project.build.finalName}.jar</include>
           </resource>
        </resources>
      </configuration>
    </plugin>
    ...
  </plugins>
</build>
{% endhighlight %}

Setelah itu kita bisa build dengan menggunakan perintah seperti berikut

{% highlight bash %}
mvn clean package docker:build -DpushImage
{% endhighlight %}

Sekarang, status dari projectnya sudah `inactive`. mereka merekomendasikan menggunakan project barunya yaitu [dockerfile-maven](https://github.com/spotify/dockerfile-maven) yang statusnya sudah `mature`. 

Ok nah sekarang kita akan menggunakan `dockerfile-maven` pada Project Java Web sebelumnya dengan menambahkan `plugin` seperti berikut:

{% gist page.gist "08b-edit-pom.xml" %}

Setelah itu kita edit file `.dockerignore` menjadi seperti berikut:

{% gist page.gist "08b-edit-dockerignore" %}

Kemudian kita coba jalankan perintah berikut:

{% highlight bash %}
mvn -DskipTests -Dfinal-name=ROOT package dockerfile:build
{% endhighlight %}

Jika dijalankan maka outputnya seperti berikut:

```powershell
➜ docker-javaweb  mvn -DskipTests -Dfinal-name=ROOT package dockerfile:build
[WARNING]
[WARNING] Some problems were encountered while building the effective settings
[WARNING] Unrecognised tag: 'releases' (position: START_TAG seen ...</url>\n         <releases>... @9:20)  @ C:\Users\dimasm93\.m2\settings.xml, line 9, column 20
[WARNING]
[INFO] Scanning for projects...
[INFO]
[INFO] --------------< com.maryanto.dimas.udemy:docker-javaweb >---------------
[INFO] Building docker-javaweb Maven Webapp 1.0.0-release
[INFO] --------------------------------[ war ]---------------------------------
[INFO] --- maven-war-plugin:3.2.3:war (default-war) @ docker-javaweb ---
[INFO] Packaging webapp
[INFO] Assembling webapp [docker-javaweb] in [C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-javaweb\target\ROOT]
[INFO] Processing war project
[INFO] Copying webapp resources [C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-javaweb\src\main\webapp]
[INFO] Webapp assembled in [35 msecs]
[INFO] Building war: C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-javaweb\target\ROOT.war
[INFO]
[INFO] --- dockerfile-maven-plugin:1.4.13:build (default-cli) @ docker-javaweb ---
[INFO] dockerfile: C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-javaweb\Dockerfile
[INFO] contextDirectory: C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-javaweb
[INFO] Building Docker context C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-javaweb
[INFO] Path(dockerfile): C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-javaweb\Dockerfile
[INFO] Path(contextDirectory): C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-javaweb
[INFO]
[INFO] Image will be built as docker.io/dimmaryanto93/docker-javaweb:1.0.0-release
[INFO]
[INFO] Step 1/5 : ARG WAR_FILE_NAME=ROOT.war
[INFO]
[INFO] Step 2/5 : FROM tomcat:8.5-jdk8-openjdk-slim
[INFO]
[INFO] Pulling from library/tomcat
[INFO] Digest: sha256:1277012ddf6c005ffbaf88c8807d1128ed93679a51111746f95badc364f897e6
[INFO] Status: Image is up to date for tomcat:8.5-jdk8-openjdk-slim
[INFO]  ---> de9773520e0d
[INFO] Step 3/5 : ADD target/${WAR_FILE_NAME} webapps/
[INFO]
[INFO]  ---> b218a1ffd95c
[INFO] Step 4/5 : EXPOSE 8080/tcp
[INFO]
[INFO]  ---> Running in 8f19ebddc285
[INFO] Removing intermediate container 8f19ebddc285
[INFO]  ---> 3cda4392daf6
[INFO] Step 5/5 : CMD ["catalina.sh", "run"]
[INFO]
[INFO]  ---> Running in 1ab7a0764794
[INFO] Removing intermediate container 1ab7a0764794
[INFO]  ---> 7b082058a00a
[INFO] Successfully built 7b082058a00a
[INFO] Successfully tagged dimmaryanto93/docker-javaweb:1.0.0-release
[INFO]
[INFO] Detected build of image with id 7b082058a00a
[INFO] Building jar: C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-javaweb\target\ROOT-docker-info.jar
[INFO] Successfully built docker.io/dimmaryanto93/docker-javaweb:1.0.0-release
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  7.804 s
[INFO] Finished at: 2021-06-29T03:31:50+07:00
[INFO] ------------------------------------------------------------------------

➜ docker-javaweb  docker image ls
REPOSITORY                     TAG                     IMAGE ID       CREATED         SIZE
dimmaryanto93/docker-javaweb   1.0.0-release           7b082058a00a   3 minutes ago   308MB
tomcat                         8.5-jdk8-openjdk-slim   de9773520e0d   2 days ago      307MB
```

## Publish docker image ke registry

Setelah kita build, kita juga bisa publish ke registry dengan menggunakan perintah `mvn dockerfile:push` command, tpi sebelum itu kita push ke registry. kita harus setup Authentication nya dulu, ada beberapa cara setup authentication 

1. Since version `1.3.0`, the plugin will automatically use any configuration in your `~/.dockercfg` or `~/.docker/config.json` file when pulling, pushing, or building images to private registries.
2. Since version `1.3.6`, you can authenticate using your maven `settings.xml` instead of docker configuration.
3. Since version `1.3.XX`, you can authenticate using config from the pom itself.

Kita bisa pilih salah satu method authenticationnya, kalo saya sendiri lebih sering menggunakan maven `.m2/setting.xml` dengan configuration seperti berikut:

{% highlight xml %}
<servers>
  <server>
    <id>docker.io</id>
    <username>me</username>
    <password>mypassword</password>
  </server>
  <server>
    <id>private.registry:8087</id>
    <username>me</username>
    <password>mypassword</password>
  </server>
</servers>
{% endhighlight %}

Selanjutnya kita coba push dengan perintah 

{% highlight bash %}
mvn -s ~/.m2/setting.xml dockerfile:push
{% endhighlight %}

Jika kita jalankan maka outputnya seperti berikut:

```powershell
➜ docker-javaweb  mvn -s C:\Users\dimasm93\.m2\settings.xml dockerfile:push
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
[INFO] --- dockerfile-maven-plugin:1.4.13:push (default-cli) @ docker-javaweb ---
[INFO] The push refers to repository [docker.io/dimmaryanto93/docker-javaweb]
[INFO] Image bed956dce53e: Preparing
[INFO] Image eb4d0db4a187: Waiting
[INFO] Image bed956dce53e: Pushing
[INFO] Image 764055ebc9a7: Mounted from library/tomcat
[INFO] Image bed956dce53e: Pushed
[INFO] 1.0.0-release: digest: sha256:a1b3a118469e9ddedba14da5dc95f9366b616ef0bcd5bd90108cc9762b01a187 size: 1997
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  31.930 s
[INFO] Finished at: 2021-06-29T03:57:59+07:00
[INFO] ------------------------------------------------------------------------
```

Berikut hasilnya:

![docker-hub]({{ page.image_path | prepend: site.baseurl }}/docker-io.png)

Selain itu juga kita bisa push ke insecure registry dengan meng-override properties nya seperti berikut:

{% highlight bash %}
mvn -s ~/.m2/settings.xml \
 -Ddocker-registry-host-push=private.registry:8087 \
 -Ddocker-registry-group=udemy/javaweb \
 dockerfile:build \
 dockerfile:push
{% endhighlight %}

Jika di jalankan maka outputnya seperti berikut:

```powershell
➜ docker-javaweb  mvn -s C:\Users\dimasm93\.m2\settings.xml `
-Ddocker-registry-host-push="repository.dimas-maryanto.com:8087" `
-Ddocker-registry-group="udemy/javaweb" `
dockerfile:build dockerfile:push
[WARNING]
[INFO] Scanning for projects...
[INFO]
[INFO] --------------< com.maryanto.dimas.udemy:docker-javaweb >---------------
[INFO] Building docker-javaweb Maven Webapp 1.0.0-release
[INFO] --------------------------------[ war ]---------------------------------
[INFO]
[INFO] --- dockerfile-maven-plugin:1.4.13:build (default-cli) @ docker-javaweb ---
[INFO] dockerfile: C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-javaweb\Dockerfile
[INFO] contextDirectory: C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-javaweb
[INFO] Building Docker context C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-javaweb
[INFO] Path(dockerfile): C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-javaweb\Dockerfile
[INFO] Path(contextDirectory): C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-javaweb
[INFO]
[INFO] Image will be built as repository.dimas-maryanto.com:8087/udemy/javaweb/docker-javaweb:1.0.0-release
[INFO]
[INFO] Step 1/5 : ARG WAR_FILE_NAME=ROOT.war
[INFO]
[INFO] Step 2/5 : FROM tomcat:8.5-jdk8-openjdk-slim
[INFO]
[INFO] Pulling from library/tomcat
[INFO] Digest: sha256:1277012ddf6c005ffbaf88c8807d1128ed93679a51111746f95badc364f897e6
[INFO] Status: Image is up to date for tomcat:8.5-jdk8-openjdk-slim
[INFO]  ---> de9773520e0d
[INFO] Step 3/5 : ADD target/${WAR_FILE_NAME} webapps/
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> b218a1ffd95c
[INFO] Step 4/5 : EXPOSE 8080/tcp
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> 3cda4392daf6
[INFO] Step 5/5 : CMD ["catalina.sh", "run"]
[INFO]
[INFO]  ---> Using cache
[INFO]  ---> 7b082058a00a
[INFO] Successfully built 7b082058a00a
[INFO] Successfully tagged repository.dimas-maryanto.com:8087/udemy/javaweb/docker-javaweb:1.0.0-release
[INFO]
[INFO] Detected build of image with id 7b082058a00a
[INFO] Building jar: C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-javaweb\target\docker-javaweb-1.0.0-release-docker-info.jar
[INFO] Successfully built repository.dimas-maryanto.com:8087/udemy/javaweb/docker-javaweb:1.0.0-release
[INFO]
[INFO] --- dockerfile-maven-plugin:1.4.13:push (default-cli) @ docker-javaweb ---
[INFO] The push refers to repository [repository.dimas-maryanto.com:8087/udemy/javaweb/docker-javaweb]
[INFO] Image bed956dce53e: Preparing
[INFO] Image eb4d0db4a187: Waiting
[INFO] Image aa7d6f60014a: Pushing
[INFO] Image 220d02abd73d: Pushed
[INFO] 1.0.0-release: digest: sha256:a1b3a118469e9ddedba14da5dc95f9366b616ef0bcd5bd90108cc9762b01a187 size: 1997
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  29.712 s
[INFO] Finished at: 2021-06-29T04:22:03+07:00
[INFO] ------------------------------------------------------------------------
```

Berikut hasilnya:

![docker-hub]({{ page.image_path | prepend: site.baseurl }}/private-registry.png)

## Cleanup

Seperti biasa, setelah kita mencoba schenario tersebut. Sekarang kita bersih-bersih ya berikut perintahnya:

For Bash script:

{% gist page.gist "08b-cleanup.bash" %}

For Powershell script:

{% gist page.gist "08b-cleanup.ps1" %}