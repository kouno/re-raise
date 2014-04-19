require 'spec_helper'

describe ReRaise::ReRaisable do
  context 'when included on a class' do
    let(:reraisable_class) do
      Class.new do
        include ReRaise::ReRaisable

        def self.class_level_exit
          `exit 1`
        end

        def instance_level_exit
          `exit 1`
        end
      end
    end

    it 'overrides all system calls within that class' do
      expect { reraisable_class.class_level_exit }.to raise_error(ReRaise::SystemExitError)
    end

    it 'overrides all system calls within instances of that class' do
      expect { reraisable_class.class_level_exit }.to raise_error(ReRaise::SystemExitError)
    end
  end
end
