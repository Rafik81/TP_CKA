# TP-CKA

## Rate-Limiting


Il faut patcher le fichier `/etc/containerd/config.toml` afin d'y ajouter un credential d'authentification


> **Avec le script**

```shell
export REGISTRY_USER="zabradocker"
export REGISTRY_PASS="dckr_pat_8UI3-EtdBMqQ_tuazKeTYclFAL0"
wget https://gitlab.enoks.fr/pub/scripts/-/raw/master/scripts/patch-cri.sh
bash patch-cri.sh
```

> **Manuellement**

Se connecter sur chacun des nodes concernés:

`vim /etc/containerd/config.toml`

Insérer ce bloc en bas du fichier

```shell
    [plugins."io.containerd.grpc.v1.cri".registry]
        [plugins."io.containerd.grpc.v1.cri".registry.configs."registry-1.docker.io".auth]
            username = "zabradocker"
            password = "dckr_pat_8UI3-EtdBMqQ_tuazKeTYclFAL0"
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