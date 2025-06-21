FROM docker.io/nvidia/cuda:12.9.0-base-ubuntu24.04

ARG DEPENDENCIES="  \
    ca-certificates \
    libsox-dev \
    build-essential \
    cmake \
    libasound-dev \
    portaudio19-dev \
    libportaudio2 \
    libportaudiocpp0 \
    ffmpeg \
    python3-dev"  # <-- Added python3-dev for torch.compile

WORKDIR /opt/fish-speech

# Install system dependencies
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    set -ex \
    && apt-get update \
    && apt-get -y install --no-install-recommends python3 python3-pip python3-venv ${DEPENDENCIES} \
    && rm -rf /var/lib/apt/lists/*

COPY . .

# Install Python dependencies
RUN --mount=type=cache,target=/root/.cache,sharing=locked \
    set -ex \
    && pip3 install --break-system-packages torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128 \
    && pip3 install --break-system-packages -e .[stable]

ENV GRADIO_SERVER_NAME="0.0.0.0"

EXPOSE 7860

CMD ["./entrypoint.sh"]