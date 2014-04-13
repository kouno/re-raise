class ReRaise
  class SystemExitError < StandardError
    attr_reader :exitstatus

    def initialize(exitstatus, *args)
      super(*args)
      @exitstatus = exitstatus
    end
  end

  def self.enable
    Kernel.class_eval do
      def system_with_raise(*args)
        system_old(*args).tap do
          raise_if_wrong_exit_code
        end
      end

      def backtick_with_raise(*args)
        old_backtick(*args).tap do
          raise_if_wrong_exit_code
        end
      end

      def raise_if_wrong_exit_code
        unless $?.exitstatus == 0
          raise SystemExitError, $?.exitstatus, "System error returned code (#{$?.exitstatus})"
        end
      end

      alias_method :system_old, :system
      alias_method :system, :system_with_raise

      alias_method :old_backtick, :`
      alias_method :`, :backtick_with_raise
    end
  end
end
