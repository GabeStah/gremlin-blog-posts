---
title: "Chaos Engineering Through Staged Resiliency - Stage 3"
excerpt: ""
categories: [chaos-engineering]
tags: [resiliency, staging]
url: "https://www.gremlin.com/blog/?"
published: true
asset-path: chaos-engineering/chaos-engineering-through-staged-resiliency/stage-3
sources:
    - tags: [base source, walmart, resilience, chaosconf 2018]
      urls: https://medium.com/walmartlabs/charting-a-path-to-software-resiliency-38148d956f4a
    - tags: [slides, chaosconf 2018]
      urls: https://www.slideshare.net/secret/jj7mkHy5JKajpm
    - tags: [chaosconf 2018, resiliency, walmart, video]
      urls: https://www.youtube.com/watch?v=4Gy_5EQMrB4&index=5&list=PLLIx5ktghjqKtZdfDDyuJrlhC-ICfhVAN&t=0s
    - tags: [chaosconf 2018, resiliency, sre, interview]
      urls: https://www.infoq.com/articles/chaos-engineering-conf
    - tags: []
      urls: 
    - tags: []
      urls: 
    - tags: []
      urls: 
    - tags: []
      urls: 
    - tags: []
      urls: 
    - tags: []
      urls: 
    - tags: []
      urls: 
    - tags: []
      urls: 
    - tags: []
      urls: 
    - tags: []
      urls: 
    - tags: []
      urls:   
---

Performing occasional, manual resiliency testing is useful, but your system must be automatically and frequently tested to provide any real sense of stability.  In [Chaos Engineering Through Staged Resiliency - Stage 2][#stage-2] we focused on critical dependency failure testing in non-production environments.  To work through **Resiliency Stage 3** your team will need to begin automating these test and experiments.  This allows the testing frequency to improve dramatically and reduces the reliance manual processes.

## Prerequisites

- Creation and agreement on [Disaster Recovery and Dependency Failover Playbooks][#stage-1#prerequisites].
- Completion of [Resiliency Stage 1][#stage-1].
- Completion of [Resiliency Stage 2][#stage-2].

## Perform Frequent, Semi-Automated Tests

There's no more putting it off -- if you haven't already done so, this resiliency stage is where you begin integrating automation into your testing procedures.

> Use Gremlin or similar Chaos Engineering tools.

## Publish Test Results

## Execute a Resiliency Experiment in Production

> Level 3 — manual + automated — Regular exercises
> All of level 2 requirements, plus
> Run tests regularly on a cadence (at least once every 4–5 weeks)
> Publish results to dashboards to track resiliency over time
> Run at least one resiliency exercise (failure injection) in production environment

> level three is where automation starts kicking in. so we are pushing teams to start doing using tools right tools like gremlin we have internal tools which they can use to basically push that either infrastructure or that applications to fail and then see what the response looks like and make sure that they have good playbooks to fix that and reduce the revenue loss over time.

## Resiliency Stage 3: Implementation Example

### Perform Frequent, Semi-Automated Tests

- Status: **Complete**

### Execute a Resiliency Experiment in Production

- Status: **Complete**

### Publish Test Results and Track Over Time

- Status: **Complete**

## Resiliency Stage 3 Completion

{% include          links-global.md %}
{% include_relative links.md %}