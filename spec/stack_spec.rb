require 'spec_helper'
require 'stack_commander/stack'

describe StackCommander::Stack do

  let(:scope) { double('scope') }
  subject(:stack) { StackCommander::Stack.new(scope) }

  it 'requires scope' do
    expect { StackCommander::Stack.new }.to raise_error(ArgumentError)
  end

  it 'enqueues commands' do
    expect(stack.size).to eq(0)
    stack << double('command')
    expect(stack.size).to eq(1)
  end

  context 'without commands' do
    it 'runs' do
      stack.call
    end
  end

  context 'with commands' do
    let(:command) { Class.new(StackCommander::BaseCommand) }

    before do
      stack << command
    end

    it 'runs the commands' do
      expect_any_instance_of(command).to receive(:call).with(stack).and_call_original
      expect_any_instance_of(command).to receive(:action)

      stack.call
    end

    it 'initializes the command' do
      # TODO: this could be responsibility of the command
      expect(stack).to receive(:initialize_command).with(command).and_call_original
      stack.call
    end

    context 'stacked' do
      let(:other_command) { Class.new(StackCommander::BaseCommand) }

      before do
        stack << other_command
      end

      it 'calls action in stack manner' do
        expect_any_instance_of(command).to receive(:action) do
          expect_any_instance_of(other_command).to receive(:action)
        end

        stack.call
      end
    end
  end
end
