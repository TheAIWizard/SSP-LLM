#!/bin/sh

# Extract the model URL on TheBloke HF website
MODEL_URL="$1"
# Extract additional variables
N_GPU_LAYERS="$2"
N_CTXT="$3"
N_BATCH="$4"
MAIN_GPU="$5"
EMBEDDING="$6"

# Extract the model name
#MODEL_NAME=$(echo "$MODEL_URL" | awk -F'/' '{print $NF}')

# Run your commands with arguments
sh init-script.sh $MODEL_NAME $MODEL_URL
python3 -m llama_cpp.server --model /app/$MODEL_NAME --n_gpu_layers $N_GPU_LAYERS --n_ctxt $N_CTXT --n_batch $N_BATCH --main_gpu $MAIN_GPU --embedding $EMBEDDING
