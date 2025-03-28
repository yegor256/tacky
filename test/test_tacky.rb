# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2020-2025 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require_relative '../lib/tacky'

# Tacky test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2020-2025 Yegor Bugayenko
# License:: MIT
class TackyTest < Minitest::Test
  def test_wraps_simple_object
    foo = Object.new
    def foo.value
      rand(100)
    end
    bar = Tacky.new(foo)
    first = bar.value
    10.times do
      assert_equal(bar.value, first)
    end
  end

  def test_passes_hash_args
    foo = Object.new
    def foo.value(one, two:)
      "#{one} #{rand(one + two)}"
    end
    bar = Tacky.new(foo)
    first = bar.value(42, two: 1)
    10.times do
      assert_equal(bar.value(42, two: 1), first)
      refute_equal(bar.value(777, two: 1), first)
      refute_equal(bar.value(42, two: 555), first)
    end
  end

  def test_passes_hash_as_arg
    foo = Object.new
    def foo.value(one, two)
      "#{one} #{rand(one + two.size)}"
    end
    bar = Tacky.new(foo)
    first = bar.value(42, { a: 22 })
    10.times do
      assert_equal(bar.value(42, { a: 22 }), first)
      refute_equal(bar.value(42, { a: 23 }), first)
      refute_equal(bar.value(43, { a: 22 }), first)
    end
  end

  def test_passes_hash_as_first_arg
    foo = Object.new
    def foo.value(one, two)
      "#{one} #{rand(one.size + two)}"
    end
    bar = Tacky.new(foo)
    first = bar.value({ a: 22 }, 42)
    10.times do
      assert_equal(bar.value({ a: 22 }, 42), first)
      refute_equal(bar.value({ a: 23 }, 42), first)
      refute_equal(bar.value({ a: 22 }, 43), first)
    end
  end

  def test_passes_two_hash_args
    foo = Object.new
    def foo.value(one, two, three:, four: 4)
      "#{one} #{rand(one + two + three + four)}"
    end
    bar = Tacky.new(foo)
    first = bar.value(42, 43, three: 1, four: 1)
    10.times do
      assert_equal(bar.value(42, 43, three: 1, four: 1), first)
      refute_equal(bar.value(42, 43, three: 1, four: 555), first)
      refute_equal(bar.value(42, 43, three: 555, four: 1), first)
    end
  end

  def test_passes_default_hash_args
    foo = Object.new
    def foo.value(one, two: 42)
      "#{one} #{rand(one + two)}"
    end
    bar = Tacky.new(foo)
    first = bar.value(42)
    10.times do
      assert_equal(bar.value(42), first)
      refute_equal(bar.value(0), first)
    end
  end

  def test_passes_one_default_hash_args
    foo = Object.new
    def foo.value(one: 42)
      "#{one} #{rand(one)}"
    end
    bar = Tacky.new(foo)
    first = bar.value
    assert_equal(bar.value, first)
    refute_equal(bar.value(one: 44), first)
  end

  def test_passes_default_args
    foo = Object.new
    def foo.value(one = 42)
      "#{one} #{rand(one)}"
    end
    bar = Tacky.new(foo)
    first = bar.value
    assert_equal(bar.value, first)
    refute_equal(bar.value(7), first)
  end

  def test_deep_caching
    foo = Object.new
    def foo.child
      bar = Object.new
      def bar.value
        rand(100)
      end
      bar
    end
    bar = Tacky.new(foo, deep: true)
    first = bar.child.value
    assert_kind_of(Numeric, first)
    assert_equal(bar.child.value, first)
  end

  def test_stops_on_string
    foo = Object.new
    def foo.value
      'hello'
    end
    bar = Tacky.new(foo)
    assert_kind_of(String, bar.value)
  end

  def test_wraps_void_returning_methods
    foo = Class.new do
      attr_reader :done

      def initialize
        @done = 0
      end

      def touch
        @done += 1
        nil
      end
    end.new
    bar = Tacky.new(foo)
    bar.touch
    bar.touch
    assert_equal(1, foo.done)
  end

  def test_diff_methods_by_params
    foo = Object.new
    def foo.value(val)
      val
    end
    bar = Tacky.new(foo)
    assert_equal(5, bar.value(5))
    assert_equal(10, bar.value(10))
  end

  def test_diff_methods_by_hash_params
    foo = Object.new
    def foo.value(*)
      rand(1000)
    end
    bar = Tacky.new(foo)
    assert_equal(bar.value(val: 5), bar.value(val: 5))
    assert_equal(bar.value(val: 10), bar.value(val: 10))
    assert_equal(bar.value(val: true), bar.value(val: true))
  end
end
