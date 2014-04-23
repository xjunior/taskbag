require 'spec_helper'

describe TaskBag::Bag do
  let(:mocked_queue) { double('mocked queue', empty?: true) }
  subject { TaskBag::Bag.new }

  it { should be_closed }

  describe '.open' do
    subject { TaskBag::Bag.open(5) }

    it { should_not be_closed }

    it 'is opened with the given number of workers' do
      subject.nworkers.should == 5
    end
  end

  describe 'opening a bag' do
    it 'makes the bag open' do
      subject.open 0
      subject.should_not be_closed
      subject.close!
    end

    it 'raises an exception if already open' do
      subject.open 0
      expect { subject.open(0) }.to raise_error
    end

    it 'creates the given number of workers in different threads' do
      TaskBag::Worker.should_receive(:start)
                     .with(subject)
                     .exactly(3).times
                     .and_return 1, 2, 3

      subject.open(3).should have(3).items
      subject.close!
    end

    it 'is opened with the given number of workers' do
      subject.open 10
      subject.nworkers.should == 10
    end
  end

  describe 'closing a bag' do
    subject { TaskBag::Bag.new(mocked_queue) }

    it 'should be closed after' do
      mocked_queue.should_receive(:empty?).and_return true
      subject.open 0
      subject.close!
      subject.should be_closed
    end

    it 'raises an exception if already closed' do
      expect { subject.close! }.to raise_error
    end

    it 'waits for all jobs to be passed to workers before closing' do
      mocked_queue.should_receive(:empty?).and_return false, false, true
      subject.open 0
      subject.close!
    end

    context 'a full bag' do
      subject { TaskBag::Bag.new }
      it 'waits for every worker to finish before it closes' do
        finished = 0
        job = double('job')
        job.stub :run do
          sleep 0.5
          finished += 1
        end
        subject.open 2
        subject.add job
        subject.add job
        subject.add job
        subject.close!
        finished.should == 3
      end
    end
  end

  it 'execute the jobs in a FIFO fashion' do
    subject.add 1
    subject.add 2

    subject.next.should be 1
    subject.next.should be 2
    subject.next.should be_nil
  end
end
