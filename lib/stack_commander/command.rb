module StackCommander
  module Command
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
  end
end
