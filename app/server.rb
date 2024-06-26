# frozen_string_literal: true

require_relative "http_server"

DIRECTORY_PATH = ARGV[ARGV.index("--directory") + 1] if ARGV.include?("--directory")

HttpServer.new("localhost", 4221).listen
