---
layout: post
title: "Getting started with docker-machine"
date: 2022-04-01T06:32:38+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Machine
refs: 
- https://docs.docker.com/
youtube: 
comments: true
catalog_key: docker-machine
image_path: /resources/posts/docker/12a-getting-started-docker-machine
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, setelah kita melakukan installasi `docker-machine` di Windows, Linux dan MacOs sekarang kita akan mencoba memulai menggunakan Docker Machine tersebut sebagai development environtment ya. Diantaranya yang kita bahas adalah:

1. Use Machine to run Docker containers
2. Accessing to a machine
3. Run containers and experiment with Machine commands
4. Start and stop machines

Ok langsung aja kita bahas materi yang pertama:

<!--more-->

## Use Machine to run Docker containers

Let's take a look at using docker-machine for creating, using, and managing a Docker host inside of [VirtualBox](https://www.virtualbox.org/).

If you used the Quickstart Terminal to launch your first machine and set your terminal environment to point to it, a default machine was automatically created.

To run a Docker container, you:

1. create a new (or start an existing) Docker virtual machine
2. switch your environment to your new VM
4. use the docker client to create, load, and manage containers

Once you create a machine, you can reuse it as often as you like. Like any VirtualBox VM, it maintains its configuration between uses.

## Accessing to a machine

The examples here show how to create and start a machine, run Docker commands, and work with containers.

1. Open a command shell or terminal window.
2. Use `docker-machine` ls to list available machines, In this example, no machines have been created yet.

    ```bash
    ➜ ~  docker-machine ls
    NAME   ACTIVE   DRIVER   STATE   URL   SWARM   DOCKER   ERRORS
    ```
3. Create a machine, Run the `docker-machine create` command, passing the string `virtualbox` to the `--driver` flag. The final argument is the name of the machine. If this is your first machine, name it `default`. If you already have a "default" machine, choose another name for this new machine.

4. List available machines again to see your newly minted machine.

    ```bash
    ➜ ~  docker-machine ls
    NAME      ACTIVE   DRIVER       STATE     URL                       SWARM     DOCKER    ERRORS
    default   -        virtualbox   Running   tcp://192.168.99.100:2376           v19.03.12
    ```
5. Get the environment commands for your new VM. Note: If you are using `fish`, or a Windows shell such as Powershell/`cmd.exe` the above method will not work as described.

    ```bash
    ➜ ~  eval "$(docker-machine env default)"
    ```

6. SSH into your VM. alternatively if you can't get environtment you can login into machine using this command below.

    ```bash
    ➜ ~  docker-machine ssh default
    ```

## Run containers and experiment with Machine commands

Run a container with docker run to verify your set up.

1. Use `docker run` to download and run `nginx`

    ```bash
    ➜ ~  docker run -p 8000:80 -d nginx
    ```

2. Get the host IP address. Any exposed ports are available on the Docker host’s IP address, which you can get using the `docker-machine ip` command:

    ```bash
    ➜ ~  docker-machine ip default
          192.168.99.102
    ➜ ~  curl 192.168.99.102:8000
    StatusCode        : 200
    StatusDescription : OK
    Content           : <!DOCTYPE html>
                        <html>
                        <head>
                        <title>Welcome to nginx!</title>
                        <style>
                        html { color-scheme: light dark; }
                        body { width: 35em; margin: 0 auto;
                        font-family: Tahoma, Verdana, Arial, sans-serif; }
    ```

## Start and stop machines

If you are finished using a host for the time being, you can stop it with `docker-machine stop` and later start it again with `docker-machine start`.

{% highlight bash %}
docker-machine stop default
docker-machine start default
{% endhighlight %}