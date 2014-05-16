module StackCommander
  module Command
    def self.included(base)
      base.extend(ClassMethods)
    end

    def call(stack)
      action
      stack.call
    rescue => exception
      recover(exception)
      raise
    ensure
      insurance
    end

    def action
    end

    def recover(exception)
    end

    def insurance
    end

    def configuration
      self.class.configuration
    end

    private

    module ClassMethods
      CONFIGURATION = :@@configuration

      def configuration
        class_variable_get(CONFIGURATION) if class_variable_defined?(CONFIGURATION)
      end

      def dependency_injection(&block)
        class_variable_set(:@@dependency_injection, block)
      end

      # Creates an anonymous subclass of current command, configured with passed value
      # then all instances of that command will have the same configuration
      def [](value)
        subclass = Class.new(self)
        subclass.class_variable_set(CONFIGURATION, value)
        subclass
      end
    end
  end
end
