# frozen_string_literal: true

require "socket"
require_relative "request"

puts "Logs from your program will appear here!"

server = TCPServer.new("localhost", 4221)

loop do
  client = server.accept
  request = Request.new(client.recvmsg)

  response = case request.path
             when "/"
               "HTTP/1.1 200 OK\r\n\r\n"
             else
               "HTTP/1.1 404 Not Found\r\n\r\n"
             end

  client.puts response

  client.close
end
