require "money"
require "money/bank/variable_exchange"
require "open-uri"
require "json"

class Money
  module Bank
    class CoinMarketCap < Money::Bank::VariableExchange
      BASE_CURRENCY = "BTC".freeze
      EXCHANGE_URL = "http://coinmarketcap.northpole.ro/api/v5/all.json".freeze

      # Seconds after which the current rates are automatically expired
      attr_accessor :ttl_in_seconds

      # List of currencies
      attr_reader :currencies_list

      # Rates expiration time
      attr_reader :rates_expire_at

      def initialize(*args, &block)
        super

        self.ttl_in_seconds = 3600 # 1 hour
      end

      def update_rates
        store.each_rate do |iso_from, iso_to, _rate|
          add_rate(iso_from, iso_to, nil)
        end

        @currencies_list = []

        add_exchange_rates
      end

      alias original_get_rate get_rate

      def get_rate(iso_from, iso_to, opts = {})
        update_rates_if_expired

        super || get_indirect_rate(iso_from, iso_to, opts)
      end

      private

      def get_indirect_rate(iso_from, iso_to, opts = {})
        return 1 if Money::Currency.wrap(iso_from).iso_code == Money::Currency.wrap(iso_to).iso_code

        rate_to_base = original_get_rate(iso_from, BASE_CURRENCY, opts)
        rate_from_base = original_get_rate(BASE_CURRENCY, iso_to, opts)

        return unless rate_to_base && rate_from_base

        rate = rate_to_base * rate_from_base

        add_rate(iso_from, iso_to, rate)
        add_rate(iso_to, iso_from, 1.0 / rate)

        rate
      end

      def currencies
        response = open(EXCHANGE_URL).read
        @coins = JSON.parse(response)['markets']
        @rates_expire_at = Time.now + ttl_in_seconds
        @coins
      end

      def add_exchange_rates
        currencies.each do |currency|
          next if currency['availableSupplyNumber'] == 0

          iso_from = currency['symbol']
          @currencies_list << iso_from

          currency['price'].each do |iso_to, rate|
            iso_to = iso_to.upcase
            next unless Money::Currency.find(iso_from) && Money::Currency.find(iso_to)

            add_rate(iso_from, iso_to, rate)
            add_rate(iso_to, iso_from, 1.0 / rate)
          end
        end
      end

      def update_rates_if_expired
        update_rates if rates_expired?
      end

      def rates_expired?
        return true unless rates_expire_at

        rates_expire_at <= Time.now
      end
    end
  end
end
