---
layout: post
title: "Install PostgreSQL for Mac users"
date: 2022-02-03T03:40:43+07:00
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/download/
- https://bitnami.com/stack/postgresql
- https://www.percona.com/software/postgresql-distribution
youtube: 
image_path: /resources/posts/postgresql/02a-install-postgres-mac
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: getting-started
downloads: 
- name: "schema-hr"
  type: "sql"
  url: /resources/downloads/file/postgresql/psql-schema.sql
---

Hai semuanya, di materi kali ini kita akan membahas Install PostgreSQL di Mac OS. Diantaranya

1. Install PostgreSQL Server for learning environment
2. Test connection to PostgreSQL
3. Create user & database for learning environment

Ok langsung aja kita bahas ke materi yang pertama

## Install PostgreSQL Server for learning environment

Untuk meng-Install PostgreSQL di Mac OS kita bisa menggunakan beberapa cara yaitu 

1. Installer
    1. [EnterpriceDB](https://www.enterprisedb.com/)
    2. [Bitnami PostgreSQL](https://bitnami.com/tag/postgresql)
    3. [Percona Distribution for PostgreSQL](https://www.percona.com/software/postgresql-distribution)
    4. Dan masih banyak lagi
2. Package manager (Homebrew, MacPors, Fink, etc)
3. Compile from source 

Untuk lebih detailnya bisa check official documentation PostgreSQL for Mac [berikut](https://www.postgresql.org/download/macosx/). Karena tujuan kita adalah untuk belajar atau Learning environtment maka kita bisa manfaatkan yang free dan opensource seperti Official distribution. Ok langsung ja kita download dulu installernya dari [Official distribution](https://www.enterprisedb.com/software-downloads-postgres)

Setelah itu pilih platform yang sesuai dengan Operation System yang kita gunakan misalnya Mac OS X dan pake versi yang terbaru saja in my case version `v14.1`. Untuk mendownload membutuhkan account jika belum punya kita bisa register saja.

![macos-installer]({{ page.image_path | prepend: site.baseurl }}/00-installer.png)

kemudian kita jalankan file `.dmg` maka akan muncul welcome page seperti berikut:

![welcome]({{ page.image_path | prepend: site.baseurl }}/01-welcome.png)

Kemudian klik **Next** untuk melanjutkan, setelah itu maka akan muncul form untuk lokasi installation seperti berikut:

![location-dir-install]({{ page.image_path | prepend: site.baseurl }}/02-installation-dir.png)

Kemudian kita pilih lokasi install untuk PostgreSQL, klo saya **biarkan aja default** seperti itu, Klik **Next** lalu maka akan muncul lagi form seperti berikut:

![components]({{ page.image_path | prepend: site.baseurl }}/03-components.png)

Nah kita tinggal pilih SQL Editornya, klo saya udah terbiasa dengan menggunakan `pgAdmin4` dan `command-line` jadi saya cheklist seperti gambar diatas, Kemudian klik **Next** untuk menanjutkan:

![data-location]({{ page.image_path | prepend: site.baseurl }}/04-data-location.png)

Setelah itu akan muncul form untuk menyimpan data seperti gambar diatas, konfigurasi ini biarkan default aja atau temen-temen juga bisa simpan di partisi lain jika partisin default terlalu kecil. langsung klik **Next**. setelah ikut akan tampil form seperti berikut:

![postgres-password]({{ page.image_path | prepend: site.baseurl }}/05-postgres-password.png)

Nah di form ini kita diminta untuk memasukan **password default untuk schema postgres**. User postgres ini adalah superuser yang bertujuan untuk membuat user baru, database, dan objek-objek lain di Database Management Sistemnya PostgreSQL. Jadi saran saya **gunakan password yang mudah di ingat** contohnya `admin`, nama-anda atau lain-lain. klo saya passwordnya `admin`. Setelah password di isi kita klik **Next** untuk melanjutkan:

![postgres-port]({{ page.image_path | prepend: site.baseurl }}/06-postgres-port.png)

Nah di form ini juga kita **diminta untuk input port** yang digunakan untuk PostgreSQL Server berkomunikasi dengan client melalu exposed port, kalau saya biarkan default yaitu `5432` kemudian **Next** untuk menampilkan konfirmasi atas konfigurasi yang udah di setup barusan maka formnya seperti berikut:

![summary]({{ page.image_path | prepend: site.baseurl }}/08-summary.png)

Kemudian kita clik **Install** maka akan melakukan installing component yang sudah di pilih seperti berikut:

![install]({{ page.image_path | prepend: site.baseurl }}/09-installing.png)

Jika sudah selesai maka seperti berikut:

![finish]({{ page.image_path | prepend: site.baseurl }}/10-finish.png)

## Test connection to PostgreSQL

Untuk melakukan testing login ada 2 cara yaitu dengan menggunakan terminal dan juga tools yang telah kita tambahkan tadi yaitu `pgAdmin4`. sekarang kita coba dulu login dengan `psql` maka gunakan perintah seperti berikut:

{% highlight bash %}
psql -h localhost -U postgres -W
{% endhighlight %}

jika berhasil login maka tampilannya seperti berikut:

![psql]({{ page.image_path | prepend: site.baseurl }}/11-psql.png)

Selain itu juga kita bisa menggunakan `pgAdmin4`

Secara default jika kita install menggunakan EDB serta mengaktfikan pgAdmin4 dan Server di hosts yang sama kita sudah di register. kita tidak perlu register lagi kita cukup click Servers dan connect PostgreSQL 14 dan input password untuk user postgres maka hasilnya seperti berikut:

![pgadmin4]({{ page.image_path | prepend: site.baseurl }}/12-pgadmin4.png)

## Create user & database for learning environment

Setelah melakukan proses installasi _software_ PostgreSQL Server dan `PgAdmin4`, tahap selanjutnya kita akan membuat scema atau role, berikut adalah caranya.

Login sebagai user `postgres`, yang pertama harus di ingat adalah _password_ postgres didapatkan ketika melakukan installasi software PostgreSQL. setelah itu baru bisa login sebagai user postgres dengan cara seperti berikut:

{% gist page.gist "login-postgres.bash" %}

Kemudian kita buat schema dengan perintah seperti berikut:

{% gist page.gist "create-database-hr.sql" %}

Setelah membuat user dengan _username_ `hr` dan passwornya sama dengan _username_ yaitu `hr`, tahap selanjutnya kita login sebagai user `hr`, dengan perintah seperti berikut:

{% highlight psql %}
psql -h localhost -U hr -W
{% endhighlight %}

Setelah login sebagai `hr` kemudian kita buat satu database dengan nama yang sama dengan username, dengan perintah seperti berikut:

{% gist page.gist "create-database-hr.bash" %}

Setelah database terbuat, kemudian download [file ini]({{ site.baseurl }}/resources/downloads/file/psql-schema.sql) setelah itu import file sql tersebut ke database `hr` dengan perintah seperti berikut:

{% highlight psql %}
psql -h localhost -d hr -U hr -W -f .\psql-schema.sql
{% endhighlight %}

Kemudian kita check dengan cara login menggunakan user dan database `hr` perintah seperti berikut:

{% highlight psql %}
psql -h localhost -d hr -U hr -W
{% endhighlight %}

Kemudian check datanya dengan perintah seperti berikut:

{% highlight psql %}
\dt

select count(*) from employees;
{% endhighlight %}

Jika sudah, selamat anda sudah sukses dan siap untuk mulai belajar Database PostgreSQL Fundamental.