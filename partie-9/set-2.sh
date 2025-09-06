#!/bin/bash

## 4. Pod issue

kubectl create ns cka-pod-error || true

cat <<EOF | kubectl apply -n cka-pod-error -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: failing-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: failing-app
  template:
    metadata:
      labels:
        app: failing-app
    spec:
      containers:
      - name: nginx
        image: nginx:1.29-alpine
        ports:
        - containerPort: 8080
        resources:
          limits:
            memory: 6Mi
        livenessProbe:
          httpGet:
            path: /
            port: 8800
          initialDelaySeconds: 15
          periodSeconds: 10
EOF