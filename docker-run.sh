#!/bin/bash

source banner.sh

echo "Default quantized HF model url: $MODEL_URL. Change MODEL_URL env variable value to load your favorite model"

# Extract the model name
export MODEL_NAME=$(echo $MODEL_URL | awk -F'/' '{print $NF}')

# If available locally, load the quantized model in your mounted directory --> If LOAD_MODEL is set, update MODEL_NAME and attach LOAD_MODEL to a volume
if [ -n "$LOAD_MODEL" ]; then \
    cd ./models # volume path
    echo "Using custom model: $LOAD_MODEL"; \
    export MODEL_NAME=$LOAD_MODEL; \
else \
    echo "Using url of a quantized HF model: $MODEL_NAME"; \
    # Download model file from url
    sh init-script.sh $MODEL_NAME $MODEL_URL

fi

# List of lowercase arguments for the LLM available at https://llama-cpp-python.readthedocs.io/en/latest/api-reference/
args=("n_gpu_layers" "n_ctx" "n_batch" "main_gpu" "embedding" "n_threads" "n_threads_batch" "rope_scaling_type" "rope_freq_base" "rope_freq_scale" "mul_mat_q" "f16_kv" "logits_all" "last_n_tokens_size" "lora_base" "lora_path" "numa" "chat_format" "chat_handler" "verbose")

# Build and execute the command
command="python3 -m llama_cpp.server --host 0.0.0.0 --port 8000 --model $MODEL_NAME"

# Handling the provision of additional parameters in the command
for arg in "${args[@]}"; do
    # Automatically creates environment variables associated with uppercase LLM arguments
    arg_uppercase="${arg^^}"
    export "$arg_uppercase"

    # Indirect access in the condition to retrieve the associated uppercase environment variable
    if [ -n "${!arg_uppercase}" ]; then
        command+=" --$arg \$${arg_uppercase}"
        echo "${!arg_uppercase}"
    fi
done

# Exécuter la commande
eval "echo $command"
eval $command
