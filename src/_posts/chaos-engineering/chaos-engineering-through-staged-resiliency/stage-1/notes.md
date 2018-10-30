---
published: false
---

{% comment %}

## Implementation Example

> Ansible?
> https://docs.ansible.com/ansible/latest/user_guide/playbooks.html
> https://galaxy.ansible.com/search?tags=cloud&order_by=-relevance&page_size=10

{% endcomment %}

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