#!/usr/bin/env ruby

require 'eventmachine'

EM.run do
  q = EM::Queue.new
  q.push(:one, :two) # push two items, which will be available immediately
  
  # request 10 pops; if there are no items, requested pop will be invoked with
  # a callback once the item is available
  10.times { q.pop { |item|
    if item == :end
      puts 'bye!'
      EM.stop
    else
      puts item 
    end
    } 
  }
  
  EM.defer do
    q.push(:three) # there are 8 pops waiting; one will grab this element right away
    sleep(1)
    q.push(:four)
    sleep(1)
    q.push(:five)
    sleep(1)
    q.push(:six)
    sleep(1)
    q.push(:seven)
    sleep(1)
    q.push(:end)
  end
end