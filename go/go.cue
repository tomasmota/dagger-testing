package go

import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"
	"universe.dagger.io/bash"
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
		bash: bash.#Run & {
			input:   version.output
			script: contents: #"""
				/usr/local/go/bin/go version
				"""#
		}
	}
}
