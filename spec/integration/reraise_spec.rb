require 'spec_helper'

describe ReRaise do
  shared_examples 'a system command' do
    context 'when the program returns false' do
      it 'raises an exception' do
        expect { subject.call('false') }.to raise_error
      end
    end

    context 'when the program have a non-zero exit code' do
      it 'raises an exception' do
        expect { subject.call('exit 1') }.to raise_error
      end

      it 'contains the error code' do
        begin
          subject.call('exit 12')
        rescue ReRaise::SystemExitError => e
          expect(e.exitstatus).to eq(12)
        end
      end
    end
  end

  context 'when it is enabled' do
    before(:all) do
      ReRaise.enable
    end

    describe 'Kernel::system' do
      subject do
        Proc.new { |*args| system(*args) }
      end

      it_behaves_like 'a system command'
    end

    describe 'Kernel::`' do
      subject do
        Proc.new { |*args| `#{args.join('')}` }
      end

      it_behaves_like 'a system command'
    end
  end

  context 'when switched ON multiple times' do
    before do
      3.times { ReRaise.enable }
    end

    describe 'Kernel::system' do
      subject do
        Proc.new { |*args| system(*args) }
      end

      it_behaves_like 'a system command'
    end

    describe 'Kernel::`' do
      subject do
        Proc.new { |*args| `#{args.join('')}` }
      end

      it_behaves_like 'a system command'
    end
  end

  context 'when switched OFF' do
    before do
      ReRaise.enable
      ReRaise.disable
    end

    it 'has Kernel default behavior' do
      expect { system('exit 1') }.to_not raise_error
    end
  end
end
