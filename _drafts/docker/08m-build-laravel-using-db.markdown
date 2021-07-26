---
layout: post
title: "Study Kasus: Laravel - Using Database"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/
- https://laravel.com/docs/8.x/database
- https://laravel.com/docs/8.x/queries
- https://laravel.com/docs/8.x/migrations
- https://laravel.com/docs/8.x/seeding#introduction
- https://laravel.com/docs/8.x/controllers#introduction
- https://laravel.com/docs/8.x/queries#introduction
youtube: 
comments: true
image_path: /resources/posts/docker/08m-laravel-db
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, di materi study kasus kali ini kita akan membahas tentang menggunakan Database pada project Laravel. Diantaranya 

1. Setup and Configure connection to Database
2. Database: Migration
3. Basic CRUD using fluent query builder
4. Deploy Manualy ke Server
5. Build & Running Docker Image
6. Cleanup

Ok langsung aja kita ke pembahasan yang pertama 

## Setup and Configure connection to Database

Almost every modern web application interacts with a database. Laravel makes interacting with databases extremely simple across a variety of supported databases using raw SQL, a fluent query builder, and the Eloquent ORM. Currently, Laravel provides first-party support for four databases:

1. MySQL `5.7+`
2. PostgreSQL `9.6+`
3. SQLite `3.8.8+`
4. SQL Server `2017+`

Sebagai study kasus kali ini kita akan menggunakan database [MySQL 5.7](https://hub.docker.com/_/mysql) yang akan saya jalankan menggunakan docker seperti berikut:

For Bash script:

{% gist page.gist "08m-docker-mysql-run.bash" %}

For Powershell script:

{% gist page.gist "08m-docker-mysql-run.ps1" %}

The configuration for Laravel's database services is located in your application's `config/database.php` configuration file. Most of the configuration options within this file are driven by the values of your application's environment variables

Kita edit file `.env` menjadi seperti berikut:

{% highlight .env %}
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=docker_laravel
DB_USERNAME=docker_laravel
DB_PASSWORD=docker_laravel
{% endhighlight %}

Setelah itu kita bisa check connectionnya menggunakan perintah 

{% highlight bash %}
php artisan migrate:install && \
php artisan migrate:status && \
php artisan migrate
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ docker-laravel git:(master) php artisan migrate:install
Migration table created successfully.

➜ docker-laravel git:(master) php artisan migrate:status
+------+------------------------------------------------+-------+
| Ran? | Migration                                      | Batch |
+------+------------------------------------------------+-------+
| No   | 2014_10_12_000000_create_users_table           |       |
| No   | 2014_10_12_100000_create_password_resets_table |       |
| No   | 2019_08_19_000000_create_failed_jobs_table     |       |
+------+------------------------------------------------+-------+

➜ docker-laravel git:(master) php artisan migrate
Migrating: 2014_10_12_000000_create_users_table
Migrated:  2014_10_12_000000_create_users_table (34.42ms)
Migrating: 2014_10_12_100000_create_password_resets_table
Migrated:  2014_10_12_100000_create_password_resets_table (26.96ms)
Migrating: 2019_08_19_000000_create_failed_jobs_table
Migrated:  2019_08_19_000000_create_failed_jobs_table (28.19ms)

➜ docker-laravel git:(master) php artisan migrate:status
+------+------------------------------------------------+-------+
| Ran? | Migration                                      | Batch |
+------+------------------------------------------------+-------+
| Yes  | 2014_10_12_000000_create_users_table           | 1     |
| Yes  | 2014_10_12_100000_create_password_resets_table | 1     |
| Yes  | 2019_08_19_000000_create_failed_jobs_table     | 1     |
+------+------------------------------------------------+-------+
```

Dengan konfigurasi seperti berikut, kita sudah bisa connect antara PHP Laravel dengan Database MySQL v5.7

## Database: Migration

Migrations are like version control for your database, allowing your team to define and share the application's database schema definition.  The new migration will be placed in your `database/migrations` directory. Each migration filename contains a timestamp that allows Laravel to determine the order of the migrations:

{% highlight bash %}
php artisan make:migration create_mahasiswa_table
{% endhighlight %}

Seperti berikut

{% gist page.gist "08m-create_mahasiswa_table.php" %}

Selanjutnya kita akan mengisi table `mahasiswa` menggunakan Seeder, untuk membuat seeder kita bisa menggunakan perintah seperti berikut:

{% highlight bash %}
php artisan make:seeder MahasiswaSeeder
{% endhighlight %}

Seperti berikut:

{% gist page.gist "08m-mahasiswa-seeder.php" %}

Dan kita edit file `database/seeders/DatabaseSeeder.php` seperti berikut:

{% gist page.gist "08m-database-seeder.php" %}

Selanjutnya kita jalankan perintah berikut:

{% highlight bash %}
php artisan migrate --seed
{% endhighlight %}

Kemudian coba check data di table `mahasiswa`, sekarang memiliki data seperti berikut contohnya:

![migrate-seeder]({{ page.image_path | prepend: site.baseurl }}/migrate-seeder.png)

Ok sekarang kita sudah success membuat database migration

## Basic CRUD using fluent query builder

Setelah kita setup connection dan membuat migration table, sekarang kita buat simple CRUD yang di expose lewat Rest API. Sekarang kita buat controller baru menggunakan perintah seperti berikut:

{% highlight bash %}
php artisan make:controller MahasiswaDbController
{% endhighlight %}

Seperti berikut:

{% gist page.gist "08m-mahasiswa-db-controller.php" %}

Kemudian tambahkan config route seperti berikut pada file `routes/api.php`:

{% gist page.gist "08m-route-api.php" %}

Untuk melakukan testing kita buat file `tests/MahasiswaDbControler.http` seperti berikut:

{% gist page.gist "08m-mahasiswa-db-controller.http" %}

Setelah semuanya berjalan dengan baik, sekarang kita bisa buat UInya dengan membuat file pada folder `resources/views` misalnya dengan nama `mahasiswa.blade.php` seperti berikut:

{% gist page.gist "08m-mahasiswa-blade.php" %}

Tambahkan juga dependency pada client yaitu `jquery-serializejson` dengan perintah seperti berikut:

{% highlight bash %}
npm install --save jquery-serializejson && \
npm run-script dev
{% endhighlight %}

Dan yang terakhir tambahakan route untuk viewnya pada file `routes/web.php` seperti berikut:

{% gist page.gist "08m-route-mahasiswa-blade.php" %}

Jika dijalankan dengan perintah seperti berikut:

{% highlight bash %}
php artisan serve
{% endhighlight %}

Kemudian akses dari browser dengan alamat [localhost:8000/db](http://localhost:8000/db) maka hasilnya seperti berikut:

![laravel-db]({{ page.image_path | prepend: site.baseurl }}/laravel-db-local.png)

## Deploy Manualy ke Server

Setelah kita mendevelop feature CRUD ke Database MySQL di local kita, sekarang kita akan deploy ke Server. Jadi workflownya 

1. Install Database MySQL
2. Create User & Database
3. Upload source-code terbaru ke folder `/var/www/php`
4. Update configuration `.env`
5. Install PHP Extension `mysqli`, `pdo_mysql`
6. Jalankan perintah `php artisan migrate`
7. Jalankan perintah `npm install && npm run-script prod && rm -rf node_modules`
8. Restart service `apache2`

Untuk installasi MySQL Database kita bisa install manual atau menggunakan Docker, jadi supaya simple kita buat di docker aja dengan menggunakan perintah yang tadi yaitu seperti berikut:

{% gist page.gist "08m-docker-mysql-run.bash" %}

Setelah itu install PHP Extension untuk module `mysql-client` dan `pdo_mysql` seperti berikut perintahnya:

{% highlight bash %}
export PHP_VERSION=8.0

apt install -y php${PHP_VERSION}-mysql mysql-client && \
systemctl restart apache2
{% endhighlight %}

Kemudian kita upload source-code terbaru dengan menggunakan perintah:

{% highlight bash %}
scp -r * username@your-server.hostname:/var/www/php
{% endhighlight %}

Setelah itu kita install kita lakukan migrate mengunakan perintah 

{% highlight bash %}
npm install && \
npm run-script prod && \
rm -rf node_modules && \
php artisan migrate --force
{% endhighlight %}

Sekarang kita bisa coba akses, hasilnya seperti berikut:

![laravel-db-server]({{ page.image_path | prepend: site.baseurl }}/laravel-db-server.png)