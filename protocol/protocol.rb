require './tx/tx_factory.rb'
require "pry"

class Protocol

  def initialize(accounts, accountPukeys, nlocktime)
    @tx_factory = Tx_Factory.new(accounts, accountPukeys, nlocktime)
  end

  def opening_processes(accounts, accountPubeys)
    # funding txを
    leader_account = accounts[0]
    funding_tx = @tx_factory.create_funding_tx()
    leader_account.add_funding_tx(funding_tx)
    for account in accounts do
      commitment_tx = @tx_factory.create_commitment_tx(funding_tx)
      account.sign(commitment_tx)
      account.transaction.push(commitment_tx)
      account.add_commitment_tx(commitment_tx)
      puts account.add_commitment_tx
      account.sign(0)
    end
  end

  def update_processes

  end

  def closing_processes

  end
    
end