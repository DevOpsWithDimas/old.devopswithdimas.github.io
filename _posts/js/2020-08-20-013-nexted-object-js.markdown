---
layout: post
title: "Nested Object in Javascript"
date: 2020-08-20T16:48:23+07:00
lang: js
authors:
- dimasm93
categories:
- web
- js
refs: 
- https://developer.mozilla.org/en-US/docs/Web/JavaScript
youtube: 
comments: true
gist: dimMaryanto93/b956151354fb8a1454d3b36d22d61a63
downloads: []
---

Kita sekarang akan membahas object dalam object kemudian mengaksesnya contohnya seperti berikut:

{% gist page.gist "obj-2.js" %}

Jadi cara membuat object dalam object seperti berikut:

{% highlight js %}
{
  "key" : {
    "key" : "value"
  }
}
{% endhighlight %}

dan Cara menghaksesnya bisa menggunakan 2 cara yaitu dengan menggunakan yaitu

* Dot notation

{% highlight js %}
obj.prop;
{% endhighlight %}

* Square bracket


{% highlight js %}
obj.["prop"];
{% endhighlight %}

seperti pada koding diatas di baris ke 15 dan 16.
