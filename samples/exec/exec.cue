package exec

import (
	"dagger.io/dagger"
	"universe.dagger.io/alpine"
	"dagger.io/dagger/core"
)

dagger.#Plan & {
	client: {
		filesystem: {
			".": read: {
				contents: dagger.#FS
			}
		}
	}
	actions: {
		_dockerCLI: alpine.#Build & {
					packages: {
						bash: {}
						go: {}
					}
		}
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
		basicexec: core.#Exec & {
			input: _ubuntu.output
			args: ["ls"]
			always: true
		}
	}
}
