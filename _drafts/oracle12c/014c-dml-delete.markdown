---
layout: post
title: "DML - Delete Statement di Oracle"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
- https://docs.oracle.com/en/bigdata/index.html
youtube: 
comments: true
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Perintah delete data, biasanya kita gunakan untuk menghapus data dari table tertentu dengan / tanpa menggukanan where klausa.

Format penulisan delete statement yaitu seperti berikut:

```sql
DELETE FROM table_name 
WHERE column_key = <valueKey>
```

Contoh penggunaanya adalah sebagai berikut, contohnya saya mau menghapus data yang telah saya insert tadi, yaitu dengan `region_id = 5`, maka berikut querynya:

{% gist page.gist "014c-dml-delete.sql" %}

berikut hasilnya:

{% highlight sql %}
-- data awal
SQL> select * from regions;

 REGION_ID REGION_NAME
---------- -------------------------
        15 Asia Tengara
         1 Europe
         2 Americas
         3 Asia
         4 Middle East and Africa

-- execute delete by region_id
SQL> delete from regions
where region_id = 15;  2

1 row deleted.

-- data setelah di hapus
SQL> select * from regions;

 REGION_ID REGION_NAME
---------- -------------------------
         1 Europe
         2 Americas
         3 Asia
         4 Middle East and Africa
{% endhighlight %}

**Note** 

1. jika kita tidak menggunakan where klausa, maka semua data akan terhapus!!
2. Jika kita menghapus data tapi masih ada relasi ke tabel lain (foreign key constrant) biasanya akan muncul error seperti berikut:
    ```sql
    ERROR at line 1: ORA-02292: integrity constraint (HR.COUNTR_REG_FK) violated - child record
found
    ```