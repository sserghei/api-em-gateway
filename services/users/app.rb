require 'sinatra'

log = File.new("./logs/app.log", "a+") 
$stdout.reopen(log)
$stderr.reopen(log)

$stderr.sync = true
$stdout.sync = true

set :port, 3000

get '/users/info' do
  content_type :json
  { message: "User info service", data: { user_id: 123, name: "John Doe" } }.to_json
end