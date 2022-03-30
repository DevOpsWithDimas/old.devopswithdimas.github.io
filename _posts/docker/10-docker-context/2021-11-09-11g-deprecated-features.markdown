---
layout: post
title: "Deprecated Engine Features"
date: 2021-11-09T06:30:35+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Context
refs: 
- https://docs.docker.com/engine/deprecated/
youtube: o8AKmI7YD_s
comments: true
catalog_key: docker-context
image_path: /resources/posts/docker/11g-deprecated-features
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas Deprecated Engine Features yang mungkin banyak di lupakan buat sebagian orang. Kenapa ini penting di bahas? jawabannya simak sampai akhir ya!!

## Feature Deprecation Policy

As changes are made to Docker there may be times when existing features need to be removed or replaced with newer features. Before an existing feature is removed it is labeled as “deprecated” within the documentation and remains in Docker for at least one stable release unless specified explicitly otherwise. After that time it may be removed.

Users are expected to take note of the list of deprecated features each release and plan their migration away from those features, and (if applicable) towards the replacement features as soon as possible.

## Deprecated Engine Features

The table below provides an overview of the current status of deprecated features:

1. **Deprecated**: the feature is marked “deprecated” and should no longer be used. The feature may be removed, disabled, or change behavior in a future release. The “Deprecated” column contains the release in which the feature was marked deprecated, whereas the “Remove” column contains a tentative release in which the feature is to be removed. If no release is included in the “Remove” column, the release is yet to be decided on.
2. **Removed**: the feature was removed, disabled, or hidden. Refer to the linked section for details. Some features are “soft” deprecated, which means that they remain functional for backward compatibility, and to allow users to migrate to alternatives. In such cases, a warning may be printed, and users should not rely on this feature.

Ada banyak sekali feature yang sudah deprecated ataupun removed berdasarkan [TOC](https://docs.docker.com/engine/deprecated/#deprecated-engine-features-1)