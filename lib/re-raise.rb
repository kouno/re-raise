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
        result = system_old(*args)

        unless result
          raise SystemExitError, $?.exitstatus, "Sytem error returned code #{args.first}"
        end
      end

      alias_method :system_old, :system
      alias_method :system, :system_with_raise
    end
  end
end
