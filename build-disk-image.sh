#!/bin/bash



docker run \
       	-it \
       	--privileged \
       	--security-opt label=type:unconfined_t \
	-v $(pwd)/config.toml:/config.toml:ro \
	-v $(pwd)/output:/output \
       	quay.io/centos-bootc/bootc-image-builder:latest \
	--type qcow2 \
	--rootfs ext4 \
        quay.io/bpradipt/podvm-bootc:latest
