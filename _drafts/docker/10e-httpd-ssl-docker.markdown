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
youtube: 
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