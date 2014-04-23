require 'taskbag/bag'
require 'taskbag/worker'
require 'taskbag/version'

module TaskBag
  def self.work(nworkers)
    bag = Bag.open(nworkers)
    yield bag
    bag.close!
  end
end
