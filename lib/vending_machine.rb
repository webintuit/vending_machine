# frozen_string_literal: true

require_relative 'inventory'
require_relative 'product_item'
require_relative 'coin_item'

require 'pry-byebug'

class VendingMachineError < StandardError; end

# Basic vending machine instance with methods
# rubocop:disable Metrics/ClassLength
class VendingMachine
  attr_accessor :cash_inventory, :current_balance, :total_sales, :current_item, :item_inventory

  def initialize
    @item_inventory = Inventory.new
    @cash_inventory = Inventory.new
    @total_sales = 0
    @current_balance = 0
    @current_item = nil
  end

  def initialize_item_inventories(product_items = [])
    product_items.each do |(item, quantity)|
      @item_inventory.put(item, quantity)
    end
  end

  def initialize_coin_inventories(coin_items = [])
    coin_items.each do |(item, quantity)|
      @cash_inventory.put(item, quantity)
    end
  end

  def insert_coin(coin)
    @current_balance += coin.denomination
    @cash_inventory.add(coin.name)
    @current_balance
  end

  def select_item_and_get_price(item)
    unless @current_balance.positive?
      raise VendingMachineError, 'Insert corresponding amount of coins before choose product'
    end

    if @item_inventory.item_present?(item.name)
      @current_item = item
      return @current_item.price
    end
    "#{item.name} Sold Out , Please buy another item or proceed for get coins back"
  end

  def collect_item_and_change
    change = if @current_item && collect_item
               item = @current_item
               @total_sales += @current_item.price
               collect_change
             else
               change = get_change(@current_balance)
               update_cash_inventory(change)
             end
    count_change = count_change(change)
    [item&.name, print_change(count_change)]
  end

  private

  def collect_item
    raise VendingMachineError, 'Insert corresponding amount of coins before choose product' unless full_paid?

    if sufficient_change?
      @item_inventory.deduct(@current_item.name)
      return @current_item
    end

    puts 'Not Sufficient change available'

    @current_item = nil
  end

  def sufficient_change?
    change_amt = @current_balance - @current_item.price
    return true if cash_inventory_amount_total >= change_amt

    false
  end

  def cash_inventory_amount_by_coin
    @cash_inventory.available_inventory.map { |(i, v)| [CoinItem.get_denomination(i), v.quantity] }
  end

  def cash_inventory_amount_total
    cash_inventory_amount_by_coin.inject(0) { |acc, (nominal, quantity)| acc + (nominal * quantity) }
  end

  def full_paid?
    @current_balance >= @current_item.price
  end

  def collect_change
    change_amt = @current_balance - @current_item.price
    change = if change_amt <= cash_inventory_amount_total
               get_change(change_amt)
             else
               get_change(@current_balance)
             end
    update_cash_inventory(change)
    @current_balance = 0
    @current_item = nil
    change
  end

  # rubocop:disable Metrics/MethodLength

  def get_change(amount)
    available_coins = cash_inventory_amount_by_coin.map { |(c, q)| c if q.positive? }.compact.reverse
    allowed_coins = CoinItem::ALLOWED_COINS_DENOMINATIONS & available_coins
    coins = []
    index = 0
    coin = allowed_coins[index]
    remaining_amount = amount
    until remaining_amount.zero?
      until remaining_amount >= coin
        index += 1
        coin = allowed_coins[index]
      end
      # uncomment line below for output changing process
      # puts "Amount: #{remaining_amount} | Coin: #{coin}"
      coins << coin
      remaining_amount -= coin
    end
    coins
  end

  # rubocop:enable Metrics/MethodLength

  def update_cash_inventory(change)
    change.each do |c|
      coin_name = CoinItem.get_symbol(c)
      @cash_inventory.deduct(coin_name)
    end
  end

  def count_change(change)
    change.each_with_object(Hash.new(0)) { |i, acc| acc[CoinItem.get_symbol(i)] += 1 }
  end

  def print_change(counted_change)
    counted_change.map { |(k, v)| "coin #{k} * count #{v}" }
  end
end
# rubocop:enable Metrics/ClassLength
