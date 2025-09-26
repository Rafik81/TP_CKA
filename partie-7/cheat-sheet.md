## storage

> storageclass


```shell

# StorageClass

cat <<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: asap-sc
provisioner: kubernetes.io/no-provisioner
reclaimPolicy: Delete
volumeBindingMode: Immediate
allowVolumeExpansion: true
EOF

# PV HostPath
cat <<EOF | kubectl apply -f -
kind: PersistentVolume
apiVersion: v1
metadata:
 name: safari-pv
spec:
 capacity:
  storage: 128Mi
 accessModes:
  - ReadWriteOnce
 hostPath:
  path: "/tmp/data"
EOF

## PV qui herite du PV

cat <<EOF | kubectl apply -f -
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: safari-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
     storage: 128Mi
EOF

## PVC shared-volume
cat <<EOF | kubectl apply -f -
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
 name: shared-volume
spec:
 storageClassName: standard
 resources:
  requests:
   storage: 128Mi
 accessModes:
  - ReadWriteOnce
EOF

```

> StatefulSet volumeclaimtemplate

https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/

```shell

cat <<EOF|kubectl apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: "nginx"
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.29-alpine
        ports:
        - containerPort: 80
          name: web
        volumeMounts:
        - name: www
          mountPath: /usr/share/nginx/html
  volumeClaimTemplates:
  - metadata:
      name: www
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: standard
      resources:
        requests:
          storage: 64Mi

EOF