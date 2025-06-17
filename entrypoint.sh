#!/bin/bash

CUDA_ENABLED=${CUDA_ENABLED:-true}
DEVICE=""

LLAMA_CHECKPOINT_PATH="checkpoints/openaudio-s1-mini-int8"
DECODER_CHECKPOINT_PATH="checkpoints/openaudio-s1-mini-int8/codec.pth"

if [ "${CUDA_ENABLED}" != "true" ]; then
    DEVICE="--device cpu"
fi

exec "$(command -v python3 || command -v python)" tools/run_webui.py \
    --llama-checkpoint-path "${LLAMA_CHECKPOINT_PATH}" \
    --decoder-checkpoint-path "${DECODER_CHECKPOINT_PATH}" \
    ${DEVICE}
