package go

import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"
)

dagger.#Plan & {
	actions: {
		_go: core.#Pull & {source: "golang:alpine"}
		ls: core.#Exec & {
			input: _go.output
			args: ["ls", "/usr/local/go/bin"]
			always: true
		}
		version: core.#Exec & {
			input: ls.output
			args: ["/usr/local/go/bin/go", "version"]
			always: true
		}
	}
}
