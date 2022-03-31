---
layout: post
title: "Installing Nexus OSS"
date: 2021-04-24T16:45:03+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Registry
refs: 
- https://help.sonatype.com/repomanager3/installation
- https://help.sonatype.com/repomanager3/system-requirements
youtube: prAwBAdQpk4
comments: true
catalog_key: docker-registry
image_path: /resources/posts/docker/03b-private-registry
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas Insecure Registry dengan menggunakan [Nexus OSS](https://www.sonatype.com/products/repository-oss), diantaranya yang akan kita bahas yaitu

1. System requirement to install Nexus OSS
2. Installing Nexus OSS
    1. Setup Proxy Repository Docker from Docker HUB
    2. Setup Proxy Repository Docker from other registry
    3. Setup Hosted Repository Docker
    4. Setup Public Group Repository Docker
3. How to Push & Pull Docker images from Insecure Registry
    1. Pulling docker image from Docker Hub using Proxy
    2. Pulling docker image from an other registry using proxy repository
    3. Push own docker image to hosted registry.

<!--more-->

## System Requirement

Untuk install Nexus OSS, kita bisa install di Windows, Mac, atau Linux dengan system required seperti berikut

1. Java runtime environtment
2. RAM, The default JRE min and max heap size of NXRM3 is pre-configured to be 1200MB, which should be considered an absolute minimum. The codebase will consume approximately another 1GB.  So factoring in operating system overhead you will need at least 4GB of RAM on a dedicated NXRM host, assuming no other large applications are running on the machine.
3. CPU, NXRM performance is primarily bounded by IO (disk and network) rather than CPU.  So any reasonably modern 4 core (or better) CPU will generally be sufficient for normal uses of NXRM. 
4. Storage, Nexus Repository Manager 3 installed consumes around 500 MB.

## Installing Nexus OSS

Sekarang kita install, karena disini saya menggunakan Server Linux Centos 8, berikut adalah cara installnya

1. Download [nexus sonatype oss](https://www.sonatype.com/download-oss-sonatype)
2. Setelah filenya di download, kemudian extract dengan perintah berikut
    {% gist page.gist "03b-extract-download.bash" %}
3. Pindahkan ke lokasi yang diiginkan, sebagai contoh saya pindahkan ke `/opt` seperti berikut
    {% gist page.gist "03b-install-nexus.bash" %}
4. Buat user `nexus` di linux
    {% gist page.gist "03b-add-user-nexus.bash" %}
5. Kemudian kita buat service file dengan nama `nexus.service` di folder `/etc/systemd/system` seperti berikut
    {% gist page.gist "03b-nexus.service" %}
6. Yang terakhir kita jalankan servicenya
    {% gist page.gist "03b-start-service-nexus.bash" %}

Kemudian coba akses, [http://localhost:8081](http://localhost:8081) maka hasilnya seperti berikut:

![Nexus Repository on localhost]({{ page.image_path | prepend: site.baseurl }}/nexus-welcome.png)

## Configure Docker Registry

Untuk membuat registry di nexus kita perlu login dulu sebagai Administrator, secara default user `admin` passwordnya adalah `admin123`. setelah itu pilih Setting seperti berikut:

![settings]({{ page.image_path | prepend: site.baseurl }}/nexus-admin.png)

Setelah itu kita akan membuat repository, Ada 3 tipe repository

1. Proxy, digunakan sebagai mirror registry dari public atau private registry lain. 
2. Hosted, digunakan untuk menyimpan image yang kita publish/push
3. Group, digunakan untuk mengelompokan proxy dan hosted registry.

Jadi kita akan buat semuanya, 

## Setup proxy registry

Pertama kita buat dulu proxy registry. Dengan cara seperti berikut:

`Create new repository` -> `docker (proxy)` 

Kemudian isi form seperti berikut configurasinya:

1. name [bebas tapi harus di isi]: `docker-registry-io`
2. online: di checklist
3. remote storage [boleh pake registry lainnya]: `https://registry-1.docker.io`
4. Docker Index [pilih]: `Use Docker Hub`
5. Blob store [pilih bebas]: `default`
6. Setelah itu click **Save**

## Setup hosted registry

Setelah itu, kita setup untuk menyimpan image yang kita miliki ke private-registry dengan menggunakan **docker (hosted)**

`Create new repository` -> `docker (hosted)`

Kemudian isi form seperti berikut configurasinya:

1. name [bebas tpi harus di isi]: docker-repository
2. online: di checklist
3. HTTP [di checklist dan di isi port contohnya]: `8087`
4. Allow anonnymuous docker pull [di checklist klo mau yang bisa ngepull tanpa login]: **uncheked**
5. Enable Docker V1 API [docker engine version]: **unchecked**
6. Deployment policy [Tergantung kebutuhan, klo saya pilih Allow redeploy supaya tanpa ganti tags]: **Allow redeploy**
7. Setelah itu di **Save**
8. Kemudian kita allow/open port `8087` dari firewall supaya bisa di access
    {% gist page.gist "03b-firewall-cmd-registry-hosted.bash" %}

## Setup group registry

Group repository, untuk mengkases ke-2 repository yang telah kita buat dalam satu port connection saja. 
atau kita bisa pisahkan misalnya yang push repository menggunakan port `8087` sedangkan yang pull bisa menggunkan group repository ini.

`Create new repository` -> `docker (group)`

Kemudian isi form seperti berikut configurasinya:

1. Name [bebas, tapi harus diisi]: docker-repository-public
2. Online: checked
3. HTTP: `8086`
4. Allow anonnymuous docker pull [di checklist klo mau yang bisa ngepull tanpa login]: **uncheked**
5. Blob store: default
6. Member repositories: pilih semua repository yang kita telah buat seperti berikut:
    ![group docker selected]({{ page.image_path | prepend: site.baseurl }}/member-repositories-selected.png)
7. Setelah itu kita **Save**
8. Dan yang terakhir sama seperti sebelumnya, kita allow/open port `8086`
    {% gist page.gist "03b-firewall-cmd-registry-group.bash" %}

## Setup authentication

Sekarang kita setup untuk authenticationnya, kita bisa menu **Security** -> **Users** Kemudian kita buat usernya

Setelah membuat user kita setup untuk Realm di menu **Security** -> **Realms** untuk mengaktifkan pull tanpa login ke docker dulu, dengan cara Aktifkan **Docker Bearer Token Realm** seperti berikut:

![docker realms]({{ page.image_path | prepend: site.baseurl }}/docker-realms-token.png)

## Configure insecure-connection

docker-engine hanya mengijinkan kita untuk melakukan pull/push dari registry docker itu sendiri, jadi kita harus daftarkan di docker-engine jika di mac kita bisa tambahkan dari Docker-Desktop -> **Preferences** -> **Daemon** -> **insecure registries** inputan [ip-nexus-server:http-connection] contohnya: `localhost:8086`, `localhost:8087`, `domain.com:8087` dan lain-lain Setelah itu **Apply & restart**

Atau jika menggunakan linux: 

Buat atau tambahkan ke file `/etc/docker/daemon.json` seperti berikut

{% gist page.gist "daemon.json" %}

Kemudian restart docker dengan perintah seperti berikut:

{% highlight bash %}
systemctl restart docker.service
{% endhighlight %}

## Testing login

Sebelum kita, melakukan pull & push kita harus login dulu ke private registry tersebut dengan perintah berikut:

{% gist page.gist "03b-docker-login.bash" %}

- `Username`: User yang kita setup di nexus repository
- `Password`: input passwordnya dari user tersebut

Jika ada message: `Login Succeeded` berarti anda sudah bisa melakukan push ke repository

Setelah itu, kita contohnya kita akan pull image `postgresql:9.3` dari private registry. berikut adalah perintahnya:

{% gist page.gist "03b-docker-pull-private-registry.bash" %}

Dan sekarang kita coba push back ke private registry

For Bash script:

{% gist page.gist "03b-docker-push-private-registry.bash" %}

For Powershell script:

{% gist page.gist "03b-docker-push-private-registry.ps1" %}

berikut hasilnya:

![docker-pushed]({{ page.image_path | prepend: site.baseurl }}/docker-pushed.png)