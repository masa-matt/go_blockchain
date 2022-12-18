package main

import "log"

// https://github.com/Jeiwan/blockchain_go

func main() {
	log.SetFlags(log.Lmicroseconds)

	cli := CLI{}
	cli.Run()
}
