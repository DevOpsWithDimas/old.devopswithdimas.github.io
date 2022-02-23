---
layout: post
title: "Basic SQL Select statements"
date: 2022-02-24T06:05:06+07:00
lang: postgresql
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/current/
youtube: 
image_path: /resources/posts/postgresql/03a-basic-select-statement
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: sql-statements
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Basic penggunaan SQL untuk Select statement pada PostgreSQL. Diantaranya yang akan kita bahas yaitu

1. Format penulisan Select statement
2. Menampilkan semua data dalam sebuah _table_
3. Menampilkan hanya beberapa _columns_ pada sebuah _table_
4. Memberikan alias pada suatu _column_

Ok langsung saja kita bahas materi yang pertama

## Format penulisan Select statement

To retrieve data from a table, the table is queried. An SQL `SELECT` statement is used to do this. The statement is divided into a select list (the part that lists the columns to be returned), a table list (the part that lists the tables from which to retrieve the data), and an optional qualification (the part that specifies any restrictions). 

{% highlight sql linenos %}
select 
     * | columns...  
from 
    table_name | tables... (separated by comma)
[where condition]
{% endhighlight %}

Contohnya di _database_ `hr` sekarang saya punya daftar _tables_ seperti berikut:

{% highlight postgresql-console %}
hr=# \dt
 public | countries    | table | hr
 public | departments  | table | hr
 public | employees    | table | hr
 public | job_history  | table | hr
 public | jobs         | table | hr
 public | locations    | table | hr
 public | regions      | table | hr
{% endhighlight %}

Jadi kita bisa pilih salah satu tabelnya contohnya `departments` maka SQL Query select statemenya seperti berikut:

{% highlight sql linenos %}
select * from departments;
{% endhighlight %}

## Menampilkan semua data dalam sebuah _table_

Untuk menampilkan semua data untuk semua column yang dipilih dalam sebuah tabel kita bisa menggunakan spesial karakter `*` (asteric / bintang) dalam perintah _select_ seperti berikut:

{% gist page.gist "03a-select-all-departments.sql" %}

Maka akan tampil datanya seperti berikut:

| dep_id | department_name     | manager_id | location_id |
| :--   | :------------        | :----      |  :--- |
|   10  | Administration       |        200 |  1700 |
|   40  | Human Resources      |        203 |  2400 |
|   50  | Shipping             |        121 |  1500 |
|   60  | IT                   |        103 |  1400 |
|   90  | Executive            |        100 |  1700 |
{:.table .striped .bordered }

## Menampilkan semua data pada beberapa _columns_ pada sebuah _table_

Selain menggunakan `*` untuk menampikan semua kolom pada tabel tersebut, kita juga bisa sebutkan nama kolomnya. Tapi yang harus kita ketahui dulu adalah nama kolomnya pada table tersebut. kita bisa menggunakan perintah seperti berikut:

{% highlight postgresql-console %}
hr=# \dt departments
 department_id   | integer               | not null default nextval('departments_department_id_seq'::regclass)
 department_name | character varying(30) | 
 manager_id      | integer               | 
 location_id     | integer               | 
{% endhighlight %}

Nah jadi kita punya column `department_id`, `department_name`, `manager_id`, dan `location_id` jadi kita bisa pilih atau semuanya seperti berikut:

{% gist page.gist "03a-select-all-columns-departments.sql" %}

Atau 

{% gist page.gist "03a-select-only-selected-columns-departments.sql" %}

Jika dijalankan maka hasilnya seperti berikut:

| department_id | department_name       |
| :--           | :------------         |
|   10          | Administration        |
|   40          | Human Resources       |
|   50          | Shipping              |
|   60          | IT                    |
|   90          | Executive             |
{:.table .striped .bordered }

## Memberikan alias pada suatu _column_

Secara _default_ kalau kita melakukan perintah `select` terhadap suatu _table_ contohnya misalnya `departments`, di _table_ `departments` terdiri dari _columns_ `department_id, department_name, manager_id, location_id` jika saya melakukan perintah `select` seperti berikut hasilnya:

| dep_id | department_name     | manager_id | location_id |
| :--   | :------------        | :----      |  :--- |
|   10  | Administration       |        200 |  1700 |
|   40  | Human Resources      |        203 |  2400 |
|   50  | Shipping             |        121 |  1500 |
|   60  | IT                   |        103 |  1400 |
|   90  | Executive            |        100 |  1700 |
{:.table .striped .bordered }

Dengan menggunakan _column alias_ kita bisa memberikan nama kolomnya sesuai yang kita inginkan, Aturan penamaan variable atau kolom alias, diantaranya:

1. Menggunakan keyword `as` dan tanpa `as`, tidak boleh menggunakan charakter khusus seperti **SPACE**, **HashTag**, **Dolar** dan lain-lain, karakter yang **diperbolehkan** yaitu **huruf, angka, dan underscore**. Ini karena dengan menggunakan _column alias_ tersebut nantinya bisa digunakan sebagai variable untuk melakukan _ordering_.
2. Diapit menggunakan double quote `"`, Diperbolehkan bebas karena hanya akan di jadikan sebagai label saja.

Seperti berikut contohnya:

{% gist page.gist "03a-select-alias-column-department.sql" %}

Jika dijalankan hasilnya seperti berikut:

{% highlight postgresql %}
kode_department |   nama_deparment     | Kode Manager | 
----------------+----------------------+------------+
            300 | System Analis        |            |
             10 | Administration       |        200 |
             20 | Marketing            |        201 |
             30 | Purchasing           |        114 |
             40 | Human Resources      |        203 |
             50 | Shipping             |        121 |
             60 | IT                   |        103 |
{% endhighlight %}