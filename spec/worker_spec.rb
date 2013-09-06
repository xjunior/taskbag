require 'spec_helper'

describe TaskBag::Worker do
	let(:bag) { double('Bag')}
	subject { TaskBag::Worker.new(bag) }

	it 'runs tasks until bag is closed' do
		job1, job2 = double('job 1'), double('job 2')
		job1.should_receive(:run).with no_args
		job2.should_receive(:run).with no_args
		bag.should_receive(:closed?).and_return false, false, true
		bag.should_receive(:next).and_return job1, job2

		subject.start
	end

	it 'worker keep asking for jobs every second' do
		job = double('job')
		job.should_receive(:run).with no_args
		bag.should_receive(:closed?).and_return false, false, true
		bag.should_receive(:next).and_return nil, job

		subject.should_receive(:sleep).with(1).and_return true

		subject.start
	end
end