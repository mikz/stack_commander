require 'spec_helper'
require 'stack_commander/command'

describe StackCommander::Command do
  expect_it { to be_a(Module) }

  expect_it { to_not be_a(Class) }

  context 'object including command' do
    subject(:command) { Class.new{ include StackCommander::Command }.new }

    expect_it { to respond_to(:action) }
    expect_it { to respond_to(:insurance) }
    expect_it { to respond_to(:cleanup) }
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

    it 'calls cleanup' do
      expect(subject).to receive(:cleanup)
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

      it 'does not call cleanup' do
        expect(subject).not_to receive(:cleanup)
        expect{ subject.call(stack) }.to raise_error(StandardError)
      end
    end
  end
end
