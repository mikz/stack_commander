module StackCommander
  class DependencyInjection
    InvalidScope = Class.new(StandardError)

    def initialize(klass)
      @klass = klass
    end

    def initialize_parameters
      @klass.instance_method(:initialize).parameters
    end

    def required_parameters
      _, parameters = initialize_parameters.transpose
      Array(parameters)
    end

    def matches?(scope)
      required_parameters.all? do |param|
        scope.respond_to?(param)
      end
    end

    def extract(scope)
      raise InvalidScope, scope unless matches?(scope)

      required_parameters.map do |param|
        scope.public_send(param)
      end
    end
  end
end
