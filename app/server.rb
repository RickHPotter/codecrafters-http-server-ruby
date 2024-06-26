# frozen_string_literal: true

require "socket"

print("Logs from your program will appear here!")

server = TCPServer.new("localhost", 4221)

# An HTTP response is made up of three parts, each separated by a CRLF (\r\n):
#
# Status line. => HTTP/1.1 200 OK
# Zero or more headers, each ending with a CRLF.
# Optional response body.

client = server.accept
client.puts "HTTP/1.1 200 OK\r\n\r\n"

client.close
