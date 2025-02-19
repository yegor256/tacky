# frozen_string_literal: true

# (The MIT License)
#
# SPDX-FileCopyrightText: Copyright (c) 2020-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'English'
Gem::Specification.new do |s|
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.required_ruby_version = '>=2.3'
  s.name = 'tacky'
  s.version = '0.0.0'
  s.license = 'MIT'
  s.summary = 'Primitive Object Memoization for Ruby'
  s.description = 'Decorate your existing Ruby object with Tacky
and all its methods will be cached.'
  s.authors = ['Yegor Bugayenko']
  s.email = 'yegor256@gmail.com'
  s.homepage = 'http://github.com/yegor256/tacky'
  s.files = `git ls-files`.split($RS)
  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = ['README.md']
  s.metadata['rubygems_mfa_required'] = 'true'
end
