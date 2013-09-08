#!/usr/bin/env ruby

require 'eventmachine'

q = EM::Queue.new

EM.defer do
  10.times do |i|
    q.push("work item \##{i}")
    sleep(1)
  end
  q.push(:end)
end

EM.run do
  
  work = Proc.new do |item|
    
    # do work here
    puts item
    sleep(1)
    
    # pop the next item and 'recursively' do work on it
    if item != :end
      EM.next_tick { q.pop( &work ) }
    else
      puts "no more work! exiting"
      EM.stop
    end
  end
  
  q.pop(&work)
  
end