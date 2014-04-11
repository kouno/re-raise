class ReRaise
  class FalseReturned < StandardError; end

  def self.enable
    Kernel.class_eval do
      def system_with_raise(*args)
        result = system_old(*args)

        unless result
          raise FalseReturned
        end
      end

      alias_method :system_old, :system
      alias_method :system, :system_with_raise
    end
  end
end
