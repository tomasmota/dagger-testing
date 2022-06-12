package go

import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"
)

dagger.#Plan & {
	client: {
		filesystem: {
			".": read: {
				contents: dagger.#FS
				include: ["main.go"]
			}
		}
	}
	actions: {
		_go: core.#Pull & {source: "golang:alpine"}
		path: core.#Exec & {
			input: _go.output
			args: ["PATH=$PATH:~/usr/local/go/bin"]
			always: true
		}
		version: core.#Exec & {
			input: path.output
			args: ["go", "version"]
			always: true
		}
		run: core.#Exec & {
			input: version.output
			mounts: code: {
				dest:     "/code"
				contents: client.filesystem.".".read.contents
			}
			workdir: "/code"
			args: ["go", "run", "main.go"]
		}
	}
}
