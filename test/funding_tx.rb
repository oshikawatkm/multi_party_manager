require 'pry'
require 'bitcoin'
Bitcoin.network = :testnet3

require '../account/account_factory'
require '../lib/json_reader'


# 定数
CONFIG_JSON_PATH = "../config.json"


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

def create_funding_script(accounts_length, pubkeys)
  asm = accounts_length.to_s + " "
  for pubkey in pubkeys do
    asm += pubkey + " "
  end
  asm += accounts_length.to_s + " " + "OP_CHECKMULTISIG"
  redeem = Bitcoin::Script.from_string(asm)
  hex = Bitcoin::Script.to_witness_p2sh_script(Bitcoin.sha256(redeem.to_payload.bth)).bth
  return asm, redeem, hex
end


def create(accounts, redeem_script)
  tx = Bitcoin::Protocol::Tx.new
  script_pubkey = Bitcoin::Script.from_string("0 #{Bitcoin.sha256(redeem_script.to_payload.bth)}")
  total_funding_value = 0
  for account in accounts do
    funding_value = account.start_amount
    total_funding_value += funding_value
    prev_tx = Bitcoin::Protocol::Tx.new(account.prev_tx_payload.htb)
    prev_tx_value = prev_tx.out[account.tx_index].value
    tx.add_in(Bitcoin::Protocol::TxIn.from_hex_hash(account.tx_id, account.tx_index))
    if prev_tx_value - funding_value != 0
      tx.add_out(Bitcoin::Protocol::TxOut.value_to_address(prev_tx_value - funding_value - 200, account.address))
    end
  end
  tx.add_out(Bitcoin::Protocol::TxOut.new(total_funding_value, script_pubkey.to_payload))
  return tx
end


accounts, pubkeys = create_accounts()
asm, redeem, hex = create_funding_script(accounts.length, pubkeys)
funding_tx = create(accounts, redeem)

binding.pry