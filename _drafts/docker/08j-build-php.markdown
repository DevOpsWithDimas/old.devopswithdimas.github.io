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
youtube: 
comments: true
image_path: /resources/posts/docker/08j-php-native
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


Hai semuanya, di materi kali ini kita akan membahas Build Docker image untuk bahasa pemograman sejuta umat yaitu [PHP](https://www.php.net/). Jadi kita akan bagi-bagi menjadi beberapa section diantaranya:

1. Setup Software Development on local environment
2. Deployment using Apache2/Httpd
3. Build Docker image
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

Jadi perintah `php -s <addr>:<port>` bisanya di gunakan untuk development mode. Nah sekarang kita akan bahas bagaimana cara deployment PHP di Server Linux.