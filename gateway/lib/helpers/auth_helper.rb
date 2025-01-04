module AuthHelper
  def authenticate(headers, auth_token, &block)
    token = headers['Authorization']&.split(' ')&.last
    block.call(token != auth_token)
  end
end