require './tx/tx_factory.rb'

class Protocol

  def initialize(accounts, accountPukeys)
    tx_factory = Tx_Factory.new(accounts, accountPukeys)
    funding_tx = tx_factory.create_funding_tx()
  end

  def opening_processes(accounts, accountPubeys)
    
  end

  def update_processes

  end

  def closing_processes

  end
    
end