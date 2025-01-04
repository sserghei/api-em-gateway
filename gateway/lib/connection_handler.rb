class ConnectionHandler < EM::Connection
  def initialize(gateway)
    @gateway = gateway
  end

  def receive_data(data)
    env = parse_request(data)
    @gateway.handle_request(env) do |status, response|
      send_data(build_response(status, response))
      close_connection_after_writing
    end
  end

  private

  def parse_request(data)
    headers, body = data.split("\r\n\r\n", 2)
    first_line, *header_lines = headers.split("\r\n")
    method, path, _ = first_line.split(' ')
    headers = header_lines.map { |h| h.split(': ', 2) }.to_h
    { method: method, path: path, headers: headers, body: body }
  end

  def build_response(status, body)
    <<~HTTP
      HTTP/1.1 #{status}
      Content-Type: application/json
      Content-Length: #{body.bytesize}

      #{body}
    HTTP
  end
end