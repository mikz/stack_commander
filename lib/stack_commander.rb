require 'stack_commander/version'

module StackCommander
  autoload :Stack, 'stack_commander/stack'
  autoload :Command, 'stack_commander/command'
  autoload :BaseCommand, 'stack_commander/base_command'
  autoload :DependencyInjection, 'stack_commander/dependency_injection'
end
