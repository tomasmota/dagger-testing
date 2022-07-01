package dotnet

import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"
    "universe.dagger.io/docker"
)

dagger.#Plan & {
	client: {
		env: {
			REGISTRY_PASS: dagger.#Secret
		}
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
		dockerBuild: docker.#Dockerfile & {
			source: client.filesystem."./app".read.contents
			dockerfile: contents: """
				FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
				WORKDIR /app

				# Copy everything
				COPY . ./
				# Restore as distinct layers
				RUN dotnet restore
				# Build and publish a release
				RUN dotnet publish --runtime alpine-x64 -c Release -o out

				# Build runtime image
				FROM mcr.microsoft.com/dotnet/runtime-deps:6.0-alpine
				WORKDIR /app
				COPY --from=build-env /app/out .
				ENTRYPOINT ["./dotnet"]
				"""
		}
		push: docker.#Push & {
			image: dockerBuild.output
			dest:  "registry.hub.docker.com/tomasmota/dotnet-dagger"
			auth: {
                username: "tomasmota"
                secret:   client.env.REGISTRY_PASS
            }
		}
	}
}
