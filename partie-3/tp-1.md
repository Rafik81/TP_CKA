# Installation Cluster

## Setup des futurs nodes du cluster

- 1 Nodes pour former le Control Plane
- 2 Workers
- `kubeadm-cluster.formation` : utiliser comme le nom DNS pour l'IP LOADBLANCER = IP du Helper


Sur chacun des 3 nodes, réalisez les actions suivantes:

```shell

sudo su -

export HELPER_IP=

rm -rf prepare-nodes.sh
wget https://gitlab.enoks.fr/pub/scripts/-/raw/master/scripts/prepare-nodes.sh
bash prepare-nodes.sh
kubeadm version

# Set le hostname en tant que master-xxx ou worker-xxx
hostnamectl set-hostname xxx  


```

## Setup du Helper

Le Helper va héberger le Haproxy qui va servir à faire du HA, Loadbalancing

Depuis VM Helper, réalisez les actions suivantes:

```shell

sudo su -

# exporter les IP des fututurs nodes duc cluster
export IP_MASTER_1=
export IP_WORKER_1=
export IP_WORKER_2=

rm -rf prepare-helper.sh
wget https://gitlab.enoks.fr/pub/scripts/-/raw/master/scripts/prepare-helper.sh
bash prepare-helper.sh single

sudo systemctl restart haproxy --quiet
sudo systemctl status haproxy --no-pager --quiet


# bash completion

echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
exec -l $SHELL

# au besoin faites un EXIT pour revenir sur le user normal
# et refaire le bash completion pour ce dernier
```



## Creation du cluster HA


- 1 Node(s) pour former le Control Plane
- 2 Workers
- `kubeadm-cluster.formation` : utiliser comme le nom DNS pour l'IP LOADBLANCER = IP du Helper


### Sur le Master 1

```shell
# Si vous n'avez pas choisi "kubeadm-cluster.formation" changez-le
sudo kubeadm init  --pod-network-cidr=172.20.0.0/16  --control-plane-endpoint kubeadm-cluster.formation 


# Noter les commandes "kubeadm" join qui sont dans le ouput
# elles serviront à ajouter les autres noeuds


# vérification
export KUBECONFIG=/etc/kubernetes/admin.conf
k get no


# Copier également le kubeconfig /etc/kubernetes/admin.conf  sur la machine Helper
USER="ambient-user"
scp /etc/kubernetes/admin.conf "${USER}"@"${HELPER_IP}":
```

### Ajout des Workers


Sur chaque Worker, lancer la commande `kubeadm join` dédiée, **sans l'option**  `--control-plane`

```shell
sudo su -

kubeadm join kubeadm-cluster.formation:6443 --token xxxxx \
      --discovery-token-ca-cert-hash sha256:yyzzzz \
```

k get no
> **Labelliser les Worker nodes**

En faisant le `kubectl get no` , la colonne `ROLES` est à `<none>`  pour les 2 workers

```shell
k  get no 
NAME               STATUS     ROLES           AGE   VERSION
master-1       NotReady   control-plane   40m   v1.32.5
worker-1   NotReady   <none>          12m   v1.32.5
worker-2   NotReady   <none>          9s    v1.32.5
```

**Ajoutez-le label qu'il faut** pour qu'il affiche "worker" : `kubectl label  node <node> node-role.kubernetes.io/worker=`

```shell
k get no
NAME       STATUS     ROLES           AGE     VERSION
master-1   NotReady   control-plane   5m44s   v1.33.4
worker-1   NotReady   <none>          40s     v1.33.4
worker-2   NotReady   <none>          34s     v1.33.4

# Après ajout du label

NAME       STATUS     ROLES           AGE     VERSION
master-1   NotReady   control-plane   7m11s   v1.33.4
worker-1   NotReady   worker          2m7s    v1.33.4
worker-2   NotReady   worker          2m1s    v1.33.4
```



> **Pourquoi** les nodes sont toujours en `NotReady` ?


## Installer le CNI - Cilium

Sur le Helper


```shell
wget https://gitlab.enoks.fr/pub/scripts/-/raw/master/scripts/install-cilium-cli.sh
sudo bash install-cilium-cli.sh

CILIUM_VERSION=v1.17.3
cilium install  --version ${CILIUM_VERSION} --set ipam.operator.clusterPoolIPv4PodCIDRList="172.20.0.0/16"
cilium status --wait

k -n  kube-system get no,po
```

## Installer Metrics-Server

```shell
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# une fois les pods OK
k top node

# HA
## kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/high-availability-1.21+.yaml
```

## Exploration de composants

- Les pods sont présents dans le namespace `kube-system` ,  vous pouvez les analyser avec `kubectl`
- L'autre option est d'utiliser `crictl` depuis un Master

- Ce sont des pods statiques, leur config est disponible dans  `/etc/kubernetes/manifests/`

> Test sur le **kube-scheduler** 

```shell
# verifier que vous avez bien 3 pods kube-scheduler
k get po -n kube-system -l component=kube-scheduler
NAME                          READY   STATUS    RESTARTS   AGE
kube-scheduler-master1   1/1     Running   0          3h22m
kube-scheduler-master2   1/1     Running   0          3h5m
kube-scheduler-master3   1/1     Running   0          3h2m


# Depuis un Node on va deplacer le fichier kube-scheduler.yaml

cd /etc/kubernetes/manifests
ls

mv kube-scheduler.yaml ..

crictl ps  # constater que le scheduler n'est plus visible

# Avec kubectl
k get po -n kube-system -l component=kube-scheduler


# Remettre le fichier à sa place
mv ../kube-scheduler.yaml .

# S'il met du temps
systemctl restart kubelet

k get po -n kube-system -l component=kube-scheduler
NAME                          READY   STATUS    RESTARTS   AGE
kube-scheduler-master1   1/1     Running   0          36s
kube-scheduler-master2   1/1     Running   0          3h10m
kube-scheduler-master3   1/1     Running   0          3h7m

```