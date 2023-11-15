#!/bin/sh

echo "Default quantized HF model url: $MODEL_URL"

# Set default values for parameters
export N_GPU_LAYERS=5
export N_CTX=3333
export N_BATCH=512
export MAIN_GPU=0
export EMBEDDING=False

# Extract the model name
export MODEL_NAME=$(echo $MODEL_URL | awk -F'/' '{print $NF}')

# If available locally, load the quantized model in your mounted directory --> If LOAD_MODEL is set, update MODEL_NAME and attach LOAD_MODEL to a volume
if [ -n "$LOAD_MODEL" ]; then \
    cd ./models # volume path
    pwd
    ls -f $LOAD_MODEL
    echo "Using custom model: $LOAD_MODEL"; \
    export MODEL_NAME=$LOAD_MODEL; \
    echo $LOAD_MODEL; \
    echo $N_GPU_LAYERS; \
    echo $N_CTX; \
else \
    echo "Using url of a quantized HF model: $MODEL_NAME"; \
    ls -d ./models
    ls
    # Download model file from url
    sh init-script.sh $MODEL_NAME $MODEL_URL

fi
ls
pwd
python3 -m llama_cpp.server --model $MODEL_NAME --n_gpu_layers $N_GPU_LAYERS --n_ctx $N_CTX --n_batch $N_BATCH --main_gpu $MAIN_GPU --embedding $EMBEDDING