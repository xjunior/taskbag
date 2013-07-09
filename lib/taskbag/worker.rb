module TaskBag
  class Worker
    def initialize(bag)
      @bag = bag
    end

    def start
      until @bag.closed?
        task = @bag.next
        (sleep(1) and next) if task.nil?

        self.run
      end
    end

    def run; end
  end
end