package todoapp

import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"
)

dagger.#Plan & {
	client: filesystem: ".": read: contents: dagger.#FS
	actions: {
		_ubuntu: core.#Pull & {source: "ubuntu:latest"}
		src: core.#Copy & {
			input: _ubuntu.output
			contents: client.filesystem.".".read.contents
			dest: "/app"
		}
		copyexec: core.#Exec & {
			input: src.output
			workdir: "/app"
			args: ["ls"]
			always: true
		}
	}
}
