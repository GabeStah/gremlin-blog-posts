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

#### Automating Blue/Green Instance Failover

We have a blue/green deployment for the **Bookstore** application service that provides two identical production environment instances of the system.  However, if the currently active instance fails we still have to manually swap DNS records from blue to green (or vice versa).  Since this process should be automated in order to work through these final **Resiliency Stages**, we'll take some time to create a failover configuration for the `bookstore-api` instances.

1. Create a metric alarm within Amazon CloudWatch.

    ```bash
    $ aws cloudwatch put-metric-alarm --output json --cli-input-json '{
        "ActionsEnabled": true,
        "AlarmActions": [
            "arn:aws:sns:us-west-2:532151327118:PingPublicationsSNS"
        ],
        "AlarmDescription": "Bookstore API (Blue) instance failure.",
        "AlarmName": "bookstore-api-blue-StatusCheckFailed",
        "ComparisonOperator": "GreaterThanOrEqualToThreshold",
        "DatapointsToAlarm": 1,
        "Dimensions": [
            {
                "Name": "InstanceId",
                "Value": "i-0ab55a49288f1da24"
            }
        ],
        "EvaluationPeriods": 1,
        "MetricName": "StatusCheckFailed",
        "Namespace": "AWS/EC2",
        "Period": 60,
        "Statistic": "Maximum",
        "Threshold": 1.0,
        "TreatMissingData": "breaching"
    }'
    ```

    The above configuration checks the `StatusCheckFailed` metric once a minute, which determines if _either_ the Amazon EC2 system or the specific EC2 instance has failed.  We have to set `TreatMissingData` to `breaching` so that the _absence_ of data will trigger an `ALARM` state (otherwise, the instance can be `stopped` or `terminated`, but the `StatusCheck` will succeed).

    The `Dimensions` array ensures this `bookstore-api-blue-StatusCheckFailed` alarm only checks against the `bookstore-api-blue` instance, and the `AlarmActions` specifies an Amazon SNS ARN to push an alert to when the alarm is triggered.

2. Next, create an Amazon Route53 Health Check that uses the `bookstore-api-blue-StatusCheckFailed` Amazon CloudWatch alarm for its `healthy/unhealthy` determination.

    ```bash
    $ aws route53 create-health-check --caller-reference bookstore-api-blue-health-check --output json --health-check-config '{
        "InsufficientDataHealthStatus": "Unhealthy", 
        "Type": "CLOUDWATCH_METRIC", 
        "AlarmIdentifier": {
            "Region": "us-west-2", 
            "Name": "bookstore-api-blue-StatusCheckFailed"
        }, 
        "Inverted": false
    }'
    {
        "HealthCheck": {
            "HealthCheckConfig": {
                "InsufficientDataHealthStatus": "Unhealthy", 
                "Type": "CLOUDWATCH_METRIC", 
                "AlarmIdentifier": {
                    "Region": "us-west-2", 
                    "Name": "bookstore-api-blue-StatusCheckFailed"
                }, 
                "Inverted": false
            }, 
            "CallerReference": "bookstore-api-blue-health-check", 
            "HealthCheckVersion": 1, 
            "Id": "119e6884-3685-4e5a-9520-44cebae6c734", 
            "CloudWatchAlarmConfiguration": {
                "EvaluationPeriods": 1, 
                "Dimensions": [
                    {
                        "Name": "InstanceId", 
                        "Value": "i-0ab55a49288f1da24"
                    }
                ], 
                "Namespace": "AWS/EC2", 
                "Period": 60, 
                "ComparisonOperator": "GreaterThanOrEqualToThreshold", 
                "Statistic": "Maximum", 
                "Threshold": 1.0, 
                "MetricName": "StatusCheckFailed"
            }
        }, 
        "Location": "https://route53.amazonaws.com/2013-04-01/healthcheck/119e6884-3685-4e5a-9520-44cebae6c734"
    }
    ```

    **TIP**: To reduce AWS costs we're using a 60-second metric evaluation interval here, but in a more demanding application this `Period` should be significantly shorter.
    {: .notice--tip }

3. Retrieve the `Id` for the `pingpublications.com` Amazon Route53 hosted zone.

    ```bash
    $ aws route53 list-hosted-zones --output json
    {
        "HostedZones": [
            {
                "ResourceRecordSetCount": 5, 
                "CallerReference": "303EC092-EDA3-C2B7-822E-5E609CA718A3", 
                "Config": {
                    "PrivateZone": false
                }, 
                "Id": "/hostedzone/Z2EHK3FAEUNRMI", 
                "Name": "pingpublications.com."
            }
        ]
    }
    ```

4. Create a pair of Amazon Route53 `Type: A` DNS record sets that will perform a `Failover` routing policy from the `bookstore-api-blue` to the `bookstore-api-green` production environment.  Therefore, even in the event that the blue instance fails the above health check, the `bookstore.pingpublications.com` endpoint will always point to an active production instance.

    ```bash
    $ aws route53 change-resource-record-sets --hosted-zone-id /hostedzone/Z2EHK3FAEUNRMI --output json --change-batch '{
        "Comment": "Adding bookstore.pingpublications.com failover.",
        "Changes": [
            {
                "Action": "CREATE",
                "ResourceRecordSet": {
                    "Name": "bookstore.pingpublications.com.",
                    "Type": "A",
                    "SetIdentifier": "bookstore-Primary",
                    "Failover": "PRIMARY",
                    "TTL": 60,
                    "ResourceRecords": [
                        {
                            "Value": "54.213.54.171"
                        }
                    ],
                    "HealthCheckId": "119e6884-3685-4e5a-9520-44cebae6c734"
                }
            },
            {
                "Action": "CREATE",
                "ResourceRecordSet": {
                    "Name": "bookstore.pingpublications.com.",
                    "Type": "A",
                    "SetIdentifier": "bookstore-Secondary",
                    "Failover": "SECONDARY",
                    "TTL": 60,
                    "ResourceRecords": [
                        {
                            "Value": "52.11.79.9"
                        }
                    ]
                }
            }
        ]
    }'
    {
        "ChangeInfo": {
            "Status": "PENDING", 
            "Comment": "Adding bookstore.pingpublications.com failover.", 
            "SubmittedAt": "2018-11-15T01:54:15.785Z", 
            "Id": "/change/C1XJ0G2FTPLYDO"
        }
    }
    ```

5. Double-check that the two failover record sets have been created.

    ```bash
    $ aws route53 list-resource-record-sets --hosted-zone-id /hostedzone/Z2EHK3FAEUNRMI --output json
    {
        "ResourceRecordSets": [
            {
                "HealthCheckId": "119e6884-3685-4e5a-9520-44cebae6c734", 
                "Name": "bookstore.pingpublications.com.", 
                "Type": "A", 
                "Failover": "PRIMARY", 
                "ResourceRecords": [
                    {
                        "Value": "54.213.54.171"
                    }
                ], 
                "TTL": 60, 
                "SetIdentifier": "bookstore-Primary"
            }, 
            {
                "Name": "bookstore.pingpublications.com.", 
                "Type": "A", 
                "Failover": "SECONDARY", 
                "ResourceRecords": [
                    {
                        "Value": "52.11.79.9"
                    }
                ], 
                "TTL": 60, 
                "SetIdentifier": "bookstore-Secondary"
            }
        ]
    }
    ```

#### Automated Instance Failover Verification

To test the failover process for the **Bookstore** API application instances we'll use a Gremlin [Shutdown Attack](https://help.gremlin.com/attack-params-ref/#shutdown).  This attack will temporarily shutdown the `bookstore-api-blue` Amazon EC2 instance for us.

1. Verify the current status of the **Bookstore** API by checking the `bookstore.pingpublications.com/version/` endpoint.

    ```bash
    $ curl bookstore.pingpublications.com/version/ | jq
    {
        "environment": "bookstore-api-blue",
        "version": 7
    }
    ```

    This shows what app version is running and confirms that the endpoint is pointing to the `bookstore-api-blue` Amazon EC2 instance.

2. Run a Gremlin Shutdown Attack targeting the `bookstore-api-blue` Client.  Check out the [Gremlin Help](https://help.gremlin.com/) documentation for more details on creating attacks with Gremlin's Chaos Engineering tools.

3. After a moment the Amazon CloudWatch `bookstore-api-blue-StatusCheckFailed` Alarm triggers, thereby causing the `bookstore-api-blue-healthy` Amazon Route53 health check to fail.  This automatically triggers the DNS failover created previously, which points the primary `bookstore.pingpublications.com` endpoint to the `green` EC2 production environment.  Verify this failover has automatically propagated by checking the `/version/` endpoint once again.

    ```bash
    $ curl bookstore.pingpublications.com/version/ | jq
    {
        "environment": "bookstore-api-green",
        "version": 7
    }
    ```

#### Generating Custom AWS Metrics

To properly automate our critical dependency failure tests we need a way to _simulate_ the failure of our CDN and database services.  Tools like Gremlin can help with this task.  Running a Gremlin **Blackhole Attack** on the **Bookstore** API environment can prevent all network communication between the API instance and the CDN and/or database endpoints.  However, AWS EC2 instances don't have any built-in capability to monitor the connectivity between said instance and another arbitrary endpoint.  Therefore, the solution is to create some _custom_ metrics that will effectively measure the "health" of the connection between the **Bookstore** API instance and its critical dependencies.

While AWS provides tons of built-in metrics, creating a [custom metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/publishingMetrics.html) requires that you generate _all_ the relevant data for said metric.  For this reason, a custom metric is little more than a combination of a metric `name` and list of `dimensions`, which are used as `key/value` pairs to distinguish and categorize metrics.  We're creating simple metrics that act as a health monitor for each critical dependency.

1. We start by creating a couple bash scripts within our application code repository.  These scripts are executed from the **Bookstore** API instances.

    ```bash
    #!/bin/bash
    # ~/apps/bookstore_api/metrics/db-connectivity.sh
    INSTANCE_ID="$(ec2metadata --instance-id)"
    TAG_NAME="$(/home/ubuntu/.local/bin/aws ec2 describe-tags --filter "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Name" --query "Tags[*].Value" --output text)"

    while sleep 10
    do
        if nc -zv -w 5 db.bookstore.pingpublications.com 5432 2>&1 | grep --line-buffered -i succeeded; then
            /home/ubuntu/.local/bin/aws cloudwatch put-metric-data --metric-name db-connectivity --namespace Bookstore --dimensions Host=$TAG_NAME --value 1
        else
            echo "Connection to db.bookstore.pingpublications.com 5432 port [tcp/postgresql] failed!"
            /home/ubuntu/.local/bin/aws cloudwatch put-metric-data --metric-name db-connectivity --namespace Bookstore --dimensions Host=$TAG_NAME --value 0
        fi
    done
    ```

    ```bash
    #!/bin/bash
    # ~/apps/bookstore_api/metrics/cdn-connectivity.sh
    INSTANCE_ID="$(ec2metadata --instance-id)"
    TAG_NAME="$(/home/ubuntu/.local/bin/aws ec2 describe-tags --filter "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Name" --query "Tags[*].Value" --output text)"

    while sleep 10
    do
        if nc -zv -w 5 cdn.bookstore.pingpublications.com 80 2>&1 | grep --line-buffered -i succeeded; then
            /home/ubuntu/.local/bin/aws cloudwatch put-metric-data --metric-name cdn-connectivity --namespace Bookstore --dimensions Host=$TAG_NAME --value 1
        else
            echo "Connection to cdn.bookstore.pingpublications.com 80 port [tcp/http] failed!"
            /home/ubuntu/.local/bin/aws cloudwatch put-metric-data --metric-name cdn-connectivity --namespace Bookstore --dimensions Host=$TAG_NAME --value 0
        fi
    done
    ```

    To check the connectivity for the database or CDN endpoint we first retrieve the Amazon EC2 instance Id and, from that, get the `Name` tag value, which we use as the `Host` dimension when creating our metric.  This `Host` value specifies which environment (blue or green) is being measured.

    The purpose of the script is to perform a network connectivity check (using `netcat`) to the dependency endpoint every few seconds.  It then uses the AWS CLI to generate metric data for the `db-connectivity` or `cdn-connectivity` metric, passing a value of `1` if the connection succeeded and `0` for a failure.

2. Create `systemd` service configuration files so the bash scripts will be executed and remain active.

    - Start by creating the `bookstore-db-connectivity` service and pointing the `ExecStart` command to the `db-connectivity.sh` file.

        ```bash
        sudo nano /etc/systemd/system/bookstore-db-connectivity.service
        ```

        ```bash
        [Unit]
        Description=Bookstore Database Connectivity Service
        After=network.target

        [Service]
        Type=simple
        User=ubuntu
        WorkingDirectory=/home/ubuntu
        ExecStart=/home/ubuntu/apps/bookstore_api/metrics/db-connectivity.sh
        Restart=on-failure

        [Install]
        WantedBy=multi-user.target
        ```

    - Do the same for the CDN.

        ```bash
        sudo nano /etc/systemd/system/bookstore-cdn-connectivity.service
        ```

        ```bash
        [Unit]
        Description=Bookstore CDN Connectivity Service
        After=network.target

        [Service]
        Type=simple
        User=ubuntu
        WorkingDirectory=/home/ubuntu
        ExecStart=/home/ubuntu/apps/bookstore_api/metrics/cdn-connectivity.sh
        Restart=on-failure

        [Install]
        WantedBy=multi-user.target
        ```

3. Set permissions such that both service target scripts are executable.

    ```bash
    chmod +x /home/ubuntu/apps/bookstore_api/metrics/db-connectivity.sh && chmod +x /home/ubuntu/apps/bookstore_api/metrics/cdn-connectivity.sh
    ```

4. Initially, we'll need to manually start both monitoring services.

    ```bash
    sudo systemctl start bookstore-db-connectivity && sudo systemctl start bookstore-cdn-connectivity
    ```

5. Verify that both services are active.

    ```bash
    $ sudo systemctl status bookstore-db-connectivity.service 
    Loaded: loaded (/etc/systemd/system/bookstore-db-connectivity.service; disabled; vendor preset: enabled)
    Active: active (running) since Mon 2018-11-17 12:02:19 UTC; 2min 3s ago

    Nov 17 12:02:42 bookstore-api-green systemd[1]: Started Bookstore Database Connectivity Service.
    Nov 17 12:02:42 bookstore-api-green db-connectivity.sh[24683]: Connection to db.bookstore.pingpublications.com 5432 port [tcp/postgresql] succeeded!
    ```

    ```bash
    $ sudo systemctl status bookstore-cdn-connectivity
    Loaded: loaded (/etc/systemd/system/bookstore-cdn-connectivity.service; disabled; vendor preset: enabled)
    Active: active (running) since Mon 2018-11-17 12:02:19 UTC; 20s ago

    Nov 17 12:02:19 bookstore-api-green systemd[1]: Started Bookstore CDN Connectivity Service.
    Nov 17 12:02:31 bookstore-api-green cdn-connectivity.sh[24695]: Connection to cdn.bookstore.pingpublications.com 80 port [tcp/http] succeeded!
    ```

6. Create Amazon CloudWatch Alarms based on the four generated metrics.  These alarms check for a connectivity failure within the last two minutes.

    ```bash
    aws cloudwatch put-metric-alarm --output json --cli-input-json '{
        "ActionsEnabled": true,
        "AlarmActions": [
            "arn:aws:sns:us-west-2:532151327118:PingPublicationsSNS"
        ],
        "AlarmDescription": "Database Connectivity failure for Bookstore API (Blue).",
        "AlarmName": "bookstore-api-blue-db-connectivity-failed",
        "ComparisonOperator": "LessThanThreshold",
        "DatapointsToAlarm": 2,
        "Dimensions": [
            {
                "Name": "Host",
                "Value": "bookstore-api-blue"
            }
        ],
        "EvaluationPeriods": 2,
        "MetricName": "db-connectivity",
        "Namespace": "Bookstore",
        "Period": 60,
        "Statistic": "Average",
        "Threshold": 1.0
    }'
    ```

    ```bash
    aws cloudwatch put-metric-alarm --output json --cli-input-json '{
        "ActionsEnabled": true,
        "AlarmActions": [
            "arn:aws:sns:us-west-2:532151327118:PingPublicationsSNS"
        ],
        "AlarmDescription": "CDN Connectivity failure for Bookstore API (Blue).",
        "AlarmName": "bookstore-api-blue-cdn-connectivity-failed",
        "ComparisonOperator": "LessThanThreshold",
        "DatapointsToAlarm": 2,
        "Dimensions": [
            {
                "Name": "Host",
                "Value": "bookstore-api-blue"
            }
        ],
        "EvaluationPeriods": 2,
        "MetricName": "cdn-connectivity",
        "Namespace": "Bookstore",
        "Period": 60,
        "Statistic": "Average",
        "Threshold": 1.0
    }'
    ```

    ```bash
    aws cloudwatch put-metric-alarm --output json --cli-input-json '{
        "ActionsEnabled": true,
        "AlarmActions": [
            "arn:aws:sns:us-west-2:532151327118:PingPublicationsSNS"
        ],
        "AlarmDescription": "Database Connectivity failure for Bookstore API (Green).",
        "AlarmName": "bookstore-api-green-db-connectivity-failed",
        "ComparisonOperator": "LessThanThreshold",
        "DatapointsToAlarm": 2,
        "Dimensions": [
            {
                "Name": "Host",
                "Value": "bookstore-api-green"
            }
        ],
        "EvaluationPeriods": 2,
        "MetricName": "db-connectivity",
        "Namespace": "Bookstore",
        "Period": 60,
        "Statistic": "Average",
        "Threshold": 1.0
    }'
    ```

    ```bash
    aws cloudwatch put-metric-alarm --output json --cli-input-json '{
        "ActionsEnabled": true,
        "AlarmActions": [
            "arn:aws:sns:us-west-2:532151327118:PingPublicationsSNS"
        ],
        "AlarmDescription": "CDN Connectivity failure for Bookstore API (Green).",
        "AlarmName": "bookstore-api-green-cdn-connectivity-failed",
        "ComparisonOperator": "LessThanThreshold",
        "DatapointsToAlarm": 2,
        "Dimensions": [
            {
                "Name": "Host",
                "Value": "bookstore-api-green"
            }
        ],
        "EvaluationPeriods": 2,
        "MetricName": "cdn-connectivity",
        "Namespace": "Bookstore",
        "Period": 60,
        "Statistic": "Average",
        "Threshold": 1.0
    }'
    ```

{% comment %}

#### CDN Failure Test

> (TODO) CloudWatch Agent: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html
> Monitor Scripts: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/mon-scripts.html

> 1. Create AWS CloudWatch Alarm/metric.
> 2. Automate AWS alarm trigger from `AWS CLI`
> 3. Failover CDN.

#### DB Failure Test

> **(TODO)**: Django StatsD: https://github.com/WoLpH/django-statsd
> Record metrics locally during Django process.
> Report externally to AWS CloudWatch Agent: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-custom-metrics-statsd.html
>   - https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/install-CloudWatch-Agent-on-first-instance.html
>   - (TODO) Test CloudWatch Agent collections https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/metrics-collected-by-CloudWatch-agent.html

### Create Metric

- Create metric

{% endcomment %}

### Execute a Resiliency Experiment in Production

- Status: **Complete**

### Publish Test Results and Track Over Time

- Status: **Complete**

## Resiliency Stage 3 Completion

{% include          links-global.md %}
{% include_relative links.md %}