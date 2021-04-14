# frozen_string_literal: true

# ProductItem class represents product instance/record with methods for vending machine
class ProductItem
  attr_accessor :price, :name

  def initialize(name, price)
    raise ArgumentError, 'The price must be a multiple of 0.25' if price % CoinItem::QUARTER != 0

    @name = name
    @price = price
  end
end
