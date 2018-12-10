---
title: "Chaos Engineering Through Staged Resiliency - Stage 5"
excerpt: ""
categories: [chaos-engineering]
tags: [resiliency, staging]
url: "https://www.gremlin.com/blog/?"
published: true
asset-path: chaos-engineering/chaos-engineering-through-staged-resiliency/stage-5
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

We've finally made it to the last **Resiliency Stage**, where your team will be working toward full automation of both resiliency testing and disaster recovery failover procedures.  [Chaos Engineering Through Staged Resiliency - Stage 4][#stage-4]
emphasized the importance of looking toward the production environment for automation, but this final **Resiliency Stage 5** is where all remaining non-automated tests and processes must be automated _within production_.  That's not to say you _cannot_ have any human interactions involved, but rather, that a given resiliency testing or disaster recovery process must not _rely on_ human intervention to succeed.

Once your team has progressed through this final stage your system will be extremely resilient and will require _far_ fewer support hours, including reduced support costs in the event of a failure.

## Prerequisites

- Creation and agreement on [Disaster Recovery and Dependency Failover Playbooks][#stage-1#prerequisites].
- Completion of [Resiliency Stage 1][#stage-1].
- Completion of [Resiliency Stage 2][#stage-2].
- Completion of [Resiliency Stage 3][#stage-3].
- Completion of [Resiliency Stage 4][#stage-4].

## Integrate Automatic Resiliency Testing in CI/CD

For systems relying on continuous integration and continuous deployment, this final stage is when you should integrate automatic resiliency testing within the CI/CD process.  

Additionally, a failed resiliency test should also result in a build and/or deployment failure.  Just as with application-level unit testing, resiliency testing should always be 100% successful prior to releasing a given build, so this prerequisite helps maintain system stability.

## Automate Resiliency and Disaster Recovery Failover Testing in Production

The final and most critical requirement for **Resiliency Stage 5** is the nearly-total automation of both resiliency and disaster recovery failover testing in the **production** environment.  An SRE _can_ be involved, but everything should be so automated that running tests merely requires a minimal amount of support time to get the process started.

## Resiliency Stage 5: Implementation Example

To keep things simple the **Bookstore** application uses [Jenkins](https://jenkins.io/) to handle CI/CD.  We've propagated a new Amazon EC2 instance onto which Jenkins is installed.  An Amazon Route53 DNS record points the `jenkins.bookstore.pingpublications.com` endpoint to the EC2 instance, so accessing the Jenkins front end is done through `http://jenkins.bookstore.pingpublications.com:8080`.

The steps for installing and running Jenkins on an Amazon EC2 instance are beyond the scope of this article, but a [traditional deployment](https://docs.aws.amazon.com/aws-technical-content/latest/jenkins-on-aws/traditional-deployment.html) is easy to accomplish.

This is now what the final **Bookstore** architecture looks like.

{% asset '{{ page.asset-path }}'/stage-5-architecture.png alt='Stage 5 - Architecture' %}{: .align-center }
_Bookstore App Architecture_
{: .text-center }

### Jenkins Configuration

With Jenkins installed we need to create a new **Project** for the **Bookstore** application.  We're using the [Publish Over SSH](http://wiki.jenkins-ci.org/display/JENKINS/Publish+Over+SSH+Plugin) plugin to simplify deployment to both the blue/green Amazon EC2 instances.  Once the plugin is installed it must be configured by adding each SSH server we'll be interacting with.

1. Navigate to **Manage Jenkins > Configure System** and scroll down to the **Publish over SSH** section.
2. Enter the appropriate private key allowing connection to both **Bookstore API** Amazon EC2 instances.
3. Under **SSH Servers** click **Add**.
4. Enter the appropriate details for the `bookstore-api-blue` server.
    - **Name**: `bookstore-api-blue`
    - **Hostname**: `54.213.54.171`
    - **Username**: `ubuntu`
    - **Remote Directory**: `/home/ubuntu/apps`
5. Add another entry for the `bookstore-api-green` server.
    - **Name**: `bookstore-api-green`
    - **Hostname**: `52.11.79.9`
    - **Username**: `ubuntu`
    - **Remote Directory**: `/home/ubuntu/apps`
6. Click **Save**.

With the SSH connections configured it's time to create the **Project** to handle actual deployment.

1. Click **New Item**.
2. Input `bookstore-deploy` in the **Item name** field.
3. Select **Freestyle Project** type and click **OK**.
4. Under **Source Code Management** select **Git** and enter the GitHub endpoint (e.g. `git@github.com:GabeStah/bookstore_api.git`).
5. Add the appropriate GitHub credentials.

Deploying the **Bookstore** application code is just a matter of creating an **SSH Publisher** for each environment.

1. Under **Build** click **Add build step** and select **Send files or execute commands over SSH**.
2. Under **SSH Server > Name** select `bookstore-api-blue`.
3. In the **Source files** field input `**/*`.  This field uses the [Apache Ant](http://ant.apache.org/manual/dirtasks.html#patterns) pattern format, so here we're merely ensuring _all_ files in the project directory are published.
4. For **Remote directory** input `bookstore_api`.
5. Since the application uses Gunicorn for the web server we need to add a command to restart it after deployment.  Input `sudo systemctl restart gunicorn` in the **Exec command** field.
6. Click **Add Server** and repeat steps 2 through 5 for the `bookstore-api-green` server.
7. Click **Save** to finalize the settings.  The `bookstore-deploy` **Project** will now deploy new builds of the **Bookstore** to each production environment!

#### Automating Resiliency Testing in Jenkins

To meet the requirements of **Resiliency Stage 5** we need to integrate automated resiliency testing into the CI/CD pipeline.  For the **Bookstore** application, we'll use a Gremlin [Blackhole Attack](https://help.gremlin.com/attack-params-ref/#blackhole).  This attack blocks all network communication between the targeted instance and specified endpoints.  Just as we saw in [Stage 3][#stage-3] we'll be using this attack to perform a resiliency test that interrupts communication and triggers an Amazon CloudWatch alarm.  Check out the [Gremlin Help](https://help.gremlin.com/) documentation for more details on creating attacks with Gremlin's Chaos Engineering tools.

Within Jenkins, we can initiate the resiliency test by executing over SSH.

1. Navigate to the **Configure** section of the `bookstore-deploy` **Project**.
2. Under **Build** click **Add build step** and select **Send files or execute commands over SSH**.
3. Under **SSH Server > Name** select `bookstore-api-blue`.
4. In the **Exec command** field input the following:

    ```bash
    gremlin attack blackhole -l 240 -h ^api.gremlin.com,cdn.bookstore.pingpublications.com,db.bookstore.pingpublications.com
    ```

    **TIP**: This Gremlin Blackhole attack tests resiliency against the simulated failure of our critical dependencies (database and CDN).  Consequently, this will trigger the respective `bookstore-api-{blue/green}-{db/cdn}-connectivity-failed` Amazon CloudWatch Alarms that we configured during [Resiliency Stage 3][#stage-3].  This causes a DNS failover, which can be confirmed just as it was in **Stage 3**.
    {: .notice--tip }

5. Click **Add Server** and repeat steps 3 and 4 for the `bookstore-api-green` server.
6. Click **Save**.

#### Automating Disaster Recovery Failover Test in Jenkins

We also want to automate disaster recovery failover testing within the CI/CD pipeline.  This time we'll use a Gremlin [Shutdown Attack](https://help.gremlin.com/attack-params-ref/#shutdown), which shuts down the targeted instance.

1. Navigate to the **Configure** section of the `bookstore-deploy` **Project**.
2. Under **Build** click **Add build step** and select **Send files or execute commands over SSH**.
3. Under **SSH Server > Name** select `bookstore-api-blue`.
4. In the **Exec command** field input the following: `gremlin attack shutdown -d 1`.

    **TIP**: This Gremlin Shutdown attack performs a disaster recovery failover test by terminating the `bookstore-api-blue` instance.  We can also optionally add the `-r` flag to have the server restart itself after shutdown.  This triggers the `bookstore-api-blue-StatusCheckFailed` Amazon CloudWatch alarm that was created within [Resiliency Stage 3][#stage-3].  This automatically triggers Amazon Route53 DNS failover to reroute the `bookstore.pingpublications.com` endpoint to the `bookstore-api-green` environment.
    {: .notice--tip }

5. Click **Save**.

### Performing a Jenkins Build

Everything is now configured for our simple **Bookstore** application to be automatically deployed via Jenkins, during which resiliency testing and disaster recovery failover testing is performed.  It may be ideal to further automate the build process with Jenkins by configuring a **Build Trigger**, but we can also manually perform a build to confirm it works properly.

1. Navigate to the `bookstore-deploy` **Project**.
2. Click **Build Now**.
3. Click **Console Output** to view the output generated by Jenkins.  It will look something like the following.

    ```bash
    Started by user Gabe
    Building in workspace /var/lib/jenkins/workspace/bookstore-deploy
    > git rev-parse --is-inside-work-tree # timeout=10
    Fetching changes from the remote Git repository
    > git config remote.origin.url https://github.com/GabeStah/bookstore_api # timeout=10
    Fetching upstream changes from https://github.com/GabeStah/bookstore_api
    > git --version # timeout=10
    using GIT_ASKPASS to set credentials gabestah@github.com
    > git fetch --tags --progress https://github.com/GabeStah/bookstore_api +refs/heads/*:refs/remotes/origin/*
    > git rev-parse refs/remotes/origin/master^{commit} # timeout=10
    > git rev-parse refs/remotes/origin/origin/master^{commit} # timeout=10
    Checking out Revision d7172265ec23ab20d9eaabc6f3dd37a6c741f2cc (refs/remotes/origin/master)
    > git config core.sparsecheckout # timeout=10
    > git checkout -f d7172265ec23ab20d9eaabc6f3dd37a6c741f2cc
    Commit message: "bumped"
    > git rev-list --no-walk d7172265ec23ab20d9eaabc6f3dd37a6c741f2cc # timeout=10
    SSH: Connecting from host [ip-172-31-43-207.us-west-2.compute.internal]
    SSH: Connecting with configuration [bookstore-api-blue] ...
    SSH: EXEC: STDOUT/STDERR from command [sudo systemctl restart gunicorn] ...
    SSH: EXEC: completed after 401 ms
    SSH: Disconnecting configuration [bookstore-api-blue] ...
    SSH: Transferred 20 file(s)
    SSH: Connecting from host [ip-172-31-43-207.us-west-2.compute.internal]
    SSH: Connecting with configuration [bookstore-api-green] ...
    SSH: EXEC: STDOUT/STDERR from command [sudo systemctl restart gunicorn] ...
    SSH: EXEC: completed after 200 ms
    SSH: Disconnecting configuration [bookstore-api-green] ...
    SSH: Transferred 20 file(s)
    Build step 'Send files or execute commands over SSH' changed build result to SUCCESS
    SSH: Connecting from host [ip-172-31-43-207.us-west-2.compute.internal]
    SSH: Connecting with configuration [bookstore-api-blue] ...
    SSH: EXEC: STDOUT/STDERR from command [gremlin attack blackhole -l 240 -h ^api.gremlin.com,cdn.bookstore.pingpublications.com,db.bookstore.pingpublications.com] ...
    Setting up blackhole gremlin with guid '0367cfe2-f9fc-11e8-acea-0242db4d1180' for 240 seconds
    Setup successfully completed
    Running blackhole gremlin with guid '0367cfe2-f9fc-11e8-acea-0242db4d1180' for 240 seconds
    Whitelisting all egress traffic to 54.186.219.32
    Whitelisting all egress traffic to 54.68.250.40
    Dropping all egress traffic to 52.84.25.207
    Dropping all egress traffic to 52.84.25.199
    Dropping all egress traffic to 52.84.25.64
    Dropping all egress traffic to 52.84.25.16
    Dropping all egress traffic to 172.31.22.69
    Whitelisting all ingress traffic from 54.186.219.32
    Whitelisting all ingress traffic from 54.68.250.40
    Dropping all ingress traffic from 52.84.25.207
    Dropping all ingress traffic from 52.84.25.199
    Dropping all ingress traffic from 52.84.25.64
    Dropping all ingress traffic from 52.84.25.16
    Dropping all ingress traffic from 172.31.22.69
    Dropping all egress traffic to 13.33.147.150
    Dropping all egress traffic to 13.33.147.73
    Dropping all egress traffic to 13.33.147.19
    Dropping all egress traffic to 13.33.147.18
    Dropping all ingress traffic from 13.33.147.150
    Dropping all ingress traffic from 13.33.147.73
    Dropping all ingress traffic from 13.33.147.19
    Dropping all ingress traffic from 13.33.147.18
    Dropping all egress traffic to 13.32.253.5
    Dropping all egress traffic to 13.32.253.244
    Dropping all egress traffic to 13.32.253.105
    Dropping all egress traffic to 13.32.253.26
    Dropping all ingress traffic from 13.32.253.5
    Dropping all ingress traffic from 13.32.253.244
    Dropping all ingress traffic from 13.32.253.105
    Dropping all ingress traffic from 13.32.253.26
    Reverting impact!
    SSH: EXEC: completed after 240,397 ms
    SSH: Disconnecting configuration [bookstore-api-blue] ...
    SSH: Transferred 0 file(s)
    SSH: Connecting from host [ip-172-31-43-207.us-west-2.compute.internal]
    SSH: Connecting with configuration [bookstore-api-green] ...
    SSH: EXEC: STDOUT/STDERR from command [gremlin attack blackhole -l 240 -h ^api.gremlin.com,cdn.bookstore.pingpublications.com,db.bookstore.pingpublications.com] ...
    Setting up blackhole gremlin with guid '932c78b3-f9fc-11e8-9244-024280df5a87' for 240 seconds
    Setup successfully completed
    Running blackhole gremlin with guid '932c78b3-f9fc-11e8-9244-024280df5a87' for 240 seconds
    Whitelisting all egress traffic to 54.186.219.32
    Whitelisting all egress traffic to 54.68.250.40
    Dropping all egress traffic to 13.33.147.150
    Dropping all egress traffic to 13.33.147.73
    Dropping all egress traffic to 13.33.147.19
    Dropping all egress traffic to 13.33.147.18
    Dropping all egress traffic to 172.31.22.69
    Whitelisting all ingress traffic from 54.186.219.32
    Whitelisting all ingress traffic from 54.68.250.40
    Dropping all ingress traffic from 13.33.147.150
    Dropping all ingress traffic from 13.33.147.73
    Dropping all ingress traffic from 13.33.147.19
    Dropping all ingress traffic from 13.33.147.18
    Dropping all ingress traffic from 172.31.22.69
    Dropping all egress traffic to 52.84.25.199
    Dropping all egress traffic to 52.84.25.207
    Dropping all egress traffic to 52.84.25.16
    Dropping all egress traffic to 52.84.25.64
    Dropping all ingress traffic from 52.84.25.64
    Dropping all ingress traffic from 52.84.25.16
    Dropping all ingress traffic from 52.84.25.207
    Dropping all ingress traffic from 52.84.25.199
    Reverting impact!
    SSH: EXEC: completed after 240,395 ms
    SSH: Disconnecting configuration [bookstore-api-green] ...
    SSH: Transferred 0 file(s)
    SSH: Connecting from host [ip-172-31-43-207.us-west-2.compute.internal]
    SSH: Connecting with configuration [bookstore-api-blue] ...
    SSH: EXEC: STDOUT/STDERR from command [gremlin attack shutdown -d 1] ...
    Setting up shutdown gremlin with guid '22cdba53-f9fd-11e8-8292-024230fbb3f0' after 1 minute
    Setup successfully completed
    Running shutdown gremlin with guid '22cdba53-f9fd-11e8-8292-024230fbb3f0' after 1 minute
    SSH: Disconnecting configuration [bookstore-api-blue] ...
    SSH: EXEC: completed after 60,450 ms
    Finished: SUCCESS
    ```

The initial build steps grab the latest version via Git, deploy the new app version to both the blue/green environments via SSH, then perform the resiliency and disaster recovery tests via Gremlin.  As expected, all relevant `bookstore-api-{blue/green}-{db/cdn}-connectivity-failed` Amazon CloudWatch Alarms are triggered, forcing Amazon Route53 and Amazon RDS to engage its automated failover policies that we established in previous **Resiliency Stages**.

**WARNING**: The above Jenkins deployment configuration for the **Bookstore** example app is merely a functional proof of concept.  For an actual production configuration, we'd want to add many more safeguards, such as automating the alternation of deployment between blue/green environments, to ensure one environment is always ready in the event of a rollback.
{: .notice--warning }

## Resiliency Stage 5 Completion

With **Resiliency Stage 5** finished you and your team have reached the end of the current journey, but site reliability engineering is an ongoing battle.  Your system should now be fully monitored, provide high observability, and automatically perform resiliency and disaster recovery testing in the production environment at regular intervals.

Working through all the **Stages of Resiliency** takes time and will invariably be more difficult for some teams, so do not be discouraged.  For organizations with multiple teams, the integration of this staged process allows for teams, as well as individuals within said teams, to be empowered to make improvements and be responsible for the services under their purview.  As teams progress further through the stages, overall support costs will drop dramatically, while system stability and resiliency will inversely increase.

{% include          links-global.md %}
{% include_relative links.md %}