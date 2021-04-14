# frozen_string_literal: true

require_relative 'lib/vending_machine'

# Simple Factory class to create Example of Vending Machine usage, this can be extended to create instance of
# different types of vending machines.
class VendingMachineFactory
  attr_reader :machine

  def initialize
    @machine = VendingMachine.new
  end

  def add_product
    @soda = ProductItem.new('Soda', 0.25)
    @snickers = ProductItem.new('Snickers', 2.25)
    @cola = ProductItem.new('Snickers', 1.50)
    @cookie = ProductItem.new('Cookie', 4.75)
    goods = [[@soda, 1], [@snickers, 3], [@cola, 4], [@cookie, 1]]

    machine.initialize_item_inventories(goods)
  end

  def add_coins
    @quarter = CoinItem.new('25c')
    @half = CoinItem.new('50c')
    @dollar = CoinItem.new('1$')
    @two = CoinItem.new('2$')
    @five = CoinItem.new('5$')

    coins = [[@quarter, 1], [@half, 0], [@dollar, 0], [@two, 0], [@five, 0]]
    machine.initialize_coin_inventories(coins)
  end

  def put_coin_five
    machine.insert_coin(@five)
    machine.insert_coin(@five)
  end

  def buy_cookie
    machine.select_item_and_get_price(@cookie)
  end

  def return_item_and_rest
    machine.collect_item_and_change
  end
end

# i = VendingMachineFactory.new
# i.add_product
# i.add_coins
# i.put_coin_five
# i.buy_cookie
# i.return_item_and_rest
