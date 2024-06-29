# frozen_string_literal: true

require_relative "request"
require_relative "response"

class Routes
  attr_accessor :request, :request_headers

  def initialize(request:)
    @request = Request.new(request)
    @request_headers = @request.headers
  end

  def handle_home
    Response.new("200", request_headers).response
  end

  def handle_echo
    case [request.paths]
    in [["/echo", message]]
      Response.new("200", request_headers, message).response
    else
      handle_not_found
    end
  end

  def handle_user_agent
    Response.new("200", request_headers, request.user_agent).response
  end

  def handle_files
    case [request.paths]
    in [["/files", filename]]
      file = File.join(DIRECTORY_PATH, filename)
      content = File.read(file) if File.file?(file)
      return handle_not_found if content.nil?

      Response.new("200", request_headers, content, { content_type: "application/octet-stream" }).response
    else
      handle_not_found
    end
  end

  def handle_files_creation
    case [request.paths]
    in [["/files", filename]]
      file = File.join(DIRECTORY_PATH, filename)
      File.open(file, "w") { |f| f.write(request.body) }

      Response.new("201", request_headers).response
    else
      handle_not_found
    end
  end

  def handle_not_found
    Response.new("404", request_headers).response
  end
end
