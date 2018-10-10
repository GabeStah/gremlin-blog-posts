---
title: "Migrating to the Cloud is Chaotic. Embrace it."
excerpt: "Why you should embrace Chaos Engineering prior to migrating to the cloud, allowing you to avoid pain down the road."
categories: [chaos-engineering]
tags: [migration]
url: "https://www.gremlin.com/blog/?"
published: true
asset-path: chaos-engineering/migrating-cloud-chaotic-embrace
sources:
    - https://medium.com/@copyconstruct/testing-in-production-the-safe-way-18ca102d0ef1
    - https://code.fb.com/production-engineering/how-production-engineers-support-global-events-on-facebook/
    - outages:
        papers: 
            - http://ucare.cs.uchicago.edu/pdf/socc16-cos.pdf
        instapaper:
            tags: []
            urls:
                - https://medium.com/making-instapaper/instapaper-outage-cause-recovery-3c32a7e9cc5f,
                - http://blog.instapaper.com/post/157227609796
        google-app-engine:
            tags: ["storage back end migration"]
            urls: https://status.cloud.google.com/incident/appengine/15025
        google-app-engine:
            tags: []
            urls: https://groups.google.com/d/msg/google-appengine-downtime-notify/nBT3UIdC00g/m1li5_-vGLEJ
        aws-ebs-and-ec2:
            tags: []
            urls: https://aws.amazon.com/message/680342/
        facebook:
            tags: ["invalid configuration values in persistent store"]
            urls: https://www.facebook.com/notes/facebook-engineering/more-details-on-todays-outage/431441338919
        blackberry:
            tags: ["automatic failover did not function properly"]
            urls: https://www.cnn.com/2011/10/12/tech/mobile/blackberry-outage/
        dropbox:
            tags: ["script bug during OS migration"]
            urls: https://blogs.dropbox.com/tech/2014/01/outage-post-mortem/
        google-docs:
            tags: ["memory management bug, failure to recycle memory"]
            urls: https://cloud.googleblog.com/2011/09/what-happened-to-google-docs-on.html
        microsoft-azure:
            tags: ["repaired storage stamp had 'node protection' disabled"]
            urls: https://azure.microsoft.com/en-us/blog/details-of-the-december-28th-2012-windows-azure-storage-disruption-in-us-south/
        microsoft-azure:
            tags: ["poorly monitored certificate expiration"]
            urls: https://azure.microsoft.com/en-us/blog/details-of-the-february-22nd-2013-windows-azure-storage-disruption/
        hotmail-outlook:
            tags: ["firmware upgrade failed, causing internal temperature spike"]
            urls: https://www.microsoft.com/en-us/microsoft-365/blog/2013/03/13/details-of-the-hotmail-outlook-com-outage-on-march-12th/
        office-365:
            tags: ["Microsoft Online edge network changed incorrectly"]
            urls: https://www.quadrotech-it.com/blog/feb-1-office-365-outage-incident-review-release/
---

**PURPOSE**: Demonstrate why companies migrating to the cloud should embrace Chaos Engineering early and often to avoid pain down the road.
{: .notice--danger }

Migrating to the cloud often feels like a monumental task.  This feeling is completely understandable -- there's a sense of comfort in the tangible nature of on-premises systems.  By contrast, moving into the ephemeral cloud can be worrisome, especially if you doubt the stability and resilience of the systems that make up your cloud architecture.  The inherent malleability of a cloud stack is both its greatest strength and a massive source of potential failures.  How can you ensure your software will be safe after migrating to the cloud?  How do you combat the cloud's chaotic nature while ensuring a resilient and stable system?  **By intentionally inducing Chaos well before migration begins.**

It may feel counter-intuitive to purposely inject additional chaos into your system when your team is actively trying to _reduce_ failures, but the critical difference here is that Chaos Engineering allows your team to _choose_ when and how systems fail.  This ensures your architecture is able to withstand unexpected failures.  By executing Chaos Experiments on both your existing systems and cloud systems you're migrating into, you'll identify weaknesses at both ends of the spectrum.

Testing your system resiliency throughout the migration process is critical, as migration is the period in a software's life cycle in which outages are _most likely_ to occur.  In 2016, groups from the University of Chicago and Surya University jointly published an in-depth [cloud outage study](http://ucare.cs.uchicago.edu/pdf/socc16-cos.pdf) that examined the causes of service outages among 32 of the most popular Internet services between 2009 and 2015.  The study found that the _majority_ of unplanned outages (16%) are caused by failures during upgrade and migration procedures.

## Managing Heavy CPU Load

CPU overloading is an easy yet effective experiment that illuminates bottlenecks and computational failures within the architecture.  This is particularly critical when migrating to a cloud environment, where instability in a single system can quickly cascade into problems elsewhere down the chain.

### Why It Matters: TBD

(TODO)

### Performing a CPU Attack with Gremlin

#### Prerequisites

- [Install Gremlin][gremlin#docs#install] on the target machine.
- Retrieve your [Gremlin API Token][#gremlin-api-token].

A [Gremlin API][gremlin#docs#api] **CPU Attack** accepts the following arguments.

| Short Flag | Long Flag  | Purpose                        |
| ---------- | ---------- | ------------------------------ |
| `-c`       | `--cores`  | Number of CPU cores to attack. |
| `-l`       | `--length` | Attack duration (in seconds).  |

Most [Gremlin API][gremlin#docs#api] calls accept a JSON body payload, which specifies critical arguments.  In all the following examples we'll be creating a local `attacks/<attack-name>.json` file to store the API attack arguments and pass those arguments along to the request.

1. On your local machine, start by creating the `attacks/cpu-random.json` file and paste the following JSON into it.  This will attack a single core for `30` seconds.

    ```json
    // attacks/cpu-random.json
    {
        "command": {
            "type": "cpu",
            "args": ["-c", "1", "-l", "30"]
        },
        "target": {
            "type": "Random"
        }
    }
    ```

2. Create the new **Attack** by passing the JSON from `attacks/cpu-random.json` to the `https://api.gremlin.com/v1/attacks/new` API endpoint.

    ```bash
    curl -H "Content-Type: application/json" -H "Authorization: $GREMLIN_API_TOKEN" https://api.gremlin.com/v1/attacks/new -d "@attacks/cpu-random.json"
    ```

3. The [Gremlin Web UI][gremlin#app] now shows the **Attack** that was created.

    {% asset '{{ page.asset-path }}'/web-ui-cpu-attack.png alt='Gremlin Web UI CPU Attack' %}{: .align-center}

4. Additionally, the targeted machine also has one CPU core maxed out.

    {% asset '{{ page.asset-path }}'/htop-cpu-max.png alt='htop CPU Maximized' %}{: .align-center}

**Optional** If you wish to attack a _specific_ **Client** just change the `target | type` argument value to `"Exact"` and add the `target | exact` field with a list of target **Clients**.  A **Client** is identified on Gremlin as the `GREMLIN_IDENTIFIER` for the instance.
{: .notice--info}

```json
// attacks/cpu-exact.json
{
    "command": {
        "type": "cpu",
        "args": ["-c", "1", "-l", "30"]
    },
    "target": {
        "type": "Exact",
        "exact": ["aws-nginx"]
    }
}
```

## Storage Disk Limitations

Migrating to a new system frequently requires moving volumes across disks and to other cloud-based storage layers.  It's vital to determine if the new storage system can handle the increase in volume the migration will require.  Additionally, to properly test the resilience of the system you'll also want to test how the system reacts when disks are overburdened or unavailable.

### Why It Matters: Instapaper (2017)

In February 2017 the popular web content bookmarking service Instapaper suffered [a service outage](https://medium.com/making-instapaper/instapaper-outage-cause-recovery-3c32a7e9cc5f) due to a [2 TB file size limit](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Limits.html#RDS_Limits.FileSize) within Instapaper's Amazon RDS MySQL instance.

This issue was unknown to Instapaper ever since their migration to AWS in 2013.  At that time, they migrated their database to MySQL on Amazon RDS, which was using a slightly outdated version of MySQL that enforced the 2 TB file size limit.  Even after attempting to upgrade to newer hardware and a newer MySQL version in March 2015, the original instance that contained the 2 TB limit was replicated, thereby retaining the hidden problem.

Eventually their database finally hit that limit in early 2017 and caused a day+ service outage.  As Instapaper points out in their post mortem, it was difficult for the team to be aware of this limitation and potential issue ahead of time.  However, this unfortunate event illustrates the importance of properly testing data storage systems prior to migration.

### Performing a Disk Attack with Gremlin

Gremlin's **Disk Attack** rapidly consumes disk space on the targeted machine, allowing you to test the resiliency of that machine and other related systems when unexpected disk failures occur.

#### Prerequisites

- [Install Gremlin][gremlin#docs#install] on the target machine.
- Retrieve your [Gremlin API Token][#gremlin-api-token].

A [Gremlin API][gremlin#docs#api] **Disk Attack** accepts the following arguments.

| Short Flag | Long Flag      | Purpose                                                |
| ---------- | -------------- | ------------------------------------------------------ |
| `-b`       | `--block-size` | The block size (in kilobytes) that are written.        |
| `-d`       | `--dir`        | The directory that temporary files will be written to. |
| `-l`       | `--length`     | Attack duration (in seconds).                          |
| `-p`       | `--percent`    | The percentage of volume to fill.                      |
| `-w`       | `--workers`    | The number of disk-write workers to run concurrently.  |

1. On your local machine, start by creating the `attacks/disk-exact.json` file and paste the following JSON into it.  Be sure to change your target **Client**.  This will attempt to fill `95%` of the volume over the course of a `60` second attack using `2` workers.

    ```json
    // attacks/disk-random.json
    {
        "command": {
            "type": "disk",
            "args": ["-d", "/tmp", "-l", "60", "-w", "2", "-b", "4", "-p", "95"]
        },
        "target": {
            "type": "Exact",
            "exact": ["aws-nginx"]
        }
    }
    ```

2. *(Optional)* Check the current disk usage on the target machine.

    ```bash
    df -H
    # OUTPUT
    Filesystem      Size  Used Avail Use% Mounted on
    /dev/xvda1      8.3G  1.4G  6.9G  17% /
    ```

3. Create the new **Disk Attack** by passing the JSON from `attacks/disk-exact.json` to the `https://api.gremlin.com/v1/attacks/new` API endpoint.

    ```bash
    curl -H "Content-Type: application/json" -H "Authorization: $GREMLIN_API_TOKEN" https://api.gremlin.com/v1/attacks/new -d "@attacks/disk-exact.json"
    ```

4. The [Gremlin Web UI][gremlin#app] now shows the **Attack** that was created.

    {% asset '{{ page.asset-path }}'/web-ui-disk-attack.png alt='Gremlin Web UI Disk Attack' %}{: .align-center}

5. Check the attack target's current disk space, which will soon reach the specified percentage before Gremlin rolls back and returns the disk to the original state.

    ```bash
    df -H
    # OUTPUT
    Filesystem      Size  Used Avail Use% Mounted on
    /dev/xvda1      8.3G  7.9G  396M  96% /
    ```

## Evaluating Network Resiliency

While the majority of Internet service outages are caused by failures during migration and upgrade procedures, the [Why Does the Cloud Stop Computing?
Lessons from Hundreds of Service Outages](http://ucare.cs.uchicago.edu/pdf/socc16-cos.pdf) study found that network problems are the second most common cause and account for some `15%` of service outages.  Even architectures designed with network redundancies can experience multiple, stacking network failures without proper testing and experimentation.  Moreover, most modern software relies on external networks to some degree, which means a network outage completely outside of your control could cause a failure to propagate throughout your system.

### Why It Matters: Microsoft Office 365 (2013)

On February 1st, 2013 a change to the Microsoft Online edge network prevented some internet traffic from reaching the Microsoft Office 365 service, which prevented customers from accessing Exchange and SharePoint services for a few hours.  While the [incident report](https://www.quadrotech-it.com/blog/feb-1-office-365-outage-incident-review-release/) doesn't explicitly name the underlying change that caused the problem, it does state that that a procedural error was unintentionally and automatically propagated to multiple devices within the Microsoft Online network, which "caused incorrect routing for a portion of the inbound internet traffic."  Additionally, affected customers were unable to access administrative services within the **Service Health Dashboard** (SHD) provided by Microsoft, but the backup process for supporting customers unable to access the SHD did not work as well as expected.

While this overall incident only lasted a few hours and affected a small subset of customers, it illustrates the importance of proper network resiliency testing prior to and during system migrations and upgrade procedures.  Chaos Experiments that cause networking failures -- such as creating a blackhole so certain traffic is halted -- are a great way to test system stability under these unexpected conditions.

### Performing a Blackhole Attack with Gremlin

A **Blackhole Attack** temporarily drop all traffic based on the parameters of the attack.  You can use a **Blackhole Attack** to test routing protocols, loss of communication to specific hosts, port-based traffic, network device failure, and much more.

#### Prerequisites

- [Install Gremlin][gremlin#docs#install] on the target machine.
- Retrieve your [Gremlin API Token][#gremlin-api-token].

A [Gremlin API][gremlin#docs#api] **Blackhole Attack** accepts the following arguments.

| Short Flag | Long Flag        | Purpose                                                                                                                                                                     |
| ---------- | ---------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `-d`       | `--device`       | Network device through which traffic should be affected.  Defaults to the first device found.                                                                               |
| `-h`       | `--hostname`     | Outgoing hostnames to affect.  Optionally, you can prefix a hostname with a caret (`^`) to whitelist it.  It is recommended to include `^api.gremlin.com` in the whitelist. |
| `-i`       | `--ipaddress`    | Outgoing IP addresses to affect.  Optionally, you can prefix an IP with a caret (`^`) to whitelist it.                                                                      |
| `-l`       | `--length`        | Attack duration (in seconds).                                                                                                                                               |
| `-n`       | `--ingress_port` | Only affect ingress traffic to these destination ports.  Optionally, ranges can also be specified (e.g. `8080-8085`).                                                       |
| `-p`       | `--egress_port`  | Only affect egress traffic to these destination ports.  Optionally, ranges can also be specified (e.g. `8080-8085`).                                                        |
| `-P`       | `--ipprotocol`   | Only affect traffic using this protocol.                                                                                                                                    |

1. Start by performing a test to establish a baseline.  The following command tests the response time of a request to `example.com` (which has an IP address of `93.184.216.34`).

    ```bash
    $ time curl -o /dev/null 93.184.216.34

    # OUTPUT
    real    0m0.025s
    user    0m0.009s
    sys     0m0.000s
    ```

2. On your local machine, create the `attacks/blackhole-exact.json` file and paste the following JSON into it.  Set your target **Client** as necessary.  This attack creates a `30` second blackhole that drops traffic to the `93.184.216.34` IP address.

    ```json
    // attacks/blackhole-random.json
    {
        "command": {
            "type": "blackhole",
            "args": ["-l", "30", "-i", "93.184.216.34", "-h", "^api.gremlin.com"]
        },
        "target": {
            "type": "Exact",
            "exact": ["aws-nginx"]
        }
    }
    ```

3. Execute the **Blackhole Attack** by passing the JSON from `attacks/blackhole-exact.json` to the `https://api.gremlin.com/v1/attacks/new` API endpoint.

    ```bash
    curl -H "Content-Type: application/json" -H "Authorization: $GREMLIN_API_TOKEN" https://api.gremlin.com/v1/attacks/new -d "@attacks/blackhole-exact.json"
    ```

4. On the target machine run the same timed `curl` test as before.  It should hang for approximately `30` seconds, until the blackhole has been terminated and a response is finally received.

    ```bash
    $ time curl -o /dev/null 93.184.216.34

    # OUTPUT
    real    0m31.623s
    user    0m0.013s
    sys     0m0.000s
    ```

5. You can also view the **Attack** on the [Gremlin Web UI][gremlin#app] to confirm it functioned properly.

    {% asset '{{ page.asset-path }}'/web-ui-blackhole-attack.png alt='Gremlin Web UI Blackhole Attack' %}{: .align-center}

6. Check the attack target's current disk space, which will soon reach the specified percentage before Gremlin rolls back and returns the disk to the original state.

    ```bash
    df -H
    # OUTPUT
    Filesystem      Size  Used Avail Use% Mounted on
    /dev/xvda1      8.3G  7.9G  396M  96% /
    ```

## Proper Memory Management

While most commonly-used cloud platforms provide auto-balancing and scaling services, it's impossible to rely solely on these technologies to ensure your migrated software will remain stable and responsive.  Memory management is a crucial part of maintaining a healthy and inexpensive cloud stack.  An improper configuration or poorly tested system may not necessarily cause a system failure or outage, but even a tiny memory issue can add up to thousands of dollars in extra support costs.

Therefore, performing Chaos Engineering before, during, and after cloud migration to test system failures when instances, containers, or nodes run out of memory ensures your stack remains active and fully functional when an _unexpected_ memory leak occurs.

### Why It Matters: Google Docs (2011)

In early September, 2011 Google Docs suffered a widespread, hour-long outage that prevented the majority of customers from accessing documents, drawings, lists, and App Scripts.  As Google [later reported](https://cloud.googleblog.com/2011/09/what-happened-to-google-docs-on.html), the incident was caused by a change that exposed a memory leak that _only occurred under heavy load_.  The lookup service that tracks of Google Doc modifications wasn't properly recycling memory, which eventually caused those machines to restart.  Of course, the redundancy systems immediately picked up the slack from these now-offline lookup service machines, but the excessive load caused the replacement machines to run out of memory ever faster.  Eventually the servers couldn't handle the number of requests that were backed up.

The Google engineering team was quick to diagnose the issue and roll out a fix within an hour of the first automated alert.  Unfortunately, Google engineers were unaware of the root cause _because_ it only occurred while the system was heavily loaded, which shows the importance of expressly testing system resilience when memory usage spikes.

### Performing a Memory Attack with Gremlin

A Gremlin **Memory Attack** consumes memory on the targeted machine, making it easy to test how that system and other dependencies behave when memory is unavailable.

#### Prerequisites

- [Install Gremlin][gremlin#docs#install] on the target machine.
- Retrieve your [Gremlin API Token][#gremlin-api-token].

A [Gremlin API][gremlin#docs#api] **Memory Attack** accepts the following arguments.

| Short Flag | Long Flag     | Purpose                                   |
| ---------- | ------------- | ----------------------------------------- |
| `-g`       | `--gigabytes` | The amount of memory (in GB) to allocate. |
| `-l`       | `--length`    | Attack duration (in seconds).             |
| `-m`       | `--megabytes` | The amount of memory (in MB) to allocate. |

1. _(Optional)_ On the target machine check the current memory usage to establish a baseline prior to executing the attack.

    ```bash
    htop
    ```

    {% asset '{{ page.asset-path }}'/htop-pre-memory-attack.png alt='HTOP Pre-Attack Memory Usage' %}{: .align-center}

2. On your local machine create a `attacks/memory-exact.json` file and paste the following JSON into it, ensuring you change your target **Client**.  This attack will consume up to `750 MB` of memory for a total of `30` seconds.

    ```json
    // attacks/memory-exact.json
    {
        "command": {
            "type": "memory",
            "args": ["-l", "30", "-g", "0.75"]
        },
        "target": {
            "type": "Exact",
            "exact": ["aws-nginx"]
        }
    }
    ```
3. Launch the **Memory Attack** by passing the JSON from `attacks/memory-exact.json` to the `https://api.gremlin.com/v1/attacks/new` API endpoint.

    ```bash
    curl -H "Content-Type: application/json" -H "Authorization: $GREMLIN_API_TOKEN" https://api.gremlin.com/v1/attacks/new -d "@attacks/memory-exact.json"
    ```

4. That additional memory is now consumed on the target machine.

    ```bash
    htop
    ```

    {% asset '{{ page.asset-path }}'/htop-post-memory-attack.png alt='HTOP Post-Attack Memory Usage' %}{: .align-center}

5. As always, you can view the **Attack** within the [Gremlin Web UI][gremlin#app].

    {% asset '{{ page.asset-path }}'/web-ui-memory-attack.png alt='Gremlin Web UI Memory Attack' %}{: .align-center}

## IO

(TODO)

### Why It Matters: TBD

(TODO)

### Performing an IO Attack with Gremlin

(TODO)

#### Prerequisites

- [Install Gremlin][gremlin#docs#install] on the target machine.
- Retrieve your [Gremlin API Token][#gremlin-api-token].

(TODO)

```bash
-l 45 -d /tmp -w 2 -m rw -s 4 -c 1
```

```bash
Total DISK READ :       0.00 B/s | Total DISK WRITE :       3.92 M/s
Actual DISK READ:       0.00 B/s | Actual DISK WRITE:      15.77 M/s
  PID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN     IO>    COMMAND                                                                   
  323 be/3 root          0.00 B     68.00 K  0.00 % 71.28 % [jbd2/xvda1-8]
20030 be/4 gremlin       0.00 B    112.15 M  0.00 % 17.11 % gremlin attack io -l 45 -d /tmp -w 2 -m rw -s 4 -c 1
```

## Obtaining a Gremlin API Token

To use the Gremlin API you'll first need your organization's API access token.  This can be obtained by authenticating with the appropriate API endpoint.

1. Retrieve your Gremlin API token by passing your `email`, `password`, and `companyName`.
    - For non-MFA authentication use the `https://api.gremlin.com/v1/users/auth` endpoint.

        ```bash
        curl -X POST --header 'Content-Type: application/x-www-form-urlencoded' \
            --data-urlencode 'email=you@example.com' \
            --data-urlencode 'password=password' \
            --data-urlencode 'companyName=Company Name' \
            'https://api.gremlin.com/v1/users/auth'
        ```

    - For MFA authentication you'll also need to include the MFA `token` value and pass it to the `https://api.gremlin.com/v1/users/auth/mfa/auth` endpoint.

        ```bash
        curl -X POST --header 'Content-Type: application/x-www-form-urlencoded' \
            --data-urlencode 'email=you@example.com' \
            --data-urlencode 'password=password' \
            --data-urlencode 'companyName=Company Name' \
            --data-urlencode 'token=123456' \
            'https://api.gremlin.com/v1/users/auth/mfa/auth'
        ```

2. The response JSON object will include your API token within the `header` field.

    ```json
    [
        {
            "company_id": "82708afe-80d0-5859-90bc-8d2e0d475454",
            "company_name": "Company Name",
            "company_is_alfi_enabled": true,
            "expires_at": "2018-10-09T04:46:52.484Z",
            "header": "Bearer NzE3NWFjYTktODBkMC01ODU5LTkwYmMtOGQyZTBkNDc1NDU0OmdhYmVAZ2FiZXd5YXR0LmNvbTpjMjA5YzA5OTgtYjhmZi0wMjQyNTI2NDdmZjY=",
            "identifier": "you@example.com",
            "org_id": "82708afe-80d0-5859-90bc-8d2e0d475454",
            "org_name": "Company Name",
            "renew_token": "8784ca0e-03aa-4753-93ca-0e03aa775336",
            "role": "SUPER",
            "token": "c209c098-cb19-11e8-b8ff-784513247988"
        }
    ]
    ```

3. Export the API token found in the returned `header` value.

    ```bash
    export GREMLIN_API_TOKEN="Bearer NzE3NWFjYTktODBkMC01ODU5LTkwYmMtOGQyZTBkNDc1NDU0OmdhYmVAZ2FiZXd5YXR0LmNvbTpjMjA5YzA5OTgtYjhmZi0wMjQyNTI2NDdmZjY="
    ```

    **TIP**: For simplicity you may `export` the `GREMLIN_API_TOKEN` within your `.bashrc` or `.bash_profile` file to keep the token permanently available across terminal sessions.
    {: .notice--info }

{% include          links-global.md %}
{% include_relative links.md %}