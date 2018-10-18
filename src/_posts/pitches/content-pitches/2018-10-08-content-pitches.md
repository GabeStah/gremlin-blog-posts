---
title: "Content Pitches"
excerpt: "Content pitches and ideas for Gremlin."
categories: [gremlin]
tags: [content, idea]
published: true
sources: [
    
]
---

## Gremlin Docs Update

### Integrate Gremlin Help Style Guidelines

**Pitch**: Update overall [Gremlin documentation](https://help.gremlin.com/) to better adhere to a singular documentation style, with the aim of maintaining consistency across both current and future content.
{: .notice--warning}

While many style guides exist (and Gremlin may have a private guide already in use), the [Google Developer Documentation Style Guide](https://developers.google.com/style/) is a good generalized guide to take guidance from.  While much of that particular guide may not be relevant to Gremlin documentation, having consistent techniques helps determine when its appropriate to use elements like **bold**, _italic_, `inline code`, ```code blocks```, `hyphenated-file.names`, `CamelCase` vs `lowercase`, and so forth.

This process could also be part of other cleanup/update efforts, as seen below.

### Gremlin API Reference

**Pitch**: Update, cleanup, and expand the [Gremlin API Reference](https://help.gremlin.com/api/), in order to give public visitors a better understanding of its capabilities.
{: .notice--warning}

Cleanup to fix a lot of formatting inconsistencies (random headers, ordering, improper casing, etc).  Update to ensure no existing information is out of date with current practices.  Then expand document to include more robust information.  This could include adding additional **Attack** examples, blowing out valid flags and what they accomplish, including API examples beyond just **Attacks** (e.g. **Containers**, **Reports**, **Schedules**, etc).  Since the [https://app.gremlin.com/api](https://app.gremlin.com/api) API playground is locked behind an active account, expanding the [https://help.gremlin.com/api/](https://help.gremlin.com/api) documentation would allow public visitors to get a better sense of everything that can be accomplished with the API.

### Gremlin Installation Tutorials

**Pitch**: Update and expand [Gremlin Help](https://help.gremlin.com/api/) documentation, to ensure content is up to date and messaging is consistent across documentation.
{: .notice--warning}

General update process would include going through each `how to` tutorial to ensure every step is still relevant to modern Gremlin, making any necessary adjustments along the way.  Some minor adjustment examples:

- Update each tutorial `Introduction` to be consistent. For many tutorials begins with `Gremlin’s “Failure as a Service” makes it easy to find weaknesses in your system...`, but a handful have a different introduction ([AWS](https://help.gremlin.com/install-gremlin-aws/), [Docker](https://help.gremlin.com/install-gremlin-docker-ubuntu-1604/), etc).
- Update mentions of Gremlin auto-populated tags.  For example, [AWS tutorial](https://help.gremlin.com/install-gremlin-aws/#step-3-registering-with-gremlin) mentions a couple tags, but Gremlin now auto-generates 7+ tags for EC2 instances.
- Add screenshots where missing to expand content.  For example, the [Docker tutorial](https://help.gremlin.com/install-gremlin-docker-ubuntu-1604/) is very in-depth and includes many images to accompany text, whereas other tutorials are more limited.
- Tutorials can be expanded with additional information, such as alternative techniques (i.e. how to create **Attacks** via the API in addition to the web UI).

### Gremlin Installation - Video Tutorials

**Pitch**: Series of video walkthrough tutorials -- with accompanying voiceover -- showing how to install and use Gremlin on a given infrastructure/technology.
{: .notice--warning}

Video guides offer an alternative learning method for visitors, particularly those trying to determine what Gremlin is capable of and if its appropriate to their use case.  For those that prefer watching video to reading text, simple video tutorials that walkthrough the basic process of installing and using Gremlin on a given technology may be valuable.  While video guides can be published as standalone content to drive traffic, embedding accompanying video guides into existing documentation content would also be beneficial.

I have a professional microphone, recording equipment, and a lot of editing experience with Adobe Premiere Pro and After Effects.  I've created hundreds of commentary guides (for personal gaming-related projects) in the past, so I am certainly capable of handling the entirety of such a project, from inception and script creation to recording and voiceover to final editing and rendering.  _Note: I would need access to Gremlin imaging/PSD files or existing video clip to add a simple Gremlin-branded video introduction splash screen._

## How to Install Gremlin on OpenShift

**Pitch**: A walkthrough tutorial for setting up OpenShift and installing/using Gremlin on it.
{: .notice--warning}

I came close to creating such a guide while writing up the [Chaos Monkey Alternatives - OpenShift](https://gabestah.github.io/gremlin-chaos-monkey/alternatives/openshift/) chapter, but didn't have enough time to dedicate to troubleshoot the issues and finish up the process.  This guide would be similar to [How to Install and Use Gremlin with Kubernetes](https://www.gremlin.com/community/tutorials/how-to-install-and-use-gremlin-with-kubernetes/), since both require the use of a DaemonSet to get Gremlin deployed on each attackable machine.

## Chaos Tooling Showdown: X vs Y [Series]

**Pitch**: A blog series in which each article compares two popular Chaos Engineering tools.
{: .notice--warning}

The purpose of these pieces would be to try to provide a factual comparison of two similar tools skewed toward running Chaos Experiments and other general SRE tasks, while allowing the reader to decide which is better.  Each article might provide the following:

- Brief overview and explanation of each tool.
- Technical tutorial for basic installation, configuration, and usage of both tools.
- Comparison of each tool, perhaps using Advantage/Disadvantage list illustrating scenarios where one tool may be preferable.

**Note**: It would be ideal to remain as neutral as possible within the tone and content of these articles, to avoid appearing too biased (especially when comparing Gremlin to other tools).  Even a little bit of humility can go a long way.

### Gremlin vs Chaos Toolkit

**Pitch**: As discussed above, do a deep dive into both Gremlin and Chaos Toolkit, providing a basic installation and usage tutorial, and then comparing the advantages and disadvantages to each tool in a handful of scenarios.
{: .notice--warning}

For example, we could show that for `AWS` both tools can fairly easily handle `EC2` instance shutdowns, while Gremlin can perform network attacks that Chaos Toolkit cannot.

## Chaos Engineering Through Staged Resiliency [Series]

### STATUS: **Complete**

**Pitch**: Discuss the danger of performing random Chaos Experiments without first establishing a disaster recovery playbook safety net.
{: .notice--warning}

Rather than defining system resiliency as a binary "yes" or "no", outline how resiliency can be thought of as a series of defined "levels."  As resiliency level rises, support costs dramatically fall.  Each post focuses on a specific "resiliency level" and defines what it is, how it is implemented, and provides examples of what such a level of resiliency might look like in an organization.  Overall discussion emphasizes the importance of allowing teams to work towards "climbing the ladder" of resiliency, rather than trying to make a sudden leap from the bottom to the top.

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

### Level 1 — Manual — Getting agreement from all parties and DR failover

> - All of the pre-requisites stored in a single well-defined place
> - Agreement on playbooks to be used by Devs, Testers, Operations, Stakeholders
> - Manual exercise that validates the DR failover playbook

### Level 2 — Manual — critical dependency failures in pre-prod

> - All of level 1 requirements, plus
> - Run a failure test for critical dependencies in a non-prod environment
> - Publish test results to team, stakeholders
> - Manual tests are acceptable

### Level 3 — Manual and Automatic — Regular exercises

> - All of level 2 requirements, plus
> - Run tests regularly on a cadence (at least once every 4–5 weeks)
> - Publish results to dashboards to track resiliency over time
> - Run at least one resiliency exercise (failure injection) in production environment

### Level 4 — Automated — fully automated in pre-prod

> - All of level 3 requirements, plus
> - Automated resiliency testing in non-prod environment
> - Semi-automated DR failover scripts (minimal human supervision required)

### Level 5 — Full automation

> - All of level 4 requirements, plus
> - Automated resiliency testing fully integrated into CI/CD environment
> - Resiliency failure results in build failure
> - Automated resiliency testing and DR failover testing enabled in production environment

## How to Build Effective Disaster Recovery Strategies

**Pitch**: 1 - 2 articles discussing **Disaster Recovery** techniques including guides for implementing a basic disaster recovery plan on the more common platforms (AWS, Azure, etc).
{: .notice--warning}

Articles will also explore subsets of disaster recovery such as failover playbooks and how Chaos practices (e.g. gamedays) fit into proper disaster recovery strategies.

## Deploying a Chaos Engineered Stack with Ansible Playbooks

**Pitch**: Article(s) providing a step-by-step tutorial for deploying a (simple) application stack in the cloud using [Ansible Playbooks](https://docs.ansible.com/ansible/latest/user_guide/playbooks.html) that _includes_ Gremlin ready to go ("pre-installed") as a Chaos Engineering solution.
{: .notice--warning}

Total length is unknown but would likely be rather in-depth as Ansible playbooks can get complex.  Gremlin auto-inclusion would need to be tested to see how feasible/workable this idea is.

## Uncategorized

### Blameless.com Ideas

**Pitch**: _**(TBD)**_
{: .notice--warning}

> ag (Slack): "each of the points on [this page](https://blameless.com/why-blameless/) could probably be incorporated into a blog post"

> DEVOPS IS REVOLUTIONIZING SOFTWARE DELIVERY.
> It knocks down barriers in software development, changing how engineering and operations teams work together. It promotes greater communication, faster release cycles, and better code delivery to end-users.

> WHAT'S MISSING IS THE INSTRUCTION MANUAL.
> How do you bridge the gap between development and operations? How do you ensure stability as you release more frequently? How do you measure success?

> SRE ANSWERS THE HOW.
> SRE (Site Reliability Engineering) makes software realiable in highly complex and ever-changing systems. SRE is implemented by the largest technology companies and being adopted by teams of all sizes.

> WHY BLAMELESS FOR SRE
> Blameless is the first step towards building your SRE practice.
> Our reliability platform helps teams quickly implement SRE best practices, workflows and tooling, resulting in more effective:

> Collaboration & Communication
> Resolve incidents faster by ensuring clear roles & processes.

> Post-Incident Workflows
> Prevent incident recurrence by learning from key data.

> Insights & Visibility
> Measure reliability with dashboards, data & reports and get insights on how to improve.

> REPORTS & DASHBOARDS
> Reliability metrics make it easy to track improvements in SLAs, org health and feature velocity over time.

> INTEGRATIONS WITH EXISTING TOOLS
> Blameless handles tool and data sprawl by integrating into your existing incident, risk and problem management workflow.

> CHAT AND VIDEO INCIDENT RESOLUTION
> Resolve incidents faster with incident roles, playbooks, war room transcriptions, real time timeline generation and more.

> INCIDENT KNOWLEDGE MANAGEMENT
> Learn painlessly and quickly using our retrospective tooling and workflow. Automatically capture incident data, build timelines, and keep a record of all prior incidents.

> COMMUNICATION MANAGEMENT
> Protect your brand and build trust by keeping internal and external stakeholders notified when an incident occurs.

> AUTOMATED PLAYBOOKS
> Take SRE actions across your infrastructure. Schedule orchestration jobs, build playbooks and automate best practices.

{% include links-global.md %}