

require 'bitcoin'
Bitcoin.network = :testnet3

# require './tx_componet/vin'
# require './tx_componet/vout'

class Funding_tx

  def initialize(accounts_data)
    @accounts = accounts_data
    @vin_array=[]
    @vout_array=[]
  end

  def create()
    for account in @accounts do
      vin = Vin.new()
      vout = Vout.new()
      
      @vin_array.push(vin)
      @vout_array.push(vout)
    end
  end

  def sign()

  end

end