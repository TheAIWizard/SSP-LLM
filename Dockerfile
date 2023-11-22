# Use the InseeFrLab Python image with pytorch and GPU integration as the base image
FROM inseefrlab/onyxia-vscode-pytorch:py3.11.4-gpu

# Manage rights for k8s
#USER root   

# Bind to a port
EXPOSE 8000

# Set the working directory
WORKDIR /app

# Copy the local requirements.txt to the container
COPY requirements.txt /app
# Copy the initialization script to download the raw model from HF to the container
# If you want to access to the VScode service on Onyxia and deploy this docker image with Kubernetes, you can use the k8s files
COPY k8s /app
COPY templates/banner.sh /app


# Install virtual environment and dependencies
RUN python3 -m venv .venv && \
    . .venv/bin/activate && \
    pip install -r requirements.txt

# Set environment variables
ENV CUDA_HOME /usr/local/cuda
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/cuda/lib64
ENV PATH $PATH:$CUDA_HOME/bin

# Extract the model URL on TheBloke HF website (default URL)
ARG MODEL_URL=
# Extract the model name
#ARG MODEL_NAME=$(echo "$MODEL_URL" | awk -F'/' '{print $NF}')

# Set arguments as environment variables
ENV MODEL_URL=${MODEL_URL}
#ENV MODEL_NAME=${MODEL_NAME}

# Mount/Load the model in container if the user wants to load his model on local and not url
ENV LOAD_MODEL=
# Create /app/volume directory
RUN mkdir -p ./models
# Create a named volume and mount it at /app/models
VOLUME /app/models

# Clone the llama-cpp-python repository
RUN git clone --recurse-submodules https://github.com/abetlen/llama-cpp-python.git

# Install llama-cpp-python with specific options
WORKDIR /app/llama-cpp-python
RUN pip uninstall -y llama-cpp-python && \
    CMAKE_ARGS="-DLLAMA_CUBLAS=on" FORCE_CMAKE=1 pip install -e .[server] --no-cache-dir

# Set the working directory back to /app
WORKDIR /app

# Copy the entry point script from the local directory to the container
COPY docker-run.sh /app
#RUN chmod +x docker-run.sh
# Launch script to execute the commands with optional arguments
ENTRYPOINT ["bash","./docker-run.sh" ]
