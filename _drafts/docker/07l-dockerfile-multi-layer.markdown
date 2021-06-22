---
layout: post
title: "Basic Dockerfile - Multiple Stage Builds"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/develop/develop-images/multistage-build/
youtube: 
comments: true
image_path: /resources/posts/docker/07l-multiple-layar
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Multiple stage builds pada single Dockerfile. Diantaranya yang akan kita bahas yaitu

1. Before multi-stage builds
2. Use multi-stage builds
3. Name your build stages
4. Use an external image as a “stage”
5. Use a previous stage as a new stage
6. Cleanup

## Before multi-stage builds

One of the most challenging things about building images is keeping the image size down. Each instruction in the `Dockerfile` adds a layer to the image, and you need to remember to clean up any artifacts you don’t need before moving on to the next layer. To write a really efficient Dockerfile, you have traditionally needed to employ shell tricks and other logic to keep the layers as small as possible and to ensure that each layer has the artifacts it needs from the previous layer and nothing else.

It was actually very common to have one Dockerfile to use for development (which contained everything needed to build your application), and a slimmed-down one to use for production, which only contained your application and exactly what was needed to run it. This has been referred to as the “builder pattern”. Maintaining two Dockerfiles is not ideal.

Here’s an example of a `build.Dockerfile` and `Dockerfile` which adhere to the builder pattern above: