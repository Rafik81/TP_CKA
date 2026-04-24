
> **Backup**

```shell
ETCDCTL_API=3 etcdctl snapshot save  /tmp/etcd-backup.db \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key
```

`k -n default run etcd-before-restore --image=nginx:1.29-alpine`


>  **Restore**

```shell
cd /etc/kubernetes/manifests/
mv *.yaml ..
watch crictl ps
################# attendre que les composants disparaissent du crictl ps
###### si besoin d'accelerer: systemctl restart kubelet

# Penser à changer l'IP 172.19.0.11 -- avec l'IP de votre control-plane
## voir le kube-apiserver.yaml - ligne advertise si besoin
ETCDCTL_API=3 etcdctl snapshot restore  /tmp/etcd-backup.db --data-dir /var/lib/etcd-backup \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
--initial-cluster=back-rest-control-plane=https://172.19.0.11:2380 \
--initial-advertise-peer-urls=https://172.19.0.11:2380 \
--name back-rest-control-plane


apt install -y vim
vim ../etcd.yaml


mv ../*.yaml .
watch crictl ps

```