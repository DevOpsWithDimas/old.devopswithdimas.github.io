---
layout: post
title: "Basic Dockerfile - User, Volumes and Working Directory"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/engine/reference/builder/
youtube: 
comments: true
image_path: /resources/posts/docker/07i-dockerfile-user-workdir
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang `USER` Instruction, `VOLUME` Instruction dan `WORKDIR` Instruction diantaranya:

1. Run command non-root user
2. Using Working Directory
3. Volume for persistence data
4. Cleanup

Ok lansung aja kita ke materi yang pertama yaitu `USER` Instruction

## `USER` Instruction

The `USER` instruction sets the user name (or UID) and optionally the user group (or GID) to use when running the image and for any `RUN`, `CMD` and `ENTRYPOINT` instructions that follow it in the `Dockerfile`.

> Note that when specifying a group for the user, the user will have only the specified group membership. Any other configured group memberships will be ignored.

> Notes: When the user doesn’t have a primary group then the image (or the next instructions) will be run with the root group. 

{% highlight docker %}
USER <user>[:<group>]
{% endhighlight %}

OR

{% highlight docker %}
USER <UID>[:<GID>]
{% endhighlight %}

> **On Windows, the user must be created first** if it’s not a built-in account. This can be done with the `net user` command called as part of a `Dockerfile`.

{% highlight docker %}
FROM microsoft/windowsservercore
# Create Windows user in the container
RUN net user /add patrick
# Set it for subsequent commands
USER patrick
{% endhighlight %}

Contoh penggunaanya, seperti berikut:

{% gist page.gist "07j-dockerfile-run-non-root" %}