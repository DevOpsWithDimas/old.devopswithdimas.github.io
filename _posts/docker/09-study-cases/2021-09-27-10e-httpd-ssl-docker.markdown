---
layout: post
title: "Deploy httpd with ssl/https on docker"
date: 2021-09-27T15:44:07+07:00
lang: docker
categories:
- DevOps
- Docker
- Compose
- Study-Cases
refs: 
- https://docs.docker.com/
- https://id.wikipedia.org/wiki/Transport_Layer_Security
- https://www.digicert.com/kb/csr-ssl-installation/ubuntu-server-with-apache2-openssl.htm
youtube: dQXnZK7wTuc
comments: true
catalog_key: study-cases-compose-files
image_path: /resources/posts/docker/10e-httpd-ssl
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---


Hai semuanya, di video study kasus kali ini kita akan membahas tentang Configure ssl/https pada httpd berdasarkan study kasus [sebelumnya]({% post_url docker/09-study-cases/2021-09-12-10b-compose-laravel-study-case %}). 

Untuk deployment Laravel application paling commons di production adalah menggunakan [SSL/TLS (Secure Sockets Layer / Transport Layer Security)](https://id.wikipedia.org/wiki/Transport_Layer_Security) Certificate atau dengan katalain menggunakan [https (Hypertext Transfer Protocol Secure)](https://id.wikipedia.org/wiki/HTTPS) yang khusus menangani web aplication.

Ada banyak cara untuk deployment Laravel Application di production menggunakan https, Diantaranya yang akan kita bahas yaitu

1. SSL/https as reverse proxy
2. SSL/https direct from docker to host

Ok langsung ja kita ke pembahasan yang pertama yaitu

## Setup ssl/https as reverse proxy

Untuk setup ssh/https sebagai reverse proxy di [httpd/apache2](https://httpd.apache.org/) yang perlu kita siapkan, environment seperti berikut:

1. VM reverse-proxy
2. VM worker 1, 2, 3, n

Jadi kalau kita gambarkan seperti berikut arsitekturnya:

![ssl-reverse-proxy-arch]({{ page.image_path | prepend: site.baseurl }}/ssl-reverse-proxy.png)

Untuk membuat arsitektur seperti berikut, 

Kita perlu siapkan dulu service `laravel` dan `database` menggunakan compose file seperti berikut. Simpan dengan nama `docker-compose.reverse-proxy.yaml`:

{% gist page.gist "10e-proxy.docker-compose.reverse-proxy.yaml" %}

Setelah itu kita bisa jalankan dengan perintah `docker-compose up -d` seperti berikut:

{% highlight bash %}
docker-compose -p reverse-proxy \
-f docker-compose.yaml \
-f docker-compose.reverse-proxy.yaml \
--env-file .env \
up -d
{% endhighlight %}

Setelah semua servicenya running, kita bisa setup https-nya yang kita install menggunakan `apache2` di Linux VM dengan perintahnya seperti berikut:

{% highlight bash %}
export SITE_NAME=<your-site-name>;
export CERT_FOLDER=/etc/ssl/certs;
export CERT_KEY_FOLDER=/etc/ssl/private;

## install httpd/apache2 & openssl
apt-get update && apt-get upgrade && \
apt-get install apache2 openssl && \
a2enmod rewrite && \
a2enmod proxy && \
a2enmod ssl && \
a2enmod proxy_http && \
a2enmod proxy_balancer && \
a2enmod lbmethod_byrequests

## generate ssl certificate for apache2
openssl dhparam -out ${CERT_FOLDER}/$SITE_NAME.pem 2048 && \
openssl req -new \
-x509 \
-newkey rsa:2048 \
-nodes \
-days 365 \
-keyout $CERT_KEY_FOLDER/$SITE_NAME.key \
-out $CERT_FOLDER/$SITE_NAME.crt && \
echo "certs file: $CERT_FOLDER/$SITE_NAME.crt" && \
echo "secretkey file: $CERT_KEY_FOLDER/$SITE_NAME.key" && \
echo "dhparam file: ${CERT_FOLDER}/$SITE_NAME.pem"

## enabled virtualhost default for ssl
a2ensite default-ssl
{% endhighlight %}

Jika dijalankan hasilnya seperti berikut:

```powershell
writing new private key to '/etc/ssl/private/udemy_dimas-maryanto_com.key'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----

Country Name (2 letter code) [AU]:ID
State or Province Name (full name) [Some-State]:Indonesia
Locality Name (eg, city) []:Bandung
Organization Name (eg, company) [Internet Widgits Pty Ltd]:PT. Testing
Organizational Unit Name (eg, section) []:IT
Common Name (e.g. server FQDN or YOUR name) []:udemy.dimas-maryanto.com
Email Address []:software.dimas_m@icloud.com

----output
certs file: /etc/ssl/certs/udemy_dimas-maryanto_com.crt
secretkey file: /etc/ssl/private/udemy_dimas-maryanto_com.key
dhparam file: /etc/ssl/certs/udemy_dimas-maryanto_com.pem
```

Setelah kita install dan generate ssl certificates nya, sekarang kita update config `apache2`  pada file `/etc/apache2/sites-enabled/default-ssl.conf`seperti berikut:

{% gist page.gist "10e-proxy.default-ssl.conf" %}

Jika sudah kita bisa check confignya menggunakan perintah 

{% highlight bash %}
apachectl configtest
{% endhighlight %}

Jika response outputnya `OK` maka kita bisa restart servicenya menggunakan perintah

{% highlight bash %}
systemctl restart apache2
{% endhighlight %}

Jika sudah sekarang coba akses dari browser ke [https://localhost](https://localhost) hasilnya seperti berikut:

![https-proxy]({{ page.image_path | prepend: site.baseurl }}/httpd-proxy-ssl.png)


## Setup SSL/https direct from docker

Selain menggunakan topology tersebut, kita juga bisa menggunakan arsitektur seperti berikut:

![direct-docker]({{ page.image_path | prepend: site.baseurl }}/ssl-docker-arch.png)

Ok pertama kita akan buat Dockerfile baru, dengan tujuan tidak menggangu file yang sudah kita buat sebelumnya. berikut `Dockerfile-ssl`:

{% gist page.gist "10e-ssl.Dockerfile-ssl" %}

Pada file tersebut, kita menambahkan dependency `openssl` dan mengaktifkan module `ssl`, `proxy_http`, `proxy_balancer` dan `lbmethod_byrequests` pada Web Server Apache2. 

Kemudian kita perlu mengconfigure Web Server Apache2 untuk lokasi certificatenya, jadi kita buat file dengan nama 

1. `000-default.apache.conf` 

    {% gist page.gist "10e-ssl.000-default.apache.conf" %}

2. `001-default-ssl.apache.conf`

    {% gist page.gist "10e-ssl.001-default-ssl.apache.conf" %}

Tahap selanjutnya kita akan buat certificate ssl menggunakan `openssl`, pastikan dulu di local pc/laptop kita sudah mengginstal `openssl`

Jika di windows kita bisa menggunakan [package manager chocolatey](https://chocolatey.org/)

{% highlight powershell %}
choco install dos2unix openssl
{% endhighlight %}

Jika di linux, kita juga bisa menggunakan package manager seperti `yum`, `apt-get`, `dnf` seperti berikut:

{% highlight bash %}
## for debian/ubuntu distribution
apt-get update && apt-get install openssl

## for centos7/rhel-7
yum install openssl

## for centos8/rhel-8
dnf install openssl
{% endhighlight %}

Jika di MacOS, kita juga bisa menggunakan package manager seperti [homebrew](https://brew.sh/), dengan perintah seperti berikut:

{% highlight bash %}
brew install openssl
{% endhighlight %}

Setelah kita install `openssl`, sekarang kita bisa generate certificatenya dengan membuat file baru `generate-ssl-certs.sh` seperti berikut

Untuk linux/macOs, seperti berikut:

{% gist page.gist "10e-generate-certs.sh" %}

Kemudian jalankan scriptnya dengan perintah:

{% highlight bash %}
sh .docker/generate-ssl-certs.sh
{% endhighlight %}

Sedangkan untuk windows, seperti berikut:

{% gist page.gist "10e-generate-certs.ps1" %}

Kemudian jalankan scriptnya dengan perintah:

{% highlight powershell %}
.docker\generate-ssl-certs.ps1
{% endhighlight %}

Maka outputnya seperti berikut:

```powershell
remove existing certs in [.docker\ssl\certs, .docker\ssl\key]
create directory [.docker\ssl\certs, .docker\ssl\key]


    Directory: C:\Users\dimasm93\Workspaces\udemy\docker\.docker\ssl


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         10/7/2021   5:45 AM                certs
d-----         10/7/2021   5:45 AM                key
Generating DH parameters, 2048 bit long safe prime, generator 2
This is going to take a long time
....................................+Generating a RSA private key
...................................................+++++
.......+++++
writing new private key to '.docker\ssl\key\docker_pemula_sampai_mahir.key'

Country Name (2 letter code) [AU]:ID
State or Province Name (full name) [Some-State]:Indonesia
Locality Name (eg, city) []:Bandung
Organization Name (eg, company) [Internet Widgits Pty Ltd]:PT. Contohajah
Organizational Unit Name (eg, section) []:IT
Common Name (e.g. server FQDN or YOUR name) []:udemy.dimas-maryanto.com
Email Address []:software.dimas_m@icloud.com

## output file
certs file: .docker\ssl\certs\docker_pemula_sampai_mahir.crt
secretkey file: .docker\ssl\key\docker_pemula_sampai_mahir.key
dhparam file: .docker\ssl\certs\docker_pemula_sampai_mahir.pem
```

Dan yang terakahir, kita buat compose file baru dengan nama `docker-compose.https-only.yaml` seperti berikut:

{% gist page.gist "10e-https.docker-compose.https-only.yaml" %}

Jadi dari `docker-compose.https-only.yaml` tersebut, kita tidak menyimpan file certificatenya dalam image, tetapi melainkan kita melakukan mount-bind karena certificate bisa dynamic dan ada waktu expirednya jadi kita cukup mount saja. Ok sekarang kita bisa jalankan dengan perintah seperti berikut:

{% highlight powershell %}
docker-compose -f docker-compose.yaml -f docker-compose.https-only.yaml --env-file .docker/.env up -d --build
{% endhighlight %}

Maka hasilnya seperti berikut:

```powershell
➜ docker git:(compose/laravel) docker-compose -f docker-compose.yaml -f .\docker-compose.https-only.yaml --env-file .docker/.env.example up -d --build
[+] Building 15.3s (27/27) FINISHED
 => [internal] load build definition from Dockerfile-ssl                                                           0.0s
 => => transferring dockerfile: 36B                                                                                0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 35B                                                                                   0.0s
 => [internal] load metadata for docker.io/library/node:14.15-alpine3.13                                          15.1s
 => [internal] load metadata for docker.io/library/php:8.0-apache                                                 15.1s
 => [auth] library/node:pull token for registry-1.docker.io                                                        0.0s
 => [auth] library/php:pull token for registry-1.docker.io                                                         0.0s
 => [php_laravel 1/8] FROM docker.io/library/php:8.0-apache@sha256:0b282b4e6c17789532271488177cf96257708d3919b252  0.0s
 => [internal] load build context                                                                                  0.0s
 => => transferring context: 6.13kB                                                                                0.0s
 => [laramix_build 1/4] FROM docker.io/library/node:14.15-alpine3.13@sha256:03b86ea1f9071a99ee3de468659c9af95ca0b  0.0s
 => CACHED [php_laravel 2/8] RUN apt-get update && apt-get install -y   curl   git   libicu-dev   libpq-dev   lib  0.0s
 => CACHED [php_laravel 3/8] RUN pecl install mcrypt-1.0.4 &&   docker-php-ext-install fileinfo exif pcntl bcmath  0.0s
 => CACHED [php_laravel 4/8] RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --fi  0.0s
 => CACHED [php_laravel 5/8] WORKDIR /var/www/php                                                                  0.0s
 => CACHED [php_laravel 6/8] COPY .docker/apache2-foreground  /usr/local/bin/apache2-laravel-foreground            0.0s
 => CACHED [php_laravel 7/8] COPY .docker/000-default.apache.conf /etc/apache2/sites-enabled/000-default.conf      0.0s
 => CACHED [php_laravel 8/8] COPY .docker/001-default-ssl.apache.conf /etc/apache2/sites-enabled/001-default-ssl.  0.0s
 => CACHED [executeable 1/7] WORKDIR /var/www/php                                                                  0.0s
 => CACHED [executeable 2/7] COPY . .                                                                              0.0s
 => CACHED [laramix_build 2/4] WORKDIR /var/www/php                                                                0.0s
 => CACHED [laramix_build 3/4] COPY . .                                                                            0.0s
 => CACHED [laramix_build 4/4] RUN npm install -q &&     npm run-script prod                                       0.0s
 => CACHED [executeable 3/7] COPY --from=laramix_build /var/www/php/public/css public/css                          0.0s
 => CACHED [executeable 4/7] COPY --from=laramix_build /var/www/php/public/fonts public/fonts                      0.0s
 => CACHED [executeable 5/7] COPY --from=laramix_build /var/www/php/public/js public/js                            0.0s
 => CACHED [executeable 6/7] RUN mkdir -p public/storage &&     chmod -R 777 storage/* &&     chmod -R 777 public  0.0s
 => CACHED [executeable 7/7] RUN php -r "file_exists('.env') || copy('.env.example', '.env');" &&     composer in  0.0s
 => exporting to image                                                                                             0.1s
 => => exporting layers                                                                                            0.0s
 => => writing image sha256:24dfaafd5fcbed9f882428b085eb5f45113577215fcd9f060b1f4285f331efe8                       0.0s
 => => naming to docker.io/dimmaryanto93/udemy-laravel8-apps:latest                                                0.0s
[+] Running 4/4
 - Network docker_backend      Created                                                                             0.0s
 - Volume "docker_db_data"     Created                                                                             0.0s
 - Container docker-mysql-1    Started                                                                             0.5s
 - Container docker-laravel-1  Started

➜ docker git:(compose/laravel) docker-compose -f docker-compose.yaml -f .\docker-compose.https-only.yaml --env-file .docker/.env.example ps
NAME                COMMAND                  SERVICE             STATUS              PORTS
docker-laravel-1    "docker-php-entrypoi…"   laravel             running             0.0.0.0:443->443/tcp
docker-mysql-1      "docker-entrypoint.s…"   mysql               running             33060/tcp

➜ docker git:(compose/laravel) docker-compose -f docker-compose.yaml -f .\docker-compose.https-only.yaml --env-file .docker/.env.example logs laravel
docker-laravel-1  | Configuration cache cleared!
docker-laravel-1  | Application cache cleared!
docker-laravel-1  | Configuration cache cleared!
docker-laravel-1  | Configuration cached successfully!
docker-laravel-1  | Route cache cleared!
docker-laravel-1  | Routes cached successfully!
docker-laravel-1  | Files cached successfully!
docker-laravel-1  | AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 172.19.0.3. Set the 'ServerName' directive globally to suppress this message
docker-laravel-1  | [Wed Oct 06 22:52:12.547705 2021] [ssl:warn] [pid 1] AH01906: udemy.dimas-maryanto.com:443:0 server certificate is a CA certificate (BasicConstraints: CA == TRUE !?)
docker-laravel-1  | AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 172.19.0.3. Set the 'ServerName' directive globally to suppress this message
docker-laravel-1  | [Wed Oct 06 22:52:12.564945 2021] [ssl:warn] [pid 1] AH01906: udemy.dimas-maryanto.com:443:0 server certificate is a CA certificate (BasicConstraints: CA == TRUE !?)
docker-laravel-1  | [Wed Oct 06 22:52:12.568095 2021] [mpm_prefork:notice] [pid 1] AH00163: Apache/2.4.48 (Debian) PHP/8.0.11 OpenSSL/1.1.1k configured -- resuming normal operations
docker-laravel-1  | [Wed Oct 06 22:52:12.568110 2021] [core:notice] [pid 1] AH00094: Command line: 'apache2 -D FOREGROUND'
```

Sekarang klo kita lihat di browser, dengan mengakses url [https://localhost](https://localhost) maka hasilnya seperti berikut:

![https-laravel]({{ page.image_path | prepend: site.baseurl }}/httpd-ssl-directly.png)