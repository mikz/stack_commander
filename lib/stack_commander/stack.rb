require 'stack_commander'

module StackCommander
  class Stack
    def initialize(scope)
      @queue = []
      @scope = scope
    end

    def size
      @queue.length
    end

    def <<(command)
      @queue.push(command)

      self # for chaining awesomeness << cmd << cmd2 << cmd3
    end

    def call
      if command_class = @queue.shift
        run_command(command_class)
      end
    end

    # TODO: maybe this should be responsibility of the command? it would make testing easier
    def initialize_command(klass)
      parameters = StackCommander::DependencyInjection.new(klass).extract(@scope)

      command = klass.allocate
      command.instance_variable_set :@scope, @scope
      command.__send__(:initialize, *parameters)

      command
    end

    private

    def run_command(klass)
      command = initialize_command(klass)
      command.call(self)
    end
  end
end

