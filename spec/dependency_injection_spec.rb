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
      expect(di).to be_matching(scope)
    end

    it do
      expect(di.extract(scope)).to eq(['one value', 'two'])
    end
  end

  context 'scope does not have required methods' do
    let(:scope) { double('scope', one: true) }

    it do
      expect(di).not_to be_matching(scope)
    end

    it do
      expect{ di.extract(scope) }.to raise_error(StackCommander::DependencyInjection::InvalidScope)
    end
  end

  context 'class has configured parameters' do
    before do
      custom_class.class_variable_set :@@dependency_injection, proc { [:three, :four] }
    end

    it do
      expect(di.parameters).to eq([:three, :four])
    end

    it 'matches new scope' do
      scope = double(three: true, four: true)
      expect(di).to be_matching(scope)
    end
  end
end
