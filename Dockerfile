# Use the InseeFrLab Python image with pytorch and GPU integration as the base image
FROM inseefrlab/onyxia-vscode-pytorch:py3.11.4-gpu

# Set the working directory
WORKDIR /app

# Copy the local requirements.txt to the container
COPY requirements.txt /app
# Copy the initialization script to download the raw model from HF to the container
COPY k8s/init-script.sh /app

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

# Set arguments as environment variables
ENV MODEL_URL=${MODEL_URL}
ENV MODEL_NAME=${MODEL_NAME}
# Set other environment variables to specify the model
ENV N_GPU_LAYERS N_CTXT N_BATCH MAIN_GPU EMBEDDING

# Mount/Load the model in container if the user wants to load his model on local and not url
COPY $MODEL_NAME /app

# Clone the llama-cpp-python repository
RUN git clone --recurse-submodules https://github.com/abetlen/llama-cpp-python.git

# Install llama-cpp-python with specific options
WORKDIR /app/llama-cpp-python
RUN pip uninstall -y llama-cpp-python && \
    CMAKE_ARGS="-DLLAMA_CUBLAS=on" FORCE_CMAKE=1 pip install -e .[server] --no-cache-dir

# Set the working directory back to /app
WORKDIR /app

# Copy the remaining files from the local directory to the container
COPY .venv /app
COPY entrypoint.sh /app

# Entrypoint script to execute the commands with arguments
ENTRYPOINT ["./entrypoint.sh","$MODEL_URL","$N_GPU_LAYERS","$N_CTXT","$N_BATCH","$MAIN_GPU","$EMBEDDING"]