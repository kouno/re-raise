require 're-raise/re-raisable'

module ReRaise
  class SystemExitError < StandardError
    attr_reader :exitstatus

    def initialize(exitstatus, *args)
      super(*args)
      @exitstatus = exitstatus
    end
  end

  def self.raise_if_wrong_exit_code
    unless $?.exitstatus == 0
      raise SystemExitError, $?.exitstatus, "System error returned code (#{$?.exitstatus})"
    end
  end

  def self.enable
    Kernel.class_eval do
      unless respond_to?(:system_with_raise)
        def system_with_raise(*args)
          system_old(*args).tap do
            ReRaise.raise_if_wrong_exit_code
          end
        end

        alias_method :system_old, :system
        alias_method :system, :system_with_raise
      end

      unless respond_to?(:backtick_with_raise)
        def backtick_with_raise(*args)
          old_backtick(*args).tap do
            ReRaise.raise_if_wrong_exit_code
          end
        end

        alias_method :old_backtick, :`
        alias_method :`, :backtick_with_raise
      end
    end
  end

  def self.disable
    Kernel.class_eval do
      if respond_to?(:system_old, true)
        alias_method :system, :system_old
        remove_method(:system_old)
      end

      if respond_to?(:system_with_raise, true)
        remove_method(:system_with_raise)
      end

      if respond_to?(:old_backtick, true)
        alias_method :`, :old_backtick
        remove_method(:old_backtick)
      end

      if respond_to?(:backtick_with_raise, true)
        remove_method(:backtick_with_raise)
      end
    end
  end
end
