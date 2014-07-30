module StackCommander
  module Command
    def call(stack)
      action
      stack.call
      cleanup
    rescue => exception
      recover(exception)
      raise
    ensure
      insurance
    end

    def cleanup
    end

    def action
    end

    def recover(exception)
    end

    def insurance
    end
  end
end
