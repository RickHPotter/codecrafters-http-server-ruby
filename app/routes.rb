# frozen_string_literal: true

require_relative "request"
require_relative "response"

class Routes
  attr_accessor :request

  def initialize(request:)
    @request = Request.new(request)
  end

  def handle_home
    Response.new(request.version, "200", "OK").response
  end

  def handle_echo
    case request.paths[1..].length
    when 1
      Response.new(request.version, "200", "OK", {}, request.paths[1]).response
    else
      handle_not_found
    end
  end

  def handle_not_found
    Response.new(request.version, "404", "Not Found").response
  end
end
