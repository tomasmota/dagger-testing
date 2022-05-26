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
				write: contents: actions.version.output
			}
		}
	}
	actions: {
		_ubuntu: core.#Pull & {source: "ubuntu"}
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
		daggerread: core.#ReadFile & {
			input: mkdir.output
			path: "bla/hello.txt"
		}
		install: core.#Exec & {
			input: _ubuntu.output
			args: [
					"sh", "-c",
					#"""
						apt update
						apt install -y golang-go
						"""#,
				]
			always: true
		}
		// install: core.#Exec & {
		// 	input: update.output
		// 	args: ["apt", "install", "-y", "golang-go"]
		// 	always: true
		// }
		version: core.#Exec & {
			input: install.output
			// args: ["/go/bin/go", "version"]
			args: ["echo", "blaaa"]
			always: true
		}
	}
}
