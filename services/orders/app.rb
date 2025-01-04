require 'sinatra'

log = File.new("./logs/app.log", "a+") 
$stdout.reopen(log)
$stderr.reopen(log)

$stderr.sync = true
$stdout.sync = true

set :port, 3000

get '/orders/details' do
  content_type :json
  { message: "Order details service", data: { order_id: 456, item: "Laptop" } }.to_json
end
