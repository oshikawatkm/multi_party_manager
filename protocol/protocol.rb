require './tx/tx_factory.rb'
require 'bitcoin'
require "pry"

class Protocol

  def initialize(accountPukeys, nlocktime)
    @tx_factory = Tx_Factory.new(accountPukeys, nlocktime)
  end

  def opening_processes(accounts, accountPubeys)
    # funding txを
    leader_account = accounts[0]
    @funding_tx = @tx_factory.create_funding_tx(accounts)
    leader_account.add_funding_tx(@funding_tx)

    # secretとhashの生成
    accounts.each_with_index{|account, index| 
      keys = Bitcoin::generate_key
      key_pairs = { "revoke_privkey" => keys[0], "revoke_pubkey" => keys[1] }
      account.revoke_keys.push(key_pairs)
    }

    # hashの交換は行ったこととする

    # refound txの作成
    accounts.each_with_index{|account, index| 
      commitment_tx = @tx_factory.create_refund_tx(index, accounts, @funding_tx)
      # accounts.each_with_index{|account, sign_index|
      #   commitment_tx = accounts[sign_index].sign_commitment_tx(commitment_tx, @funding_tx, 0)
      # }
      account.add_commitment_tx(commitment_tx)
    }
    
    # funding txへの署名
    # accounts.each_with_index{|account, index| 
    #   account.sign_funding_tx(@funding_tx)
    # }
    # binding.pry
    # funding txをブロードキャスト
    puts "funding txをブロードキャストしてください"
  end

  def update_processes(accounts, from, to, value)
    #
    accounts.each_with_index{|account, index| 
      keys = Bitcoin::generate_key
      key_pairs = { "revoke_privpubkey" => keys[0], "revoke_pubkey" => keys[1] }
      account.revoke_keys.push(key_pairs)
    }

    # accounts.each_with_index{|account, index| 
    #   commitment_tx = @tx_factory.create_commitment_tx(index, accounts, @funding_tx, from, to, value)
    #   accounts[index].sign_commitment_tx(commitment_tx, @funding_tx)
    #   account.add_commitment_tx(commitment_tx)
    # }
    commitment_tx = @tx_factory.create_commitment_tx(0, accounts, @funding_tx, from, to, value)
    commitment_tx = accounts[0].sign_commitment_tx(commitment_tx, @funding_tx)
    commitment_tx = accounts[1].sign_commitment_tx(commitment_tx, @funding_tx)
    commitment_tx = accounts[2].sign_commitment_tx(commitment_tx, @funding_tx)
    commitment_tx.tx.in[0].script_witness.stack << @funding_tx.redeem_script.to_payload
    accounts[0].add_commitment_tx(commitment_tx)

    revoke_tx1 = @tx_factory.create_revoke_tx(accounts[0], commitment_tx.tx, 2)
    revoke_tx1 = accounts[1].sign_revoke_tx(revoke_tx1, commitment_tx, 2)
    revoke_tx2 = @tx_factory.create_revoke_tx(accounts[0], commitment_tx.tx, 3)
    revoke_tx2 = accounts[2].sign_revoke_tx(revoke_tx2, commitment_tx, 3)
    # checkout_tx = @tx_factory.create_checkout_tx(accounts[0], commitment_tx)
    # checkout_tx = accounts[0].sign_checkout_tx(checkout_tx, commitment_tx)
    # checkout_tx = accounts[1].sign_checkout_tx(checkout_tx, commitment_tx)
    # checkout_tx = accounts[2].sign_checkout_tx(checkout_tx, commitment_tx)

    accounts.each_with_index{|account, index|
      if index == from
        accounts[index].latest_amount -= value
      elsif index == to
        accounts[index].latest_amount += value
      end
    }
    
    binding.pry
    puts "最新の状態が更新されました"
  end

  def closing_processes(accounts)
    closing_tx = @tx_factory.create_closing_tx(accounts)
     accounts.each_with_index{|account, index| 
      accounts[index].sign_closing_tx(closing_tx, @funding_tx)
    }
    closing_tx.tx.in[0].script_witness.stack << @funding_tx.redeem_script.to_payload
    binding.pry
    puts "取引を終了します"
  end
    
end