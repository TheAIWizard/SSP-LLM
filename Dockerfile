FROM inseefrlab/onyxia-vscode-pytorch:py3.11.4-gpu

WORKDIR /app

# Copy the scripts and requirements
COPY launch-config.sh .
COPY your_python_script.sh .
COPY k8s/init-script.sh .
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set the environment variable for --model
ENV MODEL_NAME="zephyr-7b-beta.Q8_0.gguf"

# Run the config script
RUN ./config-script.sh

# Command to run your Python script
CMD ["./your_python_script.sh"]