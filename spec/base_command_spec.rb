require 'spec_helper'
require 'stack_commander/base_command'

describe StackCommander::BaseCommand do
  it 'has command module' do
    expect(subject.class.ancestors).to include(StackCommander::Command)
  end
end
