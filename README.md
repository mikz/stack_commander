# StackCommander [![Build Status](https://travis-ci.org/mikz/stack_commander.svg?branch=master)](https://travis-ci.org/mikz/stack_commander)

StackCommander takes fresh approach to Command Pattern in Ruby.
We needed chaining of Commands with benefits of `rescue` and `ensure` which was hard to do without execution stack.

Our use case is mainly to provide rollbacks and finalize blocks for each action so system is not left in unknown state.

When doing prototypes one thing came up: how to share state between commands?

We tried: passing state to the `action` method, passing state to the `initialize` and leaving user to instantiate commands by hand. Unfortunately each one of them had drawbacks and we decided to focus on following behaviour:

* `initialize` is called just before the execution
  * to prevent mistakes of calling something in initializer that might not be there yet
  * or worse, it would be evaluated not on the stack, but before
* `initialize` is called by the stack with explicit parameters instead of whole state object
  * for easier testing
  * and not to break Law of Demeter
* command's `action`, `recover` and `insurance` are called without state parameter
* command has internal variable `@scope`

It is not final, so constructive feedback is very much appreciated.

## Installation

Add this line to your application's Gemfile:

    gem 'stack_commander'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install stack_commander

## Usage

```ruby
require 'stack_commander'

class StackState
  attr_accessor :other

  def dependency
    'gotten from somewhere'
  end
end

class MyCommand
  include StackCommander::Command

  def initialize(dependency)
    @dependency = dependency
    @scope.other = 'yes, other'
  end

  def action
    puts @dependency
  end

  def insurance
    puts 'command insurance'
  end
end

class MyOtherCommand
  include StackCommander::Command


  def initialize(other)
    @other = other
  end

  def action
    puts @other
  end

  def insurance
    puts 'other command insurance'
  end

  def recover(ex)
    puts 'recovering exception: ' + ex.to_s
  end
end

scope = StackState.new
stack = StackCommander::Stack.new(scope)
stack << MyCommand
stack << MyOtherCommand
stack.call
```

outputs:

```
gotten from somewhere
yes, other
other command insurance
command insurance
```

# TODO
* figure out how to configure commands without need of subclassing
  for example Command Gzip accepts a file and outputs a gzipped file, how you can use this command twice in one stack?

## Contributing

1. Fork it ( https://github.com/mikz/stack_commander/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
