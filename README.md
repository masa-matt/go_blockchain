# Overview
This repository is intended to help myself understand how blockchain works by writing it from scratch.
The basis for running the following [scenario](#scenario) from scratch was taken from [Jeiwan/blockchain_go](https://github.com/Jeiwan/blockchain_go).
From there, I will further deepen each technique one by one.

# Quick Recap

## [Part 1](https://jeiwan.net/posts/building-blockchain-in-go-part-1/)

### Block
In blockchain it’s blocks that store valuable information. For example, transactions, version, current timestamp and the hash of the previous block.

### Blockchain
Blockchain is just a database with certain structure: it’s an ordered, back-linked list.

## [Part 2](https://jeiwan.net/posts/building-blockchain-in-go-part-2/)

### Proof-of-Work
“Do hard work and prove” mechanism is called proof-of-work. For incorporate a block into the blockchain in a secure way. To maintain the stability of the whole blockchain database.

### Hashing
Hashing is used to guarantee the consistency of a block. Contains the hash of the previous block, thus making it impossible (or, at least, quite difficult) to modify a block in the chain.

### Hashcash
Bitcoin uses [Hashcash](https://en.wikipedia.org/wiki/Hashcash). In the original Hashcash implementation, the requirement sounds like “first 20 bits of a hash must be zeros”.

## [Part 3](https://jeiwan.net/posts/building-blockchain-in-go-part-3/)

### Database
Blockchain is a distributed database. Which database do we need? Actually, any of them.

## [Part 4](https://jeiwan.net/posts/building-blockchain-in-go-part-4/)

### Transaction
Since blockchain is a public and open database, we don’t want to store sensitive information about wallet owners. There are, no accounts, no balances, no addresses, no coins, no senders and receivers.  
A transaction is a combination of inputs and outputs.

### Transaction Outputs
It’s outputs that store “coins”. And storing means locking them with a puzzle, which is stored in the ScriptPubKey. One important thing about outputs is that they are indivisible, which means that you cannot reference a part of its value.

### Transaction Inputs
An input references a previous output. ScriptSig is a script which provides data to be used in an output’s ScriptPubKey. If the data is correct, the output can be unlocked, and its value can be used to generate new outputs. This is the mechanism that guarantees that users cannot spend coins belonging to other people.

### Unspent Transaction Outputs
When we check balance, we need to find all unspent transaction outputs (UTXO). Unspent means that these outputs weren’t referenced in any inputs. We don’t need all of them, but only those that can be unlocked by the key we own.

### Sending Coins
If we want to send some coins to someone else, we need to create a new transaction, put it in a block, and mine the block. Before creating new outputs, we first have to find all unspent outputs and ensure that they store enough value.

### Mempool
This is where transactions are stored before being packed in a block.

## [Part 5](https://jeiwan.net/posts/building-blockchain-in-go-part-5/)

### Public-key Cryptography
Public-key cryptography algorithms use pairs of keys: public keys and private keys. Public keys are not sensitive and can be disclosed to anyone. In contrast, private keys shouldn’t be disclosed.

### Digital Signatures
By applying a signing algorithm to data (i.e., signing the data), one gets a signature, which can later be verified. Digital signing happens with the usage of a private key, and verification requires a public key.

### Elliptic Curve Cryptography
Public and private keys are sequences of random bytes. Since it’s private keys that are used to identify owners of coins, there’s a required condition: the randomness algorithm must produce truly random bytes. Elliptic curves is a complex mathematical concept.

### Base58
Bitcoin uses the Base58 algorithm to convert public keys into human readable format.

## [Part 6](https://jeiwan.net/posts/building-blockchain-in-go-part-6/)

### Reward
The reward is just a coinbase transaction. When a mining node starts mining a new block, it takes transactions from the queue and prepends a coinbase transaction to them. The coinbase transaction’s only output contains miner’s public key hash.

### The UTXO Set
As of September 18, 2017, Bitcoin has 485,860 blocks and the entire data size over 140 Gb. This means that validating transactions would require iterating over many blocks.  
The solution to this problem is to have an index that stores only unused outputs, which is the role of the UTXO set. This is a cache and is later used to calculate balances and validate new transactions The UTXO set is approximately 2.7 Gb as of September 2017.

### Merkle Tree
For SPV to be possible, there should be a way to check if a block contains certain transaction without downloading the whole block. And this is where Merkle tree comes into play.  
Merkle trees are used to obtain transactions hash, which is then saved in block headers and is considered by the proof-of-work system.

## [Part 7](https://jeiwan.net/posts/building-blockchain-in-go-part-7/)

### Blockchain Network
While previous features are crucial, it’s not enough. What makes these features really shine, and what make cryptocurrencies possible, is network. Blockchain network is a community of programs that follow the same rules, and it’s this following the rules that makes the network alive.  
Blockchain network is a P2P (Peer-to-Peer) network, which is decentralized.

### Node Roles

#### Miner
Their only goal is to mine new blocks as fast as possible. Miners are only possible in blockchains that use Proof-of-Work. In Proof-of-Stake blockchains, there’s no mining.

#### Full node
These nodes validate blocks mined by miners and verify transactions. They must have the whole copy of blockchain. Also, such nodes perform such routing operations, like helping other nodes to discover each other.

#### Simplified Payment Verification (SPV)
SPV makes wallet applications possible. It's a light node that doesn’t download the whole blockchain and doesn’t verify blocks and transactions. Instead, it finds transactions in blocks (to verify payments) and is linked to a full node to retrieve just necessary data.

### Important use case of Bitcoin

#### version
Nodes communicate by the means of messages. When a new node is run, it gets several nodes from a DNS seed, and sends them version message.

#### getblocks
getblocks means “show me what blocks you have”. It requests a list of block hashes.

#### inv
Bitcoin uses inv to show other nodes what blocks or transactions current node has. It doesn’t contain whole blocks and transactions, just their hashes.

#### getdata
getdata is a request for certain block or transaction, and it can contain only one block/transaction ID.

#### block and tx
It’s these messages that actually transfer the data. When we received a new block, we put it into our blockchain. If there’re more blocks to download, we request them from the same node we downloaded the previous block. When we finally downloaded all the blocks, the UTXO set is reindexed.

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
  - Use the created address.
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
  - Create new wallet.
```shell
$ go_blockchain createwallet
```
  - Start the node with the created address.
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
