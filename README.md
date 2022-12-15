# Reference
[https://github.com/Jeiwan/blockchain_go](https://github.com/Jeiwan/blockchain_go)

# Scenario

## 1. The central node creates a blockchain.
- First, set NODE_ID to 3000 (export NODE_ID=3000) in the first terminal window. I’ll use badges like NODE 3000, NODE 3001 or NODE 3002 before next paragraphs, for you to know what node to perform actions on.
- Open a new window as `central node`.
  - Set NODE_ID.
```shell
$ export NODE_ID=3000
```
  - Create new wallet.
```shell
$ go_blockchain createwallet
```
  - Use created address.
```
$ go_blockchain createblockchain -address CENTREAL_NODE
```
  - We need to save the block and use it in other nodes.
```
$ cp blockchain_3000.db blockchain_genesis.db
```

## 2. Other (wallet) node connects to it and downloads the blockchain.
- Open a new window as `wallet node`.
  - Set NODE_ID.
```shell
$ export NODE_ID=3001
```
  - Create new wallet as WALLET_1, WALLET_2, WALLET_3, WALLET_4.  
  Repeat the command four time to generate each wallet.
```shell
$ go_blockchain createwallet
```
- In the `central node` window.
  - Send some coins to the wallet addresses.  
  `-mine` flag means that the block will be immediately mined by the same node. We have to have this flag because initially there are no miner nodes in the network.
```shell
$ go_blockchain send -from CENTREAL_NODE -to WALLET_1 -amount 10 -mine
$ go_blockchain send -from CENTREAL_NODE -to WALLET_2 -amount 10 -mine
```
  - Start the node.
```shell
$ go_blockchain startnode
```
- In the `wallet node` window.
  - Start the node’s blockchain with the genesis block saved above.
```shell
$ cp blockchain_genesis.db blockchain_3001.db
```
  - Start the node.
```shell
$ go_blockchain startnode
```
  - It’ll download all the blocks from the central node. To check that everything’s ok, stop the node and check the balances.
```shell
$ go_blockchain getbalance -address WALLET_1
Balance of 'WALLET_1': 10
$ go_blockchain getbalance -address WALLET_2
Balance of 'WALLET_2': 10
```
  - Also, you can check the balance of the CENTRAL_NODE address, because the `wallet node` now has its blockchain.
```shell
$ go_blockchain getbalance -address CENTRAL_NODE
Balance of 'CENTRAL_NODE': 10
```

## 3. One more (miner) node connects to the central node and downloads the blockchain.
- Open a new window as `miner node`.
  - Set NODE_ID.
```shell
$ export NODE_ID=3002
```
  - Initialize the blockchain.
```shell
$ cp blockchain_genesis.db blockchain_3002.db
```
  - Start the node.
```shell
$ go_blockchain startnode -miner MINER_WALLET
```

## 4. The wallet node creates a transaction.
- In the `wallet node` window.
  - Send some coins.
```shell
$ go_blockchain send -from WALLET_1 -to WALLET_3 -amount 1
$ go_blockchain send -from WALLET_2 -to WALLET_4 -amount 1
```

## 5. The miner nodes receives the transaction and keeps it in its memory pool.
## 6. When there are enough transactions in the memory pool, the miner starts mining a new block.
- Quickly! Look into the `miner node` window. See it mining a new block!

## 7. When a new block is mined, it’s send to the central node.
- In `central node` window. Also, check the output of the central node.

## 8. The wallet node synchronizes with the central node.
- In `wallet node` window.
  - Start the node. It’ll download the newly mined block!
```shell
$ go_blockchain startnode
```

## 9. User of the wallet node checks that their payment was successful.
- In `wallet node` window.
  - Stop `wallet node` and check balances.
```shell
$ go_blockchain getbalance -address WALLET_1
Balance of 'WALLET_1': 9
$ go_blockchain getbalance -address WALLET_2
Balance of 'WALLET_2': 9
$ go_blockchain getbalance -address WALLET_3
Balance of 'WALLET_3': 1
$ go_blockchain getbalance -address WALLET_4
Balance of 'WALLET_4': 1
$ go_blockchain getbalance -address MINER_WALLET
Balance of 'MINER_WALLET': 10
```
