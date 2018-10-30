---
title: "Create a Serverless Twitter Bot with Airbrake and AWS Lambda - Part 1"
excerpt: "How to create a serverless Twitter bot with Airbrake and AWS Lambda."
published: true
asset-path: misc/examples
sources:
---

In this series, you'll learn how to create a fully-automated, NodeJS, serverless Twitter bot that can tweet links to posts from your favorite blog or RSS feed.

In part one of our three-part series, you'll create a bot and configure it to manually create tweets.  In [part two](https://airbrake.io/blog/nodejs/serverless-twitter-bot-airbrake-lambda-part-2) you'll learn how to add real-time error monitoring by integrating <a class="js-cta-utm" href="https://airbrake.io/languages/nodejs-error-monitoring?utm_source=blog&utm_medium=end-post&utm_campaign=airbrake-serverless-twitter-bot">Airbrake's Node.js</a> software.  Finally, [part three](https://airbrake.io/blog/nodejs/serverless-twitter-bot-airbrake-lambda-part-3) will walk you through the process of automating your bot by integrating it into the serverless AWS Lambda platform.  Let's get to it!

## Initialize Your Project

1. Create a new Node project.

    ```bash
    npm init
    ```

2. Install the [`twitter`](https://www.npmjs.com/package/twitter) NPM package, which will simplify communication with the Twitter API.

    ```bash
    npm install twitter --save
    ```

## Working with Secret API Credentials

1. To obtain a set of Twitter API credentials log into your Twitter account and navigate to [https://apps.twitter.com/](https://apps.twitter.com/).

2. Click `Create New App` then fill out the form.  For example:

    - `Name`: AirbrakeArticles
    - `Description`: Tweeting random Airbrake.io articles!
    - `Website`: https://github.com/GabeStah/twitter-bot

3. Agree to the terms of use to create your app.

4. Click on the `Keys and Access Tokens` tab at the top, then click `Create my access token` at the bottom.  Per the [Twitter NPM](https://www.npmjs.com/package/twitter) documentation, you'll need the `consumer_key`, `consumer_secret`, `access_token_key`, and `access_token_secret` values from Twitter.

5. Open the `twitter-api-credentials.js` and paste the following template into it, adding your own credentials into each field.

    ```js
    // twitter-api-credentials.js
    module.exports = {
        consumer_key: "",
        consumer_secret: "",
        access_token_key: "",
        access_token_secret: ""
    };
    ```

6. Finally, to avoid publicly exposing your Twitter authentication API keys, add the `twitter-api-credentials.js` file to your [`.gitignore`](https://git-scm.com/docs/gitignore) file.

    ```bash
    echo "twitter-api-credentials.js" >> .gitignore
    ```

## Creating a Basic App

The next step to properly test your application logic is to ensure that the Twitter API connection can be established.

1. Start by creating the base `index.js` application file for your Node project.

    ```bash
    touch index.js
    nano index.js
    ```

2. `Require` the `twitter-api-credentials.js` credentials file, along with the `twitter` NPM module.  Additionally, instantiate a new `Twitter` object and pass the generated credentials.

    ```js
    // index.js
    const twitter_credentials = require('./twitter-api-credentials');
    const Twitter = require('twitter');

    // Use exported secret credentials.
    let twitter = new Twitter(twitter_credentials);
    ```

    The `twitter` NPM module provides convenience methods for sending `GET` and `POST` HTTP method requests to the [Twitter API](https://developer.twitter.com/en/docs).  For example, if you wish to post a tweet you must send a `POST` request to the `statuses/update` API endpoint, as shown in the [official documentation](https://developer.twitter.com/en/docs/tweets/post-and-engage/api-reference/post-statuses-update).  Check out [Twitter API Getting Started](https://developer.twitter.com/en/docs/basics/getting-started) for more details.
    {: .notice--tip }

3. To perform a simple test tweet of `"Am I a robot?"` add the following to `index.js`.

    ```js
    // Perform a test tweet.
    twitter.post(
        'statuses/update',
        {
            status: 'Am I a robot?'
        },
        function(error, tweet, response) {
            if(error) {
                console.log(error);
                throw error;
            }
            console.log('---- TWEET ----');
            console.log(tweet);
            console.log('---- RESPONSE ----');
            console.log(response);
        }
    );
    ```

4. Verify that your Node app works as expected.  If everything was setup correctly you'll see the output in the console log to confirm it works.  You can also refresh your Twitter account page to see the new [`"Am I a robot?"` tweet](https://twitter.com/AirbrakeArticle/status/946880037424209921).

    ```bash
    $ node index.js
    { created_at: 'Fri Dec 29 23:12:53 +0000 2017',
    id: 946881740039057400,
    id_str: '946881740039057408',
    text: 'Am I a robot?',
    truncated: false,
    ...
    ```

## Making Your Bot More Interesting

Alright, you've got a working shell of a bot, but it doesn't do anything very exciting.  In this section, you'll configure the bot to tweet links to random posts obtained from an RSS, Atom, or RDF feed.  The example bot uses the [https://airbrake.io/blog/feed/atom](https://airbrake.io/blog/feed/atom) feed, but you may use any valid feed URL.

1. Start by installing the [feedparser](https://www.npmjs.com/package/feedparser) NPM module, which simplifies the process of retrieving the latest feed data.

    ```bash
    npm install --save feedparser
    ```

2. Modify `index.js` to `require` the `feedparser` and `request` modules.  The `index.js` file should look something like this, with the URL to your desired Atom feed.

    ```js
    // index.js
    const FeedParser = require('feedparser');
    const request = require('request');
    const twitter_credentials = require('./twitter-api-credentials');
    const Twitter = require('twitter');

    let feedparser = new FeedParser();
    let feed = request('https://airbrake.io/blog/feed/atom');

    // Use exported secret credentials.
    let twitter = new Twitter(twitter_credentials);

    // Article collection.
    let articles = [];
    ```

3. Because the request is asynchronous the bot needs to respond to a few different events to process the incoming feed request, so append the following to `index.js`.

    ```js
    /**
    * Fires when feed request receives a response from server.
    */
    feed.on('response', function (response) {
        if (response.statusCode !== 200) {
            this.emit('error', new Error('Bad status code'));
        } else {
            // Pipes request to feedparser for processing.
            this.pipe(feedparser);
        }
    });

    /**
    * Invoked when feedparser completes processing request.
    */
    feedparser.on('end', function () {
        tweetRandomArticle(articles);
    });

    /**
    * Executes when feedparser contains readable stream data.
    */
    feedparser.on('readable', function () {
        let article;

        // Iterate through all items in stream.
        while (article = this.read()) {
            // Output each Article to console.
            console.log(`Gathered '${article.title}' published ${article.date}`);
            // Add Article to collection.
            articles.push(article);
        }
    });
    ```

4. The `tweetArticle(article)` and `tweetRandomArticle()` helper functions act as simple wrappers for calling `twitter` module methods to send a `POST` request to the `statuses/update` API endpoint.

    ```js
    /**
    * Tweet the passed Article object.
    *
    * @param article Article to be tweeted.
    */
    function tweetArticle(article) {
        if (article == null) return;
        twitter.post(
            'statuses/update',
            {
                status: `${article.title} ${article.link}`
            },
            function(error, tweet, response) {
                if(error) {
                    console.log(error);
                    throw error;
                }
                console.log('---- TWEETED ARTICLE ----');
                console.log(tweet);
            }
        );
    }

    /**
    * Tweet a random Article.
    */
    function tweetRandomArticle() {
        // Tweet a random article.
        tweetArticle(articles[Math.floor(Math.random()*articles.length)])
    }
    ```

Everything is now setup, so it's time to run your application and see it in action.

```bash
$ node index.js
Gathered '410 Gone Error: What It Is and How to Fix It' published Thu Dec 28 2017 19:09:32 GMT-0800 (PST)
Gathered 'Python Exception Handling &#8211; EOFError' published Wed Dec 27 2017 19:21:25 GMT-0800 (PST)
Gathered 'Techniques for Preventing Software Bugs' published Tue Dec 26 2017 14:23:52 GMT-0800 (PST)
...
---- TWEETED ARTICLE ----
{ created_at: 'Sat Dec 30 00:10:26 +0000 2017',
  id: 946896220181561300,
  id_str: '946896220181561344',
  text: '303 See Other: What It Is and How to Fix It https://t.co/UaIf0uYeUS',
...
```

Awesome!  The bot parsed the feed, captured the latest posts, selected a random post, and automatically tweeted the post title and URL (e.g. [AirbrakeArticle](https://twitter.com/AirbrakeArticle/status/946896220181561344)).

## Conclusion

You now have a basic Twitter bot up and running.  Next week's post will show you how to refine your bot and make it better suited to the real-world by implementing real-time error monitoring via <a class="js-cta-utm" href="https://airbrake.io/languages/nodejs-error-monitoring?utm_source=blog&utm_medium=end-post&utm_campaign=airbrake-serverless-twitter-bot">Airbrake's NodeJS</a> package.  After that, you'll setup AWS Lambda so your bot can run automatically and serverlessly.  Stay tuned!