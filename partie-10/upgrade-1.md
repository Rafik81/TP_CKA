# Upgrade cluster


## Preparation

```shell

rm -f cka-upgrade-2.sh
wget https://gitlab.enoks.fr/pub/scripts/-/raw/master/scripts/cka-upgrade-1.sh
bash cka-upgrade-1.sh

```

## Upgrade de cluster


Utiliser ce contexte pour l'exercice: `kubectl config use-context kind-k8s-full-upgrade`

La version **actuelle**  du cluster est `v1.32.5`. 

- Créer le pod `nginx` dans le namespace **default** en utilisant l'image `nginx:1.29-alpine`

- Procéder à l'upgrade du cluster pour le passer à la version `v1.32.9`

- Assurez-vous que tous les nodes sont à la version souhaitée avec `kubectl get no`


## 🔧 Étapes attendues

- **Tips** Au besoin utiliser la documentation d'upgrade: [https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade)


- Vérifier si **la version actuelle** de kubeadm  correspond à la version cible
  
- **SINON**
  - Lister les versions disponibles de Kubernetes: `apt-cache madison kubeadm`
  - Mettre à jour le package `kubeadm`

- Lancer la mise à jour du premier control-plane, n'oublier pas de faire un plan avant

- Si vous avez d'autres  Control-Plane, mettez-les à jour avant de passer au nodes Worker

- Mettez à jour `kubelet`, `kubectl` sur l'ensemble des nodes, n'oublier pas de restart kubelet

- **Vérifier que votre cluster et tous ses nodes sont bien à la version attentude**