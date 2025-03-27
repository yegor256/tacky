# Caching Decorator for Ruby Objects

[![EO principles respected here](https://www.elegantobjects.org/badge.svg)](https://www.elegantobjects.org)
[![DevOps By Rultor.com](http://www.rultor.com/b/yegor256/tacky)](http://www.rultor.com/p/yegor256/tacky)
[![We recommend RubyMine](https://www.elegantobjects.org/rubymine.svg)](https://www.jetbrains.com/ruby/)

[![rake](https://github.com/yegor256/tacky/actions/workflows/rake.yml/badge.svg)](https://github.com/yegor256/tacky/actions/workflows/rake.yml)
[![Gem Version](https://badge.fury.io/rb/tacky.svg)](http://badge.fury.io/rb/tacky)
[![Maintainability](https://api.codeclimate.com/v1/badges/224939b58aa606fdd56c/maintainability)](https://codeclimate.com/github/yegor256/tacky/maintainability)
[![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://rubydoc.info/github/yegor256/tacky/master/frames)
[![Hits-of-Code](https://hitsofcode.com/github/yegor256/tacky)](https://hitsofcode.com/view/github/yegor256/tacky)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/yegor256/tacky/blob/master/LICENSE.txt)

First, install it:

```bash
$ gem install tacky
```

Then, use it like this:

```ruby
require 'tacky'
obj = Tacky.new(obj)
```

That's it, all method calls will be cached. This means that only the first
call of any method will actually reach your object. All consecutive calls
will be intercepted by the `Tacky` decorator, which will return
previously calculated values. The decorator keeps all values in its internal
`Hash`.

If you want all methods of everything your methods return be cached too, you
need to use "deep" caching (it's `true` by default):

```ruby
obj = Tacky.new(obj, deep: true)
```

Keep in mind that `Tacky` is thread-safe.

## How to contribute

Read
[these guidelines](https://www.yegor256.com/2014/04/15/github-guidelines.html).
Make sure your build is green before you contribute
your pull request. You will need to have
[Ruby](https://www.ruby-lang.org/en/) 2.3+ and
[Bundler](https://bundler.io/) installed. Then:

```
$ bundle update
$ bundle exec rake
```

If it's clean and you don't see any error messages, submit your pull request.
