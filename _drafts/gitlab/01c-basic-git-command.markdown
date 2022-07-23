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
image_path: /resources/posts/git/01c-basic-git-command
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Hai semuanya, setelah kita menyiapkan environment untuk belajar Git Version Control sekarang kita mulai Hand-on untuk Dasar perintah Git diantaranya:

1. Getting a Git Repository 
    1. Create new Git Repository
    2. Cloning an Existing Repository
2. Recording Changes to the Repository
    1. Checking the Status of Your Files
    2. Tracking New Files
    3. Staging Modified Files
3. Ignoring Files
4. Viewing Your Staged and Unstaged Changes
5. Committing Your Changes
6. Removing/Moving Files

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

## Recording Changes to the Repository

At this point, you should have a **bona fide** Git repository on your local machine, and a checkout or working copy of all of its files in front of you. Typically, you’ll want to start making changes and committing snapshots of those changes into your repository each time the project reaches a state you want to record.

Remember that each file in your working directory can be in one of two states: `tracked` or `untracked`:

1. Tracked files are files that were in the last snapshot, as well as any newly staged files; they can be unmodified, modified, or staged. In short, tracked files are files that Git knows about. 
2. Untracked files are everything else — any files in your working directory that were not in your last snapshot and are not in your staging area.

When you first clone a repository, all of your files will be tracked and unmodified because Git just checked them out and you haven’t edited anything. As you edit files, Git sees them as modified, because you’ve changed them since your last commit. As you work, you selectively stage these modified files and then commit all those staged changes, and the cycle repeats.

The lifecycle of the status of your files:

{% mermaid %}
sequenceDiagram
    participant untrack as Untracked
    participant unmodif as Unmodified
    participant modif as Modified
    participant stage as Staged

    untrack->>stage: Add the file
    unmodif->>modif: Edit the file
    modif->>stage: Stage the file
    unmodif->>untrack: Remove the file
    stage->>unmodif: Commit
{% endmermaid %}

## Checking the Status of Your Files

The main tool you use to determine which files are in which state is the `git status` command. If you run this command directly after a clone:

{% highlight bash %}
git status
{% endhighlight %}

Jika dijalankan hasilnya seperti berikut:

```bash
$ git status
On branch main
Your branch is up-to-date with 'origin/main'.
nothing to commit, working tree clean
```

This means you have a clean working directory; in other words, none of your tracked files are modified. Git also doesn’t see any untracked files, or they would be listed here. Finally, the command tells you which branch you’re on and informs you that it has not diverged from the same branch on the server. For now, that branch is always `main`, which is the default; you won’t worry about it here. Git Branching will go over branches and references in detail.

Let’s say you add a new file to your project, a simple README file. If the file didn’t exist before, and you run git status, you see your untracked file like so:

{% highlight bash %}
echo "\nSekarang saya sudah mulai paham dengan Git command" >> README.md
git status
{% endhighlight %}

Jika dijalankan hasilnya seperti berikut:

```bash
$ git status
On branch main
Your branch is up-to-date with 'origin/main'.
Untracked files:
  (use "git add <file>..." to include in what will be committed)

    README.md

nothing added to commit but untracked files present (use "git add" to track)
```

You can see that your new `README.md` file is untracked, because it’s under the “Untracked files” heading in your status output. Untracked basically means that Git sees a file you didn’t have in the previous snapshot (commit), and which hasn’t yet been staged; Git won’t start including it in your commit snapshots until you explicitly tell it to do so. It does this so you don’t accidentally begin including generated binary files or other files that you did not mean to include. You do want to start including `README.md`, so let’s start tracking the file.

## Tracking New Files

In order to begin tracking a new file, you use the command git add. To begin tracking the `README.md` file, you can run this:

{% highlight bash %}
git add README.md
{% endhighlight %}

If you run your status command again, you can see that your `README.md` file is now tracked and staged to be committed:

```bash
$ git status
On branch main
Your branch is up-to-date with 'origin/main'.
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)

    new file:   README.md
```

You can tell that it’s staged because it’s under the “Changes to be committed” heading. If you commit at this point, the version of the file at the time you ran `git add` is what will be in the subsequent historical snapshot. You may recall that when you ran git init earlier, you then ran `git add <files>` — that was to begin tracking files in your directory. The `git add` command takes a path name for either a file or a directory; if it’s a directory, the command adds all the files in that directory recursively.

{% highlight bash %}
# for tracking file
git add file

# for tracking directory or subdirectory
git add directory-path/files

# for tracking with pattern regex
git add * ## mean tracking all file or directory inside git project
{% endhighlight %}

## Committing Your Changes

Now that your staging area is set up the way you want it, you can commit your changes. Remember that anything that is still unstaged — any files you have created or modified that you haven’t run `git add` on since you edited them — won’t go into this commit. They will stay as modified files on your disk. In this case, let’s say that the last time you ran git status, you saw that everything was staged, so you’re ready to commit your changes. The simplest way to commit is to type `git commit`:

```bash
$ git commit
```

Doing so launches your editor of choice. The editor displays the following text (this example is a `Vim` screen):

```bash
# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
# On branch master
# Your branch is up-to-date with 'origin/master'.
#
# Changes to be committed:
#	new file:   README
#
~
".git/COMMIT_EDITMSG" 9L, 283C
```

You can see that the default commit message contains the latest output of the git status command commented out and one empty line on top. You can remove these comments and type your commit message, or you can leave them there to help you remember what you’re committing.

When you exit the editor, Git creates your commit with that commit message (with the comments and diff stripped out).

Alternatively, you can type your commit message inline with the commit command by specifying it after a `-m` flag, like this:

{% highlight bash %}
git commit -m "Adding a description to README.md"
{% endhighlight %}

Jika dijalankan hasilnya seperti berikut:

```bash
$ git commit -m "Adding a description to README.md"
[main 463dc4f] Adding a description to README.md
 1 files changed, 1 insertions(+)
 create mode 100644 README.md
```

Now you’ve created your first commit! You can see that the commit has given you some output about itself: which branch you committed to (master), what `SHA-1` checksum the commit has (`463dc4f`), how many files were changed, and statistics about lines added and removed in the commit.

Remember that the commit records the snapshot you set up in your staging area. Anything you didn’t stage is still sitting there modified; you can do another commit to add it to your history. Every time you perform a commit, you’re recording a snapshot of your project that you can revert to or compare to later.