# Silencer [![Build Status](https://secure.travis-ci.org/spagalloco/silencer.png?branch=master)][travis] [![Dependency Status](https://gemnasium.com/spagalloco/silencer.png?travis)][gemnasium]

[travis]: http://travis-ci.org/spagalloco/silencer
[gemnasium]: https://gemnasium.com/spagalloco/silencer

Silencer is a simple rack-middleware for Rails that can selectively disable logging on per-action basis.  It's based on a [blog post](http://dennisreimann.de/blog/silencing-the-rails-log-on-a-per-action-basis/) by Dennis Reimann.

## Installation

Just add silencer to your Gemfile:

    gem 'silencer'

## Usage

In your production environment (presumably):


    require 'silencer/logger'

    config.middleware.swap Rails::Rack::Logger, Silencer::Logger, :silence => ["/noisy/action.json"]

Or if you'd prefer, you can pass it regular expressions:


    config.middleware.swap Rails::Rack::Logger, Silencer::Logger, :silence => [/assets/]

Silencer's logger will serve as a drop-in replacement for Rails' default logger.  It will not suppress any logging by default, simply pass it an array of urls via the options hash.  You can also send it a 'X-SILENCE-LOGGER' header (with any value) with your request and that will also produce the same behavior.

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2012 Steve Agalloco. See [LICENSE](https://github.com/spagalloco/silencer/blob/master/LICENSE.md) for details.
