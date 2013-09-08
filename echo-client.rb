#!/usr/bin/env ruby

require 'eventmachine'

class EchoClient < EM::Connection

  def initialize(user)
    @user = user
    puts "initialized; user is: #{@user}"
  end

  def post_init
    puts "connection to server established"
    msg = "Hello from #{@user}"
    puts "sending data: '#{msg}'"
    send_data msg
  end

  def unbind
    puts "disconnecting"
    EM.stop
  end

  def receive_data( data )
    puts "got #{data} from the server; closing the connection"
    close_connection
    # EM.stop # ends the reactor loop
  end
end

EM.run do
  EM.connect('localhost', 9000, EchoClient, ARGV[0])
end

