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
MODEL_NAME=$(echo "$MODEL_URL" | awk -F'/' '{print $NF}')

# Run your commands with arguments
sh init-script.sh $MODEL_NAME $MODEL_URL $N_CTXT $N_BATCH $MAIN_GPU $EMBEDDING
python3 -m llama_cpp.server --model /app/$MODEL_NAME --n_gpu_layers $N_GPU_LAYERS
