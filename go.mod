module github.com/masa-matt/go_blockchain

go 1.18

replace github.com/masa-matt/go_blockchain/p2p => ./p2p

replace github.com/masa-matt/go_blockchain/common => ./common

replace github.com/masa-matt/go_blockchain/crypto => ./crypto

replace github.com/masa-matt/go_blockchain/wallet => ./wallet

replace github.com/masa-matt/go_blockchain/core => ./core

require github.com/masa-matt/go_blockchain/p2p v0.0.0-00010101000000-000000000000

require (
	github.com/boltdb/bolt v1.3.1 // indirect
	github.com/masa-matt/go_blockchain/common v0.0.0-00010101000000-000000000000 // indirect
	github.com/masa-matt/go_blockchain/core v0.0.0-00010101000000-000000000000 // indirect
	github.com/masa-matt/go_blockchain/crypto v0.0.0-00010101000000-000000000000 // indirect
	github.com/masa-matt/go_blockchain/wallet v0.0.0-00010101000000-000000000000 // indirect
	golang.org/x/crypto v0.4.0 // indirect
	golang.org/x/sys v0.3.0 // indirect
)
