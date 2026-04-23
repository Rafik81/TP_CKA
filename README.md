# TP-Cka

## Rate-Limiting

Se connecter sur les nodes workers (à minima):

`vim /etc/containerd/config.toml`

Insérer ce bloc en bas du fichier

```shell
    [plugins."io.containerd.grpc.v1.cri".registry]
        [plugins."io.containerd.grpc.v1.cri".registry.configs."registry-1.docker.io".auth]
            username = "zabradocker"
            password = "dckr_pat_xcnAbzdZ523FNwWVLy1Q_owJVR8"
            auth = ""
            identitytoken = ""
```

Ensuite restart **containerd** : `systemctl restart containerd`


## Alias

```shell
alias k=kubectl  # présent par défaut
alias ky="kubectl get -o yaml"
alias kd="kubectl describe"
alias kl="kubectl logs"

export do="--dry-run=client -o yaml"
#ex:  k create deploy nginx --image=nginx $do
export now="--force --grace-period 0"
# ex: k delete pod x $now

# CONFIGURATION VIM pour els copier-coller
vim ~/.vimrc
set tabstop=2
set expandtab
set shiftwidth=2
```

## Metric Server

- https://github.com/kubernetes-sigs/metrics-server
- https://github.com/kubernetes-sigs/metrics-server/releases/tag/v0.8.0

```shell
# non-HA
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.8.0/components.yaml

# SI erreur: tls: failed to verify certificate: x509: cannot validate certificate for 172.18.0.9 because it doesn't contain any IP SANs"

# ajouter: - --kubelet-insecure-tls
#  à la liste des arguments du deployment
k -n kube-system edit deploy metrics-server
```