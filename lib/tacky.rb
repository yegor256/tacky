# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2020-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

# Tacky is a simple decorator of an existing object that makes all of
# its methods cache all values and calculate them only once.
#
# For more information read
# {README}[https://github.com/yegor256/tacky/blob/master/README.md] file.
#
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2020-2026 Yegor Bugayenko
# License:: MIT
class Tacky
  undef_method :send

  # Deep nesting will stop at these classes.
  STOP = [
    Numeric, NilClass,
    TrueClass, FalseClass,
    Array, Hash,
    Time,
    String
  ].freeze

  def initialize(origin, deep: true)
    @origin = origin
    @cache = {}
    @deep = deep
    @mutex = Mutex.new
  end

  def method_missing(*args)
    maybe = %i[key keyreq]
    @mutex.synchronize do
      key = args.dup
      mtd = args.shift
      unless @cache.key?(key)
        params = @origin.method(mtd).parameters
        reqs = params.count { |p| p[0] == :req }
        @cache[key] =
          if params.any? { |p| maybe.include?(p[0]) } && args.size > reqs
            @origin.__send__(mtd, *args[0..-2], **args.last) do |*a|
              yield(*a) if block_given?
            end
          else
            @origin.__send__(mtd, *args) do |*a|
              yield(*a) if block_given?
            end
          end
        @cache[key] = Tacky.new(@cache[key], deep: @deep) if @deep && STOP.none? { |t| @cache[key].is_a?(t) }
      end
      @cache[key]
    end
  end

  def respond_to?(method, include_private = false)
    @origin.respond_to?(method, include_private)
  end

  def respond_to_missing?(_method, _include_private = false)
    true
  end
end
