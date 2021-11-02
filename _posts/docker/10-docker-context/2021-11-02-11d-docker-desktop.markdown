---
layout: post
title: "Dashboard using Docker Desktop"
date: 2021-11-02T20:18:48+07:00
lang: docker
categories:
- DevOps
- Docker
- Context
- Dashboard
refs: 
- https://docs.docker.com/desktop/
- https://docs.docker.com/desktop/dashboard/
youtube: 
comments: true
catalog_key: docker-context
image_path: /resources/posts/docker/11d-docker-desktop
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang dashboard menggunakan Docker Dekstop, Diantaranya sebagai berikut:

1. Docker desktop overview
2. Explore running containers and applications
3. Interact with containers and applications
4. Explore docker images
5. Explore volumes

Ok langsung aja kita ke pembahasan pertama yaitu

## Docker desktop overview

Docker Desktop is an easy-to-install application for your Mac or Windows environment that enables you to build and share containerized applications and microservices. Docker Desktop includes [Docker Engine](https://docs.docker.com/engine/), Docker CLI client, [Docker Compose](https://docs.docker.com/compose/), [Docker Content Trust](https://docs.docker.com/engine/security/trust/), [Kubernetes](https://github.com/kubernetes/kubernetes/), and [Credential Helper](https://github.com/docker/docker-credential-helpers/).

**Notes** Professional use of Docker Desktop in large organizations (more than 250 employees or more than $10 million in annual revenue) requires users to have a paid Docker subscription. While the effective date of these terms is August 31, 2021, there is a grace period until January 31, 2022 for those that require a paid subscription. For more information, see [Docker Desktop License Agreement](https://docs.docker.com/subscription/#docker-desktop-license-agreement).

Some of the key features of Docker Desktop include:

1. Ability to containerize and share any application on any cloud platform, in multiple languages and frameworks
2. Easy installation and setup of a complete Docker development environment
3. Includes the latest version of Kubernetes
4. Automatic updates to keep you up to date and secure
5. On Windows, the ability to toggle between Linux and Windows Server environments to build applications
6. Fast and reliable performance with native Windows Hyper-V virtualization
7. Ability to work natively on Linux through WSL 2 on Windows machines
8. Volume mounting for code and data, including file change notifications and easy access to running containers on the localhost network
9. In-container development and debugging with supported IDEs

## Explore running containers and applications

From the Docker menu, select **Dashboard**. This lists all your running containers and applications. You must have running or stopped containers and applications to see them listed on the Docker Dashboard.

Same as using `docker` command line 

{% highlight bash %}
docker container ls -a
{% endhighlight %}

**Starting container from docker command**

Seperti yang kita telah pelajari, untuk menjalankan container kita bisa menggunakan terminal/commandpromt dengan menggunakan perintah seperti berikut

{% highlight bash %}
docker run -d -e POSTGRES_PASSW0RD=testPasswordRoot postgres:12.6
{% endhighlight %}

the result look's like this:

![basic-docker-desktop]({{ page.image_path | prepend: site.baseurl }}/01-basic-dashboard.png)

**Starting container from docker-compose**

Sama halnya dengan perintah `docker-compose ps` docker-desktop juga bisa menampilkan detail list containernya, Sekarang coba jalankan compose file seperti berikut

{% highlight bash %}
docker-compose --project-directory .\08-docker-compose\10-scale\ up -d --scale backend=3
{% endhighlight %}

the result look's like this:

![compose-docker-desktop]({{ page.image_path | prepend: site.baseurl }}/01-compose-dashboard.png)

Now that you can see the list of running containers and applications on the Dashboard, let us explore some of the actions you can perform:

1. Click `Port` to open the port exposed by the container in a browser.
2. Click `CLI` to open a terminal and run commands on the container. If you have installed iTerm2 on your Mac, the CLI option opens an iTerm2 terminal. Otherwise, it opens the Terminal app on Mac, or a Command Prompt on Windows.
3. Click `Stop`, `Start`, `Restart`, or `Delete` to perform lifecycle operations on the container.
4. Use the Search option to search for a specific object. You can also sort your containers and applications using various options. Click the `Sort by` drop-down to see a list of available options.

## Interact with containers and applications

From the Docker Dashboard, select the example application we started earlier.

The `Containers/Apps` view lists all the containers running on the application and contains a detailed logs view. It also allows you to `start`, `stop`, or `delete` the application. Use the `Search` option at the bottom of the logs view to search application logs for specific events, or select the Copy icon to copy the logs to your clipboard.

Click on a specific container for detailed information about the container. The container view displays Logs, Inspect, and Stats tabs and provides quick action buttons to perform various actions.

1. Select Logs to see logs from the container. You can also search the logs for specific events and copy the logs to your clipboard.
2. Select Inspect to view low-level information about the container. You can see the local path, version number of the image, SHA-256, port mapping, and other details.
3. Select Stats to view information about the container resource utilization. You can see the amount of CPU, disk I/O, memory, and network I/O used by the container.

## Explore docker images

The Images view is a simple interface that lets you manage Docker images without having to use the CLI. By default, it displays a list of all Docker images on your local disk. To view images in remote repositories, click Sign in and connect to Docker Hub. This allows you to collaborate with your team and manage your images directly through Docker Desktop.

The Images view allows you to perform core operations such as running an image as a container, pulling the latest version of an image from Docker Hub, pushing the image to Docker Hub, and inspecting images.

![local-image-docker-desktop]({{ page.image_path | prepend: site.baseurl }}/02-local-image-docker-desktop.png)

**Interact with remote repositories**

The Images view also allows you to manage and interact with images in remote repositories and lets you switch between organizations. Select an organization from the drop-down to view a list of repositories in your organization.

![remote-image-docker-desktop]({{ page.image_path | prepend: site.baseurl }}/02-remote-image-docker-desktop.png)

## Explore volumes

You can use volumes to store files and share them among containers. Volumes are created and are directly managed by Docker. They are also the preferred mechanism to persist data in Docker containers and services.

![volumes-docker-desktop]({{ page.image_path | prepend: site.baseurl }}/03-volume-docker-desktop.png)