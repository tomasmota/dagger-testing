package todoapp

import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"
)

dagger.#Plan & {
	actions: {
		_ubuntu: core.#Pull & {source: "ubuntu:latest"}
		basicexec: core.#Exec & {
			input: _ubuntu.output
			args: ["ls"]
			always: true
		}
	}
}
