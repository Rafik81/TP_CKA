#!/bin/bash

## 5. Deployment issue

kubectl config use-context  kind-k8s-no-cni

kubectl create ns failed-deploy || true

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-configmap
  namespace: failed-deploy
data:
  nginx.conf: |
    server {
        listen 80;
        server_name localhost;

        location / {
            root /usr/share/nginx/html;
            index index.html;
        }
    }
EOF

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: failed-deploy
  namespace: failed-deploy
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - image: nginx:1.29-alpine
        name: nginx-container
        ports:
        - containerPort: 80
          protocol: TCP
        resources: {}
      initContainers:
      - command:
        - shell
        - echo 'Forcement, je marche moins bien avec cette syntaxe!'
        image: busybox:1.36
        name: init-container
        resources: {}
        volumeMounts:
        - mountPath: /etc/nginx/nginx.conf
          name: nginx-config
      volumes:
      - configMap:
          name: nginx-configuration
        name: nginx-config
EOF


## 7. Redis Pod Issue

kubectl create ns debug-redis || true

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: redis-pvc
  namespace: debug-redis
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 80Mi
  storageClassName: standard
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: redis-pod
  namespace: debug-redis
spec:
  containers:
  - image: redis:latested
    imagePullPolicy: IfNotPresent
    name: redis-container
    ports:
    - containerPort: 6379
      name: redis
      protocol: TCP
    resources: {}
    volumeMounts:
    - mountPath: /data
      name: redis-data
  volumes:
  - name: redis-data
    persistentVolumeClaim:
      claimName: pvc-redis
EOF

## 8. Another Pod Issue

kubectl create ns another-issue || true

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: app-frontend
  namespace: another-issue
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: NodeName
            operator: In
            values:
            - frontend
  containers:
  - image: nginx:1.29-alpine
    imagePullPolicy: Always
    name: web
EOF


## 10. Issue Pod PVC
kubectl create ns my-pod-cka || true

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: my-pv-cka
spec:
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: 100Mi
  hostPath:
    path: /mnt/data
    type: ""
  storageClassName: standard
  volumeMode: Filesystem
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc-cka
  namespace: my-pod-cka
spec:
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 100Mi
  storageClassName: standard
  volumeMode: Filesystem
  volumeName: my-pv-cka
EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: my-pod-cka
  namespace: my-pod-cka
spec:
  containers:
  - image: nginx:1.29-alpine
    name: nginx-container
    resources: {}
    volumeMounts:
    - mountPath: /var/www/html
      name: shared-storage
  volumes:
  - name: shared-storage
    persistentVolumeClaim:
      claimName: my-pvc-cka
EOF

## 12. Deployement Issue - postgres

kubectl create ns fix-postgres || true

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: postgres-secret
  namespace: fix-postgres
data:
  password: Y2thLXRyYWluaW5n
  username: Y2R0emFicmE=

type: Opaque
EOF

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres-deployment
  namespace: fix-postgres
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
        - name: postgres-container
          image: postgres:13.22-alpine
          env:
            - name: POSTGRES_DB
              value: mydatabase
            - name: POSTGRES_USER
              valueFrom:
                secretKeyRef:
                  name: postgres-secrte
                  key: db_user
            - name: POSTGRES_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: postgres-secret
                  key: db_password
          ports:
            - containerPort: 5432
EOF

## 14. Cronjob Issue

kubectl create ns failed-cron-job || true

kubectl -n failed-cron-job run cka-cron-pod --image=nginx:1.29-alpine --labels="id=cka-training-ready"

cat <<EOF | kubectl apply -f -
apiVersion: batch/v1
kind: CronJob
metadata:
  name: cka-failed-cronjob
  namespace: failed-cron-job
spec:
  concurrencyPolicy: Allow
  failedJobsHistoryLimit: 3
  successfulJobsHistoryLimit: 3
  schedule: '*/3 * * * *'
  suspend: false
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - command:
            - curl
            - cka-cron-pod
            image: curlimages/curl:latest
            imagePullPolicy: Always
            name: curl-container
            resources: {}
          restartPolicy: Never

EOF

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: cka-cron-pod 
  name: cka-cron-svc
  namespace: failed-cron-job
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: cka-cron-pod 
EOF