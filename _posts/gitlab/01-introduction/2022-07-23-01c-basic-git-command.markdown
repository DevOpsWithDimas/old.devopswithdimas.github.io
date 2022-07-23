---
layout: post
title: "Getting started with git"
date: 2022-07-23T12:41:05+07:00
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
7. Viewing the Commit History

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
touch README.md && \
echo "Halo saya sedang belajar git! " > README.md

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
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   README.md

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

## Staging Modified Files

Let’s change a file that was already tracked. If you change a previously tracked file called `README.md` and then run your `git status` command again, you get something that looks like this:

{% highlight bash %}
# create new file
touch CONTRIBUTING.md

# update file readme
echo "\nSaya sudah berhasil meng-commit file" >> README.md

# see the status now
git status
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```bash
$ git status
On branch main
Your branch is up-to-date with 'origin/main'.
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

    new file:   CONTRIBUTING.md

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

    modified:   README.md
```

The `README.md` file appears under a section named “Changes not staged for commit” — which means that a file that is tracked has been modified in the working directory but not yet staged. To stage it, you run the `git add` command. `git add` is a multipurpose command — you use it to begin tracking new files, to stage files, and to do other things like marking merge-conflicted files as resolved. It may be helpful to think of it more as “add precisely this content to the next commit” rather than “add this file to the project”. Let’s run `git add` now to stage the `README.md` file, and then run `git status` again:

```bash
$ git add CONTRIBUTING.md
$ git status
On branch main
Your branch is up-to-date with 'origin/main'.
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

    new file:   CONTRIBUTING.md
    modified:   README.md
```

Both files are staged and will go into your next commit. At this point, suppose you remember one little change that you want to make in `CONTRIBUTING.md` before you commit it. You open it again and make that change, and you’re ready to commit. However, let’s run git status one more time:

{% highlight bash %}
# update again file CONTRIBUTING.md
echo "\nSaya sudah berhasil meng-commit file" >> CONTRIBUTING.md

# see the status again
git status
{% endhighlight %}

Jika dijalankan hasilnya seperti berikut:

```bash
$ git status
On branch main
Your branch is up-to-date with 'origin/main'.
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

    new file:   CONTRIBUTING.md
    modified:   README.md

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

    modified:   CONTRIBUTING.md
```

What the heck? Now `CONTRIBUTING.md` is listed as both staged and unstaged. How is that possible? It turns out that Git stages a file exactly as it is when you run the `git add` command. If you commit now, the version of `CONTRIBUTING.md` as it was when you last ran the `git add` command is how it will go into the commit, not the version of the file as it looks in your working directory when you run `git commit`. If you modify a file after you run `git add`, you have to run `git add` again to stage the latest version of the file:

```bash
$ git add CONTRIBUTING.md
$ git status
On branch main
Your branch is up-to-date with 'origin/main'.
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

    new file:   README
    modified:   CONTRIBUTING.md
```

## Ignoring Files

Often, you’ll have a class of files that you don’t want Git to automatically add or even show you as being untracked. These are generally automatically generated files such as log files or files produced by your build system. In such cases, you can create a file listing patterns to match them named `.gitignore`. 

Here is an example .gitignore file:

```config
*.class
target/
*~
```

The first line tells Git to ignore any files ending in “.class” — object and archive files that may be the product of building your code. The second line tells Git to ignore all file inside directory called `target`. The third line tells Git to ignore all files whose names end with a tilde (`~`), which is used by many text editors such as `Emacs`, `vim` or `nano` to mark temporary files.

Setting up a `.gitignore` file for your new repository before you get going is generally a good idea so you don’t accidentally commit files that you really don’t want in your Git repository. The rules for the patterns you can put in the `.gitignore` file are as follows:

1. Blank lines or lines starting with # are ignored.
2. Standard glob patterns work, and will be applied recursively throughout the entire working tree.
3. You can start patterns with a forward slash (`/`) to avoid recursivity.
4. You can end patterns with a forward slash (`/`) to specify a directory.
5. You can negate a pattern by starting it with an exclamation point (`!`).

Glob patterns are like simplified regular expressions that shells use. An asterisk (`*`) matches zero or more characters; [`abc`] matches any character inside the brackets (in this case `a`, `b`, or `c`); a question mark (`?`) matches a single character; and brackets enclosing characters separated by a hyphen (`[0-9]`) matches any character between them (in this case `0` through `9`). You can also use two asterisks to match nested directories;` a/**/z` would match `a/z`, `a/b/z`, `a/b/c/z`, and so on.

Here is another example .gitignore file:

```config
# ignore all .a files
*.a

# but do track lib.a, even though you're ignoring .a files above
!lib.a

# only ignore the TODO file in the current directory, not subdir/TODO
/TODO

# ignore all files in any directory named build
build/

# ignore doc/notes.txt, but not doc/server/arch.txt
doc/*.txt

# ignore all .pdf files in the doc/ directory and any of its subdirectories
doc/**/*.pdf
```

## Removing/Moving Files

To remove a file from Git, you have to remove it from your tracked files (more accurately, remove it from your staging area) and then commit. The `git rm` command does that, and also removes the file from your working directory so you don’t see it as an untracked file the next time around.

If you simply remove the file from your working directory, it shows up under the “Changes not staged for commit” (that is, unstaged) area of your git status output:

```bash
$ rm PROJECTS.md
$ git status
On branch main
Your branch is up-to-date with 'origin/main'.
Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        deleted:    PROJECTS.md

no changes added to commit (use "git add" and/or "git commit -a")
```

Then, if you run `git rm`, it stages the file’s removal:

```bash
$ git rm PROJECTS.md
rm 'PROJECTS.md'
$ git status
On branch main
Your branch is up-to-date with 'origin/main'.
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

    deleted:    PROJECTS.md
```

The next time you commit, the file will be gone and no longer tracked. If you modified the file or had already added it to the staging area, you must force the removal with the -f option. This is a safety feature to prevent accidental removal of data that hasn’t yet been recorded in a snapshot and that can’t be recovered from Git.

Unlike many other VCSs, Git doesn’t explicitly track file movement. If you rename a file in Git, no metadata is stored in Git that tells it you renamed the file. However, Git is pretty smart about figuring that out after the fact — we’ll deal with detecting file movement a bit later.

Thus it’s a bit confusing that Git has a mv command. If you want to rename a file in Git, you can run something like:

{% highlight bash %}
git mv file_from file_to
{% endhighlight %}

and it works fine. In fact, if you run something like this and look at the status, you’ll see that Git considers it a renamed file:

```bash
$ git mv README.md README
$ git status
On branch main
Your branch is up-to-date with 'origin/main'.
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

    renamed:    README.md -> README
```

However, this is equivalent to running something like this:

{% highlight bash %}
mv README.md README
git rm README.md
git add README
{% endhighlight %}

Git figures out that it’s a rename implicitly, so it doesn’t matter if you rename a file that way or with the mv command. The only real difference is that `git mv` is one command instead of three — it’s a convenience function. More importantly, you can use any tool you like to rename a file, and address the add/rm later, before you commit.

## Viewing the Commit History

After you have created several commits, or if you have cloned a repository with an existing commit history, you’ll probably want to look back to see what has happened. 

The most basic and powerful tool to do this is the `git log` command:

{% highlight bash %}
git log
{% endhighlight %}

When you run `git log` in this project, you should get output that looks something like this:

```bash
commit cd08659e7891816b875a0996a0be3e66a7ad2e4f (HEAD -> main)
Author: dimasm93 <software.dimas_m@icloud.com>
Date:   Sat Jul 23 14:04:58 2022 +0700

    delete everything inside

commit ee8c88cc1f8dcc092e1f39efb2a1af0419f850a4
Author: dimasm93 <software.dimas_m@icloud.com>
Date:   Sat Jul 23 14:04:02 2022 +0700

    tracking new files

commit c99c4562f072a6bc680e6300894206252ae4617d
Author: dimasm93 <software.dimas_m@icloud.com>
Date:   Sat Jul 23 13:59:32 2022 +0700

    init project
```

By default, with no arguments, `git log` lists the commits made in that repository in reverse chronological order; that is, the most recent commits show up first. As you can see, this command lists each commit with its `SHA-1` checksum, the author’s name and email, the date written, and the commit message.

A huge number and variety of options to the git log command are available to show you exactly what you’re looking for. Here, we’ll show you some of the most popular.

One of the more helpful options is `-p` or `--patch`, which shows the difference (the patch output) introduced in each commit. You can also limit the number of log entries displayed, such as using `-2` to show only the last two entries.

{% highlight bash %}
git log -p -2
{% endhighlight %}

Jika di jalankan outputnya seperti berikut:

```bash
commit cd08659e7891816b875a0996a0be3e66a7ad2e4f (HEAD -> main)
Author: dimasm93 <software.dimas_m@icloud.com>
Date:   Sat Jul 23 14:04:58 2022 +0700

    delete everything inside

diff --git a/README.md b/README.md
index c8df977..8b13789 100644
--- a/README.md
+++ b/README.md
@@ -1,3 +1 @@
-Halo saya sedang belajar git!

-Sekarang saya sudah mulai paham dengan git command

commit ee8c88cc1f8dcc092e1f39efb2a1af0419f850a4
Author: dimasm93 <software.dimas_m@icloud.com>
Date:   Sat Jul 23 14:04:02 2022 +0700

    tracking new files

diff --git a/README.md b/README.md
index 4a622a3..c8df977 100644
--- a/README.md
+++ b/README.md
@@ -1 +1,3 @@
 Halo saya sedang belajar git!
+
+Sekarang saya sudah mulai paham dengan git command
```

Another really useful option is `--oneline`. The oneline value for this option prints each commit on a single line, which is useful if you’re looking at a lot of commits. In addition, the short, full, and fuller values show the output in roughly the same format but with less or more information, respectively:

{% highlight bash %}
git log --oneline
{% endhighlight %}

Jika dijalankan hasilnya seperti berikut:

```bash
cd08659 (HEAD -> main) delete everything inside
ee8c88c tracking new files
c99c456 init project
```