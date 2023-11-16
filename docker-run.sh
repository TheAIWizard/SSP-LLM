#!/bin/sh

echo "Default quantized HF model url: $MODEL_URL"

# Set default values for parameters
export N_GPU_LAYERS=0
export N_CTX=3000
export N_BATCH=512
export MAIN_GPU=0
export EMBEDDING=False
#export TENSOR_SPLIT=None
export VOCAB_ONLY=False
export USE_MMAP=True
export USE_MLOCK=False
#export SEED=LLAMA_DEFAULT_SEED
#export N_THREADS=None
#export N_THREADS_BATCH=None
#export ROPE_SCALING_TYPE=LLAMA_ROPE_SCALING_UNSPECIFIED
export ROPE_FREQ_BASE=0.0
export ROPE_FREQ_SCALE=0.0
export MUL_MAT_Q=True
export F16_KV=True
export LOGITS_ALL=False
export LAST_N_TOKENS_SIZE=64
#export LORA_BASE=None
#export LORA_PATH=None
export NUMA=False
export CHAT_FORMAT=llama-2
#export CHAT_HANDLER=None
export VERBOSE=True

# Extract the model name
export MODEL_NAME=$(echo $MODEL_URL | awk -F'/' '{print $NF}')

# If available locally, load the quantized model in your mounted directory --> If LOAD_MODEL is set, update MODEL_NAME and attach LOAD_MODEL to a volume
if [ -n "$LOAD_MODEL" ]; then \
    cd ./models # volume path
    echo "Using custom model: $LOAD_MODEL"; \
    export MODEL_NAME=$LOAD_MODEL; \
else \
    echo "Using url of a quantized HF model: $MODEL_NAME"; \
    ls -d ./models
    ls
    # Download model file from url
    sh init-script.sh $MODEL_NAME $MODEL_URL

fi

#full param:python3 -m llama_cpp.server --host 0.0.0.0 --port 8000 --model $MODEL_NAME --n_gpu_layers $N_GPU_LAYERS --n_ctx $N_CTX --n_batch $N_BATCH --main_gpu $MAIN_GPU --embedding $EMBEDDING --n_threads $N_THREADS --n_threads_batch $N_THREADS_BATCH --rope_scaling_type $ROPE_SCALING_TYPE --rope_freq_base $ROPE_FREQ_BASE --rope_freq_scale $ROPE_FREQ_SCALE --mul_mat_q $MUL_MAT_Q --f16_kv $F16_KV --logits_all $LOGITS_ALL --last_n_tokens_size $LAST_N_TOKENS_SIZE --lora_base $LORA_BASE --lora_path $LORA_PATH --numa $NUMA --chat-format $CHAT_FORMAT --chat_handler $CHAT_HANDLER --verbose $VERBOSE
python3 -m llama_cpp.server --host 0.0.0.0 --port 8000 --model $MODEL_NAME --n_gpu_layers $N_GPU_LAYERS --n_ctx $N_CTX --n_batch $N_BATCH --main_gpu $MAIN_GPU --embedding $EMBEDDING --rope_freq_base $ROPE_FREQ_BASE --rope_freq_scale $ROPE_FREQ_SCALE --mul_mat_q $MUL_MAT_Q --f16_kv $F16_KV --logits_all $LOGITS_ALL --last_n_tokens_size $LAST_N_TOKENS_SIZE --numa $NUMA --chat_format '$CHAT_FORMAT' --verbose $VERBOSE