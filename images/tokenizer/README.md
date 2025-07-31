# Run as root
$ podman build --format docker . -t 10.42.145.151:5000/nltk-tokenizer:latest
$ podman push 10.42.145.151:5000/nltk-tokenizer:latest

# Or is using self-signed certificates
$ podman push 10.43.17.109:5000/nltk-tokenizer:latest --tls-verify=false