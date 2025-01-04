require 'eventmachine'
require 'em-http-request'
require 'em-hiredis'
require 'json'
require 'logger'
require_relative './connection_handler'
require_relative './helpers/auth_helper'
require_relative './helpers/cache_helper'
require_relative './helpers/route_helper'

class APIGateway
  AUTH_TOKEN = 'secret-token'
  CACHE_TTL = 60

  include AuthHelper
  include CacheHelper
  include RouteHelper

  def initialize
    @logger = Logger.new("./logs/app.log")
    @logger.level = "DEBUG"
  end

  def start
    @logger.info('API Gateway is starting...')

    EM.run do
      @redis = EM::Hiredis.connect('redis://redis:6379')
      EM.start_server('0.0.0.0', 8080, ConnectionHandler, self)
      puts 'API Gateway started on port 8080'
    end
  end

  def handle_request(env, &block)
    path = env[:path]
    headers = env[:headers]
    authenticate(headers, AUTH_TOKEN) do |auth_error|
      if auth_error
        block.call(401, { error: 'Unauthorized' }.to_json)
      else
        cached_response(path) do |cached|
          if cached
            block.call(200, cached)
          else
            forward_request(env) do |status, response|
              cache_response(path, response, CACHE_TTL) if status == 200
              block.call(status, response)
            end
          end
        end
      end
    end
  end

  private

  def forward_request(env, &block)
    service_url = route_to_service(env[:path])

    if service_url
      http = EM::HttpRequest.new("#{service_url}#{env[:path]}").get
      http.callback { block.call(http.response_header.status, http.response) }
      http.errback { block.call(500, { error: 'Service unavailable' }.to_json) }
    else
      block.call(404, { error: 'Not found' }.to_json)
    end
  end
end