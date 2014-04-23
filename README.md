# TaskBag
[![Gem Version](https://badge.fury.io/rb/taskbag.png)](http://badge.fury.io/rb/taskbag)
[![Build Status](https://travis-ci.org/xjunior/taskbag.svg?branch=master)](https://travis-ci.org/xjunior/taskbag)

A super simple implementation of the Bag-of-Tasks Paradigm [1].

This gem was originally created to scrap websites and download content in a parallel fashion.

## Installation

Add this line to your application's Gemfile:

    gem 'taskbag'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install taskbag

## Usage

### When to use it

You have [2]:
* A bunch of tasks to do
* They are all independent
* Similar, maybe just different input files

In TaskBag you can actually have different tasks in the same bag.

### When not to use it

If you're not in the above situation.

### How to use it

Define your job class:

```
class DownloadVideoJob < Struct.new(:video_url)
  def run
  	`wget -c #{self.video_url}`
  end
end
```

create your bag and open it with a number of workers:

```
bag = TaskBag::Bag.new
bag.open 4
```

add your tasks however you want (maybe from another worker):

```
bag.add DownloadVideoJob.new('http://www.sometube.com/video.mp4')
```

don't *ever* forget to close the bag, or your application might finish before all the jobs are run:

```
bag.close!
```

As said before, you can add more tasks as the result of a job, for example, if you're writting a page scrapper, you can initiate your taskbag with only one job to scrap the index page, which will create other jobs to scrap each of the pages and find more jobs. The number of workers will never change unless you close and open your bag again.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## References

[1] http://www.cs.arizona.edu/~greg/mpdbook/glossary.html

[2] http://www.eead.csic.es/compbio/material/programacion_rocks/pics/paral_tareas.pdf
