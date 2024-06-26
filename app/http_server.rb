# frozen_string_literal: true

require "socket"
require_relative "routes"

class HttpServer
  attr_reader :host, :port

  def initialize(host, port)
    @host = host
    @port = port
  end

  def listen
    server = TCPServer.new(host, port)
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
                 in ["GET", "/files"]
                   routes.handle_files
                 else
                   routes.handle_not_found
                 end

      client.puts response

      client.close
    end
  end
end
