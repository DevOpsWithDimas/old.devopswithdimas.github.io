---
layout: post
title: "Study Cases: Laravel - Using Frontend & Rest API"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/
- https://laravel.com/docs/8.x/eloquent-resources#introduction
- https://laravel.com/docs/8.x/mix
youtube: 
comments: true
image_path: /resources/posts/docker/08l-laravel-webapp-restapi
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, di materi study kasus kali ini kita akan membahas menggunakan Frontend / Webapp atau API Resources (Rest API) dengan Laravel, diantaranya yaitu

1. Using static Resource API
2. Create Sample Frontend
3. Deploy Production Mode
4. Build & Run Docker images
5. Cleanup

Ok langsung aja kita ke pembahasan yang pertama

## Using static Resource API

Untuk membuat Resource API di Laravel kita buat controllernya dulu dengan menggunakan perintah:

{% highlight bash %}
php artisan make:controller MahasiswaController
{% endhighlight %}

Kemudian kita edit file `app/Http/Controllers/MahasiswaController.php` seperti berikut:

{% gist page.gist "08l-MahasiswaController.php" %}

Lalu kita tambahkan juga Endpoint/Route API di `routes/api.php` seperti berikut:

{% gist page.gist "08l-routes-api.php" %}

Untuk melakukan testing Rest API nya kita buat file Request Http atau menggunakan Postman request seperti berikut:

{% gist page.gist "08l-mahasiswa-controller.http" %}

Dan yang terakhir buat environtment juga supaya memudahkan untuk menjalankan di berbagai environment seperti berikut:

{% gist page.gist "08l-http-client.env.json" %}

Nah sekarang kita coba jalankan dulu untuk Development mode yaitu menggunakan perintah:

{% highlight bash %}
php artisan serve
{% endhighlight %}

Sekarang kita jalankan Http Requestnya menggunakan env `dev` yaitu `localhost:8000` untuk `get Mahasiswa list` dan `get mahasiswa id` maka hasilnya seperti berikut:

1. Get Mahasiswa list
    ![api-dev-mahasiswa-list]({{ page.image_path | prepend: site.baseurl }}/api-dev-mahasiswa-list.png)

2. Get Mahasiswa id
    ![api-dev-mahasiswa-id]({{ page.image_path | prepend: site.baseurl }}/api-dev-mahasiswa-id.png)

## Create Sample Frontend Apps

Untuk membuat frontend application di Laravel kita bisa include CSS dan JS menggunakan Laravel Mix. Laravel Mix is a package developed by Laracasts creator Jeffrey Way, provides a fluent API for defining webpack build steps for your Laravel application using several common CSS and JavaScript pre-processors. 

Sebagai contoh kita akan menginstall package `bootstrap`, `font-awesome`, `jquery`, `jquery-datatables` menggunakan perintah berikut:

{% highlight bash %}
npm install && \
npm install --save @popperjs/core bootstrap datatables.net datatables.net-bs5 font-awesome jquery
{% endhighlight %}

Kemudian kita bundle `js`, `css` libraries dari folder `node_modules` menggunakan `webpack.mix.js` dengan meng-import nya di folder `resources/{js,css}` seperti berikut:

1. Import js dengan edit file `resources/js/app.js` seperti berikut:

    {% gist page.gist "08l-resources-js-app.js" %}

2. Import css file dengan edit file `resources/css/app.css` seperti berikut:

    {% gist page.gist "08l-resources-css-app.css" %}

3. Kemudian kita edit file `resources/view/welcome.blade.php` seperti berikut:

    {% gist page.gist "08l-welcome.blade.php" %}

Setelah itu kita compile file js, css nya dengan menggunakan perintah:

{% highlight bash %}
npm run-script dev
{% endhighlight %}

Dan kita coba jalankan PHP development mode menggunakan perintah seperti berikut:

{% highlight bash %}
php artisan serve
{% endhighlight %}

Sekarang kita coba access browsernya, maka hasilnya seperti berikut:

![laravel-jquery-datatables]({{ page.image_path | prepend: site.baseurl }}/laravel-jquery-datatables.png)