FROM quay.io/centos/centos:stream9
RUN dnf install -y git python3.12 python3.12-devel python3.12-pip 

WORKDIR /
RUN git clone https://github.com/HKUNLP/Dream
WORKDIR /Dream
RUN pip3.12 install transformers==4.46.2
RUN pip3.12 install torch==2.5.1 torchvision==0.20.1 torchaudio==2.5.1 --index-url https://download.pytorch.org/whl/cu124
RUN pip3.12 install gradio

# float32 wouldn't run on my system with 24GB VRAM, so updating this to bfloat16 in app.py:
RUN sed -i 's/dtype = torch.float32/dtype = torch.bfloat16/g' app.py

# I'm not using the Gradio share link functionality, so disable it: 
RUN sed -i 's/launch(share=True/launch(share=False/g' app.py

# This is running in a container, listen on 0.0.0.0 to enable communication outside the container
ENV GRADIO_SERVER_NAME="0.0.0.0"

ENTRYPOINT ["python3.12", "app.py"]

# If running rootless Podman, enable the container_use_devices SELinux boolean:  sudo setsebool -P container_use_devices=true
# Build with:  podman build --device nvidia.com/gpu=all . -t dream7b
# Run with:  podman run --device nvidia.com/gpu=all -p 7860:7860 --name dream7b dream7b
