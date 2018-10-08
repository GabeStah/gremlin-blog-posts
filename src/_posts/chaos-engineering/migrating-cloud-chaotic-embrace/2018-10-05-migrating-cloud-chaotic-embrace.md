---
title: "Migrating to the Cloud is Chaotic. Embrace it."
excerpt: "Demonstrating why companies migrating to cloud should embrace Chaos Engineering early and often to avoid pain down the road."
categories: [chaos-engineering]
tags: [migration]
url: "https://www.gremlin.com/blog/?"
published: true
sources: [
    
]
---

{% comment %}
There's plenty to like about the cloud, but newcomers almost always dread its main drawback: its ephemeral nature. They know they can't count on servers to stick around indefinitely. They expect disk performance to tank without warning. They fear the day that some critical managed service suddenly goes dark. As Chaos Engineering evangelists, we hear these fears all the time. "The cloud is chaotic enough! Why would we add more chaos on purpose?" We get it—we've answered the 3am pages too. But remember: Chaos Engineering grew up in the cloud. Netflix embraced the problem of vanishing cloud servers, they didn't fear it. They created Chaos Monkey not as an optional tool to give their engineers, but as a mandatory tool to impose on them. [As we recently put it](https://www.gremlin.com/continuous-chaos-never-stop-iterating/), the best way to get ahead of natural chaos is to synthesize your own, and synthetic chaos is especially powerful when you apply it regularly—when it's non-negotiable. As you make continuous chaos a part of your normal engineering practice, you gradually learn to stop fearing the ephemerality of the cloud.
What's even more chaotic than running in the cloud? Migrating to it. Although you might rather start your Chaos Engineering practice after your migration, the truth is that you should be proactively testing and identifying weaknesses as you move over pieces of your infrastructure.. Think about it: this is a golden opportunity to test how your cloud infrastructure behaves, as your old infrastructure is still taking most production traffic. Better to run your cloud environment through the ringer now while it's still in its embryonic stage and it's low stakes. What's the alternative? Migrating all of your mission-critical services and finding out they don't behave in the cloud like you'd hoped? In that scenario, you are impacting customers and not doing what you should to make sure your systems are behaving the way you want them to.
If you're moving to cloud, you're probably changing your stack in a few other ways too. Perhaps you are experimenting with containers; perhaps you are implementing new CI / CD tools. This is your chance to start doing infrastructure-wide testing, before you get years down the road and don't truly understand your system. This process is table stakes in writing software: when you are building a new application, you don't avoid writing tests for the first six months, do you? No, you do it from day one. We need to shift the mindset of operations from reactive to being more proactive with chaos engineering.
So too should you practice Chaos Engineering from day one in the cloud, because it's often more chaotic—or at least more ephemeral—than on-prem. When you migrate, oftentimes stuff isn't configured the same way in the new environment; at least not at first. Chaos Eng can help you catch these misconfigurations (e.g. database replication not working right? Then when you shoot the master in the head and the slave takes
over—but it has no data—you catch the misconfiguration.)
Objections from the reader/migrator:
Examples of when to do chaos eng during migration:

- Database failover—kill your new, cloudy master node to make sure failover works (and that the slave is replicating).
- Noisy neighbor? Using a chaos tools to chew up your CPU in your original environment, you can
- Some services still running on-prem? Test your latency to them. Test Blackholes on them!
- Test disk latency?
- Don't assume new resilience mechanisms from your cloud provider work as you expect. (Honeycomb found out the hard way that Amazon RDS only fails over to hot spares in the face of total infrastructure failure of the primary DB—it does not account for slow queries/bad performance): https://www.honeycomb.io/blog/2018/05/rds-performance-degradation-postmortem/
- Your cloud environment may be more spread out than your old environment. There's more space, literally, between all your services. (And we saw in The Cost of Downtime post that Network outages are the number one cause of downtime.)
- Chaos Engineering forces you to confront your steady state: to know what that state is, think about how to measure it, and how to test its strength.
- The ephemerality of the cloud
  
Don't just pick random things to test. Move some stuff over to the cloud, watch your monitoring dashboards, and see where the problem areas may lie. If you don't see anything the first few days, wait a few weeks.
The meta point: maybe your on-prem deployment was super stable. They can be in certain ways (low network latency, low-to-no contention for CPU/disk, etc), and not in others (not resilient to DC outage (if you're in one DC), major network outages, etc). But if it's stable, and you've gotten complacent
{% endcomment %}

{% comment %}
Austin Gunter (Slack):
this blog post serves to demonstrate why a company migrating to the cloud would want to plan for chaos engineering in advance of their migration
one of the main objections to folks not doing chaos during their migration is they think that adding this in will slow things down
but in reality, NOT doing it will just lead to pain later when things don't work out
in particular, there's a big chunk of technical depth that we can go into about migrating to various distributed technologies

and you can create quick tutorials for the bullets mentioned
we can make this 2500 words pretty easily
and i don't mind if it's more
one thing that would be fun is if you can find examples of real world outages from migrations that would have been avoided had a particular thing been tested for
{% endcomment %}

**PURPOSE**: Demonstrate why companies migrating to the cloud should embrace Chaos Engineering early and often to avoid pain down the road.
{: .notice--danger }

## Examples of Chaos Experiments During Migration

- Database failover—kill your new, cloudy master node to make sure failover works (and that the slave is replicating).
- Noisy neighbor? Using a chaos tools to chew up your CPU in your original environment, you can
- Some services still running on-prem? Test your latency to them. Test Blackholes on them!
- Test disk latency?
- Don't assume new resilience mechanisms from your cloud provider work as you expect. (Honeycomb found out the hard way that Amazon RDS only fails over to hot spares in the face of total infrastructure failure of the primary DB—it does not account for slow queries/bad performance): https://www.honeycomb.io/blog/2018/05/rds-performance-degradation-postmortem/
- Your cloud environment may be more spread out than your old environment. There's more space, literally, between all your services. (And we saw in The Cost of Downtime post that Network outages are the number one cause of downtime.)
- Chaos Engineering forces you to confront your steady state: to know what that state is, think about how to measure it, and how to test its strength.
- The ephemerality of the cloud

### Gremlin API Token

```bash
export GREMLIN_API_TOKEN="Bearer NzE3NWFjYTktODBkMC01ODU5LTkwYmMtOGQyZTBkNDc1NDU0OmdhYmVAZ2FiZXd5YXR0LmNvbTozZTRkMjI2Ny1jYThhLTEx"
```

**TIP**: For simplicity you may also opt to `export` the `GREMLIN_API_TOKEN` within your `.bashrc` or `.bash_profile` file to keep it permanently available across terminal sessions.
{: .notice--info }

### CPU Attack

> Noisy neighbor? Using a chaos tools to chew up your CPU in your original environment, you can

- `c`: Number of CPU cores to attack.
- `length` or `l`: Attack duration (in seconds).

```json
// cpu-random.json
{
    "command": {
        "type": "cpu",
        "args": ["-c", "1", "--length", "30"]
    },
    "target": {
        "type": "Random"
    }
}
```

```bash
curl -H "Content-Type: application/json" -H "Authorization: $GREMLIN_API_TOKEN" https://api.gremlin.com/v1/attacks/new -d "@attacks/cpu-random.json"
```

```json
// cpu-exact.json
{
    "command": {
        "type": "cpu",
        "args": ["-c", "1", "--length", "30"]
    },
    "target": {
        "type": "Exact",
        "exact": ["172.31.42.65"]
    }
}
```

```bash
curl -H "Content-Type: application/json" -H "Authorization: $GREMLIN_API_TOKEN" https://api.gremlin.com/v1/attacks/new -d "@attacks/cpu-exact.json"
```

### Disk Latency

> Test disk latency?

- `d`: Root directory which files will be temporarily written to.
- `length` or `l`: Attack duration (in seconds).
- `w`: Number of concurrent disk-write workers.
- `b`: Block size (in kilobytes).
- `p`: Percentage of volume to fill.

```json
// disk-random.json
{
    "command": {
        "type": "disk",
        "args": ["-d", "/tmp", "--length", "30", "-w", "1", "-b", "4", "-p", "100"]
    },
    "target": {
        "type": "Random"
    }
}
```

```bash
curl -H "Content-Type: application/json" -H "Authorization: $GREMLIN_API_TOKEN" https://api.gremlin.com/v1/attacks/new -d "@attacks/cpu-random.json"
```

```json
// cpu-exact.json
{
    "command": {
        "type": "cpu",
        "args": ["-c", "1", "--length", "30"]
    },
    "target": {
        "type": "Exact",
        "exact": ["172.31.42.65"]
    }
}
```

### Blackhole

1. Start by performing a test to establish a baseline.  In this case, we're timing how long to recieve a response from `example.com` (which has an IP address of `93.184.216.34`).

    ```bash
    $ time curl -o /dev/null 93.184.216.34

    # OUTPUT
    real	0m0.025s
    user	0m0.009s
    sys	0m0.000s
    ```

2. asd

**attacks/blackhole-random.json**

- `length` or `l`: Attack duration (in seconds).
- `i`: Outgoing IP address(es) to affect.  Optionally, you can prefix an IP with a caret (`^`) to whitelist it.
- `h`: Outgoing hostname(s) to affect.  Optionally, you can prefix a hostname with a caret (`^`) to whitelist it.  It is recommended to include `^api.gremlin.com` in the whitelist.

```json
{
    "command": {
        "type": "blackhole",
        "args": ["-l", "30", "-i", "93.184.216.34", "-h", "^api.gremlin.com"]
    },
    "target": {
        "type": "Random"
    }
}
```

```bash
$ time curl -o /dev/null 93.184.216.34

# OUTPUT
real	0m31.623s
user	0m0.013s
sys	0m0.000s
```

`aws:aws:us-west-2`

```
100.20.0.0/14,176.32
```

`aws:ec2:us-west-2`

```
100.20.0.0/14,18.236
```

```bash
curl -H "Content-Type: application/json" -H "Authorization: $GREMLIN_API_TOKEN" https://api.gremlin.com/v1/attacks/new -d "@att

## Real World Examples

> find examples of real world outages from migrations that would have been avoided had a particular thing been tested for

## Hello There

1. Doing a thing.
2. Doing another hting.

{% capture notice-text %}
This is a test of the notice.  Links [to self][#migrating-cloud-chaotic-embrace].

- blah
- bleh
{% endcapture %}

<div class="notice--info">
    {{ notice-text | markdownify }}
</div>

3. Doing a third thing.

This is a test of the notice.  Links [to gremlin.com/product][gremlin.com/product].
{: .notice--info}

This is a test of the notice.  Links [to self][#migrating-cloud-chaotic-embrace].  Here is a `code item`.
{: .notice--warning}

This is a test of text center.  Links [to test][#test].
{: .text-center}

[Text](#link){: .btn .btn--danger}

{% include          links-global.md %}
{% include_relative links.md %}