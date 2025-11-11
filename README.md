# TP-Cka



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