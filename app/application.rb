require 'pry'

class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = ["Go Pro 8", "Nike 270", "Tesla Model 3"]

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end

    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)

    elsif req.path.match(/cart/)
      if @@cart.size > 0
        @@cart.each do |cart_item|
          resp.write "#{cart_item}\n"
        end
      else
        resp.write "Your cart is empty"
      end

    elsif req.path.match(/add/)
      item = req.params["item"]
      resp.write handle_item(item)

    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end

  def handle_item(added_item)
    if @@items.include?(added_item)
      @@cart << added_item
      return "added #{added_item}"
    else
      return "We don't have that item"
    end
  end
end
