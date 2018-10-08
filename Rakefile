require 'html-proofer'

task :test do
  # Temporarily replace baseurl for shared mount directories to hash correctly.
  sh "bundle exec jekyll build --baseurl ''"
  options = { 
    assume_extension: true,
    url_ignore: [
      # Documentation link.
      "http://localhost:9000",
      # Private GitHub.
      "https://github.com/GabeStah/gremlin-blog-posts",
    ]
  }
  HTMLProofer.check_directory("./docs", options).run
end
