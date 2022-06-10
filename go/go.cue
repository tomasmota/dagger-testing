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
			args: ["ls"]
			always: true
		}
		version: core.#Exec & {
			input: ls.output
			args: ["which", "go"]
			always: true
		}
	}
}
