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
        - https://aws.amazon.com/disaster-recovery/getting-started/
        - https://aws.amazon.com/blogs/startups/large-scale-disaster-recovery-using-aws-regions/
        - https://aws.amazon.com/blogs/aws/new-whitepaper-use-aws-for-disaster-recovery/
        - http://d36cz9buwru1tt.cloudfront.net/AWS_Disaster_Recovery.pdf
        - http://d36cz9buwru1tt.cloudfront.net/ESG_WP_AWS_DR_Jan_2012.pdf
        - https://dzone.com/articles/using-aws-disaster-recovery
    - tags: [service level agreement, SLA]
      urls: https://www.techrepublic.com/article/service-level-agreements-and-disaster-recovery/
    - tags: [recovery time objective, recovery point objective, disaster recovery]
      urls: 
        - https://en.wikipedia.org/wiki/Recovery_time_objective
        - https://en.wikipedia.org/wiki/Recovery_point_objective
    - tags: []
      urls: 
    - tags: [observability, tracing, monitoring]
      urls:
        - https://landing.google.com/sre/sre-book/toc/
        - https://ai.google/research/pubs/pub36356
        - https://blog.twitter.com/engineering/en_us/a/2016/observability-at-twitter-technical-overview-part-i.html
        - https://blog.twitter.com/engineering/en_us/a/2016/observability-at-twitter-technical-overview-part-ii.html
        - https://www.honeycomb.io/wp-content/uploads/2018/08/Honeycomb-Guide-Achieving-Observability-v1_1.pdf
---

In spite of what the name may suggest, Chaos Engineering is a _disciplined_ approach of identifying potential failures before they become outages.  Ultimately, the goal of Chaos Engineering is to create more stable and **resilient** systems.  There is some disagreement in the community about proper terminology, but regardless of which side of the [Chaos Engineering](https://medium.com/@jpaulreed/chaos-engineered-or-otherwise-is-not-enough-ad5792309ecf) vs [Resilience Engineering](https://www.linkedin.com/pulse/would-chaos-any-othername-casey-rosenthal/) debate you come down on, most engineers probably agree that proper implementation is more important than naming semantics.

Creating resilient software is a fundamental necessity within modern cloud applications and architectures.  As systems become more distributed the potential for unplanned outages and unexpected failure significantly increases.  Thankfully, Chaos and Resilience Engineering techniques are quickly gaining traction within the community.  [Many organizations](https://coggle.it/diagram/WiKceGDAwgABrmyv/t/chaos-engineering-companies%2C-people%2C-tools-practices) -- both big and small -- have embraced Chaos Engineering over the last few years.  In his fascinating [ChaosConf 2018][#chaosconf-2018] talk titled [_Practicing Chaos Engineering at Walmart_][#youtube-practicing], Walmart's Director of Engineering Vilas Veeraraghavan outlines how he and the hundreds of engineering teams at Walmart have implemented Resilience Engineering.  By creating a robust series of "levels" or "stages" that each engineering team can work through, Walmart is able to progressively improve system resiliency while dramatically reducing support costs.

This blog series expands on Vilas' and Walmart's techniques by diving deep into the five **Stages of Resiliency**.  Each post examines the necessary components of a stage, describes how those components are evaluated and assembled, and outlines the step-by-step process necessary to move from one stage to the next.

This series also digs into the specific implementation of each stage by progressing through the entire process with a real-world, fully-functional API application hosted on AWS.  We'll go through everything from defining and executing disaster recovery playbook scenarios to improving system architecture and reducing RTO, RPO, and applicable support costs for this example app.

With a bit of adjustment for your own organizational needs, you and your team can implement similar practices to quickly add Chaos Engineering to your own systems with relative ease.  After climbing through all five stages your system and its deployment will be almost entirely automated and will feature significant resiliency testing and robust disaster recovery failover.

**NOTE**: The remainder of this article will use the term `team` to indicate a singular group that is responsible for an application that is progressing through the resiliency stages.
{: .notice--tip }

## Prerequisites

{% comment %}

(TODO) ### Verify Observability

> Re, stage 1 of the maturity model. Any reason it’s missing observability and monitoring?
> Surprisingly enough, that’s a huge chunk that people miss
> It’s a critical part
> **And having a definition for observability, monitoring, and tracing will be helpful**
> Lots of people have no monitoring, et al, or they aren’t confident their monitoring is working properly
> Means we can’t sell them anything cause you can’t see the impact of an experiment without monitoring
> OR sometimes we literally run experiments to test their monitoring out
> At Walmart, they literally send out of band metrics to on call folks during an outage via slack and it’s automated
> So you get paged, and you immediately get data to ground you in context
> **Observability is making monitoring digestible and accessible and meaningful**
> I have some bigger ideas for how this will pan out as a content experience, so I may have more ideas incoming over the next few days

> https://blog.twitter.com/engineering/en_us/a/2016/observability-at-twitter-technical-overview-part-i.html
> https://blog.twitter.com/engineering/en_us/a/2016/observability-at-twitter-technical-overview-part-ii.html
> https://medium.com/@copyconstruct/monitoring-and-observability-8417d1952e1c

{% endcomment %}

Before you can begin moving through the resiliency stages there are a few prerequisite steps you'll need to complete.  Most of these requirements are standard fare for a well-designed system, but ensuring each and every unique application team is fully prepared for the unknown is paramount to developing resilient systems.

### 1. Establish High Observability

(TODO)

Microservice and clustered architectures favor the scalability and cost-efficiency of distributed computing, but also require a deep understanding of system behavior across a large pool of services and machines.  Robust observability is a necessity for most modern software, which tend to be comprised of these complex distributed systems.  

- **Monitoring**: The act of collecting, processing, aggregating, and displaying quantitative data about a system.  These data may be anything from query counts/types and error counts/types to processing times and server lifetimes.  Monitoring is a smaller subset of overall measure of observability.
- **Observability**: A measure of the ability to accurately infer what is happening internally within a system based solely on external information.

A properly observable system is one that allows your team to answer new questions about the internals of the system _without_ the need to deploy a new build.  Continuous monitoring is critical to catch unexpected behavior that is difficult to reproduce, but monitoring largely focuses on measuring "known unknowns."  By contrast, a highly-distributed system presents the need to track down and understand a multitude of "unknown unknowns" -- an obscure issue that has never happened before, and may never happen again.

Most importantly, high observability is critically important when implementing Chaos Engineering techniques.  As [Charity Majors](https://twitter.com/mipsytipsy), CEO of [Honeycomb](https://www.honeycomb.io/), puts it, "Without observability, you don't have 'chaos engineering'.  You just have chaos."

{% comment %}
- https://www.gremlin.com/blog/charity-majors-closing-the-loop-on-chaos-with-observability-chaos-conf-2018/
- https://www.honeycomb.io/wp-content/uploads/2018/08/Honeycomb-Guide-Achieving-Observability-v1_1.pdf
- https://landing.google.com/sre/sre-book/toc/
- https://ai.google/research/pubs/pub36356
- https://blog.twitter.com/engineering/en_us/a/2016/observability-at-twitter-technical-overview-part-i.html
- https://blog.twitter.com/engineering/en_us/a/2016/observability-at-twitter-technical-overview-part-ii.html
{% endcomment %}

### 2. Define the Critical Dependencies

Start by documenting every application dependency that is _required_ for the application to function at all.  This type of dependency is referred to as a **critical dependency**.

### 3. Define the Non-Critical Dependencies

Once all critical dependencies are identified then all remaining dependencies should be **non-critical dependencies**.  If the core application can still function -- even in a degraded state -- when a dependency is missing, then that dependency is considered non-critical.

### 4. Create a Disaster Recovery Failover Playbook

Your team should create a disaster recovery plan specific to **failover**.  A **disaster recovery failover playbook** should include the following information, at a minimum:

- **Contact information**: Explicitly document all relevant contact info for all team members.  Identifying priority team members based on seniority, role, expertise, and the like will prove beneficial for later steps.
- **Notification procedures**: This should answer all the "Who/What/When/Why/How" questions for notifying relevant team members.
- **Failover procedures**: Deliberate, step-by-step instructions for handling each potential **failover scenario**.

**TIP**: Not sure which failover scenarios to expect or plan for?  Unable to determine if a dependency is critical vs non-critical?  Consider running a GameDay to better prepare for and test specific scenarios in a controlled manner.  Check out [How to Run a GameDay](https://www.gremlin.com/community/tutorials/how-to-run-a-gameday/) for more info.
{: .notice--tip }

### 5. Create a Critical Dependency Failover Playbook

A **critical dependency failover playbook** is a subset of the disaster recovery failover playbook and it should detail the step-by-step procedures for handling the potential failover scenarios for each critical dependency.

### 6. Create a Non-Critical Dependency Failover Playbook

The final prerequisite is to determine how non-critical dependency failures will impact the system.  Your team may not _necessarily_ have failover procedures in place for non-critical dependencies, so this process can be as simple as testing and documenting what happens when each non-critical dependency is unavailable.  Be sure to gauge the **severity** of the failure impact on the core application, which will provide the team with a better understanding of the system and its interactions (see [Recovery Objectives][#recovery-objectives]).

#### Recovery Objectives

Most disaster recovery playbooks define the goals and allotted impact of a given failure using two common terms: **Recovery Time Objective** and **Recovery Point Objective**.

- **Recovery Time Objective (RTO)**: The maximum period of time in which the functionality of a failed service should be restored.  For example, if a service with an RTO of twelve hours experiences an outage at 5:00 PM then functionality should be restored to the service by 5:00 AM the next morning.
- **Recovery Point Objective (RPO)**: The maximum period of time during which data can be lost during a service failure.  For example, if a service with an RPO of two hours experiences an outage at 5:00 PM then _only_ data generated between 3:00 PM and 5:00 PM should be lost -- all existing data prior to 3:00 PM should still be intact.

{% asset '{{ page.asset-path }}'/rto-rpo-example-wikipedia.png alt='RTO & RPO Diagrammed - Courtesy of Wikipedia' %}{: .align-center }
_RTO & RPO Diagrammed -- Source: [Wikipedia](https://en.wikipedia.org/wiki/File:RPO_RTO_example_converted.png)_
{: .text-center }

## Complete and Publish Prerequisites

Ensure that all [Prerequisites][#prerequisites] have been met.  All playbooks, dependency definitions, and other relevant documentation should be placed in a singular, globally accessible location so every single team member has immediate access to that information.  Maintaining a single repository for the information also maintains consistency across the team, so there's never any confusion about the steps in a particular scenario or what is defined as a critical dependency.

## Team-Wide Agreement on Playbooks

With unfettered access to all documentation, the next step is to ensure the entire team agrees with all documented information as its laid out.  If there is disagreement about the best way to approach a given failover scenario, or about the risk and potential impact of a non-critical dependency failure, this is the best time to suss out those differences of opinion and come to a unanimous "best" solution.  A healthy, active debate provides the team with a deeper understanding of the system and encourages the best ideas and techniques to bubble up to the surface.

While the goal is agreement on the playbooks currently laid out, documentation can (and should) be updated in the future as experiments shed new light on the system.  The team should be encouraged and empowered to challenge the norms in order to create a system that is always adapting and evolving to be as resilient as possible.

## Manually Execute a Failover Exercise

The last step is to manually perform a failover exercise.  The goal of this exercise is to verify that the disaster recovery failover playbook works as expected.  Therefore, the step-by-step process defined in the playbook should be followed exactly as documented.

**WARNING**: If an action or step is not _explicitly_ documented within a playbook then it should be ignored.  If the exercise fails or cannot be completed this likely indicates that the playbook needs to be updated.
{: .notice--warning }

## Resiliency Stage 1: Implementation Example

Throughout this series, we'll take a simple yet real-world application through the entire staging process to illustrate how a team might progress their application through all five resiliency stages.  While every application and system architecture is unique, this example illustrates the basics of implementing every step within a stage, to provide you with a jumping off point for staged resiliency within your own system.

The [**Bookstore** example application](https://github.com/GabeStah/bookstore_api) is a publicly accessible API for a virtual bookstore.  The API includes two primary endpoints: `/authors/` and `/books/`, which can be used to add, update, or remove **Authors** and **Books**, respectively.

**Bookstore's** architecture consists of three core components, all of which are housed within Amazon Web Services.

- **API**: The API is created with Django and the [Django REST Framework](https://www.django-rest-framework.org/) and is hosted on an Amazon EC2 instance running NGINX.
- **Database**: A PostgreSQL database handles all data and uses Amazon RDS.
- **CDN**: All static content is collected in and served from an Amazon S3 bucket.

{% asset '{{ page.asset-path }}'/stage-1-architecture.png alt='Stage 1 - Initial' %}{: .align-center }
_Initial System Architecture_
{: .text-center }

The web API is at the publicly accessible [http://bookstore.pingpublications.com](http://bookstore.pingpublications.com) endpoint.  The web API, database, and CDN endpoints are DNS-routed via Amazon Route53 to the underlying Amazon EC2, RDS, and Amazon S3 buckets, respectively.

Here's a simple request to the `/books/` API endpoint.

```bash
$ curl http://bookstore.pingpublications.com/books/ | jq
[
  {
    "url": "http://bookstore.pingpublications.com/books/1/",
    "authors": [
      {
        "url": "http://bookstore.pingpublications.com/authors/1/",
        "birth_date": "1947-09-21",
        "first_name": "Stephen",
        "last_name": "King"
      }
    ],
    "publication_date": "1978-09-01",
    "title": "The Stand"
  }
]
```

**WARNING**: The initial design and architecture for the **Bookstore** sample application is _intentionally_ less resilient than a full production-ready system.  This leaves room for improvement as progress is made through the resiliency stages throughout this series.
{: .notice--warning }

### Prerequisites

We begin the example implementation by defining all prerequisites for the **Bookstore** app.

#### 0. Define System Architecture

It may be useful to take a moment to define the basic components of the system, which can then be referenced throughout your playbooks.  Below are the initial services for the **Bookstore** app.

| Service  | Platform   | Technologies    | AZ         | VPC           | Subnet              | Endpoint                           |
| -------- | ---------- | --------------- | ---------- | ------------- | ------------------- | ---------------------------------- |
| API      | Amazon EC2 | Django, Nginx   | us-west-2a | bookstore-vpc | bookstore-subnet-2a | bookstore.pingpublications.com     |
| Database | Amazon RDS | PostgreSQL 10.4 | us-west-2a | bookstore-vpc | bookstore-subnet-2a | db.bookstore.pingpublications.com  |
| CDN      | Amazon S3  | Amazon S3       | N/A        | N/A           | N/A                 | cdn.bookstore.pingpublications.com |

#### 1. Define the Critical Dependencies

At this early stage of the application _all_ dependencies are critical.

| Dependency | Criticality Period | Manual Workaround                    | RTO | RPO | Child Dependencies |
| ---------- | ------------------ | ------------------------------------ | --- | --- | ------------------ |
| API        | Always             | Manual Amazon EC2 Instance Restart   | 12  | 24  | Database, CDN      |
| Database   | Always             | Manual Amazon RDS Instance Restart   | 12  | 24  | N/A                |
| CDN        | Always             | Manual Amazon S3 Bucket Verification | 24  | 24  | N/A                |

A **criticality period** is useful for dependencies that are only considered "critical" during a specific period of time.  For example, a database backup service that runs at 2:00 AM PST every night may have a criticality period of `2:00 AM - 3:00 AM PST`.  This is also a good time to evaluate initial acceptable RTO and RPO values.  These values will decrease over time as resiliency improves, but setting a baseline goal provides a target to work toward.

#### 2. Define the Non-Critical Dependencies

The **Bookstore** app is so simple that it doesn't have any non-critical dependencies -- if a service fails, the entire application fails with it.

#### 3. Create a Disaster Recovery Failover Playbook

The first part of a disaster recovery failover playbook should contain contact information for all relevant team members, including the services those members are related to and their availability.

| Team Member | Position                      | Relevant Services | Email                 | Phone        | Availability                |
| ----------- | ----------------------------- | ----------------- | --------------------- | ------------ | --------------------------- |
| Alice       | Director of Technology        | ALL               | alice@example.com     | 555-555-5550 | 9 - 5, M - F                |
| Bob         | Lead Developer, Bookstore API | Bookstore API     | bob@example.com       | 555-555-5551 | 9 - 5, M - F; 10 - 2, S & S |
| Christina   | Site Reliability Engineer     | ALL               | christina@example.com | 555-555-5552 | On-call                     |

To define the proper notification procedures it may help to add an organizational chart to the playbook.

{% asset '{{ page.asset-path }}'/stage-1-org-chart.png alt='Stage 1 - Org Chart' %}{: .align-center }
_Organizational Chart_
{: .text-center }

This can be used in conjunction with the contact information table to determine which team members should be contacted -- and in what priority -- when a given service fails.

The final part of the disaster recovery failover playbook is to explicitly document the step-by-step procedures for every failover scenario.  For the **Bookstore** application, we'll just provide a single failover scenario plan for when the database fails, but this can be expanded as necessary for all other failover scenarios.

##### Scenario: Bookstore API Failure

The current architecture of the **Bookstore** app is limited to a manual _Backup & Restore_ disaster recovery strategy.

###### Disaster Recovery Leads

- Primary: Bob, Lead Developer, Bookstore API
- Secondary: Alice, Director of Technology

###### Severity

- Critical

**PURPOSE**: The severity level of this particular failover.  Severity should be a general indicator of acceptable RTO/RPO metrics, as well as how critically dependent the service is.
{: .notice--tip }

###### Recovery Procedure Overview

1. Manually verify if the API server has failed, or if the server is available but the Django API app failed.
    - If server failure: Manually restart API server.
    - If Django API app failure: Manually restart Django API app.
2. If neither restart solution works, propagate replacement server using prepared backup Amazon Machine Image (AMI).
3. Verify backup instance is functional.
4. Update DNS routing.

###### Basic Assumptions

- Amazon S3, Amazon RDS, Amazon Route 53, and Amazon EC2 are all online and functional.
- Frequent AMI backups are generated for the application instance.
- Application code can be restored from code repository with minimal manual effort.

**PURPOSE**: Indicates the basic assumptions that can be made during the recovery process.  Assumptions are typically factors outside of your control, such as third-party vendor availability.
{: .notice--tip }

###### Recovery Time Objective

- 12 Hours

###### Recovery Point Objective

- 24 Hours

###### Recovery Platform

- Amazon EC2 `t2.micro` instance on `us-west-2a` Availability Zone with NGINX, Python, and Django **Bookstore** application configured and installed from the latest release.

**PURPOSE**: Indicate the specific technologies, platforms, and services that are necessary to complete the recovery procedure.
{: .notice--tip }

###### Recovery Procedure

1. Manually verify the `bookstore-api` instance availability on Amazon EC2.

    ```bash
    $ curl http://bookstore.pingpublications.com
    curl: (7) Failed to connect to bookstore.pingpublications.com port 80: Connection refused
    ```

    - If the `bookstore-api` instance is active but **Bookstore** Django application is failing then manually restart app from the terminal.

        ```bash
        sudo systemctl restart gunicorn
        ```

    - If **Bookstore** Django application remains offline then manually restart the instance and recheck application availability.

2. If the `bookstore-api` EC2 instance has completely failed and must be replaced then propagate a new Amazon EC2 instance from the `bookstore-api-ec2-image` AMI backup.

    Use the pre-defined `bookstore-api-ec2` launch template.

    ```bash
    $ aws ec2 run-instances --launch-template LaunchTemplateName=bookstore-api-ec2
    532151327118   r-0e57eca4a2e78d479
    ...
    ```

    Default values can be overridden as seen below.

    ```bash
    aws ec2 run-instances \
        --image-id ami-087ff330c90e99ac5 \
        --count 1 \
        --instance-type t2.micro \
        --key-name gabe-ping-pub \
        --security-group-ids sg-25268a50 sg-0f818c22884a88694 \
        --subnet-id subnet-47ebaf0c
    ```

3. Confirm the instance has been launched and retrieve the public DNS and IPv4 address.

    ```bash
    $ aws ec2 describe-instances --filters "Name=image-id,Values=ami-087ff330c90e99ac5,Name=instance-state-code,Values=16" --query "Reservations[*].Instances[*].[LaunchTime,PublicDnsName,PublicIpAddress]"
    2018-11-09T04:37:32.000Z	ec2-54-188-3-235.us-west-2.compute.amazonaws.com	54.188.3.235
    ```

    **NOTE**: The `filters` used in the command above searched for **Running** instances based on the AMI `image-id`.  If multiple instances match these filters then the `LaunchTime` value retrieved from the query will help determine which instance is the latest launched.
    {: .notice--tip }

4. SSH into the new `bookstore-api` instance.

    ```bash
    ssh ec2-54-188-3-235.us-west-2.compute.amazonaws.com
    ```

5. Pull latest **Bookstore** application code from the repository.

    ```bash
    $ cd ~/apps/bookstore_api && git pull
    Already up to date.
    ```

6. Restart application via `gunicorn`.

    ```bash
    sudo systemctl restart gunicorn
    ```

7. On a local machine verify backup instance is functional, the public IPv4 address is available, and the **Bookstore** app is online.

    ```bash
    $ curl ec2-54-188-3-235.us-west-2.compute.amazonaws.com | jq
    {
      "authors": "http://ec2-54-188-3-235.us-west-2.compute.amazonaws.com/authors/",
      "books": "http://ec2-54-188-3-235.us-west-2.compute.amazonaws.com/books/"
    }
    ```

8. Update the Amazon Route 53 DNS `A` record to point to the new `bookstore-api` EC2 instance IPv4 address.
9. Once DNS propagation completes verify that the API endpoint is functional.

    ```bash
    $ curl bookstore.pingpublications.com | jq
    {
      "authors": "http://bookstore.pingpublications.com/authors/",
      "books": "http://bookstore.pingpublications.com/books/"
    }
    ```

###### Test Procedure

1. Manually verify that `bookstore.pingpublications.com` is accessible and functional.
2. Confirm that critical dependencies are functional and also connected (database and CDN).

**PURPOSE**: Indicates the test procedures necessary to ensure the system is functioning normally.
{: .notice--tip }

###### Resume Procedure

- Service is now fully restored.

**PURPOSE**: For more complex systems this final procedure should provide steps for resuming normal service.
{: .notice--tip }

#### 4. Create a Critical Dependency Failover Playbook

##### Scenario: Database Failure

###### Disaster Recovery Leads

- Primary: Alice, Director of Technology
- Secondary: Bob, Lead Developer, Bookstore API

###### Severity

- Critical

###### Recovery Procedure Overview

1. Manually verify database availability through Amazon RDS monitoring.
2. If unavailable, restart.
3. If still unavailable, manually propagate replica.
4. If necessary, restore from the most recent snapshot.

###### Basic Assumptions

- Amazon RDS is online and functional.
- Database backups are available.
- AWS Support contact is available for additional assistance.

###### Recovery Time Objective

- 12 Hours

###### Recovery Point Objective

- 24 Hours

###### Recovery Platform

- PostgreSQL 10.4 database with identical configuration running on Amazon RDS with minimal `us-west-2a` Availability Zone.

###### Recovery Procedure

1. Disaster recovery team member should manually verify database availability through Amazon RDS monitoring.
2. Manually restart the `bookstore-db` instance.
    - If `bookstore-db` is back online, proceed to _Resume Procedure_.
3. If `bookstore-db` remains unavailable manual propagate a replica Amazon RDS PostgreSQL 10.4 instance.
4. If replacement created, update DNS routing on Amazon Route 53 for `db.bookstore.pingpublications.com` endpoint.
5. _(Optional)_: Restore data from the most recent snapshot within acceptable RPO.

###### Test Procedure

1. Manually confirm a connection to public `bookstore-db` endpoint (`db.bookstore.pingpublications.com`).
2. Confirm that `bookstore-api` can access the `bookstore-db` instance.

###### Resume Procedure

- Service is now fully restored.
  - If necessary, perform manual data recovery.

##### Scenario: CDN Failure

###### Disaster Recovery Leads

- Primary: Alice, Director of Technology
- Secondary: Christina, Site Reliability Engineer

###### Severity

- Critical

###### Recovery Procedure Overview

1. Manual verification of applicable Amazon S3 bucket.
2. If unavailable, manually recreate bucket and upload a backup snapshot of static data.

###### Basic Assumptions

- Amazon S3 is online and functional.
- Static asset backups are available.
- Static asset collection can be performed remotely from the EC2 `bookstore-api` server or locally via Django `manage.py collectstatic` command.
- AWS Support contact is available for additional assistance.

###### Recovery Time Objective

- 24 Hours

###### Recovery Point Objective

- 24 Hours

###### Recovery Platform

- Amazon S3 `private` bucket accessible by administrator AWS account.

###### Recovery Procedure

1. Team member manually verifies Amazon S3 `cdn.bookstore.pingpublications.com` bucket exists, is accessible, and contains all static content.
2. Manually recreate `cdn.bookstore.pingpublications.com` bucket.
3. Manually upload all static content to `cdn.bookstore.pingpublications.com` bucket.
4. If `cdn.bookstore.pingpublications.com` bucket exists but is non-functional, manually create the bucket, upload static content, and route the system to backup.

###### Test Procedure

1. Confirm all static content exists in `cdn.bookstore.pingpublications.com` Amazon S3 bucket.
2. Confirm public endpoint (`cdn.bookstore.pingpublications.com/static`) is accessible for static content.
3. Confirm that `bookstore-api` can access `cdn.bookstore.pingpublications.com` bucket and content.

###### Resume Procedure

- Service is now fully restored.

#### 5. Create a Non-Critical Dependency Failover Playbook

The **Bookstore** example app doesn't have any non-critical dependencies at the moment given its simple architecture (`CDN > API Server < Database`).  However, progressing through each resiliency stage will _require_ additional systems and services to maintain failure resilience, which will inherently add non-critical dependencies.

### Complete and Available Prerequisites

- Status: **Complete**

All prerequisites for the **Bookstore** app have been met and all documentation has been dispersed among every member of the team.

### Team-Wide Agreement on Playbooks

- Status: **Complete**

Every team member has agreed on the playbook/scenarios defined above.

### Manually Execute a Failover Exercise

- Status: **Complete**

For this stage of the **Bookstore** app, we've manually performed the [Scenario: Bookstore API Failure](#scenario-bookstore-api-failure) exercise.

Full manual restoration of the `bookstore-api` EC2 instance and the **Bookstore** app resulted in approximately `30 minutes` of downtime.  This is well under the initial RTO/RPO goals so we can reasonably update the playbooks.  However, this manual process is still clunky and prone to errors, so there's plenty of room for improvement.

## Resiliency Stage 1 Completion

This post laid the groundwork for how to implement resilience engineering practices through thoughtfully-designed dependency identification and disaster recovery playbooks.  We also broke down the requirements and steps of **Resiliency Stage 1**, which empowers your team to begin the journey toward a highly-resilient system.  Stay tuned to the [Gremlin Blog](https://www.gremlin.com/blog/) for additional posts that will break down the four remaining **Stages of Resiliency**!

{% include          links-global.md %}
{% include_relative links.md %}