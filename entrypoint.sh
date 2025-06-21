#!/bin/bash

CUDA_ENABLED=${CUDA_ENABLED:-true}
DEVICE=""
HALF=""
COMPILE="--compile"

if [ "${CUDA_ENABLED}" != "true" ]; then
    DEVICE="--device cpu"
    COMPILE=""  # Don't use --compile on CPU
else
    HALF="--half"
fi

exec "$(command -v python3 || command -v python)" tools/run_webui.py \
    ${DEVICE} ${HALF} ${COMPILE}