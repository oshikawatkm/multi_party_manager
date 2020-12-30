
require './tx/tx_component/script_manager.rb'
require './tx/tx_component/multisig_addr.rb'
require './tx/funding_tx.rb'
require './tx/commitment_tx.rb'
require 'pry'

class Tx_Factory

  def initialize(accountArray, accountPubkeys, nlocktime)
    @accounts = accountArray
    @accountPubkeys = accountPubkeys
    @script_manager = Script_Manager.new(@accountPubkeys.length, @accountPubkeys)
    @nlocktime = nlocktime
  end

  def create_funding_tx
    # Scriptの作成
    script_asm, script_redeem, script_hex = @script_manager.create_funding_script()
    # Funding Txの作成
    funding_tx = Funding_tx.new(script_asm, script_redeem, script_hex)
    funding_tx.create(@accounts)
    return funding_tx
  end

  def create_commitment_tx(funding_tx)
    script_asm, script_redeem, script_hex = @script_manager.create_commitment_script(@accounts[0].pubkey, @accounts[1].pubkey, @nlocktime)
    commitment_tx = Commitment_tx.new(funding_tx.tx.to_witness_payload, funding_tx.redeem_script)
    commitment_tx.create(@accounts, funding_tx.tx)
    return commitment_tx
  end
  

  def create_closing_tx
    commitment_tx = Commitment_tx.new(@accounts, funding_tx)
    return commitment_tx
  end
    
end