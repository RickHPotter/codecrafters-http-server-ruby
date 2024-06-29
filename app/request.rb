# frozen_string_literal: true

class Request
  attr_reader :request,
              :request_line, :verb, :path, :paths, :params, :version,
              :headers, :host, :port, :user_agent, :accept,
              :body

  def initialize(request)
    @request = request.first
    return if @request.nil?

    dissect_request
  end

  def dissect_request
    altered_request, @body = request.split("\r\n\r\n")

    @request_line, *array_of_headers = altered_request.split("\r\n")
    @verb, @path, @version = request_line.split(" ")

    dissect_headers(array_of_headers)
    dissect_path
  end

  def dissect_headers(array_of_headers)
    @full_host, array_of_headers  = array_of_headers.partition { |header| header.start_with?("Host: ") }
    @user_agent, array_of_headers = array_of_headers.partition { |header| header.start_with?("User-Agent: ") }
    @accept, array_of_headers     = array_of_headers.partition { |header| header.start_with?("Accept: ") }
    @accept_encoding, leftovers   = array_of_headers.partition { |header| header.start_with?("Accept-Encoding: ") }

    @headers = {
      host: trim_header(@full_host),
      user_agent: trim_header(@user_agent),
      accept: trim_header(@accept),
      accept_encoding: trim_header(@accept_encoding),
      leftovers:
    }.compact

    @host, @port = @headers[:host].split(":")
    @user_agent  = @headers[:user_agent]
    @accept      = @headers[:accept]
  end

  def dissect_path
    @path = @path[..-1] if @path.end_with?("/")
    @path, @params = @path.split("?")
    @paths = @path[1..].split("/")
    @paths[0] = "/#{@paths[0]}"
  end

  def trim_header(header)
    header&.first&.split(": ")&.drop(1)&.join(":")
  end
end
