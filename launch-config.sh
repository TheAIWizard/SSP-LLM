#!/bin/bash

# Set the base directory: repo name
BASE_DIR="SSP-LLM"
# Extract the model URL on TheBloke HF website
MODEL_URL="https://huggingface.co/TheBloke/zephyr-7B-beta-GGUF/resolve/main/zephyr-7b-beta.Q8_0.gguf"
# Extract the model name
MODEL_NAME=$(echo "$MODEL_URL" | awk -F'/' '{print $NF}')


# Function to run commands with error handling
run_command() {
  echo "Running: $*"
  "$@" || exit 1
}

# Change to the base directory
cd "$BASE_DIR" || exit

# config
run_command python3 -m venv .venv
source .venv/bin/activate
run_command pip install -r requirements.txt
export CUDA_HOME=/usr/local/cuda
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
export PATH=$PATH:$CUDA_HOME/bin
[ -d "llama-cpp-python" ] || run_command git clone --recurse-submodules https://github.com/abetlen/llama-cpp-python.git
# Locate to llama-cpp-python project
cd "llama-cpp-python" || exit
run_command pip uninstall -y llama-cpp-python
CMAKE_ARGS="-DLLAMA_CUBLAS=on" FORCE_CMAKE=1 pip install -e .[server] --no-cache-dir

# Go back to last directory
cd - || exit
# download model file
run_command sh k8s/init-script.sh $MODEL_NAME $MODEL_URL
#python3 k8s/download-model.py $MODEL_NAME $MODEL_URL

# execute llama cpp python
#cd "llama-cpp-python" || exit
run_command python3 -m llama_cpp.server --model ~/work/$BASE_DIR/$MODEL_NAME --n_gpu_layers 35
