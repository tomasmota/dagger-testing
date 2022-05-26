package samples

import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"
	"universe.dagger.io/alpine"
	// "universe.dagger.io/bash"
)

dagger.#Plan & {
	client: {
		filesystem: {
			"./": {
				read: contents: dagger.#FS
			}
			"out": {
				write: contents: actions.bashwrite.output
			}
		}
	}
	actions: {
		_ubuntu: core.#Pull & {source: "ubuntu:latest"}
		_dockerCLI: alpine.#Build & {
					packages: {
						bash: {}
						go: {}
					}
		}
		mkdir: core.#Mkdir & {
			input: client.filesystem."./".read.contents
			path: "bla"
		}
		daggerwrite: core.#WriteFile & {
			input: mkdir.output
			path: "bla/hello.txt"
			contents: "hello, dagger!"
		}
		update: core.#Exec & {
			input: _ubuntu.output
			workdir: "bla"
			args: ["apt", "update"]
			always: true
		}
		bashwrite: core.#Exec & {
			input: _ubuntu.output
			workdir: "bla"
			args: ["apt", "search", "golang-go"]
			always: true
		}
		// read: core.#ReadFile & {
		// 	input: mkdir.output
		// 	path: "bla/hello.txt"
		// }
	}
}
