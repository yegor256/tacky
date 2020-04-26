<img src="/logo.svg" width="64px" height="64px"/>

[![EO principles respected here](https://www.elegantobjects.org/badge.svg)](https://www.elegantobjects.org)
[![DevOps By Rultor.com](http://www.rultor.com/b/yegor256/tacky)](http://www.rultor.com/p/yegor256/tacky)
[![We recommend RubyMine](https://www.elegantobjects.org/rubymine.svg)](https://www.jetbrains.com/ruby/)

[![Build Status](https://travis-ci.org/yegor256/tacky.svg)](https://travis-ci.org/yegor256/tacky)
[![Build status](https://ci.appveyor.com/api/projects/status/e61qudqccs0fu8xt?svg=true)](https://ci.appveyor.com/project/yegor256/tacky)
[![Gem Version](https://badge.fury.io/rb/tacky.svg)](http://badge.fury.io/rb/tacky)
[![Maintainability](https://api.codeclimate.com/v1/badges/5528e182bb5e4a2ecc1f/maintainability)](https://codeclimate.com/github/yegor256/tacky/maintainability)
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

That's it. All method calls will be cached.

## How to contribute

Read [these guidelines](https://www.yegor256.com/2014/04/15/github-guidelines.html).
Make sure you build is green before you contribute
your pull request. You will need to have [Ruby](https://www.ruby-lang.org/en/) 2.3+ and
[Bundler](https://bundler.io/) installed. Then:

```
$ bundle update
$ bundle exec rake
```

If it's clean and you don't see any error messages, submit your pull request.
