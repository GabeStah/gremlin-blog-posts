---
title: "Chaos Engineering Through Staged Resiliency - Stage 1"
excerpt: "Why organizations planning to migrate to the cloud should embrace Chaos Engineering as a thoughtful strategy to avoid pain down the road."
categories: [chaos-engineering]
tags: [migration, experiment, outage]
url: "https://www.gremlin.com/blog/?"
published: true
asset-path: chaos-engineering/chaos-engineering-through-staged-resiliency/stage-1
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
        facebook-dns:
            tags: ["DNS issue prevented access for many global users"]
            urls: https://thenextweb.com/facebook/2012/12/11/facebook-encountering-dns-issues-making-it-unavailable-for-some-users/
        amazon-ec2-rds-east:
            tags: ["Amazon EBS volumes became stuck, unable to servie read/write operations"]
            urls: https://aws.amazon.com/message/65648/
---

## Introduction

Hello there

{% comment %}
{% asset '{{ page.asset-path }}'/web-ui-blackhole-attack.png %}{: .align-center}
{% endcomment %}

## Conclusion

{% include          links-global.md %}
{% include_relative links.md %}