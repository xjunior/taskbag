module TaskBag
  class Worker
    def initialize(bag)
      @bag = bag
    end

    def self.start(bag)
      Worker.new(bag).start
    end

    def start
      until @bag.closed?
        job = @bag.next
        (sleep(1) and next) if job.nil?

        job.run
      end
    end
  end
end