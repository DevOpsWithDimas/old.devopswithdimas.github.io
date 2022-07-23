---
layout: post
title: "Getting started with git"
lang: gitlab
authors:
- dimasm93
categories:
- git
- gitops
- gitlab
refs: 
- https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository
- https://git-scm.com/book/en/v2/Git-Basics-Recording-Changes-to-the-Repository
- https://git-scm.com/book/en/v2/Git-Basics-Viewing-the-Commit-History
- https://git-scm.com/book/en/v2/Git-Basics-Undoing-Things
youtube: 
comments: true
catalog_key: introduction
image_path: /resources/posts/git/01b-basic-git-command
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Hai semuanya, setelah kita menyiapkan environment untuk belajar Git Version Control sekarang kita mulai Hand-on untuk Dasar perintah Git diantaranya:

1. Getting a Git Repository 
    1. Create new Git Repository
    2. Cloning an Existing Repository
2. Checking the Status of Your Files
3. Tracking New Files
4. Staging Modified Files
5. Ignoring Files
6. Viewing Your Staged and Unstaged Changes
7. Committing Your Changes
8. Removing/Moving Files

Ok yukk langsung aja kita bahas materi yang pertama:

<!--more-->

## Getting a Git Repository

This chapter covers every basic command you need to do the vast majority of the things you’ll eventually spend your time doing with Git. By the end of the chapter, you should be able to configure and initialize a repository, begin and stop tracking files, and stage and commit changes. We’ll also show you how to set up Git to ignore certain files and file patterns, how to undo mistakes quickly and easily, how to browse the history of your project and view changes between commits, and how to push and pull from remote repositories.

You typically obtain a Git repository in one of two ways:

1. You can take a local directory that is currently not under version control, and turn it into a Git repository
2. You can clone an existing Git repository from elsewhere.

In either case, you end up with a Git repository on your local machine, ready for work.

If you have a project directory that is currently not under version control and you want to start controlling it with Git, you first need to go to that project’s directory. Than type:

{% highlight bash %}
git init
{% endhighlight %}

This creates a new subdirectory named `.git` that contains all of your necessary repository files — a Git repository skeleton. At this point, nothing in your project is tracked yet. If you want to start version-controlling existing files (as opposed to an empty directory), you should probably begin tracking those files and do an initial commit. You can accomplish that with a few `git add` commands that specify the files you want to track, followed by a `git commit`:

{% highlight bash %}
## create files & write some text
touch README.md & echo "Halo saya sedang belajar git!" > README.md

## tracking your files
git add README.md

## commit state
git commit -m 'Initial project'
{% endhighlight %}

We’ll go over what these commands do in just a minute. At this point, you have a Git repository with tracked files and an initial commit.

If you want to get a copy of an existing Git repository — for example, a project you’d like to contribute to — the command you need is `git clone`. You clone a repository with `git clone <url>`. For example, if you want to clone the repository called [ansible-role-nginx](https://github.com/dimMaryanto93/ansible-role-nginx), you can do so like this:

{% highlight bash %}
git clone https://github.com/dimMaryanto93/ansible-role-nginx.git
{% endhighlight %}

If you want to clone the repository into a directory named something other than `ansible-role-nginx`, you can specify the new directory name as an additional argument:

{% highlight bash %}
git clone https://github.com/dimMaryanto93/ansible-role-nginx.git role-nginx
{% endhighlight %}

Git has a number of different transfer protocols you can use. The previous example uses the `https://` protocol, but you may also see `git://` or `user@server:path/to/repo.git`, which uses the SSH transfer protocol.