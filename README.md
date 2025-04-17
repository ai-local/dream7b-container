This repository contains a Containerfile to build and run a container with the Dream 7B diffusion large language model (https://github.com/HKUNLP/Dream)

For use with an NVIDIA GPU with the NVIDIA container toolkit installed and configured for use with Podman.

Clone this repository: `git clone https://github.com/ai-local/dream7b-container.git`

If running rootless Podman, enable the container_use_devices SELinux boolean: `sudo setsebool -P container_use_devices=true`

Build container with:  `podman build --device nvidia.com/gpu=all . -t dream7b`

Run container with:  `podman run --device nvidia.com/gpu=all -p 7860:7860 --name dream7b dream7b`

Then use a web browser to connect to port 7860 to access the Gradio web interface

Tips: 
- I've found that setting the temperature to .4 generally improves results
- The higher the diffusion steps, the slower it is, but it will generally have improved results
- Set max new tokens based on the size of the output you would like to see
- Try out the various algorithm's, I've seen good results with `origin` and `entropy`
