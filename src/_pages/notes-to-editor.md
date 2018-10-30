---
title: "Notes to Gremlin Editors"
description: "Notes for Gremlin editors for configuration, formatting, and site usage."
sources: ""
published: true
permalink: /notes-to-editor
layout: posts
---

The following items are assorted things for Austin and/or other editors to take note of and evaluate.  All project files and original Markdown can be found on the [gremlin-blog-posts](https://github.com/GabeStah/gremlin-blog-posts) GitHub repository.

## Links

All reference style and frequently used URLs are located in included `.md` files.  Any given post can include both the **global** and **local** links files.  A local `links.md` file should add additional reference links and/or override existing global links.

### Global Links

**Global** links are defined in `src/_includes/links-global.md`.  Add the `{% raw %}{% include links-global.md %}{% endraw %}` tag to the bottom of any `.md` file to include all global reference links.

### Local Links

If a post requires additional links then create a new local `links.md` file in the same directory as the post `.md`.  Add additional reference links to that file and append the `{% raw %}{% include_relative links.md %}{% endraw %}` tag to the end of the `.md` file.  Ideally, the local `links.md` should be included after the global version, which will ensure any local changes take precedence.

For example, consider a post that links to the [https://www.gremlin.com/product/][gremlin#product] page using Markdown with a relative link, like so: `{% raw %}[Gremlin Product Page][gremlin#product]{% endraw %}`.

The global `links-global.md` might have the link pointing to the following URL:

```markdown
<!-- global links-global.md -->
[gremlin#product]: http://gremlin.com/product
```

However, that's not quite how we want to format it, so within the local `links.md` we can override it like so:

```markdown
<!-- local links.md -->
[gremlin#product]: https://www.gremlin.com/product
```

### Testing URL Validity and Functionality

1. The `html-proofer` gem is used to help verify link validity.  It can be run manually, but the `Rakefile` is configured to perform a Jekyll build and then execute `html-proofer`.

    ```ruby
    # RAKEFILE
    require 'html-proofer'

    task :test do
        # Temporarily replace baseurl for shared mount directories to hash correctly.
        sh "bundle exec jekyll build --baseurl ''"
        options = {
            assume_extension: true,
            url_ignore: [
            # Documentation link.
            "http://localhost:9000",
            ]
        }
        HTMLProofer.check_directory("./docs", options).run
    end
    ```

    Execute with standard `rake test` command.

    ```bash
    rake test
    ```

    Errors indicate the specific problem, while a successful output confirms all links are valid and functional.

    ```bash
    Running ["LinkCheck", "ScriptCheck", "ImageCheck"] on ["./docs"] on *.html...

    Checking 257 external links...
    Ran on 16 files!

    HTML-Proofer finished successfully.
    ```

### External Links

By default, all external links are processes with `target="_blank" rel="noreferrer noopener"` tags, opening them in a new window.  To disable this behavior disable the `jekyll-target-blank` gem and rebuild.

## Notes/Admonitions

The content contains occasional alerts to emphasize certain text for the reader.

This is an info box.
{: .notice--info}

This is a warning box.
{: .notice--warning}

Formatting is handled during site build by Jekyll/Liquid and is created by suffixing a paragraph with the appropriate `{% raw %}{: .notice}{% endraw %}` tag.

The purpose of these is similar to the [Admonition](https://squidfunk.github.io/mkdocs-material/extensions/admonition/) extension of MkDocs.  If the final published version appearing on the Gremlin site can include such styling it should improve readability of the content.

{% include links-global.md %}