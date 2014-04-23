require 'spec_helper'

describe TaskBag do
  let(:bag) { double('task bag') }
  around {|example| TaskBag.work(10, &example)}

  describe '.work' do
    it 'opens a bag with the given number of workers' do
      allow(bag).to receive(:close!)
      expect(TaskBag::Bag).to receive(:open).with(10) { bag }

      TaskBag.work(10) do |b|
        expect(b).to be bag
      end
    end

    it 'closes the bag after it is done with the given block' do
      allow(TaskBag::Bag).to receive(:open).and_return(bag)
      TaskBag.work(10) do |b|
        # This will guarantee that the close! method will only
        # be called after this block is completed
        expect(bag).to receive(:close!)
      end
    end
  end
end
