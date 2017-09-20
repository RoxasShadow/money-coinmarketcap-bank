money-coinmarketcap-bank
========================
CoinMarketCap frontend for ruby-money

Attach this gem to ruby-money to use it as bank and get the exchange rate from [coinmarketcap.com](http://coinmarketcap.com/).

This gem is basically a clone of [money-uphold-bank](https://github.com/subvisual/money-uphold-bank).
All the credits go to its creators.

# Usage

```rb
# Minimal requirements
require 'money/bank/coin_market_cap'

bank = Money::Bank::CoinMarketCap.new

# (optional)
# Set the number of seconds after which the rates are automatically expired.
# By default, they expire every hour
bank.ttl_in_seconds = 3600

Money.default_bank = bank
```
