#!/bin/sh

# Extract the model URL on TheBloke HF website
MODEL_URL="$1"
# Extract additional variables
N_GPU_LAYERS=${2:-35}
N_CTXT=${3:-3000}
N_BATCH=${4:-$512}
MAIN_GPU=${5:-$0}
EMBEDDING=${6:-$False}

# Extract the model name
#MODEL_NAME=$(echo "$MODEL_URL" | awk -F'/' '{print $NF}')

# If LOAD_MODEL is set, update MODEL_NAME and attach LOAD_MODEL to a volume
if [ -n "$LOAD_MODEL" ]; then \
    echo "Using custom model: $LOAD_MODEL"; \
    export MODEL_NAME=$LOAD_MODEL; \
    echo $LOAD_MODEL; \
else \
    echo "Using default model: $MODEL_NAME"; \
    # Download model file from url
    sh init-script.sh $MODEL_NAME $MODEL_URL
fi

python3 -m llama_cpp.server --model /models/$MODEL_NAME --n_gpu_layers $N_GPU_LAYERS --n_ctxt $N_CTXT --n_batch $N_BATCH --main_gpu $MAIN_GPU --embedding $EMBEDDING