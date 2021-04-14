# frozen_string_literal: true

# CoinItem class represents coin instance/record with methods for vending machine
class CoinItem
  # Just a naive NOTICE:
  # in origin task description says Available coins equal to:  25c 50c 1$ 2$ 5$
  # however if follow real world examples there no 2$ and 5$ coins denomination in USA http://en.wikipedia.org/wiki/Coins_of_the_United_States_dollar
  # so I accept 2$ and 5$  denominations as a coins not banknotes
  QUARTER = 0.25
  HALF = 0.50
  DOLLAR = 1
  TWO = 2
  FIVE = 5

  SYMBOLS_TO_DENOMINATIONS = {
    '25c' => QUARTER,
    '50c' => HALF,
    '1$' => DOLLAR,
    '2$' => TWO,
    '5$' => FIVE
  }.freeze

  DENOMINATIONS_TO_SYMBOLS = {
    QUARTER => '25c',
    HALF => '50c',
    DOLLAR => '1$',
    TWO => '2$',
    FIVE => '5$'
  }.freeze
  ALLOWED_COINS_DENOMINATIONS = [FIVE, TWO, DOLLAR, HALF, QUARTER].freeze
  ALLOWED_COINS_SYMBOLS = DENOMINATIONS_TO_SYMBOLS.values
  attr_accessor :name

  def self.get_denomination(coin_symbol)
    SYMBOLS_TO_DENOMINATIONS[coin_symbol]
  end

  def self.get_symbol(denomination)
    DENOMINATIONS_TO_SYMBOLS[denomination]
  end

  def initialize(name)
    unless ALLOWED_COINS_SYMBOLS.include?(name)
      raise ArgumentError, "Accepts coins only in denominations of: #{ALLOWED_COINS_SYMBOLS}"
    end

    @name = name
  end

  def denomination
    self.class.get_denomination(name)
  end
end
