---
title: "Chaos Engineering Through Staged Resiliency - Stage 4"
excerpt: ""
categories: [chaos-engineering]
tags: [resiliency, staging]
url: "https://www.gremlin.com/blog/?"
published: true
asset-path: chaos-engineering/chaos-engineering-through-staged-resiliency/stage-4
sources:
    - tags: [base source, walmart, resilience, chaosconf 2018]
      urls: https://medium.com/walmartlabs/charting-a-path-to-software-resiliency-38148d956f4a
    - tags: [slides, chaosconf 2018]
      urls: https://www.slideshare.net/secret/jj7mkHy5JKajpm
    - tags: [chaosconf 2018, resiliency, walmart, video]
      urls: https://www.youtube.com/watch?v=4Gy_5EQMrB4&index=5&list=PLLIx5ktghjqKtZdfDDyuJrlhC-ICfhVAN&t=0s
    - tags: [chaosconf 2018, resiliency, sre, interview]
      urls: https://www.infoq.com/articles/chaos-engineering-conf
---

In [Chaos Engineering Through Staged Resiliency - Stage 3][#stage-3] we examined partial automation by implementing a handful of automated resiliency tests.  Now, as we progress through **Resiliency Stage 4** it's time to fully embrace automation: All resiliency testing in non-production environments should be completely automated, requiring little to no manual interaction.  After completing the entirety of this **Resiliency Stage** your application will be quite resilient and -- at least outside of production -- should require minimal supervision and support costs.  Let's get to it!

## Prerequisites

- Creation and agreement on [Disaster Recovery and Dependency Failover Playbooks][#stage-1#prerequisites].
- Completion of [Resiliency Stage 1][#stage-1].
- Completion of [Resiliency Stage 2][#stage-2].
- Completion of [Resiliency Stage 3][#stage-3].

## Automate Resiliency Testing in Non-Production

After progressing through [Resiliency Stage 3][#stage-3] your team implemented at least _some_ semi-automated resiliency testing.  However, this fourth stage is where all non-automated resiliency tests must also be integrated into your automated testing suite.  If your application features a development or other non-production environment, you can opt to integrate these automated resilience tests in that non-production environment, as full-blown production testing isn't required until [Stage 5][#stage-5].  However, the earlier the team starts thinking about and practicing implementation within production systems, the smoother the transition will be and the sooner you'll see that dramatic increase in resilience and drop in support costs that staged resiliency aims to provide.

## Semi-Automate Disaster Recovery Failover

In spite of everyone's best efforts, not all disaster can be avoided, so it's critical that the team implement at least a _semi_-automated disaster recovery failover script.  As with resiliency testing, it's best to automate as much of the disaster recovery failover process as possible, requiring as little human intervention as feasible.  However, depending on the breadth of the system and initial planning throughout the earlier **Resiliency Stages**, it's entirely possible your disaster recovery failover will require at least a modicum of human supervision.

As the team progresses through this stage make sure you follow the playbooks that have been previously established.  If something needs to be changed in a process or playbook, this is the time to suss that out and make those updates.

## Resiliency Stage 4: Implementation Example

As will sometimes be the case when your own team is working through each **Stage of Resiliency**, the **Bookstore** application has already been configured to automatically perform resiliency testing in non-production environments.  In **Stage 3** we explored [Performing a CDN Failure Simulation Test][#stage-3#performing-a-cdn-failure-simulation-test] and [Performing a DB Failure Simulation Test][#stage-3#performing-a-db-failure-simulation-test], which handles the major resiliency tests for the system by creating Gremlin attacks to sever the connection between the `bookstore-api` instances and the respective CDN/DB endpoints.

To ensure these tests are performed automatically, we can use the [Gremlin API](https://app.gremlin.com/api) or [web front-end](https://app.gremlin.com/attacks) to _automatically schedule_ attacks for our given testing schedule.  Similarly, we'd want to schedule an automatic disaster recovery failover test using a Gremlin [Shutdown Attack](https://help.gremlin.com/attack-params-ref/#shutdown), as illustrated in [Verifying Automated Instance Failover][#stage-3#verifying-automated-instance-failover] in **Stage 3**.  Check out the [Gremlin Help](https://help.gremlin.com/) documentation for more details on creating attacks with Gremlin.

## Resiliency Stage 4 Completion

You've automated resiliency testing in a non-production environment (and, ideally, even a bit in production).  Your team has also semi-automated disaster recovery failover procedures to ensure your service can moderately recover itself after a failure, with minimal human intervention.  In the last chapter of this series, [Chaos Engineering Through Staged Resiliency - Stage 5][#stage-5], we'll explore the final steps of fully automating resiliency testing in production, along with CI/CD integration to ensure your service maintains stability throughout every step of the software development life cycle.

{% include          links-global.md %}
{% include_relative links.md %}