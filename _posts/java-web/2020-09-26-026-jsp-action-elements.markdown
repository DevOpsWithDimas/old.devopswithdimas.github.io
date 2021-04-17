---
layout: post
title: "JSP Action Element"
date: 2020-09-26T20:32:06+07:00
lang: java-web
categories:
- java
- web
- war
refs: 
- https://docs.oracle.com/cd/B14099_19/web.1012/b14014/genlovw.htm#directives
- https://docs.oracle.com/cd/B14099_19/web.1012/b14014/jspnls.htm
youtube: CDTnXtjCHWM
comments: true
gist: dimMaryanto93/c0a51e92e23ada4ecb71f9c18c803fea
image_path: /resources/posts/java-web/java-web-022
downloads: []
---

JSP Action digunakan untuk meng-control servlet melalui XML syntax, contohnya seperti berikut:

{% gist page.gist "scriptlet-action-usebean.jsp" %}

berikuat kelas `Mahasiswa` yang di panggil dalam jsp tersebut:

{% highlight java linenos %}
package com.maryanto.dimas.bootcamp.entity;

import lombok.Data;

import java.sql.Date;

@Data
public class Mahasiswa {

    private String nim;
    private String namaLengkap;
    private Date tanggalLahir;
}
{% endhighlight %}