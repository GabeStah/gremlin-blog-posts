---
title: "Chaos Engineering Through Staged Resiliency - Stage 1"
excerpt: ""
categories: [chaos-engineering]
tags: [resiliency, staging]
url: "https://www.gremlin.com/blog/?"
published: false
asset-path: chaos-engineering/chaos-engineering-through-staged-resiliency/stage-1
sources:
    - tags: [base source, walmart, resilience, chaosconf 2018]
      urls: https://medium.com/walmartlabs/charting-a-path-to-software-resiliency-38148d956f4a
    - tags: [slides, chaosconf 2018]
      urls: https://www.slideshare.net/secret/jj7mkHy5JKajpm
    - tags: [chaosconf 2018, resiliency, walmart, video]
      urls: https://www.youtube.com/watch?v=4Gy_5EQMrB4&index=5&list=PLLIx5ktghjqKtZdfDDyuJrlhC-ICfhVAN&t=0s
    - tags: [chaosconf 2018, resiliency, sre, interview]
      urls: https://www.infoq.com/articles/chaos-engineering-conf
    - tags: [disaster recovery, failover, site recovery]
      urls: https://docs.microsoft.com/en-us/azure/site-recovery/site-recovery-failover
    - tags: [disaster recovery, jira]
      urls: https://confluence.atlassian.com/enterprise/disaster-recovery-guide-for-jira-692782022.html
    - tags: [disaster recovery]
      urls: https://cloud.google.com/solutions/dr-scenarios-planning-guide
    - tags: [aws, disaster recovery]
      urls: 
        - https://aws.amazon.com/disaster-recovery/
        - https://aws.amazon.com/blogs/startups/large-scale-disaster-recovery-using-aws-regions/
        - https://aws.amazon.com/blogs/aws/new-whitepaper-use-aws-for-disaster-recovery/
    - tags: [service level agreement, SLA]
      urls: https://www.techrepublic.com/article/service-level-agreements-and-disaster-recovery/
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

## Introduction

In spite of what the name may suggest, Chaos Engineering is the _disciplined_ approach of identifying potential failures before they become outages.  Ultimately, the goal of Chaos Engineering is to create more stable and **resilient** systems.  There is some disagreement in the community about proper terminology, but regardless of which side of the [Chaos Engineering](https://medium.com/@jpaulreed/chaos-engineered-or-otherwise-is-not-enough-ad5792309ecf) vs [Resilience Engineering](https://www.linkedin.com/pulse/would-chaos-any-othername-casey-rosenthal/) debate you come down on, most engineers probably agree that proper implementation is more important than naming semantics.

Creating resilient software is a fundamental necessity within modern cloud applications and architectures.  As systems become more distributed the potential for unplanned outages and unexpected failure significantly increases.  Thankfully, Chaos and Resilience Engineering techniques are quickly gaining traction within the community.  [Many organizations](https://coggle.it/diagram/WiKceGDAwgABrmyv/t/chaos-engineering-companies%2C-people%2C-tools-practices), both big and small, have embraced Chaos Engineering over the last few years.  In his fascinating [ChaosConf 2018][#chaosconf-2018] talk titled [_Practicing Chaos Engineering at Walmart_][#youtube-practicing], Walmart's Director of Engineering Vilas Veeraraghavan outlines how he and the hundreds of engineering teams at Walmart have implemented Resilience Engineering.  By creating a robust series of "levels" or "stages" that each separate engineering team can work through, Walmart is able to progressively improve system resiliency while dramatically reducing support costs.

This blog series expands on Vilas' and Walmart's techniques by diving deep into each of the **five** _Stages of Resiliency_.  Each post examines the necessary components of a stage, describes how those components are evaluated and assembled, and outlines the step-by-step process necessary to move from one stage to the next.  With a bit of adjustment for your own organizational needs, you and your team can implement similar practices to quickly add Chaos Engineering to your own systems with relative ease.  After climbing through all five stages your system and its deployment will be almost entirely automated and will feature significant resiliency testing and robust disaster recovery failover.

## Prerequisites

Before you can begin moving through the resiliency stages there are a few prerequisite steps you'll need to complete.  Most of these requirements are standard fare for a well-designed system, but ensuring each and every unique application team is fully prepared for the unknown is paramount to developing resilient systems.

The remainder of this article will use the term `team` to indicate a singular group that is responsible for a system or application that is progressing through the resiliency stages.
{: .notice--warning }

### 1. Create a Disaster Recovery Failover Playbook



### 2. Define the Critical Dependencies

### 3. Create a Critical Dependency Failover Playbook

### 4. Define the Non-Critical Dependencies

### 5. Determine When Non-Critical Dependency Failures Will Impact the System

## Disaster Recovery Goals

> Infrastructure issues - failures, glitches, faulty maintenance policies
> Dependency failures - changing versions of APIs, changing SLAs (Service Level Agreements)
> SLA info: https://www.techrepublic.com/article/service-level-agreements-and-disaster-recovery/
> Deployment issues - Are you even deployed correctly?

> Critical dependencies are defined as dependencies such that — Service cannot function in any shape or form without them
> Non-Critical dependencies — Service can function in a degraded state if these are unavailable.
> The playbook is a documented set of steps that will be executed in the event of a disaster or a failure. By separating out critical and non-critical dependencies for a given application, teams gain a deeper understanding of their systems and this promotes active debate and encourages teams to systematically run experiments so they can determine the dependencies.
> Once teams complete this step, they are ready to begin their journey.

> Roles of Cloud Platform team:
> - Centralize the best practices, tools and techniques
> - Enforce and facilitate gamedays
> - Create tools for every phase of the CD pipeline
> - Monitor acceptable levels of resiliency and call out "risks"

> 5 Stages of Resiliency:
> - 1: High revenue loss, high support costs, and low resiliency.
> - 5: Low revenue loss, low support costs, and high resiliency.

> Prerequisites:
> 1. Create your DR failover playbook.
> 2. Define critical dependencies.
> 3. Compose playbook for critical dependency failures.
> 4. Define non-critical dependencies.
> 5. Define thresholds at which non-critical dependency failures will impact system.

> Customer comes first
> The customer experiencbe is paramount, antying that impacts customer experience and causes revenue loss is first thing we should be facing.
> 
> Teams OWN resiliency
> Each team is responsible for ensuring the quality of their product is absolutely the best.
> 
> Fail fast, fail often
> Teams shoudl be encouraged to fail fast and often.  Run gamedays

## Cloud Platform Team

> Centralize the best practices, tools, and techniques
> enforce and facilitate gamedays
> create tools for every phase of the CD pipeline
> monitor acceptable levels of resiliency and call out "risks"

{% comment %}
{% asset '{{ page.asset-path }}'/web-ui-blackhole-attack.png %}{: .align-center}
{% endcomment %}

## Conclusion

{% include          links-global.md %}
{% include_relative links.md %}