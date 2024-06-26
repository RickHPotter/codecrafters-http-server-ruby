# frozen_string_literal: true

require "socket"
require_relative "routes"

puts "Logs from your program will appear here!"

server = TCPServer.new("localhost", 4221)

loop do
  client = server.accept

  routes = Routes.new(request: client.recvmsg)
  paths = routes.request.paths
  verb = routes.request.verb

  response = case [verb, paths[0]]
             in ["GET", "/"]
               routes.handle_home
             in ["GET", "/echo"]
               routes.handle_echo
             in ["GET", "/user-agent"]
               routes.handle_user_agent
             else
               routes.handle_not_found
             end

  client.puts response

  client.close
end
