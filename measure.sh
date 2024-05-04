#!/bin/bash

images_file="./launch/images.json"

function load_base_images {
	docker pull golang:1.22.2-alpine3.19

	local tags=("latest" "nonroot" "debug" "debug-nonroot")
	for image in $(jq -r 'keys[]' ${images_file}); do
		for tag in ${tags[@]}; do
			docker pull ${image}:${tag}
		done
	done
}

function get_java_release {
	local image=$1

	local java=$(grep -o 'java[0-9]*' <<< ${image})

	java_release=$(grep -o '[0-9]*' <<< ${java})
}

function reset_folder {
	rm -rf run* main.jar package.json
}

function distroless_build_setup {
	local image=$1

	if [[ ${image} ==  *"python3"* ]]; then
		cp ./launch/python/* ./

		sed -i -e "s/@PYTHON_IMAGE@/$(sed 's/\//\\\//g' <<< ${image})/g" Dockerfile
		return
	elif [[ ${image} == *"nodejs"* ]]; then
		cp ./launch/node/* ./

		sed -i -e "s/@NODE_IMAGE@/$(sed 's/\//\\\//g' <<< ${image})/g" Dockerfile
		return
	elif [[ ${image} == *"java"* ]]; then
		get_java_release ${image}

		if ! [[ ${java_release} ]]; then
			cp ./launch/default/multi/* ./

			sed -i -e "s/FROM scratch/FROM $(sed 's/\//\\\//g' <<< ${image})/g" Dockerfile
			return
		fi

		cp ./launch/java/* ./

		sed -i -e "s/@JAVA_IMAGE@/$(sed 's/\//\\\//g' <<< ${image})/g" Dockerfile
		sed -i -e "s/@JAVA_RELEASE@/${java_release}/g" Dockerfile
		return
	fi

	cp ./launch/default/multi/* ./

	sed -i -e "s/FROM scratch/FROM $(sed 's/\//\\\//g' <<< ${image})/g" Dockerfile
}

function build_distroless {
	local tags=("latest" "nonroot" "debug" "debug-nonroot")

	for image in $(jq -r 'keys[]' ${images_file}); do
		reset_folder
		for tag in ${tags[@]}; do
			distroless_build_setup "${image}:${tag}"
			local name="l3-go-$(awk -F'/' '{print $3}' <<< ${image}):${tag}"
			time docker build --no-cache -t ${name} .
			docker images ${name}

			git add .
			git commit -m "${name}"
		done
	done
}

function build_single {
	cp ./launch/default/single/* ./
	time docker build --no-cache -t 'l3-go:single' .
	docker images 'l3-go:single'

	git add .
	git commit -m "l3-go:single"
}

function build_multi {
	cp ./launch/default/multi/* ./
	time docker build --no-cache -t 'l3-go:multi' .
	docker images 'l3-go:multi'

	git add .
	git commit -m "l3-go:multi"
}

function main {
	docker system prune -a
	load_base_images
	
	reset_folder

	build_single
	build_multi
	build_distroless
}

main

