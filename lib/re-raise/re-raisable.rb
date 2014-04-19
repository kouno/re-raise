module ReRaise
  module ReRaisable
    def self.included(klass)
      klass.class_eval do
        define_singleton_method('`') do |*args|
          Kernel.public_send(:`, *args).tap do
            ReRaise.raise_if_wrong_exit_code
          end
        end

        define_singleton_method(:system) do |*args|
          Kernel.public_send(:system, *args).tap do
            ReRaise.raise_if_wrong_exit_code
          end
        end
      end
    end
  end
end
