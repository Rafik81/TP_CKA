# Upgrade cluster


**Objectif** : Mettre à jour un cluster kubeadm du control-plane (v1.X.Y) vers une version mineure supérieure (v1.X.Y+1), puis mettre à jour un nœud worker.
C'est donc le patch `Y` qui évolue, exemple de `1.33.2` vers `1.33.4`

**Consignes**: Identifier la version actuelle de votre cluster et upgrader le au patch `4` 


## 🔧 Étapes attendues

- **Tips** Au besoin utiliser la documentation d'upgrade: [https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade)


- Vérifier si **la version actuelle** de kubeadm  correspond à la version cible
  
- **SINON**
  - Lister les versions disponibles de Kubernetes: `apt-cache madison kubeadm`
  - Mettre à jour le package `kubeadm` et le figer ensuite

- Lancer la mise à jour du premier control-plane, n'oublier pas de faire un plan avant

- Si vous avez d'autres nodes  Control-Plane, mettez-les à jour avant de passer au nodes Worker

- Mettez à jour `kubelet`, `kubectl` sur l'ensemble des nodes

- **Vérifier que votre cluster et tous ses nodes sont bien à la version attentude**