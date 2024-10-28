# Introduction

Build podvm image using bootc

```bash
export BOOTC_IMAGE=quay.io/bpradipt/podvm-bootc

podman build -t $BOOTC_IMAGE -f Dockerfile .

podman push $BOOTC_IMAGE
```

Create qcow2 image

```bash
./build-disk-image.sh
```

If you want to build image using NVIDIA driver, then
use `Dockerfile.nvidia` to build the bootc image
