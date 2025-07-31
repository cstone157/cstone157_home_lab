# Need to update the openssl.cnf to include a subjectAltName = IP:<ip of registry server>

openssl req -newkey rsa:2048 -nodes -keyout registry_auth.key -x509 -days 365 -out registry_auth.crt
kubectl create secret tls registry-tls --key registry_auth.key --cert registry_auth.crt -n=lab-test


1. Create TLS Certificates
2. Create Kubernetes Secret
3. Create Persistent Volume Claim
4. Apply the YAML
