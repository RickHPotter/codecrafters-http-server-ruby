# frozen_string_literal: true

require "cgi"
require "stringio"
require "zlib"

class Response
  attr_reader :response,
              :response_line, :version, :status_code, :status_message,
              :headers, :content_type, :content_length,
              :body

  VERSION = "HTTP/1.1"
  STATUS_MESSAGE = { "200": "OK", "201": "Created", "404": "Not Found", "500": "Internal Server Error" }.freeze
  ACCEPTED_ENCODINGS = %w[gzip].freeze

  def initialize(status_code, request_headers, body = nil, additional_headers = {})
    @version         = VERSION
    @status_code     = status_code
    @status_message  = STATUS_MESSAGE[status_code.to_sym]
    @other_headers   = additional_headers
    @body            = CGI.unescape(body) if body
    @request_headers = request_headers

    compress_body if compression?

    generate_headers
    generate_response
  end

  def generate_headers
    @headers = []
    return unless body

    @headers << "Content-Type: #{@other_headers.fetch(:content_type, 'text/plain')}"
    @headers << "Content-Length: #{@body.bytesize}"
    @headers << "Content-Encoding: #{preferred_encoding}" if compression?
  end

  def generate_response
    @response_line = "#{version} #{status_code} #{status_message}"
    @response = [response_line, *headers, "\r\n#{body}"].join("\r\n")
  end

  private

  def compression?
    @request_headers.include?(:accept_encoding)
  end

  def preferred_encoding
    ACCEPTED_ENCODINGS.find { |encoding| @request_headers[:accept_encoding].include?(encoding) }
  end

  def compress_body
    io = StringIO.new
    gzip = Zlib::GzipWriter.new(io)
    gzip.write(@body)
    gzip.close

    @body = io.string
  end
end
