# frozen_string_literal: true

# Inventory class represents base storage instance/structure with methods for vending machine
class Inventory
  attr_accessor :inventory

  def initialize
    @inventory = {}
  end

  def get_quantity(item_name)
    @inventory[item_name].quantity
  end

  def add(item_name)
    @inventory[item_name].quantity += 1
  end

  def deduct(item_name)
    @inventory[item_name].quantity -= 1
  end

  def item_present?(item_name)
    @inventory[item_name].quantity.positive?
  end

  def clear
    @inventory.each_key do |item|
      @inventory[item] = 0
      # or self.inventory = {}
    end
  end

  def put(item, quantity)
    @inventory[item.name] = inventory_item.new(item: item, quantity: quantity)
  end

  def available_inventory
    @inventory.each_with_object({}) do |(k, v), a|
      a[k] = v if v.quantity.positive?
    end
  end

  private

  def inventory_item
    Struct.new(:item, :quantity, keyword_init: true)
  end
end
