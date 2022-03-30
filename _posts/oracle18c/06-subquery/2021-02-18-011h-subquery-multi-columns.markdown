---
layout: post
title: "Pairwise Sub Query di Oracle"
date: 2021-02-18T19:44:23+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
youtube: c7SRJ_JQ3mI
comments: true
catalog_key: sql-subquery
image_path: /resources/posts/oracle12c/011g-subquery-multi-columns
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Selain Multiple Rows, kita juga bisa menggunakan Multiple Columns atau biasanya disebut pairwise subquery. tapi disini jumlah column predicate harus sama dengan jumlah column yang ada di inner query, berikut adalah contoh penggunaannya:

{% gist page.gist "011h-subquery-pairwise.sql" %}

Berikut hasilnya:

{% highlight sql %}
EMPLOYEE_ID FIRST_NAME               SALARY
----------- -------------------- ----------
        198 Donald                     2600
        199 Douglas                    2600
        180 Winston                    3200
        181 Jean                       3100
        182 Martha                     2500
        183 Girard                     2800
        184 Nandita                    4200
        185 Alexis                     4100
        186 Julia                      3400
        187 Anthony                    3000
        188 Kelly                      3800
        138 Stephen                    3200
        139 John                       2700
        140 Joshua                     2500
        141 Trenna                     3500
        142 Curtis                     3100
        143 Randall                    2600
        144 Peter                      2500

51 rows selected.
{% endhighlight %}