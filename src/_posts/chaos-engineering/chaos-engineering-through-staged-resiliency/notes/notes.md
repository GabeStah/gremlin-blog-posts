---
published: false
---

## Chaos Engineering Through Staged Resiliency [Series]

> https://medium.com/walmartlabs/charting-a-path-to-software-resiliency-38148d956f4a
> 
> Step 1 — Get a checkup from the resiliency doctor
> Before running any resiliency exercises, we need to ensure that applications are deployed right. This means checking if they are configured correctly in their respective cloud (private or public), their instances are healthy, metrics are flowing in, and observability is high.
> This is done using a tool we wrote internally called the Resiliency Doctor (docRx for short). The tool is a debugging tool for your application deployment. For every application, it does the following -
> Provides a one page report for the entire hybrid cloud deployment
> Serves as a debug tool and an enforcement tool
> Performs both passive and active checks
> Step 2 — Start climbing levels
> Once docRx clears the team for testing, the resiliency level climb begins. Teams control their own velocity through the process. Here is a description of the levels

**Pitch**: Discuss the danger of performing random Chaos Experiments without first establishing a disaster recovery playbook safety net.
{: .notice--warning}

Rather than defining system resiliency as a binary "yes" or "no", outline how resiliency can be thought of as a series of defined "stages."  As resiliency stage rises, support costs dramatically fall.  Each post focuses on a specific "resiliency level" and defines what it is, how it is implemented, and provides examples of what such a level of resiliency might look like in an organization.  Overall discussion emphasizes the importance of allowing teams to work towards "climbing the ladder" of resiliency, rather than trying to make a sudden leap from the bottom to the top.

Sources:

- https://medium.com/walmartlabs/charting-a-path-to-software-resiliency-38148d956f4a
- https://www.youtube.com/watch?v=4Gy_5EQMrB4&index=5&list=PLLIx5ktghjqKtZdfDDyuJrlhC-ICfhVAN&t=0s
- https://www.slideshare.net/secret/jj7mkHy5JKajpm?from_action=save
- https://www.infoq.com/articles/chaos-engineering-conf

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

### Stage 1 — Manual — Getting agreement from all parties and DR failover

> - All of the pre-requisites stored in a single well-defined place
> - Agreement on playbooks to be used by Devs, Testers, Operations, Stakeholders
> - Manual exercise that validates the DR failover playbook

### Stage 2 — Manual — critical dependency failures in pre-prod

> - All of level 1 requirements, plus
> - Run a failure test for critical dependencies in a non-prod environment
> - Publish test results to team, stakeholders
> - Manual tests are acceptable

> level two is it's again edited, all of these levels are edited. it this level to it the only thing that changes is making sure that you can do failure injection test for all of your dependencies for application dependencies.

### Stage 3 — Manual and Automatic — Regular exercises

> - All of level 2 requirements, plus
> - Run tests regularly on a cadence (at least once every 4–5 weeks)
> - Publish results to dashboards to track resiliency over time
> - Run at least one resiliency exercise (failure injection) in production environment

> level three is where automation starts kicking in. so we are pushing teams to start doing using tools right tools like gremlin we have internal tools which they can use to basically push that either infrastructure or that applications to fail and then see what the response looks like and make sure that they have good playbooks to fix that and reduce the revenue loss over time.

### Stage 4 — Automated — fully automated in pre-prod

> - All of level 3 requirements, plus
> - Automated resiliency testing in non-prod environment
> - Semi-automated DR failover scripts (minimal human supervision required)

> level four increases the amount of automation.

### Stage 5 — Full automation

> - All of level 4 requirements, plus
> - Automated resiliency testing fully integrated into CI/CD environment
> - Resiliency failure results in build failure
> - Automated resiliency testing and DR failover testing enabled in production environment

> by the time you are at level five you are completely automated and literally the only support that someone in sre or SiteOps have to give you is a few hours of engineer time to ensure that the right buttons are clicked.