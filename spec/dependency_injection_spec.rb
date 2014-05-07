require 'spec_helper'
require 'stack_commander/dependency_injection'

describe StackCommander::DependencyInjection do

  let(:custom_class) { Class.new { def initialize(one, two); end } }
  subject(:di) { StackCommander::DependencyInjection.new(custom_class) }

  it 'extracts parameter names from initializer' do
    expect(di.required_parameters).to eq([:one, :two])
  end

  context 'scope has required methods' do
    let(:scope) { double('scope', one: 'one value', two: 'two') }

    it do
      expect(di.matches?(scope)).to be
    end

    it do
      expect(di.extract(scope)).to eq(['one value', 'two'])
    end
  end

  context 'scope does not have requried methods' do
    let(:scope) { double('scope', one: true) }

    it do
      expect(di.matches?(scope)).not_to be
    end

    it do
      expect{ di.extract(scope) }.to raise_error(StackCommander::DependencyInjection::InvalidScope)
    end
  end
end
