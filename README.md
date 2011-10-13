Silencer
========

Silencer is a simple rack-middleware for Rails that can selectively disable logging on per-action basis.  It's based on a [blog post](http://dennisreimann.de/blog/silencing-the-rails-log-on-a-per-action-basis/) by Dennis Reimann.

Installation
------------

Just add silencer to your Gemfile:

gem 'silencer'

Usage
-----

In your production environment (presumably):

```ruby
require 'silencer/logger'

module MyApp
  class Application < Rails::Application
    config.middleware.swap Rails::Rack::Logger, Silencer::Logger, :silence => ["/noisy/action.json"]
  end
end
```

By default, Silencer's logger will serve as a drop-in replacement for Rails default logger, but you can also send it a 'X-SILENCE-LOGGER' header (with any value) and that will also produce the same behavior.

Note on Patches/Pull Requests
-----------------------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright (c) 2011 Steve Agalloco. See LICENSE for details.