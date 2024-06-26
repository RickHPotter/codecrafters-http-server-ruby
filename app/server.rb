# frozen_string_literal: true

require "socket"
require_relative "request"
require_relative "response"

puts "Logs from your program will appear here!"

server = TCPServer.new("localhost", 4221)

loop do
  client = server.accept
  request = Request.new(client.recvmsg)

  response = case request.paths[0]
             when ""
               Response.new(request.version, "200", "OK").response
             when "echo"
               Response.new(request.version, "200", "OK", {}, request.paths[1]).response
             else
               Response.new(request.version, "404", "Not Found").response
             end

  client.puts response

  client.close
end
