require 'bitcoin'
Bitcoin::network = :regtest

require 'pry'

priv = Bitcoin::Key.from_base58('cRwUogvobfV3nuH9svycYfqXcwQn1cNtNGRF8cfm6fTU13XdWhd3')
puts priv.pub