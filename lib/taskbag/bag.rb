require 'thread'

module TaskBag
  class Bag
    def initialize(jobs=Queue.new)
      @closed = true
      @jobs = jobs
      @threads = []
    end

    def open(nworkers)
      raise "Bag is already opened!" unless closed?
      @closed = false
      _self = self
      @threads = nworkers.times.map do
        Thread.new { Worker.start(_self) }
      end
    end

    def close!
      raise 'Bag is already closed!' if closed?
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

    def self.open(nworkers)
      Bag.new.tap {|b| b.open(nworkers)}
    end

    def nworkers
      @threads.size
    end
  end
end
