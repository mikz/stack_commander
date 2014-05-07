# StackCommander

TODO: Write a gem description

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
end

class MyOtherCommand
  include StackCommander::Command


  def initialize(other)
    @other = other
  end

  def action
    puts @other
  end
end

scope = StackState.new
stack = StackCommander::Stack.new(scope)
stack << MyCommand
stack << MyOtherCommand
stack.call
```

outputs:

>  gotten from somewhere
>  yes, other

## Contributing

1. Fork it ( https://github.com/[my-github-username]/stack_commander/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
