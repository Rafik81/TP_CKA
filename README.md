# TP-Cka



## Alias

```shell
alias k=kubectl  # present par defaut
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