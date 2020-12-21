

class Account
  attr_accessor :name, :tx_id, :tx_index, :value, :address, :pubkey, :transactions

  def initialize(name, tx_id, tx_index, value, address, pubkey, prev_tx_payload)
    @name = name
    @tx_id = tx_id
    @tx_index = tx_index
    @value = value
    @address = address
    @pubkey = pubkey
    @prev_tx_payload = prev_tx_payload
    @transactions = []
  end

end 