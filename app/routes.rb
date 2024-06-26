# frozen_string_literal: true

require_relative "request"
require_relative "response"

class Routes
  attr_accessor :request

  def initialize(request:)
    @request = Request.new(request)
  end

  def handle_home
    Response.new("200").response
  end

  def handle_echo
    case [request.paths]
    in [["/echo", message]]
      Response.new("200", message).response
    else
      handle_not_found
    end
  end

  def handle_user_agent
    Response.new("200", request.user_agent).response
  end

  def handle_not_found
    Response.new("404").response
  end
end
