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
    let(:command) { double('command').as_null_object }

    before do
      stack << command
    end

    it 'runs the commands' do
      expect(command).to receive(:call).with(stack)
      stack.call
    end

    it 'initializes the command' do
      expect(command).to receive(:new).with
      stack.call
    end
  end
end
