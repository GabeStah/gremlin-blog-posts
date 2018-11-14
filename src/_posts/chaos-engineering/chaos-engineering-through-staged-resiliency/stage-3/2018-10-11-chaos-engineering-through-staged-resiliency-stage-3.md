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
    - tags: [blue/green, aws]
      urls: https://aws.amazon.com/blogs/startups/upgrades-without-tears-part-2-bluegreen-deployment-step-by-step-on-aws/
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

There's no more putting it off -- it's time to begin automating your testing procedures.  During this third **Resiliency Stage** the team should aim to automate as much of the resiliency testing process as reasonably possible.  The overall goal of this stage isn't to finalize automation, but to work toward a regular cadence of testing.  The frequency of each test is up to the team, but once established it's critical that the schedule is maintained and automation handles at least _some_ of the testing process.

If the team isn't already doing so, this is a prime opportunity to introduce Chaos Engineering tools.  These tools empower the team to intelligently create controlled experiments that can be executed precisely when necessary.  For example, Gremlin attacks can be [scheduled](https://help.gremlin.com/attacks/#how-to-schedule-attacks-with-gremlin) to execute on certain days of the week and within a specified window of time.

## Execute a Resiliency Experiment in Production

> Configure Gremlin: https://help.gremlin.com/configuration/

## Publish Test Results

> Level 3 — manual + automated — Regular exercises
> All of level 2 requirements, plus
> Run tests regularly on a cadence (at least once every 4–5 weeks)
> Publish results to dashboards to track resiliency over time
> Run at least one resiliency exercise (failure injection) in production environment

> level three is where automation starts kicking in. so we are pushing teams to start doing using tools right tools like gremlin we have internal tools which they can use to basically push that either infrastructure or that applications to fail and then see what the response looks like and make sure that they have good playbooks to fix that and reduce the revenue loss over time.

## Resiliency Stage 3: Implementation Example

### Perform Frequent, Semi-Automated Tests

- Status: **Complete**

#### EC2 Instance Failure Test

> Use Gremlin attack.

> Lambda perhaps? https://aws.amazon.com/premiumsupport/knowledge-center/start-stop-lambda-cloudwatch/

#### CDN Failure Test

> (TODO) CloudWatch Agent: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html
> Monitor Scripts: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/mon-scripts.html

> 1. Create AWS CloudWatch Alarm/metric.
> 2. Automate AWS alarm trigger from `AWS CLI`
> 3. Failover CDN.

#### DB Failure Test

> (TODO) CloudWatch Agent: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html
> Monitor Scripts: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/mon-scripts.html

> 1. Create AWS CloudWatch Alarm/metric.
> 2. Automate AWS alarm trigger from `AWS CLI`
> 3. Failover CDN.

### Execute a Resiliency Experiment in Production

- Status: **Complete**

> Use Gremlin or similar Chaos Engineering tools.

### Publish Test Results and Track Over Time

- Status: **Complete**

## Resiliency Stage 3 Completion

{% include          links-global.md %}
{% include_relative links.md %}