require 'spec_helper'

describe ReRaise do
  context 'when it is enabled' do
    before(:all) do
      ReRaise.enable
    end

    it 'can be re-enabled safely' do
      pending
    end

    it 'overwrites backtick (`command`)' do
      pending
    end

    context 'when the program returns false' do
      it 'raises an exception' do
        expect { system('false') }.to raise_error
      end
    end

    context 'when the program have a non-zero exit code' do
      it 'raises an exception' do
        expect { system('exit 1') }.to raise_error
      end

      it 'contains the error code' do
        begin
          system('exit 12')
        rescue ReRaise::SystemExitError => e
          expect(e.exitstatus).to eq(12)
        end
      end
    end
  end
end
