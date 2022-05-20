package main

import (
	"log"
	"os"
)

func main() {
	err := os.Mkdir("bla", 0755)
	if err != nil {
		log.Fatal(err)
	}

	err = os.WriteFile("./bla/test", []byte("hello world (go)"), 0644)
	if err != nil {
		log.Fatal(err)
	}
}
