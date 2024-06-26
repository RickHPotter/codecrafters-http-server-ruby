# frozen_string_literal: true

require "socket"
require_relative "routes"

puts "Logs from your program will appear here!"

server = TCPServer.new("localhost", 4221)

loop do
  client = server.accept

  routes = Routes.new(request: client.recvmsg)
  paths = routes.request.paths

  response = case paths[0]
             when "/"
               routes.handle_home
             when "/echo"
               routes.handle_echo
             else
               routes.handle_not_found
             end

  client.puts response

  client.close
end
