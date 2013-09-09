#!/usr/bin/env ruby

require 'eventmachine'

c = EM::Channel.new

EM.defer do
  # first, subscribe to the channel; print every message received
  sid = c.subscribe { |m| puts "thread 1, sid: #{sid} got message #{m}" }
  # then go to sleep for 10
  puts "thread 1 subscribed an now snoozing for 10\n"
  sleep(10)
  # now, send your own message back
  c << "thread 1: yawn"
end
    
EM.defer do
  sid = c.subscribe do |m|
    puts "thread 2, sid: #{sid} got message #{m}"
    sleep(20)
    puts "thread 2 slept INSIDE the message handler"
  end
  puts "thread 2 subscribed and now snoozing for 5\n"
  sleep(5)
  c << "thread 2: yawn"
end

EM.run do
  EM.add_periodic_timer(1) do
    c << 'ping'
  end
end
  