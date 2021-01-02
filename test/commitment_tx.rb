require 'pry'
require 'bitcoin'
Bitcoin.network = :testnet3

require '../account/account_factory'
require '../lib/json_reader'

CONFIG_JSON_PATH = "../config.json"




@funding_tx_id="c8b3c183296cf03a6a90610286b0ab5d0ae1531ff28933e88510fdd513178238"
@funding_tx_index=""
@nlocktime=10
@move_value = 1000
@from_account_index = 0
@to_account_index = 1

def create_accounts
  accounts = []
  accountPubeys = []
  # #  コマンドライン引数のアカウント個数を取得
  # account_factory_count = ARGV[0].to_i

  # config.jsonの読み込み
  json_reader = JSON_Reader.new()
  json_data = json_reader.read_json(CONFIG_JSON_PATH)
  accounts_data = json_data["accounts"]

  # アカウントの作成
  account_factory = Account_Factory.new()
  for account_data in accounts_data do
    account = account_factory.create(account_data)
    # account.genarate_pubkey()
    accountPubeys.push(account.pubkey)
    accounts.push(account)
  end
  return accounts, accountPubeys
end

def create_commitment_script(revoke_pubkey, pubkey, nlocktime)
  locktime = nlocktime + 10
  asm = "OP_IF #{revoke_pubkey} OP_ELSE #{locktime} OP_NOP3 OP_DROP #{pubkey} OP_ENDIF OP_CHECKSIG"
  redeem = Bitcoin::Script.from_string(asm)
  hex = Bitcoin::Script.to_witness_p2sh_script(Bitcoin.sha256(redeem.to_payload.bth)).bth
  return asm, redeem, hex
end


def create(accounts, account_index)
  account_length = accounts.length
  tx = Bitcoin::Protocol::Tx.new
  tx.add_in(Bitcoin::Protocol::TxIn.from_hex_hash(@funding_tx_id, 3))
  account_length.times do |i|
    if i != account_index
      value = accounts[i].latest_amount
      if i == @from_account_index
        value -= @move_value
      elsif i == @to_account_index
        value += @move_value
      end
      tx.add_out(Bitcoin::Protocol::TxOut.value_to_address(value, accounts[i].address))
    end
  end
  account_length.times do |i|
    if i != account_index
      lock_value = accounts[account_index].latest_amount
      if account_index == @from_account_index
        lock_value -= @move_value
      elsif account_index == @to_account_index
        lock_value += @move_value
      end
      splited_lock_value = lock_value / (account_length - 1)
      script_asm, script_redeem, script_hex = create_commitment_script(accounts[i].revoke_keys.last["revoke_pubkey"], accounts[i].pubkey, @nlocktime)
      script_pubkey = Bitcoin::Script.from_string("0 #{Bitcoin.sha256(script_redeem.to_payload.bth)}")
      tx.add_out(Bitcoin::Protocol::TxOut.new(splited_lock_value, script_pubkey.to_payload))
    end
  end
  return tx
end

commitment_txs = []
accounts, accountPubeys = create_accounts()

accounts.each_with_index{|account, index| 
  keys = Bitcoin::generate_key
  key_pairs = { "revoke_privpubkey" => keys[0], "revoke_pubkey" => keys[1] }
  account.revoke_keys.push(key_pairs)
}

accounts.each_with_index{|account, index| 
  commitment_tx = create(accounts, index)
  commitment_txs.push(commitment_tx)
}

binding.pry