package main

import (
	"crypto/sha256"
	"fmt"
	"os"
	"strconv"
)

func main() {
	blockhash := os.Args[1]

	for nonce := 0; nonce < 100000000; nonce++ {
		input := blockhash + strconv.Itoa(nonce)
		hashbyte := sha256.Sum256([]byte(input))
		hash := fmt.Sprintf("%x", hashbyte[:])
		fmt.Printf("%s %s\n", input, hash)
		if hash[0:4] == "0000" {
			fmt.Println("Found Hash!!")
			return
		}
	}
}
