require_relative './lib/api_gateway'

log = File.new("./logs/app.log", "a+") 
$stdout.reopen(log)
$stderr.reopen(log)

$stderr.sync = true
$stdout.sync = true

if __FILE__ == $0
  APIGateway.new.start  
end