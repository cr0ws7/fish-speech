#!/bin/bash

CUDA_ENABLED=${CUDA_ENABLED:-true}
DEVICE=""
HALF=""

if [ "${CUDA_ENABLED}" != "true" ]; then
    DEVICE="--device cpu"
else
    HALF="--half"
fi

exec "$(command -v python3 || command -v python)" tools/run_webui.py \
    ${DEVICE} ${HALF}