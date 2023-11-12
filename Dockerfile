# Use the InseeFrLab Python image with pytorch and GPU integration as the base image
FROM inseefrlab/onyxia-vscode-pytorch:py3.11.4-gpu

# Set the working directory
WORKDIR /app

# Copy the local requirements.txt to the container
COPY requirements.txt .
# Copy the initialization script to download the raw model from HF to the container
COPY k8s/init-script.sh .

# Install virtual environment and dependencies
RUN python3 -m venv .venv && \
    . .venv/bin/activate && \
    pip install -r requirements.txt

# Set environment variables
ENV CUDA_HOME /usr/local/cuda
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/cuda/lib64
ENV PATH $PATH:$CUDA_HOME/bin

# Extract the model URL on TheBloke HF website
ARG MODEL_URL="https://huggingface.co/TheBloke/zephyr-7B-beta-GGUF/resolve/main/zephyr-7b-beta.Q8_0.gguf"
# Extract the model name
ARG MODEL_NAME=$(echo "$MODEL_URL" | awk -F'/' '{print $NF}')

# Clone the llama-cpp-python repository
RUN git clone --recurse-submodules https://github.com/abetlen/llama-cpp-python.git

# Install llama-cpp-python with specific options
WORKDIR /app/llama-cpp-python
RUN pip uninstall -y llama-cpp-python && \
    CMAKE_ARGS="-DLLAMA_CUBLAS=on" FORCE_CMAKE=1 pip install -e .[server] --no-cache-dir

# Set the working directory back to /app
WORKDIR /app

# Copy the remaining files from the local directory to the container
COPY .venv .
COPY entrypoint.sh .

# Entrypoint script to execute the commands with arguments
ENTRYPOINT ["./entrypoint.sh"]