---
layout: post
title: "Best practices for scanning images"
date: 2021-06-27T13:28:32+07:00
lang: docker
categories:
- DevOps
- Docker
- Dockerfile
refs: 
- https://docs.docker.com/engine/scan/
- https://docs.docker.com/develop/scan-images/
youtube: 
comments: true
image_path: /resources/posts/docker/07n-docker-image-scan
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Scanning docker images yang telah kita build berserta best practice nya. Berikut adalah materi yang akan kita bahas

1. Vulnerability images
2. How to scan using the CLI
3. Choose the right base image
4. Scan images during development & production
5. Conclusion

Ok langsung aja kita bahas ke materi yang pertama

## Vulnerability docker images

Setelah kita melakukan build docker image, apa yang harus dilakukan selanjutnya? langsung kita push ke registry? ettss tunggu dulu, coba perhatikan tentang security issue dalam docker image apakah image yang kita build sudah aman? 

Vulnerability scanning for Docker local images allows developers and development teams to review the security state of the container images and take actions to fix issues identified during the scan, resulting in more secure deployments. 
Docker Scan runs on Snyk engine, providing users with visibility into the security posture of their local Dockerfiles and local images.

Users trigger vulnerability scans through the CLI, and use the CLI to view the scan results. 
The scan results contain a list of Common Vulnerabilities and Exposures (CVEs), the sources, such as OS packages and libraries, versions in which they were introduced, and a recommended fixed version (if available) to remediate the CVEs discovered.

## How to scan using the CLI

The `docker scan` command allows you to scan existing Docker images using the image name or ID. For example, run the following command to scan the hello-world image:

{% gist page.gist "07n-docker-scan-help.bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ 07-dockerfile  docker scan --help

Usage:  docker scan [OPTIONS] IMAGE

A tool to scan your images

Options:
      --accept-license    Accept using a third party scanning provider
      --dependency-tree   Show dependency tree with scan results
      --exclude-base      Exclude base image from vulnerability scanning
                          (requires --file)
  -f, --file string       Dockerfile associated with image, provides more
                          detailed results
      --group-issues      Aggregate duplicated vulnerabilities and group
                          them to a single one (requires --json)
      --json              Output results in JSON format
      --login             Authenticate to the scan provider using an
                          optional token (with --token), or web base
                          token if empty
      --reject-license    Reject using a third party scanning provider
      --severity string   Only report vulnerabilities of provided level
                          or higher (low|medium|high)
      --token string      Authentication token to login to the third
                          party scanning provider
      --version           Display version of the scan plugin
```

Sekarang kita coba jalankan perintah `docker scan` untuk docker image yang terakhir yang kita build yaitu `dimmaryanto93/centos:1.8` seperti berikut:

{% gist page.gist "07n-docker-scan.bash" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ 07-dockerfile  docker scan --exclude-base --file Dockerfile dimmaryanto93/centos:1.8

Testing dimmaryanto93/centos:1.8...

Package manager:   deb
Target file:       Dockerfile
Project name:      docker-image|dimmaryanto93/centos
Docker image:      dimmaryanto93/centos:1.8
Platform:          linux/amd64
Base image:        php:7.3-apache

Tested 176 dependencies for known vulnerabilities, found 0 vulnerabilities.

Base Image      Vulnerabilities  Severity
php:7.3-apache  158              18 high, 11 medium, 129 low

Recommendations for base image upgrade:

Alternative image types
Base Image             Vulnerabilities  Severity
php:7.3-fpm-buster     141              13 high, 9 medium, 119 low
php:7.3.28-cli-buster  141              13 high, 9 medium, 119 low
php:7.3.28-zts-buster  141              13 high, 9 medium, 119 low
php:8-buster           148              13 high, 9 medium, 126 low

For more free scans that keep your images secure, sign up to Snyk at https://dockr.ly/3ePqVcp
```

## Choose the right base image

The first step towards achieving a secure image is to choose the right base image. When choosing an image, ensure it is built from a trusted source and keep it small. 

Docker Hub has more than 8.3 million repositories. Some of these images are Official Images, which are published by Docker as a curated set of Docker open source and drop-in solution repositories. 

When building your own image from a `Dockerfile`, ensure you choose a minimal base image that matches your requirements. A smaller base image not just offers portability and fast downloads, but also shrinks the size of your image and minimizes the number of vulnerabilities introduced through the dependencies.

when rebuild your own imag from a `Dockerfile`, A Dockerfile contains a set of instructions which allows you to automate the steps you would normally (manually) take to create an image. Additionally, it can include some imported libraries and install custom software. These appear as instructions in the Dockerfile. Building your image is a snapshot of that image, at that moment in time. When you depend on a base image without a tag, you’ll get a different base image every time you rebuild. Also, when you install packages using a package installer, rebuilding can change the image drastically. For example, a Dockerfile containing the following entries can potentially have a different binary with every rebuild.

{% highlight docker %}
FROM ubuntu:latest
RUN apt-get -y update && apt-get install -y python
{% endhighlight %}

We recommend that you rebuild your Docker image regularly to prevent known vulnerabilities that have been addressed. When rebuilding, use the option `--no-cache` to avoid cache hits and to ensure a fresh download.

{% highlight docker %}
docker build --no-cache -t myImage:myTag myPath/
{% endhighlight %}

Consider the following best practices when rebuilding an image:

1. Each container should have only one responsibility.
2. Containers should be immutable, lightweight, and fast.
3. Don’t store data in your container. Use a shared data store instead.
4. Containers should be easy to destroy and rebuild.
5. Use a small base image (such as Linux Alpine). Smaller images are easier to distribute.
6. Avoid installing unnecessary packages. This keeps the image clean and safe.
7. Auto-scan your image before deploying to avoid pushing vulnerable containers to production.
8. Scan your images daily both during development and production for vulnerabilities Based on that, automate the rebuild of images if necessary.

## Scan images during development & production

Creating an image from a Dockerfile and even rebuilding an image can introduce new vulnerabilities in your system. 
Scanning your Docker images during development should be part of your workflow to catch vulnerabilities earlier in your development. 
You should scan images at all stages of the development cycle, and ideally consider automating scans. For example, consider configuring automated scans during the build process, before pushing the image to Docker Hub (or any other registry), and finally before pushing it to a production environment.

Actively checking your container can save you a lot of hassle when a new vulnerability is discovered, which otherwise can put your production system at risk.

Periodically scanning your Docker image is possible by using the Snyk monitor capabilities for containers. Snyk creates a snapshot of the image’s dependencies for continuous monitoring. Additionally, you should also activate runtime monitoring. 

Scanning for unused modules and packages inside your runtime gives insight into how to shrink images. Removing unused components prevents unnecessary vulnerabilities from entering both system and application libraries. This also makes an image more easily maintainable.

## Conclusion

Building secure images is a continuous process. Consider the recommendations and best practices highlighted in this guide to plan and build efficient, scalable, and secure images.

Let’s recap what we’ve learnt in this guide:

1. Start with a base image that you trust. Remember the Official image and Verified Publisher badges when you choose your base images.
2. Secure your code and its dependencies.
3. Select a minimal base image which contains only the required packages.
4. Use multi-stage builds to optimize your image.
5. Ensure you carefully monitor and manage the tools and dependencies you add to your image.
6. Ensure you scan images at multiple stages during your development lifecycle.
7. Check your images frequently for vulnerabilities.