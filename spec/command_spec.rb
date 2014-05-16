require 'spec_helper'
require 'stack_commander/command'

describe StackCommander::Command do
  expect_it { to be_a(Module) }

  expect_it { to_not be_a(Class) }

  context 'object including command' do
    subject(:command) { Class.new{ include StackCommander::Command }.new }

    expect_it { to respond_to(:action) }
    expect_it { to respond_to(:insurance) }
    expect_it { to respond_to(:recover).with(1).argument }


    let(:stack) { double('stack').as_null_object }

    it 'calls action' do
      expect(subject).to receive(:action)
      subject.call(stack)
    end

    it 'calls stack' do
      expect(stack).to receive(:call)
      subject.call(stack)
    end

    it 'calls insurance' do
      expect(subject).to receive(:insurance)
      subject.call(stack)
    end

    it 'does not call recover' do
      expect(subject).not_to receive(:recover)
      subject.call(stack)
    end

    context 'exception is raised' do

      before do
        expect(stack).to receive(:call).and_raise(StandardError)
      end

      it 'still calls insurance' do
        expect(subject).to receive(:insurance)
        expect { subject.call(stack) }.to raise_error(StandardError)
      end

      it 'calls recover' do
        expect(subject).to receive(:recover).with(an_instance_of(StandardError))
        expect{ subject.call(stack) }.to raise_error(StandardError)
      end
    end
  end

  context 'classes including command' do
    subject(:command) { Class.new{ include StackCommander::Command } }

    before do
      stub_const('TestCommand', command)
    end

    it 'has name' do
      expect(command.to_s).to eq('TestCommand')
    end

    it 'has configuration' do
      expect(command.configuration).to be_nil
    end

    context 'with config' do
      subject(:configured_command) { command[:test] }

      expect_it { to be }

      it 'does not have a name' do
        expect(configured_command.to_s).not_to eq('TestCommand')
      end

      it 'has configuration' do
        expect(configured_command.configuration).to eq(:test)
      end

      context 'an instance' do
        subject(:instance) { configured_command.new }

        it 'has configuration' do
          expect(instance.configuration).to eq(:test)
        end
      end
    end
  end
end
