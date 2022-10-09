---
layout: post
title: "Prepared Statement in SQL"
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
- SQL
- DML
refs: 
- https://www.postgresql.org/docs/14/sql-prepare.html
youtube: 
image_path: /resources/posts/postgresql/05e-dml-prepared-statement
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: dml-statement
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Prepared Statement pada SQL, feature ini biasanya hanya bisa digunakan pada Bahasa Pemograman yang menggunakan API seperti [JDBC](https://docs.oracle.com/en/java/javase/13/docs/api/java.sql/java/sql/PreparedStatement.html) di Java, [pdo](https://www.php.net/manual/en/pdo.prepared-statements.php) di PHP dan lain-lain, Nah tetapi di PostgreSQL Database kita bisa terapkan secara directly pada query SQL baik untuk select, insert, update dan delete. Perintah sqlnya seperti berikut:

{% highlight sql %}
PREPARE name [ ( data_type [, ...] ) ] AS statement
{% endhighlight %}

Dan untuk menjalankan perintanya kita bisa menggunakan perintah seperti berikut:

{% highlight sql %}
EXPLAIN EXECUTE name(parameter_values);
{% endhighlight %}

Jadi dengan kita mendefined prepared query tersebut, kita bisa meng-execute multiple times dengan parameter yang berbeda. Pada implemetasinya kita bisa gunakan untuk:

1. Create input parameterized with text editor
2. Create a Prepared statement for INSERT, UPDATE, DELETE
3. Execute multiple times a Prepared statement
4. Show all prepared statement
5. Remove prepared statement from a session.

Ok tanpa berlama-lama kita bahas kemateri yang pertama:

<!--more-->

Materi: 

1. Topic1
2. Topic2
    1. Topic 2.a
    2. Topic 2.b
3. Topic 3
4. Topic 4