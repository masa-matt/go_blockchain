module github.com/masa-matt/go_blockchain/wallet

go 1.18

replace github.com/masa-matt/go_blockchain/crypto => ../crypto

replace github.com/masa-matt/go_blockchain/common => ../common

require (
	github.com/masa-matt/go_blockchain/crypto v0.0.0-00010101000000-000000000000
	golang.org/x/crypto v0.4.0
)

require github.com/masa-matt/go_blockchain/common v0.0.0-00010101000000-000000000000 // indirect
