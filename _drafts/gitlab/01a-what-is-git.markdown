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
3. Short history of Git
4. Getting started - The command line

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

Dengan menggunakan Git SCM, kita bisa menggunakan beberapa workflow yaitu Working in local and collaboration baik sifatnya public maupun internal. Contohnya Saya adalah seorang developer/programmer yang sedang mengerjakan project web aplikasi, saya hanya membutuhkan git engine saja di local PC/Laptop saya karena dengan Git hampir semua operation di lakukan di local. Dan ketika saya memiliki team untuk berkolaborasi dalam project tersebut kita bisa menggunakan distributed hosting Git Repository yang tersedia secara public ataupun self hosting. 

Secara workflow dengan menggunakan git version control hampir semua workflow bisa dilakukan seperti pada contoh kasus diatas. Ok sekarang mungkin kita bahas Feature apa saja yang bisa di lakukan oleh Git:

1. **Nearly every operation is Local**, Most operations in Git need only local files and resources to operate. generally no information is needed from another computer on your network. If you’re used to a CVCS where most operations have that network latency overhead, this aspect of Git will make you think that the gods of speed have blessed Git with unworldly powers. Because you have the entire history of the project right there on your local disk, most operations seem almost instantaneous.
2. **Git has Integrity**, Everything in Git is checksummed before it is stored and is then referred to by that checksum. This means it’s impossible to change the contents of any file or directory without Git knowing about it. This functionality is built into Git at the lowest levels and is integral to its philosophy. You can’t lose information in transit or get file corruption without Git being able to detect it.
3. **Git generaly only add data**, When you do actions in Git, nearly all of them only add data to the Git database. It is hard to get the system to do anything that is not undoable or to make it erase data in any way. As with any VCS, you can lose or mess up changes you haven’t committed yet, but after you commit a snapshot into Git, it is very difficult to lose, especially if you regularly push your database to another repository.
4. **State of git**, the main thing to remember about Git if you want the rest of your learning process to go smoothly. Git has three main states that your files can reside in: **modified**, **staged**, and **committed**. This leads us to the three main sections of a Git project: the working tree, the staging area, and the Git directory.
    ![state of git]({{ page.image_path | prepend: site.baseurl }}/03-state-of-git.png)

## Short history of Git

As with many great things in life, Git began with a bit of creative destruction and fiery controversy.

The Linux kernel is an open source software project of fairly large scope. During the early years of the Linux kernel maintenance (1991–2002), changes to the software were passed around as patches and archived files. In 2002, the Linux kernel project began using a proprietary DVCS called BitKeeper.

In 2005, the relationship between the community that developed the Linux kernel and the commercial company that developed BitKeeper broke down, and the tool’s free-of-charge status was revoked. This prompted the Linux development community (and in particular Linus Torvalds, the creator of Linux) to develop their own tool based on some of the lessons they learned while using BitKeeper. Some of the goals of the new system were as follows:

1. Speed
2. Simple design
3. Strong support for non-linear development (thousands of parallel branches)
4. Fully distributed

Able to handle large projects like the Linux kernel efficiently (speed and data size)

Since its birth in 2005, Git has evolved and matured to be easy to use and yet retain these initial qualities. It’s amazingly fast, it’s very efficient with large projects, and it has an incredible branching system for non-linear development (Git Branching).

## Getting started - The command line

There are a lot of different ways to use Git. There are the original command-line tools, and there are many graphical user interfaces of varying capabilities. We will be using Git on the command line. For one, the command line is the only place you can run all Git commands — most of the GUIs implement only a partial subset of Git functionality for simplicity. If you know how to run the command-line version, you can probably also figure out how to run the GUI version, while the opposite is not necessarily true. Also, while your choice of graphical client is a matter of personal taste, all users will have the command-line tools installed and available.

So we will expect you to know how to open Terminal in macOS or Command Prompt or PowerShell in Windows. If you don’t know what we’re talking about here, no problem we will teach you from begining.