# Use the InseeFrLab Python image with pytorch and GPU integration as the base image
# fix avouacr: inseefrlab/onyxia-python-minimal:py3.11.4
FROM inseefrlab/onyxia-python-minimal:py3.11.4

EXPOSE 8000

# Set environment variables
ENV CUDA_HOME /usr/local/cuda
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/cuda/lib64
ENV PATH $PATH:$CUDA_HOME/bin

# Install dependencies
COPY requirements.txt .
RUN python3 -m venv .venv && \
    source  .venv/bin/activate && \
    pip install -r requirements.txt

# Install llama-cpp-python from source
RUN git clone --recurse-submodules https://github.com/abetlen/llama-cpp-python.git && \
    cd llama-cpp-python && \
    CMAKE_ARGS="-DLLAMA_CUBLAS=on" FORCE_CMAKE=1 pip install -e .[server] --no-cache-dir

# Copy the entry point script from the local directory to the container
COPY k8s/init-script.sh .
COPY templates/banner.sh .
COPY docker-run.sh .

CMD ["./docker-run.sh" ]
