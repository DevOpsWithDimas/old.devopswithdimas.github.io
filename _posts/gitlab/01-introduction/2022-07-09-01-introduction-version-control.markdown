---
layout: post
title: "Pengenalan Version Control"
date: 2022-07-09T12:40:08+07:00
lang: gitlab
authors:
- dimasm93
categories:
- git
- gitops
- gitlab
refs: 
- https://git-scm.com/book/en/v2/Getting-Started-About-Version-Control
youtube: 
comments: true
catalog_key: introduction
image_path: /resources/posts/git/01-introduction-git
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Version Control menggunakan salah satu yang paling popular yaitu Git Source Code Management (SCM). Sebelum kita memulai menggunakan Git Version Control kita akan bahas dulu tentang Version Control itu sendiri Diantaranya:

1. About Version Control?
2. Local VCS (Version Control System)
3. Centralized VCS (Version Control System)
4. Distribute VCS (Version Control System)

Ok tanpa berlama-lama langsung aja kita bahas materi yang pertama

<!--more-->

## What is Version Control System?

What is “version control”, and why should you care? Version control is a system that records changes to a file or set of files over time so that you can recall specific versions later.

If you are a graphic or web designer and want to keep every version of an image or layout (which you would most certainly want to), a Version Control System (VCS) is a very wise thing to use. It allows you to revert selected files back to a previous state, revert the entire project back to a previous state, compare changes over time, see who last modified something that might be causing a problem, who introduced an issue and when, and more. Using a VCS also generally means that if you screw things up or lose files, you can easily recover. In addition, you get all this for very little overhead.

In Version Control System, have three based architectures:

1. Local Version Control
2. Centralized Version Control
3. Distribute Version Control

## Local VCS (Version Control System)

Many people’s version-control method of choice is to copy files into another directory (perhaps a time-stamped directory, if they’re clever). This approach is very common because it is so simple, but it is also incredibly error prone. It is easy to forget which directory you’re in and accidentally write to the wrong file or copy over files you don’t mean to.

To deal with this issue, programmers long ago developed local VCSs that had a simple database that kept all the changes to files under revision control.

![local version control]({{ page.image_path | prepend: site.baseurl }}/01-local-version-control.png)

One of the most popular VCS tools was a system called RCS, which is still distributed with many computers today. [RCS](https://www.gnu.org/software/rcs/) works by keeping patch sets (that is, the differences between files) in a special format on disk; it can then re-create what any file looked like at any point in time by adding up all the patches.

## Centralized VCS (Version Control System)

The next major issue that people encounter is that they need to collaborate with developers on other systems. To deal with this problem, Centralized Version Control Systems (CVCSs) were developed. These systems (such as [CVS](https://www.nongnu.org/cvs/), [Subversion](https://subversion.apache.org), and [Perforce](https://www.perforce.com/solutions/version-control)) have a single server that contains all the versioned files, and a number of clients that check out files from that central place. For many years, this has been the standard for version control.

![centralized version control]({{ page.image_path | prepend: site.baseurl }}/02-centralized-version-control.png)

This setup offers many advantages, especially over local VCSs. For example, everyone knows to a certain degree what everyone else on the project is doing. Administrators have fine-grained control over who can do what, and it’s far easier to administer a CVCS than it is to deal with local databases on every client.

However, this setup also has some serious downsides. The most obvious is the single point of failure that the centralized server represents. If that server goes down for an hour, then during that hour nobody can collaborate at all or save versioned changes to anything they’re working on. If the hard disk the central database is on becomes corrupted, and proper backups haven’t been kept, you lose absolutely everything — the entire history of the project except whatever single snapshots people happen to have on their local machines. Local VCSs suffer from this same problem — whenever you have the entire history of the project in a single place, you risk losing everything.

## Distribute VCS (Version Control System)

This is where Distributed Version Control Systems (DVCSs) step in. In a DVCS (such as [Git](https://git-scm.com), [Mercurial](https://www.mercurial-scm.org), [Bazaar](https://bazaar.canonical.com/en/) or [http://darcs.net]), clients don’t just check out the latest snapshot of the files; rather, they fully mirror the repository, including its full history. Thus, if any server dies, and these systems were collaborating via that server, any of the client repositories can be copied back up to the server to restore it. Every clone is really a full backup of all the data.

![distributed version control]({{ page.image_path | prepend: site.baseurl }}/03-distributed-version-control.png)

Furthermore, many of these systems deal pretty well with having several remote repositories they can work with, so you can collaborate with different groups of people in different ways simultaneously within the same project. This allows you to set up several types of workflows that aren’t possible in centralized systems, such as hierarchical models.
