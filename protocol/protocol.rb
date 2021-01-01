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
      key_pairs = { "revoke_privpubkey" => keys[0], "revoke_pubkey" => keys[1] }
      account.revoke_keys.push(key_pairs)
    }

    # hashの交換は行ったこととする

    # refound txの作成
    accounts.each_with_index{|account, index| 
      commitment_tx = @tx_factory.create_refund_tx(index, accounts, @funding_tx)
      puts 1
      accounts.each_with_index{|account, sign_index| 
        commitment_tx = accounts[sign_index].sign(commitment_tx, @funding_tx, 0)
      }
      puts 2
      account.add_commitment_tx(commitment_tx)
    }
    
    # funding txへの署名
    accounts.each_with_index{|account, index| 
      account.sign(0)
    }

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

    accounts.each_with_index{|account, index| 
      commitment_tx = @tx_factory.create_commitment_tx(index, accounts, @funding_tx, from, to, value)
      commitment_tx = account.sign(commitment_tx)
      account.add_commitment_tx(commitment_tx)
    }
    
    # funding txへの署名
    accounts.each_with_index{|account, index| 
      account.sign(0)
    }

    accounts.each_with_index{|account, index|
      if index == from
        accounts[index].latest_amount -= value
      elsif index == to
        accounts[index].latest_amount += value
      end
    }

    puts "最新の状態が更新されました"
  end

  def closing_processes

  end
    
end