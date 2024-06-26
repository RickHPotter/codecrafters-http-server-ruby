# frozen_string_literal: true

require "cgi"

class Response
  attr_reader :response,
              :response_line, :version, :status_code, :status_message,
              :headers, :content_type, :content_length,
              :body

  def initialize(version, status_code, status_message, additional_headers = {}, body = nil)
    @version        = version
    @status_code    = status_code
    @status_message = status_message
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
