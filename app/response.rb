# frozen_string_literal: true

require "cgi"

class Response
  attr_reader :response,
              :response_line, :version, :status_code, :status_message,
              :headers, :content_type, :content_length,
              :body

  VERSION = "HTTP/1.1"
  STATUS_MESSAGE = { "200": "OK", "201": "Created", "404": "Not Found", "500": "Internal Server Error" }.freeze

  def initialize(status_code, body = nil, additional_headers = {})
    @version        = VERSION
    @status_code    = status_code
    @status_message = STATUS_MESSAGE[status_code.to_sym]
    @other_headers  = additional_headers
    @body           = CGI.unescape(body) if body

    generate_headers
    generate_response
  end

  def generate_headers
    @headers = []
    return unless body

    @headers << "Content-Type: #{@other_headers.fetch(:content_type, 'text/plain')}"
    @headers << "Content-Length: #{@other_headers.fetch(:content_length, body.length)}"
  end

  def generate_response
    @response_line = "#{version} #{status_code} #{status_message}"
    @response = [response_line, *headers, "\r\n#{body}"].join("\r\n")
  end
end
