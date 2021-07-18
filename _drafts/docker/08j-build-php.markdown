---
layout: post
title: "Study Kasus: Build docker image for PHP"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/
- https://www.php.net/
- https://www.tecmint.com/install-php-8-on-centos/
youtube: 
comments: true
image_path: /resources/posts/docker/08j-php-native
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


Hai semuanya, di materi kali ini kita akan membahas Build Docker image untuk bahasa pemograman sejuta umat yaitu [PHP](https://www.php.net/). Jadi kita akan bagi-bagi menjadi beberapa section diantaranya:

1. Setup Software Development on local environment
2. Deployment using Apache2/Httpd
3. Build & Run Docker image
4. Cleanup

Sedikit introduction tentang PHP (PHP: Hypertext Preprocessor) adalah widely-used open source general-purpose scripting language that is especially suited for web development and can be embedded into HTML. 

What can PHP do? PHP is mainly focused on server-side scripting, so you can do anything any other CGI program can do, such as collect form data, generate dynamic page content, or send and receive cookies. But PHP can do much more

Ok cukup pengenalannya, sekarang kita bahas materi yang pertama

## Setup SDK on local environment

Untuk menggunakan PHP, yang kita perlu install 

1. For Windows, [original documentation](https://www.php.net/manual/en/install.windows.php)
2. For Mac OS, [original documentation](https://www.php.net/manual/en/install.macosx.php) 
3. For Unix/Linux, [original documentaion](https://www.php.net/manual/en/install.unix.php)

Atau selain itu juga, kita bisa menggunakan third-party bundle untuk php, httpd, perl, pear seperti 

1. [Bitnami WAMP](https://bitnami.com/stack/wamp),
2. [XAMPP](https://www.apachefriends.org/index.html), 
3. [MAMP](https://www.mamp.info/en/windows/),
4. Dan masih banyak lagi.

Setelah di install sekarang kita buat project/folder PHP, untuk lokasinya tergatung dari temen-temen menggunakan installation yang mana, klo saya lebih sering menggunakan `php-cli` atau `php-fpm` jadi lokasinya saya bisa bebas disimpan di mana saja. 
Setelah itu sebagai contoh kita buat 2 file yang berisi `phpinfo()` dan `index.php` seperti berikut:

1. Buat file `index.php`, seperti berikut
    {% gist page.gist "08j-index.php" %}
2. Buat file pada folder `system` dengan nama file `info.php` seperti berikut:
    {% gist page.gist "08j-info.php" %}

Kemudian kita coba jalankan Build-in PHP Web Server dengan menggunakan perintah berikut:

{% highlight bash %}
php -S localhost:8000 -t docker-php
{% endhighlight %}


Jika dijalankan maka hasilnya seperti berikut:

```powershell
C:\tools\php80\php.exe -S localhost:8000 -t C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-php
[Sun Jul 18 13:06:53 2021] PHP 8.0.7 Development Server (http://localhost:8000) started
[Sun Jul 18 13:07:43 2021] [::1]:51179 Accepted
[Sun Jul 18 13:07:43 2021] [::1]:51179 [200]: GET /
[Sun Jul 18 13:07:43 2021] [::1]:51179 Closing
[Sun Jul 18 13:07:43 2021] [::1]:49500 Accepted
[Sun Jul 18 13:07:43 2021] [::1]:49500 [404]: GET /favicon.ico - No such file or directory
[Sun Jul 18 13:07:43 2021] [::1]:49500 Closing
[Sun Jul 18 13:08:44 2021] [::1]:62041 Accepted
[Sun Jul 18 13:08:44 2021] [::1]:62041 [200]: GET /system/info.php
[Sun Jul 18 13:08:44 2021] [::1]:62041 Closing
```

Kemudian coba access [localhost:8000/system/info.php](http://localhost:8000/system/info.php) dari browser, hasilnya seperti berikut:

![php-info]({{ page.image_path | prepend: site.baseurl }}/01-php-info.png)

Setelah menampilkan version dari PHP, sekarang kita bisa coba access [localhost:8000/index.php](http://localhost:8000) maka hasilnya seperti berikut:

![index.php]({{ page.image_path | prepend: site.baseurl }}/02-index-php.png)

## Deployment using Apache2/Httpd

Jadi perintah `php -s <addr>:<port>` bisanya di gunakan untuk development mode. Nah sekarang kita akan bahas bagaimana cara deployment PHP di Server Linux. Linux server yang saya akan gunakan adalah CentOS 7 kemudian software yang kita perlu install yaitu

1. Apache2 / Apache Httpd
2. PHP 8 (`php`, `php-cli`, `php-common`, `php-fpm`)

Install PHP 8.0 as Default version (Only recommended for GA release) Seperti berikut:

{% highlight bash %}
yum update -y && \
yum install -y yum-utils epel-release && \
yum-config-manager --disable 'remi-php*' && \
yum-config-manager --enable remi-php80 && \
yum -y install httpd php php-{cli,fpm,zip,devel,curl,pear,json} && \
## allow to access public
firewall-cmd --add-service=http --zone=public --permanent && \
firewall-cmd --reload && \
## enable service 
systemctl enable --now httpd && \
chmod -R 777 /var/www/html
{% endhighlight %}

Setelah kita install, sekarang kita upload source-code yang telah kita buat tadi ke Root Httpd Document. by default biasanya menggunakan `/var/www/html` menggunakan perintah berikut:

{% highlight bash %}
scp -r your-folder-php your-user@your.hostname:/var/www/html
{% endhighlight %}

Setelah semuanya terupload, nanti hasilnya seperti berikut:

![deploy-php-info]({{ page.image_path | prepend: site.baseurl }}/03-deploy-php-info.png)

## Build & Running Docker image

Setelah kita mengetahui workflow manual deploymentnya, sekarang kita bisa tarik kesimpulan untuk mendeploy PHP aplikasi kita membutuhkan

1. PHP Execution
2. Web Server, bisa menggunakan Httpd atau Nginx

Seperti biasa, untuk membuat Docker image. kita pilih dulu base image dockernya, sebagai contoh disini menggunakan [official docker image php](https://hub.docker.com/_/php)

Di official image, kita bisa pilih versinya ada yang hanya `php-cli`, ada yang include web server seperti `php-apache` atau `php-fpm`. Karena kita butuh menggunakan web-server jadi kita bisa menggunakan versi `8.0-apache` seperti berikut Dockerfilenya:

{% gist page.gist "08j-dockerfile" %}

Dan satu lagi yaitu `.dockerignore` seperti berikut:

{% gist page.gist "08j-dockerignore" %}

Setelah itu kita coba build docker image, menggunakan perintah berikut:

{% highlight bash %}
docker build -t dimmaryanto93/docker-php:1.0.0-SNAPSHOT .
{% endhighlight %}

Jika di jalankan hasilnya seperti berikut:

```powershell
➜ docker-php ✗  docker build -t dimmaryanto93/docker-php:1.0.0-SNAPSHOT .
[+] Building 10.6s (9/9) FINISHED
 => [internal] load build definition from Dockerfile                                                               0.0s
 => => transferring dockerfile: 435B                                                                               0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 34B                                                                                   0.0s
 => [internal] load metadata for docker.io/library/php:8.0-apache                                                  1.4s
 => CACHED [1/4] FROM docker.io/library/php:8.0-apache@sha256:1a69e0b19f5e2d006bec4d985e678733bf452ce76bf558d1553  0.0s
 => [internal] load build context                                                                                  0.0s
 => => transferring context: 123B                                                                                  0.0s
 => [2/4] RUN apt-get update && apt-get install -y     curl                                                        8.9s
 => [3/4] WORKDIR /var/www/html                                                                                    0.0s
 => [4/4] COPY . .                                                                                                 0.0s
 => exporting to image                                                                                             0.1s
 => => exporting layers                                                                                            0.1s
 => => writing image sha256:35c8cf4586da19b75e230372dfa80c0c891da066f191dd276e2292dfe9bb9192                       0.0s
 => => naming to docker.io/dimmaryanto93/docker-php:1.0.0-SNAPSHOT

➜ docker-php  docker images dimmaryanto93/docker-php
REPOSITORY                 TAG              IMAGE ID       CREATED         SIZE
dimmaryanto93/docker-php   1.0.0-SNAPSHOT   35c8cf4586da   5 minutes ago   435MB
```

Sekarang kita coba running containernya, dengan menggunakan perintah berikut:

{% highlight bash %}
docker run --name php-apache -p 80:80 -d dimmaryanto93/docker-php:1.0.0-SNAPSHOT
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ docker-php  docker run --name php-apache -p 80:80 -d dimmaryanto93/docker-php:1.0.0-SNAPSHOT
a37041a4ec43d7d434f3ed5693dbcede94ba01e4f51517f9174fca66f931ec04

➜ docker-php  curl localhost

StatusCode        : 200
StatusDescription : OK
Content           : <!doctype html>
                    <html lang="en">
                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport"
                              content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0,
                    minimum..."
RawContent        : HTTP/1.1 200 OK
                    Vary: Accept-Encoding
                    Keep-Alive: timeout=5, max=100
                    Connection: Keep-Alive
                    Content-Length: 389
                    Content-Type: text/html; charset=UTF-8
                    Date: Sun, 18 Jul 2021 08:07:40 GMT
                    Server...
Headers           : {[Vary, Accept-Encoding], [Keep-Alive, timeout=5, max=100], [Connection, Keep-Alive],
                    [Content-Length, 389]...}
ParsedHtml        : System.__ComObject
RawContentLength  : 389

➜ docker-php  docker exec php-apache php -v
PHP 8.0.8 (cli) (built: Jul  1 2021 22:32:03) ( NTS )
Copyright (c) The PHP Group
Zend Engine v4.0.8, Copyright (c) Zend Technologies
```

Sekarang coba akses dari browser ke alamat [localhost/system/info.php](http://localhost/system/info.php) hasilnya seperti berikut:

![php-info]({{ page.image_path | prepend: site.baseurl }}/04-docker-php-info.png)

## Cleanup

Seperti biasa setelah kita mencoba schenario studi kasus tersebut. sekarang kita bersih-bersih dulu ya berikut perintahnya:

For Bash script:

{% gist page.gist "08j-cleanup.bash" %}

For Powershell script:

{% gist page.gist "08j-cleanup.ps1" %}