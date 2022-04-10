# Silencer

[![Gem Version](http://img.shields.io/gem/v/silencer.svg)][gem]
![Tests](https://github.com/stve/silencer/actions/workflows/ci.yml/badge.svg)

[gem]: https://rubygems.org/gems/silencer

Silencer is a simple rack-middleware for Rails that can selectively disable logging on per-action basis.  It's based on a [blog post](http://dennisreimann.de/blog/silencing-the-rails-log-on-a-per-action-basis/) by Dennis Reimann.

__Note__: Silencer is only threadsafe in Rails version 4.2.6 and later.

## Installation

Just add silencer to your Gemfile:

```ruby
gem 'silencer'
```

## Usage

### Rails

Create an initializer (like `config/initializers/silencer.rb`) with the contents:

```ruby
require 'silencer/logger'

Rails.application.configure do
  config.middleware.swap(
    Rails::Rack::Logger, 
    Silencer::Logger, 
    config.log_tags,
    silence: ["/noisy/action.json"]
  )
end
```

### Rack

```ruby
require 'silencer/logger'

use Silencer::Logger, :silence => ["/noisy/action.json"]
```

## Configuration

Or if you'd prefer, you can pass it regular expressions:

```ruby
config.middleware.swap(
  Rails::Rack::Logger, 
  Silencer::Logger, 
  config.log_tags, 
  silence: [%r{^/assets/}]
)
```

Or you can silence specific request methods only:

```ruby
config.middleware.swap(
  Rails::Rack::Logger, 
  Silencer::Logger, 
  config.log_tags, 
  get: [%r{^/assets/}], 
  post: [%r{^/some_path}]
)
```

Silencer's logger will serve as a drop-in replacement for Rails' default logger.  It will not suppress any logging by default, simply pass it an array of URLs via the options hash.  You can also send an `X-SILENCE-LOGGER` header (with any value) with your request and that will also produce the same behavior.

### All options

Silencer supports the following configuration options.

```
:silence       - Silences matching requests regardless of request method
:get           - Silences matching GET requests
:head          - Silences matching HEAD requests
:post          - Silences matching POST requests
:put           - Silences matching PUT requests
:delete        - Silences matching DELETE requests
:patch         - Silences matching PATCH requests
:trace         - Silences matching TRACE requests
:connect       - Silences matching CONNECT requests
:options       - Silences matching OPTIONS requests
:enable_header - Enable/disable X-SILENCE-LOGGER header support (default: true)
```

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bugfix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2012 Steve Agalloco. See [LICENSE](https://github.com/spagalloco/silencer/blob/main/LICENSE.md) for details.
