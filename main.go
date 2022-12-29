package main

import (
	"log"

	"github.com/masa-matt/go_blockchain/p2p"
)

func main() {
	log.SetFlags(log.Lmicroseconds)

	cli := p2p.CLI{}
	cli.Run()
}
