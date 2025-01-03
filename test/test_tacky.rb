# frozen_string_literal: true

# (The MIT License)
#
# Copyright (c) 2020-2025 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
    assert(bar.value == first)
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
    assert(first.is_a?(Numeric))
    assert(bar.child.value == first)
  end

  def test_stops_on_string
    foo = Object.new
    def foo.value
      'hello'
    end
    bar = Tacky.new(foo)
    assert(bar.value.is_a?(String))
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
