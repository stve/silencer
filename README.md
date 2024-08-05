# Silencer

[![Gem Version](http://img.shields.io/gem/v/silencer.svg)][gem]
![Tests](https://github.com/stve/silencer/actions/workflows/ci.yml/badge.svg)

[gem]: https://rubygems.org/gems/silencer

Silencer is a simple rack-middleware for Rails that can selectively disable logging on per-action basis.  It's based on a [blog post](http://dennisreimann.de/blog/silencing-the-rails-log-on-a-per-action-basis/) by Dennis Reimann.

__Note__: Silencer is only threadsafe in Rails version 4.2.6 and later.

## Installation

Just add silencer to your Gemfile:

```ruby
gem 'silencer', require: false
```

### Upgrading to version 2.0

__Note:__ 1.x versions of silencer detected the presence of Rails when it was required. This made it easy to use silencer for most applications, but made assumptions on usage.

In version 2.0, you'll need to require the correct logger within your application. See the Usage documentation for more details.

## Usage

### Rails

Create an initializer (like `config/initializers/silencer.rb`) with the contents:

```ruby
require 'silencer/rails/logger'

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
require 'silencer/rack/logger'

use Silencer::Logger, silence: ["/noisy/action.json"]
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

| Configuration | Description | Default |
|---------------|-------------|---------|
| `silence` | Silences matching requests regardless of request method | None |
| `get` | Silences matching GET requests | None |
| `head` | Silences matching HEAD requests | None |
| `post` | Silences matching POST requests | None |
| `put` | Silences matching PUT requests | None |
| `delete` | Silences matching DELETE requests | None |
| `patch` | Silences matching PATCH requests | None |
| `trace` | Silences matching TRACE requests | None |
| `connect` | Silences matching CONNECT requests | None |
| `options` | Silences matching OPTIONS requests | None |
| `enable_header` | Enable/disable X-SILENCE-LOGGER header support | `true` |

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bugfix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2012 Steve Agalloco. See [LICENSE](https://github.com/stve/silencer/blob/main/LICENSE.md) for details.
