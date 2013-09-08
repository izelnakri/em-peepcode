#!/usr/bin/env ruby

require 'rubygems'
require 'eventmachine'

class EchoServer < EM::Connection
  def post_init
    puts "connection established! nothing else happened yet."
    puts "This is a good place to set up instance variables, or do other kinds of initialization"
  end

  def receive_data( data )
    puts "received #{data}"
    send_data ">> #{data}"
  end

  def unbind
    puts "connection is being terminated!"
    puts "maybe release resources, or something"
  end
end

EM.run do
  EM.start_server('0.0.0.0', 9000, EchoServer)
  puts "alexakarpov's EchoServer running on port 9000"
end

