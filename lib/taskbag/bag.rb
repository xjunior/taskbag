module TaskBag
  class Bag
    def initialize(task_class)
      @tasks = []
      @task_class = task_class
    end

    def open(nthreads)
      @closed = false
      bag = self
      @threads = nthreads.times.map do |w|
        Thread.new { @task_class.new(bag).start }
      end
    end

    def add(object)
      @tasks << object
    end

    def close
      loop { break unless @tasks.any? }
      @closed = true
      @threads.each{|t| t.join}
    end

    def closed?
      !!@closed
    end

    def next
      @tasks.pop
    end
  end
end
