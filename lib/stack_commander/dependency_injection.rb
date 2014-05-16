module StackCommander
  class DependencyInjection
    InvalidScope = Class.new(StandardError)

    CVAR = :@@dependency_injection

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

    def configured_parameters
      parameters = @klass.class_variable_defined?(CVAR) && @klass.class_variable_get(CVAR)
      parameters && parameters.respond_to?(:[]) ? parameters[:initialize] : parameters
    end

    def parameters
      configured_parameters || required_parameters
    end

    def matching?(scope)
      parameters.all? do |param|
        scope.respond_to?(param)
      end
    end

    def match!(scope)
      raise InvalidScope, scope unless matching?(scope)
    end

    def extract(scope)
      match!(scope)

      required_parameters.map do |param|
        scope.public_send(param)
      end
    end
  end
end
