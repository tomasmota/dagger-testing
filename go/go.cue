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
		setpath: core.#Exec & {
			input: _go.output
			// args: ["PATH=$PATH:~/usr/local/go/bin"]
			args: [
					"sh", "-c",
					#"""
						cp /usr/local/go/bin/go /usr/local/bin/go
					"""#,
				]
			always: true
		}
		version: core.#Exec & {
			input: setpath.output
			args: ["go", "version"]
			always: true
		}
		build: core.#Exec & {
			input: version.output
			mounts: code: {
				dest:     "/code"
				contents: client.filesystem.".".read.contents
			}
			workdir: "/code"
			args: [
					"sh", "-c",
					#"""
						go mod init hello
						go mod tidy
						go build -o out
					"""#,
				]
			always: true
		}
		run: core.#Exec & {
			input: build.output
			workdir: "/code"
			args: ["./out"]
			always: true
		}
	}
}
