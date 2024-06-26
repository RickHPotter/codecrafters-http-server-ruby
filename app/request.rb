# frozen_string_literal: true

class Request
  attr_reader :request,
              :request_line, :verb, :path, :http,
              :headers, :host, :port, :user_agent, :accept,
              :body

  def initialize(request)
    @request = request.first
    dissect_request
  end

  def dissect_request
    @request_line, *headers_body = request.split("\r\n")
    dissect_request_line
    dissect_headers_body(headers_body)
  end

  def dissect_request_line
    @verb, @path, @http = request_line.split(" ")
  end

  def dissect_headers_body(headers_body)
    host_port, user_agent, media_types_to_accept, *body = headers_body
    @headers = [host_port, user_agent, media_types_to_accept]
    @host, @port = host_port&.gsub("Host: ", "")&.split(":")
    @user_agent = user_agent&.gsub("User-Agent: ", "")
    @accept = media_types_to_accept&.gsub("Accept: ", "")
    @body = body
  end
end
