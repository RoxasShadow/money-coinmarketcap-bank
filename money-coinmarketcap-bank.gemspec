Gem::Specification.new { |s|
  s.name          = 'money-coinmarketcap-bank'
  s.version       = '0.1.1'
  s.author        = 'Giovanni Capuano'
  s.email         = 'webmaster@giovannicapuano.net'
  s.homepage      = 'https://github.com/RoxasShadow'
  s.summary       = 'CoinMarketCap frontend for ruby-money'
  s.description   = 'Attach this gem to ruby-money to use it as bank and get the exchange rate from coinmarketcap.com'
  s.licenses      = 'WTFPL'

  s.files = `git ls-files`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'money', '~> 6.9'

  s.add_development_dependency 'rake', '~> 12.0'
}
