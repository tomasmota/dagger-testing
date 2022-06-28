package dotnet

import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"
)

dagger.#Plan & {
	client: {
		filesystem: {
			"./app": read: {
				contents: dagger.#FS
				exclude: ["obj", "bin"]
			}
			"./out": {
				write: {
					contents: actions.buildResult.output
				}	
			}
		}
	}
	actions: {
		_dotnet: core.#Pull & {source: "mcr.microsoft.com/dotnet/sdk:6.0-alpine"}
		sdks: core.#Exec & {
			input: _dotnet.output
			args: [
					"sh", "-c",
					#"""
						dotnet --list-sdks
					"""#,
				]
			always: true
		}
		build: core.#Exec & {
			input: sdks.output
			mounts: code: {
				dest:     "/code"
				contents: client.filesystem."./app".read.contents
			}
			workdir: "/code"
			args: [
					"sh", "-c",
					#"""
						dotnet publish -o /out
					"""#,
				]
			always: true
		}
		buildResult: core.#Subdir & {
				input: build.output
				path:  "/out" 
		}
	}
}
