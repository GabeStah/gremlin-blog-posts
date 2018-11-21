---
published: false
---

##### Amazon SSM

```bash
$ sudo systemctl status snap.amazon-ssm-agent.amazon-ssm-agent
```

- Attach IAM Role: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-iam-roles-for-cloudwatch-agent.html
- Create Run Command: https://us-west-2.console.aws.amazon.com/systems-manager/run-command/send-command?region=us-west-2
    - ConfigureAWSPackage, select instances.

##### StatsD and Amazon CloudWatch Agent

- Stop agent: `sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a stop`
- Start agent: `sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:AmazonCloudWatch-linux -s`
- Get metrics list: `aws cloudwatch list-metrics --output json --namespace CWAgent`
- Get metric statistics:

    ```bash
    $ aws cloudwatch  get-metric-statistics --metric-name view_get_bookstore_views_get_version_total --namespace CWAgent --start-time 2018-11-15T00:00:00Z --end-time 2018-11-16T00:00:00Z --period 60 --statistics Average --output json
    {
        "Datapoints": [], 
        "Label": "view_get_bookstore_views_get_version_total"
    }
    ```

- Get metric data (See: https://docs.aws.amazon.com/cli/latest/reference/cloudwatch/get-metric-data.html)

    ```bash
    
    ```

- Use `netcat` and local bash script to check connectivity (see: http://dev.nuclearrooster.com/2011/05/11/sending-metrics-to-statsd-from-bash/)

    ```bash
    $ nc -vzu db.bookstore.pingpublications.com 5432
    Connection to db.bookstore.pingpublications.com 5432 port [udp/postgresql] succeeded!
    ```

- Record a metric.

    ```bash
    $ echo "a_test_metric:1|c" | nc -w 1 -u 127.0.0.1 8125
    ```

- Database connection test (`2>&1` to output to `stdout` for `grep` interaction).

    - Normal:

        ```bash
        $ nc -zv -w 5 db.bookstore.pingpublications.com 5432 2>&1
        Connection to db.bookstore.pingpublications.com 5432 port [tcp/postgresql] succeeded!
        ```

    - During attack:

        ```bash
        $ nc -zv -w 5 db.bookstore.pingpublications.com 5432 2>&1
        nc: connect to db.bookstore.pingpublications.com port 5432 (tcp) timed out: Operation now in progress
        ```

    - Unknown:

        ```bash
        $ nc -zv -w 5 ddb.bookstore.pingpublications.com 5432 2>&1
        nc: getaddrinfo for host "ddb.bookstore.pingpublications.com" port 5432: Name or service not known
        ```

- Parse result.

    - If grep result found, return `1`:

        ```bash
        $ nc -zv -w 5 db.bookstore.pingpublications.com 5432 2>&1 | grep -cim1 --line-buffered -i succeeded
        1
        ```
    
    - Else, return `0`:

        ```bash
        $ nc -zv -w 5 db.bookstore.pingpublications.com 5432 2>&1 | grep -cim1 --line-buffered -i fail
        0
        ```

    ```bash
    $ nc -zv -w 5 db.bookstore.pingpublications.com 5432 2>&1 | grep --line-buffered -i succeeded
    Connection to db.bookstore.pingpublications.com 5432 port [tcp/postgresql] succeeded!
    ```

    ```bash
    $ nc -zv -w 5 db.bookstore.pingpublications.com 5432 2>&1 | grep --line-buffered -i fail
    ```

```bash
$ echo "db_connection_success:`nc -zv -w 5 db.bookstore.pingpublications.com 5432 2>&1 | grep --line-buffered -i succeeded`|c" | nc -w 1 -u 127.0.0.1 8125
```

- `db_connection_test` bash script (`/home/ubuntu/bin/db_connection_test`):

    ```bash
    #!/bin/bash
    while sleep 10
    do
        if nc -zv -w 5 db.bookstore.pingpublications.com 5432 2>&1 | grep --line-buffered -i succeeded; then
            echo "db_hit:1|s" | nc -w 1 -u 127.0.0.1 8125
        else
            #echo "Connection to db.bookstore.pingpublications.com 5432 port [tcp/postgresql] failed." >&2
            echo "db_miss:1|s" | nc -w 1 -u 127.0.0.1 8215
        fi
    done
    ```

```bash
#!/bin/bash

while sleep 10
do
    if nc -zv -w 5 db.bookstore.pingpublications.com 5432 2>&1 | grep --line-buffered -i succeeded; then
        /home/ubuntu/.local/bin/aws cloudwatch put-metric-data --metric-name DatabaseConnectivity --dimensions Instance=i-0ab55a49288f1da24 --namespace "Bookstore" --value 1
    else
        echo "Connection to db.bookstore.pingpublications.com 5432 port [tcp/postgresql] failed!"
        /home/ubuntu/.local/bin/aws cloudwatch put-metric-data --metric-name DatabaseConnectivity --dimensions Instance=i-0ab55a49288f1da24 --namespace "Bookstore" --value 0
    fi
done
```

> (TODO) CloudWatch Agent: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html
> Monitor Scripts: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/mon-scripts.html

> 1. Create AWS CloudWatch Alarm/metric.
> 2. Automate AWS alarm trigger from `AWS CLI`
> 3. Failover CDN.
