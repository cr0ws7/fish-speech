pip install -U "huggingface_hub[cli]"

huggingface-cli download fishaudio/fish-speech-1.5 --local-dir checkpoints/fish-speech-1.5

huggingface-cli download fishaudio/openaudio-s1-mini --local-dir checkpoints/openaudio-s1-mini

https://docs.nvidia.com/ai-enterprise/deployment/rhel-with-kvm/latest/podman.html
´´´curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
´´´

sudo apt-get update

sudo apt-get install -y nvidia-container-toolkit

sudo nvidia-ctk cdi generate --output=/etc/cdi/

# Check podman GPU NVIDIA container support
podman run --rm --device nvidia.com/gpu=all -it -p 7860:7860 fish-speech

# Test CUDA
podman run --rm --device nvidia.com/gpu=all docker.io/nvidia/cuda:12.9.0-base-ubuntu24.04 nvidia-smi

mv dockerfile Dockerfile
podman build -t fish-speech .
podman run --rm --device nvidia.com/gpu=all -it -p 7860:7860 fish-speech