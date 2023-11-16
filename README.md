# SSP-LLM
Deploying open source LLM for ulterior motives

Effortlessly deploy a local OpenAI-compatible API server for GGUF models with this Docker image. Simply provide the download link of your model or specify the path to the downloaded model by mounting the volume. All model parameters available on Llama CPP Python are supported in this image. Additionally, unlike Llama CPP Python, this image is GPU-compatible, provided that the NVIDIA Container Toolkit is installed