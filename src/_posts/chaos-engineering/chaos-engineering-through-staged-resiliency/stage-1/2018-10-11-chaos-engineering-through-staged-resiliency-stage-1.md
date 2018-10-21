---
title: "Chaos Engineering Through Staged Resiliency - Stage 1"
excerpt: ""
categories: [chaos-engineering]
tags: [resiliency, staging]
url: "https://www.gremlin.com/blog/?"
published: true
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
        - http://d36cz9buwru1tt.cloudfront.net/AWS_Disaster_Recovery.pdf
        - http://d36cz9buwru1tt.cloudfront.net/ESG_WP_AWS_DR_Jan_2012.pdf
    - tags: [service level agreement, SLA]
      urls: https://www.techrepublic.com/article/service-level-agreements-and-disaster-recovery/
    - tags: [recovery time objective, recovery point objective, disaster recovery]
      urls: 
        - https://en.wikipedia.org/wiki/Recovery_time_objective
        - https://en.wikipedia.org/wiki/Recovery_point_objective
    - tags: []
      urls: 
    - tags: []
      urls: 
    - tags: []
      urls:   
---

In spite of what the name may suggest, Chaos Engineering is a _disciplined_ approach of identifying potential failures before they become outages.  Ultimately, the goal of Chaos Engineering is to create more stable and **resilient** systems.  There is some disagreement in the community about proper terminology, but regardless of which side of the [Chaos Engineering](https://medium.com/@jpaulreed/chaos-engineered-or-otherwise-is-not-enough-ad5792309ecf) vs [Resilience Engineering](https://www.linkedin.com/pulse/would-chaos-any-othername-casey-rosenthal/) debate you come down on, most engineers probably agree that proper implementation is more important than naming semantics.

Creating resilient software is a fundamental necessity within modern cloud applications and architectures.  As systems become more distributed the potential for unplanned outages and unexpected failure significantly increases.  Thankfully, Chaos and Resilience Engineering techniques are quickly gaining traction within the community.  [Many organizations](https://coggle.it/diagram/WiKceGDAwgABrmyv/t/chaos-engineering-companies%2C-people%2C-tools-practices) -- both big and small -- have embraced Chaos Engineering over the last few years.  In his fascinating [ChaosConf 2018][#chaosconf-2018] talk titled [_Practicing Chaos Engineering at Walmart_][#youtube-practicing], Walmart's Director of Engineering Vilas Veeraraghavan outlines how he and the hundreds of engineering teams at Walmart have implemented Resilience Engineering.  By creating a robust series of "levels" or "stages" that each engineering team can work through, Walmart is able to progressively improve system resiliency while dramatically reducing support costs.

This blog series expands on Vilas' and Walmart's techniques by diving deep into the **five** _Stages of Resiliency_.  Each post examines the necessary components of a stage, describes how those components are evaluated and assembled, and outlines the step-by-step process necessary to move from one stage to the next.  With a bit of adjustment for your own organizational needs, you and your team can implement similar practices to quickly add Chaos Engineering to your own systems with relative ease.  After climbing through all five stages your system and its deployment will be almost entirely automated and will feature significant resiliency testing and robust disaster recovery failover.

**NOTE**: The remainder of this article will use the term `team` to indicate a singular group that is responsible for an application that is progressing through the resiliency stages.
{: .notice--tip }

## Prerequisites

Before you can begin moving through the resiliency stages there are a few prerequisite steps you'll need to complete.  Most of these requirements are standard fare for a well-designed system, but ensuring each and every unique application team is fully prepared for the unknown is paramount to developing resilient systems.

### 1. Define the Critical Dependencies

Start by documenting every application dependency that is _required_ for the application to function at all.  This type of dependency is referred to as a **critical dependency**.

### 2. Define the Non-Critical Dependencies

Once all critical dependencies are identified then all remaining dependencies should be **non-critical dependencies**.  If the core application can still function -- even in a degraded state -- when a dependency is missing, then that dependency is considered non-critical.

### 3. Create a Disaster Recovery Failover Playbook

Your team should create a disaster recovery plan specific to **failover**.  A **disaster recovery failover playbook** should include the following information, at a minimum:

- **Contact information**: Explicitly document all relevant contact info for all team members.  Identifying priority team members based on seniority, role, expertise, and the like will prove beneficial for later steps.
- **Notification procedures**: This should answer all the "Who/What/When/Why/How" questions for notifying relevant team members.
- **Failover procedures**: Deliberate, step-by-step instructions for handling each potential **failover scenario**.

**TIP**: Not sure which failover scenarios to expect or plan for?  Unable to determine if a dependency is critical vs non-critical?  Consider running a GameDay to better prepare for and test specific scenarios in a controlled manner.  Check out [How to Run a GameDay](https://www.gremlin.com/community/tutorials/how-to-run-a-gameday/) for more info.
{: .notice--tip }

### 4. Create a Critical Dependency Failover Playbook

A **critical dependency failover playbook** is a subset of the disaster recovery failover playbook and it should detail the step-by-step procedures for handling the potential failover scenarios for each critical dependency.

### 5. Create a Non-Critical Dependency Failover Playbook

The final prerequisite is to determine how non-critical dependency failures will impact the system.  Your team may not _necessarily_ have failover procedures in place for non-critical dependencies, so this process can be as simple as testing and documenting what happens when each non-critical dependency is unavailable.  Be sure to gauge the **severity** of the failure impact on the core application, which will provide the team with a better understanding of the system and its interactions (see [Recovery Objectives][#recovery-objectives]).

#### Recovery Objectives

Most disaster recovery playbooks define the goals and allotted impact of a given failure using two common terms: **Recovery Time Objective** and **Recovery Point Objective**.

- **Recovery Time Objective**: RTO defines the maximum period of time in which the functionality of a failed service should be restored.  For example, if a service with an RTO of twelve hours experiences an outage at 5:00 PM then functionality should be restored to the service by 5:00 AM the next morning.
- **Recovery Point Objective**: RPO defines the maximum period of time during which data can be lost during a service failure.  For example, if a service with an RPO of two hours experiences an outage at 5:00 PM then _only_ data generated between 3:00 PM and 5:00 PM should be lost -- all existing data prior to 3:00 PM should still be intact.

{% asset '{{ page.asset-path }}'/rto-rpo-example-wikipedia.png alt='RTO & RPO Diagrammed - Courtesy of Wikipedia' %}{: .align-center }
_RTO & RPO Diagrammed -- Source: [Wikipedia](https://en.wikipedia.org/wiki/File:RPO_RTO_example_converted.png)_
{: .text-center }

## Resiliency Stage 1: Prerequisites, Playbook Agreement, and Manual Failover Exercises

It's now time to work through the first of the five resiliency stages by confirming all prerequisite steps have been completed, ensuring the entire team agrees on everything defined in the prerequisites, and manually performing at least one failover exercise.

### Complete and Available Prerequisites

Ensure that all [Prerequisites][#prerequisites] have been met.  All playbooks, dependency definitions, and other relevant documentation should be placed in a singular, globally accessible location so every single team member has immediate access to that information.  Maintaining a single repository for the information also maintains consistency across the team, so there's never any confusion about the steps in a particular scenario or what is defined as a critical dependency.

### Team-Wide Agreement on Playbooks

With unfettered access to all documentation, the next step is to ensure the entire team agrees with all documented information as its laid out.  If there is disagreement about the best way to approach a given failover scenario or the risk and potential impact of a non-critical dependency failure, this is the best time to suss out those differences of opinion and come to a unanimous "best" solution.  A healthy, active debate provides the team with a deeper understanding of the system and encourages the best ideas and techniques to bubble up to the surface.

While the goal is agreement on the playbooks currently laid out, documentation can (and should) be updated in the future as experiments shed new light on the system.  The team should be encouraged and empowered to challenge the norms in order to create a system that is always adapting and evolving to be as resilient as possible.

### Manually Execute a Failover Exercise

The last step is to manually perform a failover exercise.  The goal of this exercise is to verify that the disaster recovery failover playbook works as expected.  Therefore, the step-by-step process defined in the playbook should be followed exactly as documented.

**WARNING**: If an action or step is not _explicitly_ documented within a playbook then it should be ignored.  If the exercise fails or cannot be completed this likely indicates that the playbook needs to be updated.
{: .notice--warning }

{% comment %}

## Implementation Example

> Ansible?
> https://docs.ansible.com/ansible/latest/user_guide/playbooks.html
> https://galaxy.ansible.com/search?tags=cloud&order_by=-relevance&page_size=10

{% endcomment %}

## Additional Stages

This post laid the groundwork for how to implement resilience engineering practices through thoughtfully-designed dependency identification and disaster recovery playbooks.  We also broke down the requirements and steps of _Resiliency Stage 1_, which empowers your team to begin the journey toward a highly-resilient system.  Stay tuned to the [Gremlin Blog](https://www.gremlin.com/blog/) for additional posts that will break down the four remaining _Stages of Resiliency_!

{% comment %}
> Stage 1 — Manual — Getting agreement from all parties and DR failover

> - All of the pre-requisites stored in a single well-defined place
> - Agreement on playbooks to be used by Devs, Testers, Operations, Stakeholders
> - Manual exercise that validates the DR failover playbook

> so level one
> so once you have all of your prerequisites completed, level one was given as a first step for every team to even start educating themselves about what is resiliency. so all of the prerequisites are stored in a well known place. we have agreement on those playbooks. it's not like I write something and then someone else doesn't even know how to run it. we have to make sure that it's in a language that makes sense to everyone. and we end that level one by making sure that we can do a failover exercise manually that verifies that the playbook actually works.

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
{% endcomment %}

{% comment %}
{% asset '{{ page.asset-path }}'/web-ui-blackhole-attack.png %}{: .align-center}
{% endcomment %}

{% include          links-global.md %}
{% include_relative links.md %}