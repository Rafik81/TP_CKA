#!/bin/bash

kubectl  --context kind-k8s-c1-h create ns project-sts-app
kubectl  --context kind-k8s-c1-h create ns live

cat <<EOF | kubectl  --context kind-k8s-c1-h apply -n project-sts-app -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  creationTimestamp: null
  labels:
    app: stsapp
  name: stsapp
  namespace: project-sts-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: stsapp
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: stsapp
    spec:
      containers:
      - image: nginx
        name: nginx
        resources: {}
EOF


cat <<EOF | kubectl  --context kind-k8s-c1-h apply -n live -f -
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    id: cka-training-ready
  name: service-am-i-ready
  namespace: live
spec:
  ports:
  - name: "80"
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    id: cka-training-ready
  type: ClusterIP
EOF


cat > /tmp/secret-toto.yaml <<EOF
apiVersion: v1
apiVersion: v1
data:
  formateur: U0tPTkU=
  formation: Y2th
kind: Secret
metadata:
  creationTimestamp: null
  name: secret-toto
EOF

cat > /tmp/secret-env.txt <<EOF
goal=Become a CKA
achieve=CKA certification
EOF

cat > /tmp/configmap-data.txt <<EOF
I am a simple text file
Use me to test ConfigMap volume mounts
I can have multiple lines
Each line is separated by a newline character
Good luck! May the code be with you!
EOF