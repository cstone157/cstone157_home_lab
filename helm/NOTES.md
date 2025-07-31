## Creating secrets

    - This helm chart uses Secrets to populate the initial username/password of the different services the expected secret structure is
    - From command: <code>$ kubectl create secret generic lab-secrets --from-literal=db-admin-password="your_strong_password"</code>

apiVersion: v1
kind: Secret
metadata:
  name: stone-data-lake-secret
  namespace: stone-data-lake
  labels:
    app: postgres
type: Opaque
data:
    postgres_root_username: ${postgres_root_username_b64}
    postgres_root_password: ${postgres_root_password_b64}