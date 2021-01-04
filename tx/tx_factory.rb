
require './tx/funding_tx.rb'
require './tx/refund_tx.rb'
require './tx/revoke_tx.rb'
require './tx/commitment_tx.rb'
require './tx/closing_tx.rb'
require 'pry'

class Tx_Factory

  def initialize(accountPubkeys, nlocktime)
    @accountPubkeys = accountPubkeys
    @script_manager = Script_Manager.new(@accountPubkeys.length, @accountPubkeys)
    @nlocktime = nlocktime
  end

  def create_funding_tx(accounts)
    # Scriptの作成
    script_asm, script_redeem, script_hex = @script_manager.create_funding_script()
    # Funding Txの作成
    funding_tx = Funding_tx.new(script_asm, script_redeem, script_hex)
    funding_tx.create(accounts)
    return funding_tx
  end

  def create_refund_tx(account_index, accounts, funding_tx)
    refund_tx = Refund_tx.new(account_index, funding_tx.tx.to_witness_payload, funding_tx.redeem_script)
    refund_tx.create(@script_manager, @nlocktime, accounts, funding_tx)
    return refund_tx
  end

  def create_commitment_tx(account_index, accounts, funding_tx, from, to, value)
    commitment_tx = Commitment_tx.new(account_index, funding_tx.tx.to_witness_payload, from, to, value, funding_tx.redeem_script)
    commitment_tx.create(@script_manager, @nlocktime, accounts, funding_tx.tx)
    return commitment_tx
  end

  def create_closing_tx(accounts)
    closing_tx = Closing_tx.new()
    closing_tx.create(accounts)
    return closing_tx
  end

  def create_revoke_tx(account, commitment_tx, input_index)
    revoke_tx = Revoke_tx.new()
    revoke_tx.create(account, commitment_tx, input_index)
    return revoke_tx
  end

  def create_checkout_tx(account, commitment_tx)
    revoke_tx = Revoke_tx.new()
    revoke_tx.create(account, commitment_tx)
    return revoke_tx
  end
    
end