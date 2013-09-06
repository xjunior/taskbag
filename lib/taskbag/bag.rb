require 'thread'

module TaskBag
  class Bag
    def initialize(jobs=Queue.new)
      @jobs = jobs
      @threads = []
    end

    def open(nworkers)
      @closed = false
      _self = self
      @threads = nworkers.times.map do
        Thread.new { Worker.start(_self) }
      end
    end

    def close!
      loop { break if @jobs.empty? }
      @closed = true
      @threads.each{|t| t.join}
    end

    def add(object)
      @jobs.push object
    end

    def closed?
      !!@closed
    end

    def next
      @jobs.pop unless @jobs.empty?
    end
  end
end
