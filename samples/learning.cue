// package samples

// import (
// 	"dagger.io/dagger"
// 	"dagger.io/dagger/core"
// 	"universe.dagger.io/alpine"
// 	// "universe.dagger.io/bash"
// )

// dagger.#Plan & {
// 	// client: {
// 	// 	filesystem: {
// 	// 		./: {
// 	// 			read: contents: dagger.#FS
// 	// 			write: contents: actions.gowrite.output
// 	// 		}
// 	// 	}
// 	// }
// 	actions: {
// 		_dockerCLI: alpine.#Build & {
// 					packages: {
// 						bash: {}
// 						go: {}
// 					}
// 		}
// 		_ubuntu: core.#Pull & {
// 			source: "golang:latest"
// 		}
// 		// mkdir: core.#Mkdir & {
// 		// 	input: client.filesystem."./".read.contents
// 		// 	path: "bla"
// 		// }
// 		// daggerwrite: core.#WriteFile & {
// 		// 	input: mkdir.output
// 		// 	path: "bla/hello.txt"
// 		// 	contents: "hello, dagger!"
// 		// }
// 		gowrite: core.#Exec & {
// 			input: _ubuntu.output
// 			// mounts: "source": {
// 			// 	dest:     "/"
// 			// 	contents: client.filesystem."./".read.contents
// 			// }
// 			always: true
// 			args: ["go", "run", "main.go"]
// 			args: ["ls"]
// 		}
// 		// bashwrite: bash.#Run & {
// 		// 	input: _dockerCLI.output
// 		// 	mounts: "source": {
// 		// 		dest:     "/"
// 		// 		contents: daggerwrite.output
// 		// 	}
// 		// 	script: contents: #"""
// 		// 		echo 'hello world' > bla/hello.txt
// 		// 		"""#
// 		// }
// 		// read: core.#ReadFile & {
// 		// 	input: mkdir.output
// 		// 	path: "bla/hello.txt"
// 		// }
// 	}
// }
