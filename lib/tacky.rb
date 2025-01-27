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

# Tacky is a simple decorator of an existing object that makes all of
# its methods cache all values and calculate them only once.
#
# For more information read
# {README}[https://github.com/yegor256/tacky/blob/master/README.md] file.
#
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2020-2025 Yegor Bugayenko
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
    @mutex.synchronize do
      unless @cache.key?(args)
        @cache[args] = @origin.__send__(*args) do |*a|
          yield(*a) if block_given?
        end
        @cache[args] = Tacky.new(@cache[args], deep: @deep) if @deep && STOP.none? { |t| @cache[args].is_a?(t) }
      end
      @cache[args]
    end
  end

  def respond_to?(method, include_private = false)
    @origin.respond_to?(method, include_private)
  end

  def respond_to_missing?(_method, _include_private = false)
    true
  end
end
