---
layout: post
title: "Pipeline: Laravel deploy with Gitlab CI"
date: 2021-12-18T10:56:14+07:00
lang: docker
categories:
- DevOps
- Docker
- ci
- Study-Cases
- Gitlab-CI
refs: 
- https://docs.gitlab.com/ee/ci/examples/deployment/composer-npm-deploy.html
- https://laravel.com/docs/8.x/testing
- https://docs.gitlab.com/ee/ci/examples/laravel_with_gitlab_and_envoy/
youtube: 
comments: true
catalog_key: study-cases-docker-ci
image_path: /resources/posts/docker/12g-pipeline-laravel
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, di materi study kasus kali ini kita akan membahas Pipeline untuk Laravel application berdasarkan source-code [berikut]({% post_url docker/09-study-cases/2021-09-27-10e-httpd-ssl-docker %}). Seperti biasa karena pembahasan kali akan lumayan panjang kita bagi-bagi menjadi beberapa bagian, Diantaranya

1. Introduction to workflow deployment
2. Build custome image to test, and build Laravel application
3. Write unit/integration testing locally
4. Pipeline unit/integration testing with Gitlab CI
5. Build source-code to site resources with Gitlab CI
6. Build docker image with Gitlab CI
7. Test run containers

Ok langsung kita ke pembahasan yang pertama yaitu

## Introduction to workflow deployment

Berdasarkan materi-materi sebelumnya, kita sudah bisa membuat CI Pipeline untuk berbagai macam bahasa pemograman mulai dari JavaEE, PHP, Springboot dan Angular. 

Untuk Laravel sendiri kita membutuhkan cara yang sedikit berbeda karena membutuhkan environment dan dependencies specific berdasarkan project yang telah kita buat untuk melakukan seperti Test, dan build source-code menjadi artifact.

Basicly secara workflow kita akan membuat

1. `Dockerfile-ci`, untuk based image melakukan test, build laravel aplikasi
2. Build frontend (Laravel mix) using [node](https://hub.docker.com/_/node) docker image
3. `Dockerfile-run`, untuk serve content Laravel Application

## Build custome image to test, and build Laravel apps

Sebetulnya kita bisa menggunakan `Dockerfile` yang telah kita buat pada materi [sebelumnya]({% post_url docker/07-study-cases/2021-07-26-08m-build-laravel-using-db %}), pada file tersebut terdiri dari `3 stage` yaitu

1. Custome environment php dengan apache
2. Build frontend
3. Serve laravel application dengan menggunakan image based pada stage pertama.

Hanya saja jika kita menggunakan configurasi seperti itu, component di dalamnya tidak bisa reusable seperti contohnya jika kita mau test aplikasi sebelum di build jadi docker image. Maka dari itu kita akan split menjadi 3 step tadi, Sekarang tahap pertama ini kita akan membuat CI Pipeline untuk 

1. Build custome image, yang berfungsi untuk envinment Laravel Aplikasi itu sendiri misalnya run PHPUnit Test, DB Migration ataupun build source-code
2. Build frontend (Laravel MIX)

Ok pertama kita buat file `Dockerfile` baru dengan nama `Dockerfile-ci` seperti berikut:

{% gist page.gist "12g-dockerfile-ci" %}

Dan yang terakhir, kita buat file baru dengan nama `.gitlab-ci.yml` seperti berikut:

{% gist page.gist "12g-gitlab-ci.custom-image.yml" %}

Jika sudah kita bisa, commit dan push ke repository gitlabnya. Kemudian kita bisa check pipelinenya seperti berikut:

![build-env-laravel-pipeline]({{ page.image_path | prepend: site.baseurl }}/01-build-laravel-env-pipeline.png)

Jadi pada pipeline `build:docker:php-laravel` kita bisa build everytime kita update file `Dockerfile-ci` dan `.gitlab-ci.yml`. Jika sudah selesai hasilnya seperti berikut:

![build-env-laravel-job-detail]({{ page.image_path | prepend: site.baseurl }}/02-build-laravel-env-job-detail.png)

Dan berikut adalah docker image pada Nexus OSS:

![docker-image-php-laravel]({{ page.image_path | prepend: site.baseurl }}/03-docker-image-php-laravel.png)

Sedangkan untuk pipeline `build:mix:production` kita perlu membuat tag dengan surfix `xx.xx.xx.xx-release` contohnya seperti berikut:

![build-laravel-mix-pipeline]({{ page.image_path | prepend: site.baseurl }}/04-build-laravel-mix-pipeline.png)

Dan jika sudah selesai, kita bisa lihat job detailnya seperti berikut:

![build-laravel-mix-job-detail]({{ page.image_path | prepend: site.baseurl }}/05-build-laravel-mix-job-detail.png)

## Write unit/integration testing locally

Laravel is built with testing in mind. In fact, support for testing with PHPUnit is included out of the box and a `phpunit.xml` file is already set up for your application. The framework also ships with convenient helper methods that allow you to expressively test your applications.

By default, your application's `tests` directory contains two directories: `Feature` and `Unit`. `Unit` tests are tests that focus on a very small, isolated portion of your code. In fact, most unit tests probably focus on a single method. Tests within your "Unit" test directory do not boot your Laravel application and therefore are unable to access your application's database or other framework services. `Feature` tests may test a larger portion of your code, including how several objects interact with each other or even a full HTTP request to a JSON endpoint.

In addition, you may create a `.env.testing` file in the root of your project. This file will be used instead of the `.env` file when running PHPUnit tests or executing Artisan commands with the `--env=testing` option.

To create a new test case, use the `make:test` Artisan command. By default, tests will be placed in the `tests/Feature` directory:

{% highlight bash %}
php artisan make:test MahasiswaTest
{% endhighlight %}

Seperti berikut filenya:

{% gist page.gist "12g-feature-mahasiswa-test.php" %}

Sekarang kita coba jalankan, tapi sebelum itu kita harus siapkan dulu environment seperti database, config database dan lain-lain. Untuk database kita bisa lansung jalankan menggunakan docker-compose seperti berikut:

{% highlight bash %}
docker-compose up -d mysql
{% endhighlight %}

Setelah databasenya jalan kita bisa coba jalankan menggunakan debug mode seperti berikut:

{% highlight bash %}
php artisan migrate;
php artisan test;
{% endhighlight %}

Jika di jalankan hasilnya seperti berikut:

```powershell
➜ docker git:(compose/laravel) docker-compose up -d mysql
[+] Running 3/3
 - Network docker_default      Created                                              0.7s
 - Volume "docker_mysql_data"  Created                                              0.0s
 - Container docker_mysql_1    Started                                              1.1s

➜ docker git:(compose/laravel) php artisan migrate
Migration table created successfully.
Migrating: 2014_10_12_000000_create_users_table
Migrated:  2014_10_12_000000_create_users_table (29.53ms)
Migrating: 2014_10_12_100000_create_password_resets_table
Migrated:  2014_10_12_100000_create_password_resets_table (38.95ms)
Migrating: 2019_08_19_000000_create_failed_jobs_table
Migrated:  2019_08_19_000000_create_failed_jobs_table (31.68ms)
Migrating: 2021_08_09_164144_create_mahasiswa_table
Migrated:  2021_08_09_164144_create_mahasiswa_table (60.49ms)

➜ docker git:(compose/laravel) php artisan test
Warning: TTY mode is not supported on Windows platform.

   PASS  Tests\Unit\ExampleTest
  ✓ example

   PASS  Tests\Feature\ExampleTest
  ✓ example

   PASS  Tests\Feature\MahasiswaTest
  ✓ list mahasiswa
  ✓ find by id mahasiswa

  Tests:  5 passed
  Time:   0.20s
```

Jadi dengan seperti berikut, kita sudah sukses melakukan integration testing menggunakan Rest API dari Laravel menggunakan Database MySQL.

## Pipeline unit/integration testing

Setelah sebelumnya kita membuat Unit/Integration testing di Laravel Application, selanjutnya kita akan buat Pipelinenya juga. Ok jadi langsung ja berikut adalah file `.gitlab-ci.yml` yang kita perlu update seperti berikut:

{% gist page.gist "12g-gitlab-ci.testing.yml" %}

Jika sudah seperti biasa, kita commit dan push dan yang terkahir kita buat tagnya kemudian kita check pipelinenya:

![test-laravel-pipeline]({{ page.image_path | prepend: site.baseurl }}/06-test-laravel-pipeline.png)

Jika sudah selesai kita bisa check test unitnya seperti berikut:

![test-laravel-tests-status]({{ page.image_path | prepend: site.baseurl }}/07-test-laravel-test-status.png)

## Build Pipeline source-code to site webapp resources

Setelah kita success melakukan unit/integration testing tahap selanjutnya adalah kita akan build source-code menjadi site webapp resources kemudian kita buat Gitlab archive as artifact, Seperti biasanya kita update file `.gitlab-ci.yml` seperti berikut:

{% gist page.gist "12g-gitlab-ci.build-laravel.yml" %}

Jika sudah sekarang, kita commit, push dan buat tag baru lalu kita check status pipelinenya seperti berikut:

![build-laravel-pipeline-status]({{ page.image_path | prepend: site.baseurl }}/08-build-laravel-pipeline-status.png)

Jika sudah selesai, kita bisa check job detailnya seperti berikut:

![build-laravel-job-detail]({{ page.image_path | prepend: site.baseurl }}/09-build-laravel-pipeline-job-detail.png)

Dan yang terakhir, kita bisa check Gitlab archive as artifact maka hasilnya seperti berikut:

![build-laravel-gitlab-artifact]({{ page.image_path | prepend: site.baseurl }}/10-build-laravel-artifact.png)

## Build docker image

Setelah kita build source-code menjadi Gitlab Archive as artifact, sekarang kita akan build docker image berdasarkan artifact tersebut. tpi sebelum itu kita modifikasi file `Dockerfile` untuk menyesuaikan worklow dengan Gitlab CI.

Jadi yang kita gunakan adalah stage untuk mencopy dari Gitlab archive as artifact ke Docker image. Nah supaya kita tidak menyinggung tutorial sebelumnya kita akan buat file baru dengan nama `Dockerfile-run` seperti berikut:

{% gist page.gist "12g-dockerfile-build-run" %}

Selanjutnya kita modifkasi file `.gitlab-ci.yml` seperti berikut:

{% gist page.gist "12g-gitlab-ci.build-docker.yml" %}

Nah sekarang seperti biasa kita commit, push dan buat tag baru. Kemudian kita check status pipelinenya seperti berikut:

![build-docker-pipeline-status]({{ page.image_path | prepend: site.baseurl }}/11-build-docker-pipeline-status.png)

Jika sudah selesai, kita bisa check job detailnya seperti berikut:

![build-docker-pipeline-job-detail]({{ page.image_path | prepend: site.baseurl }}/12-build-docker-job-detail.png)

Dan yang terakhir kita check apakah docker image sudah ada di Nexus OSS seperti berikut:

![nexus-oss]({{ page.image_path | prepend: site.baseurl }}/13-docker-image-pushed.png)

## Test run containers

Ok setelah kita berhasil publish docker imagenya menggunakan Gitlab CI, sekarang kita akan test containernya menggunakan docker-compose, Sekarang kita buat file `docker-compose.ci.yaml` seperti berikut:

{% gist page.gist "12g-docker-compose.ci-yaml" %}

Dan berikut adalah file `.env.ci`

{% gist page.gist "12g-env.ci-yaml" %}

Jika kita running menggunakan perintah 

{% highlight bash %}
docker-compose -f docker-compose.ci.yaml --env-file .env up -d
docker-compose -f docker-compose.ci.yaml --enf-file .env exec laravel php artisan migrate
{% endhighlight %}

Maka hasilnya seperti berikut:

```powershell
dimasm93@gitlab-runner01:~$ docker-compose -f docker-compose.ci.yaml --env-file .env up -d
Starting dimasm93_mysql_1 ... done
Starting dimasm93_laravel_1 ... done

dimasm93@gitlab-runner01:~$ docker-compose -f docker-compose.ci.yaml --env-file .env ps
       Name                     Command               State                   Ports
----------------------------------------------------------------------------------------------------
dimasm93_laravel_1   docker-php-entrypoint .doc ...   Up      0.0.0.0:80->80/tcp,:::80->80/tcp
dimasm93_mysql_1     docker-entrypoint.sh mysqld      Up      0.0.0.0:3306->3306/tcp,:::3306->3306/t
                                                              cp, 33060/tcp

dimasm93@gitlab-runner01:~$ curl localhost
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Laravel</title>
    <link href="/css/app.css" rel="stylesheet"/>
    <script src="/js/app.js"></script>
</head>
<body class="antialiased">

<div class="container">

    <p>jQuery not work!!! enable JS now</p>

    <h3>Daftar Mahasiswa</h3>
    <table id="mahasiswaList" class="table table-bordered table-striped dataTable">
        <thead>
        <tr>
            <td>No</td>
            <td>NIM</td>
            <td>Nama</td>
            <td>Email</td>
            <td>Semester</td>
        </tr>
        </thead>
    </table>

</div>

<script>
    $(document).ready(function () {
        $('p').html('jQuery works!');
        $('#mahasiswaList').DataTable({
            ajax: '/api/mahasiswa',
            columns: [
                {data: 'id'},
                {data: 'nim'},
                {data: 'name'},
                {data: 'email'},
                {data: 'semester'}
            ]
        });
    });
</script>
</body>
</html>
```

Jika kita coba dari browser maka hasilnya seperti berikut:

![test-container]({{ page.image_path | prepend: site.baseurl }}/14-tested-container.png)
