package main

import (
	"log"
	"os"
)

func main() {
	err := os.WriteFile("./bla/test", []byte("hello world (go)"), 0644)
	if err != nil {
		log.Fatal(err)
	}
}
