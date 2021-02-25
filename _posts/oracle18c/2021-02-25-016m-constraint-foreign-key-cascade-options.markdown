---
layout: post
title: "DDL - Foreign Key Constraint dengan Options"
date: 2021-02-25T19:37:07+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/21/sqlrf/constraint.html#GUID-1055EA97-BA6F-4764-A15F-1024FD5B6DFE
- https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:5773459616034
youtube: 
comments: true
image_path: /resources/posts/oracle12c/016m-constraint-foreign-key-cascade-options
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Sebuah `foreign-key` digunakan untuk `maintanance data integrity` the problem is gimana klo kita hapus dari tabel yang menjadi acuan kita terus gimana nasibnya? invalid relation?

Nah secara default, kita gak bisa update primary-key value yang udah digunakan karena secara default oracle menerapkan `option restrictions` contohnya seperti berikut:

{% highlight sql %}
SQL> delete
from TEST_FK_MASTER_TABLE
where ID = 'prog';

ERROR at line 1:
ORA-02292: integrity constraint (HR.FK_DETAIL_MASTER_ID) violated - child
record found
{% endhighlight %}

Sebagai solusinya ada trigger yang kita bisa gunakan yaitu

`on delete`, perintah ini dijalankan ketika query `delete` di execute yang memiliki constraint foreign key dan me-referensi ke table pada kolom tersebut yang harus digabungkan dengan option sebagai berikut:

1. `set null`
2. `cascade` 

Ok sekarang kita siapkan dulu table masternya seperti berikut:

{% gist page.gist "016m-test-constraint-fk-option.sql" %}

## Set Null

Dengan menggunakan `set null`, begitu data di table master di hapus tetapi masih memiliki relasi maka **automatis nilainya akan di set null** seperti berikut:

{% gist page.gist "016m-test-constraint-fk-option-set-null.sql" %}

Sekarang coba execute perintah delete berikut:

{% highlight sql %}
delete
from test_constraint_fk_options
where id = 'rnd';
{% endhighlight %}

Maka hasilnya seperti berikut:

{% highlight sql %}
SQL> delete
from test_constraint_fk_options
where id = 'rnd';

1 row deleted.

SQL> select * from test_constraint_fk_options_set_null;

ID         FIRST_NAME      MASTER_ID  SALARY
---------- --------------- ---------- ----------
01         Dimas Maryanto  <null>     9000
02         Muhamad Yusuf   prog       8000
{% endhighlight %}

## Cascade

Dengan menggunakan `cascade`, begitu data di table master di hapus tetapi masih memiliki relasi maka **automatis akan dihapus** juga pada baris yang memiliki constraint tersebut, sebagai contoh berikut adalah querynya:

{% gist page.gist "016m-test-constraint-fk-option-cascade.sql" %}

Sekarang coba execute perintah delete berikut:

{% highlight sql %}
delete from test_constraint_fk_options
where id = 'arch';
{% endhighlight %}

Maka hasilnya seperti berikut:

{% highlight sql %}
SQL> select * from test_constraint_fk_options_cascade;

ID         FIRST_NAME       MASTER_ID    SALARY
---------- ---------------------------  ----------
01         Dimas Maryanto   arch        9000
02         Muhamad Yusuf    prog        8000


SQL> delete from test_constraint_fk_options
where id = 'arch';

1 row deleted.

SQL> select * from test_constraint_fk_options_cascade;

ID         FIRST_NAME       MASTER_ID    SALARY
---------- ---------------- ----------   ----------
02         Muhamad Yusuf    prog         8000
{% endhighlight %}