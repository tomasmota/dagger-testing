package todoapp

import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"
	"universe.dagger.io/alpine"
)

dagger.#Plan & {
	client: {
		filesystem: {
			"./": {
				read: contents: dagger.#FS
				write: contents: actions.write.output
			}
		}
	}
	actions: {
		_dockerCLI: alpine.#Build & {
			packages: bash: _
		}
		mkdir: core.#Mkdir & {
			input: client.filesystem."./".read.contents
			path: "bla"
		}
		write: core.#WriteFile & {
			input: mkdir.output
			path: "bla/hello.txt"
			contents: "hello, tom!"
		}
		run: bash.#Run & {
			input: _dockerCLI.output
			mounts: "source": {
				dest:     "/"
				contents: write.output
			}
			script: contents: #"""
				echo 'hello world'
				"""#
		}
	}
}
