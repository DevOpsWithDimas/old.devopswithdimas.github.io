---
layout: post
title: "DDL - Purge Table & Recyclebin"
date: 2021-02-23T19:22:07+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/PURGE.html#GUID-9257F773-E019-4464-80F4-F5AB61D7D9B6
youtube: pcu-CX2CScs
comments: true
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Mulai dari Oracle 10g, Oracle mengenalkan feature Recyclebin dalam enginenya. jadi ketika kita menghapus object database dengan perintah drop, maka object tersebut akan dipindahkan ke recyclebin sebelum dihapus secara permanent.

Ok langsung ja, kita coba buat table dengan perintah berikut:

{% gist page.gist "016f-init-table-to-purge.sql" %}

Setelah di execute, kemudian di `commit`. Maka hasilnya seperti berikut:

{% highlight sql %}
SQL> select kode, nama from need_to_drop;

      KODE NAMA
---------- --------------------------------------------------
         1 Dimas Maryanto
         2 Muhamad Yusuf
{% endhighlight %}

Sekarang coba drop tablenya dengan perintah berikut:

{% gist page.gist "016f-drop-table.sql" %}

Sekarang coba periksa dictionary view, `recyclebin` dengan perintah berikut:

{% gist page.gist "016f-select-recyclebin.sql" %}

Berikut hasilnya:

{% highlight sql %}
SQL> select OBJECT_NAME, ORIGINAL_NAME, OPERATION, TYPE from RECYCLEBIN;

OBJECT_NAME                       ORIGINAL_NAME          OPERATION TYPE
--------------------------------- ---------------------- --------- ------------------
BIN$vAC1YpxjAkfgUwIAEqz5tA==$0    NEED_TO_DROP           DROP      TABLE
{% endhighlight %}

Sekarang klo kita mau liat dulu datanya masih ada atau tidak sekarang kita coba perintah berikut:

{% highlight sql %}
SQL> select kode, nama
from "BIN$vAC1YpxjAkfgUwIAEqz5tA==$0";

      KODE NAMA
---------- --------------------------------------------------
         1 Dimas Maryanto
         2 Muhamad Yusuf
{% endhighlight %}

## Mengembalikan table yang telah di drop

Jika kita ingin mengembalikan table dari recyclebin, Berikut perintahnya:

{% gist page.gist "016f-flashback-from-recyclebin.sql" %}

Berikut hasilnya:

{% highlight sql %}
SQL> flashback table need_to_drop to before drop ;

Flashback complete.

SQL> select OBJECT_NAME, ORIGINAL_NAME, OPERATION, TYPE
from RECYCLEBIN;

no rows selected

SQL> select TABLE_NAME, STATUS, READ_ONLY
from USER_TABLES
where TABLE_NAME = 'NEED_TO_DROP';

TABLE_NAME                   STATUS   REA
---------------------------- -------- ---
NEED_TO_DROP                 VALID    NO

{% endhighlight %}

## Menghapus secara permanet

Untuk menghapus secara permanent, kita bisa menggunakan keyword `purge` seperti berikut:

{% gist page.gist "016f-purge-recyclebin.sql" %}

berikut hasilnya:

{% highlight sql %}
SQL> purge recyclebin;

Recyclebin purged.
{% endhighlight %}

atau klo misalnya menghapus table secara permanent tanpa dipindahkan lebih dulu ke recyclebin gunakan perintah berikut:

{% gist page.gist "016f-drop-table-purge-option.sql" %}