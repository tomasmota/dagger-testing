package main

import (
	"fmt"
	"log"
	"os"
)

func main() {
	err := os.WriteFile("test", []byte("hello world (go)"), 0644)
	fmt.Println("hello dagger")
	if err != nil {
		log.Fatal(err)
	}
}
