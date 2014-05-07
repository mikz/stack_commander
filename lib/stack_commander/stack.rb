require 'thread'

module StackCommander
  class Stack
    def initialize(scope)
      @queue = Queue.new
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
      return if @queue.empty?
      command_class = @queue.pop

      run_command(command_class)
    end

    private

    def run_command(klass)
      parameters = StackCommander::DependencyInjection.new(klass).extract(@scope)

      command = klass.new(*parameters)
      command.instance_variable_set :@scope, @scope
      command.call(self)
    end
  end
end

