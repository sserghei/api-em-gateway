module CacheHelper
  def cached_response(key, &block)
    @redis.get(key).callback do |cached|
      block.call(cached)
    end
  end

  def cache_response(key, value, cache_ttl)
    @redis.setex(key, cache_ttl, value)
  end
end