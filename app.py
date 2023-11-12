
import os
# download model file
os.system('sh k8s/init-script.sh')
# execute llama cpp python
os.system('python3 -m llama_cpp.server --model zephyr-7b-beta.Q8_0.gguf')

