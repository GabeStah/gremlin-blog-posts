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

In [Chaos Engineering Through Staged Resiliency - Stage 1][#stage-1] we explored how engineering teams at Walmart successfully identify and combat unexpected system failure using a series of "resiliency stages."  Completing **Resiliency Stage 1** requires the definition of a disaster recovery failover playbook, dependency failover playbooks, team-wide agreement on said playbooks, and execution of a manual failover exercise.

In this second part we'll dive into the components of **Resiliency Stage 2**, which focuses on critical dependency failure testing in non-production environments.

## Resiliency Stage 2: Critical Dependency Failure Testing in Non-Production

### Prerequisites

- Creation and agreement on [Disaster Recovery and Dependency Failover Playbooks][#stage-1#prerequisites].
- Completion of [Resiliency Stage 1][#stage-1].

### Perform Critical Dependency Failure Tests in Non-Production

The most important aspect of **Resiliency Stage 2** is testing the resilience of your systems when critical dependencies fail.  However, this early in the process the system can't be expected to handle such failures in a production environment, so these tests should be performed in a non-production setting.  

#### Manual Testing Is Okay

Eventually, all experiments should be executed automatically, with little to no human intervention required.  However, during **Resiliency Stage 2** the team should feel comfortable performing manual tests.  The goal here isn't to test the _automation_ of the system, but rather to determine the outcome and system-wide impact whenever a critical dependency fails.

### Publish Test Results

After every critical dependency failure test is performed the results should be globally published to the entire team.  This allows every team member to closely scrutinize the outcome of a given test.  This encourages feedback and communication, which naturally provides insightful evaluation from the members that are best equipped to analyze the test results.

## Implementation Example

(TODO)

## Stage 2 Completion

Once all critical dependencies have been failure tested and those test results have been disseminated throughout the team then **Resiliency Stage 2** is complete!  Your system should now have well-defined recovery playbooks and been manually tested for both failover and critical dependency failures.  In [Chaos Engineering Through Staged Resiliency - Stage 3][#stage-3] we'll look at the transition into automating some of these tests and performing them at regular intervals.

{% include          links-global.md %}
{% include_relative links.md %}