import os
# config
os.system('cd SSP-LLM/ && python3 -m venv .venv')
os.system('cd SSP-LLM/ && source .venv/bin/activate')
os.system('cd SSP-LLM/ && pip install -r requirements.txt')
os.system('export CUDA_HOME=/usr/local/cuda')
os.system('export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64')
os.system('export PATH=$PATH:$CUDA_HOME/bin')
os.system('cd SSP-LLM/ && git clone --recurse-submodules https://github.com/abetlen/llama-cpp-python.git')
os.system('pip uninstall -y llama-cpp-python')
os.system('cd llama-cpp-python/&& CMAKE_ARGS="-DLLAMA_CUBLAS=on" FORCE_CMAKE=1 pip install -e .[server] --no-cache-dir')
# download model file
os.system('cd SSP-LLM/ && sh k8s/init-script.sh')
# execute llama cpp python
os.system('cd .. && python3 -m llama_cpp.server --model zephyr-7b-beta.Q8_0.gguf')

