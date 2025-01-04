module RouteHelper
  def route_to_service(path)
    if path.start_with?('/users')
      'http://users:3000'
    elsif path.start_with?('/orders')
      'http://orders:3000'
    else
      nil
    end
  end
end