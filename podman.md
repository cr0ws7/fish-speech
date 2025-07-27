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

# Test CUDA
podman run --rm --device nvidia.com/gpu=all docker.io/nvidia/cuda:12.8.0-base-ubuntu24.04 nvidia-smi

## Troubleshooting
### Error: setting up CDI devices: failed to inject devices: failed to stat CDI host device "/dev/nvidia-uvm": no such file or directory
Ensure cdi contains a valid CDI spec referencing all necessary devices, including nvidia-uvm.
You can inspect the generated file:
Look for entries like /dev/nvidia-uvm and /dev/nvidia-uvm-tools.
Regenerate CDI Spec:

Try regenerating the CDI spec to ensure all devices are included:
sudo nvidia-ctk cdi generate --output=/etc/cdi/

### Error: crun: cannot stat `/usr/lib/x86_64-linux-gnu/libEGL_nvidia.so.570.169`: No such file or directory

This means your NVIDIA driver version is newer than what the container expects.

**Fix:**  
Create a symlink from your installed version to the missing one:
```sh
sudo ln -s /usr/lib/x86_64-linux-gnu/libEGL_nvidia.so.570.172.08 /usr/lib/x86_64-linux-gnu/libEGL_nvidia.so.570.169
```
Then re-run your Podman command.

If you see similar errors for other NVIDIA libraries (e.g. `libGLESv1_CM_nvidia.so.570.169`),  
create a symlink from your installed version to the missing one:
```sh
sudo ln -s /usr/lib/x86_64-linux-gnu/libGLESv1_CM_nvidia.so.570.172.08 /usr/lib/x86_64-linux-gnu/libGLESv1_CM_nvidia.so.570.169
```
Repeat for any other missing `.570.169` NVIDIA libraries.

# podman GPU NVIDIA container support
podman run --rm --device nvidia.com/gpu=all -it -p 7860:7860 fish-speech


# if not yet renamed
mv dockerfile Dockerfile

podman build -t fish-speech .
podman run --rm --device nvidia.com/gpu=all -it -p 7860:7860 fish-speech

# create a quantized model version
python3 ./tools/llama/quantize.py --mode="int4" --checkpoint-path="checkpoints/openaudio-s1-mini"

copy the codec.pth