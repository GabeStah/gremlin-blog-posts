---
title: "Chaos Engineering Through Staged Resiliency - Stage 2"
excerpt: ""
categories: [chaos-engineering]
tags: [resiliency, staging]
url: "https://www.gremlin.com/blog/?"
published: true
asset-path: chaos-engineering/chaos-engineering-through-staged-resiliency/stage-2
sources:
    - tags: [base source, walmart, resilience, chaosconf 2018]
      urls: https://medium.com/walmartlabs/charting-a-path-to-software-resiliency-38148d956f4a
    - tags: [slides, chaosconf 2018]
      urls: https://www.slideshare.net/secret/jj7mkHy5JKajpm
    - tags: [chaosconf 2018, resiliency, walmart, video]
      urls: https://www.youtube.com/watch?v=4Gy_5EQMrB4&index=5&list=PLLIx5ktghjqKtZdfDDyuJrlhC-ICfhVAN&t=0s
    - tags: [chaosconf 2018, resiliency, sre, interview]
      urls: https://www.infoq.com/articles/chaos-engineering-conf
    - tags: [deploy, cloud, scale, resilience, failure]
      urls: https://www.usenix.org/legacy/event/lisa07/tech/full_papers/hamilton/hamilton_html/index.html
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

(TODO)

In [Chaos Engineering Through Staged Resiliency - Stage 1][#stage-1], the first part of this series, we examined the prerequisites

## Prerequisites

- [Disaster Recovery and Dependency Failover Playbooks][#stage-1#prerequisites]
- Completion of [Resiliency Stage 1][#stage-1]

## Resiliency Stage 2: Critical Dependency Failure Testing in Non-Production

### Perform a Critical Dependency Failure Test in Non-Production

#### Manual Testing

### Publish Test Results

> Level 2 — Manual — critical dependency failures in pre-prod
> All of level 1 requirements, plus
> Run a failure test for critical dependencies in a non-prod environment
> Publish test results to team, stakeholders
> Manual tests are acceptable

> level two is it's again edited, all of these levels are edited. it this level to it the only thing that changes is making sure that you can do failure injection test for all of your dependencies for application dependencies. 

{% comment %}
{% asset '{{ page.asset-path }}'/Drawing1.png alt='RTO & RPO Diagrammed - Courtesy of Wikipedia' %}{: .align-center }
_RTO & RPO Diagrammed -- Source: [Wikipedia](https://en.wikipedia.org/wiki/File:RPO_RTO_example_converted.png)_
{: .text-center }
{% endcomment %}

## Conclusion

{% include          links-global.md %}
{% include_relative links.md %}