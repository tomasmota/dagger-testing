package go

import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"
)

dagger.#Plan & {
	actions: {
		_go: core.#Pull & {source: "golang"}
		version: core.#Exec & {
			input: _go.output
			args: ["which", "go"]
			always: true
		}
	}
}
