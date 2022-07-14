---
layout: post
title: "What is Git SCM"
lang: gitlab
authors:
- dimasm93
categories:
- git
- gitops
- gitlab
refs: 
- https://git-scm.com/book/en/v2/Getting-Started-What-is-Git%3F
youtube: 
comments: true
catalog_key: introduction
image_path: /resources/posts/git/01a-what-is-git
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Hai semuanya, setelah kita membahas tentang Apa itu Version Control sekarang kita akan membahas salah satu teknologi-nya atau implementasinya yaitu menggunakan [Git SCM](https://git-scm.com). Sebelum kita hand-on menggunakan Git SCM ada baiknya kita lihat dulu beberapa pembahasan berikut:

1. Apa itu Git SCM?
2. How to work with Git?
3. Why we used Git SCM?
4. Short history of Git

Yukk langsung aja kita bahas satu-per-satu:

<!--more-->

## What is Git SCM?

So, what is Git? This is an important section to absorb, because if you understand what Git is and the fundamentals of how it works, then using Git effectively will probably be much easier for you. As you learn Git, try to clear your mind of the things you may know about other VCSs, such as CVS, Subversion or Perforce — doing so will help you avoid subtle confusion when using the tool. Even though Git’s user interface is fairly similar to these other VCSs, Git stores and thinks about information in a very different way, and understanding these differences will help you avoid becoming confused while using it.

The major difference between Git and any other VCS (Subversion and friends included) is the way Git thinks about its data. Conceptually, most other systems store information as a list of file-based changes. These other systems (CVS, Subversion, Perforce, Bazaar, and so on) think of the information they store as a set of files and the changes made to each file over time (this is commonly described as delta-based version control).

![the delta of vsc data]({{ page.image_path | prepend: site.baseurl }}/01-deltas.png)

Git doesn’t think of or store its data this way. Instead, **Git thinks of its data more like a series of snapshots of a miniature filesystem**. With Git, every time you commit, or save the state of your project, Git basically takes a picture of what all your files look like at that moment and stores a reference to that snapshot. To be efficient, if files have not changed, Git doesn’t store the file again, just a link to the previous identical file it has already stored. Git thinks about its data more like a stream of snapshots.

![snapshots]({{ page.image_path | prepend: site.baseurl }}/02-snapshots.png)

This is an important distinction between Git and nearly all other VCSs. It makes Git reconsider almost every aspect of version control that most other systems copied from the previous generation. This makes Git more like a mini filesystem with some incredibly powerful tools built on top of it, rather than simply a VCS. We’ll explore some of the benefits you gain by thinking of your data this way when we cover Git branching in Git Branching.

## How to work with Git?