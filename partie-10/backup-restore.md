# Etcd Snapshot Save and Restore

## Preparation

```shell
cat > kind-etcd.yaml <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
  - role: worker
  - role: worker
EOF

kind create cluster -n back-rest --config kind-etcd.yaml

```


## Consignes


Utiliser le contexte `kubectl config use-context kind-back-rest` 

- Effectuez une sauvegarde du `etcd` du node **Master**  et enregistrez-la sur le nœud  dans `/tmp/etcd-backup.db`
  - Utiliser `apt update -y && apt install -y etcd-client`

- Créez ensuite dans le namespace `default` le pod `etcd-before-restore` avec `nginx:1.29-alpine`

- Enfin, restaurez la sauvegarde, vérifiez que le cluster fonctionne toujours et que le pod créé n'est plus présent.



## 🔧 Quelques Étapes attendues

**Tips** : Au besoin utiliser la documentation [https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/)

- Vérifier que le client `etcdctl`existe sinon installer le package `etcd-client`
  
- Identifier les informations à utiliser pour  la connexion Etcd
  
- Faites le snapshot
  
- Créer le pod demandé
  
- Arrêter à minima les pods statiques: vérifier et attendre ou faire le nécessaire afin qu'ils disparaissent de l'output de  `crictl ps`
  
- **Faites la restauration** - n'oublier pas le `data-dir`!
  
- Modifier le manifest `etcd.yaml` en accord avec la restauration effectuée
  
- Démarrer l'ensemble des pods précédemment arrêtés

- Vérifier que:
  - le cluster est toujours fonctionnel
  - le pod crée n'est pas présent 

  - **! Génial, la sauvegarde et la restauration ont fonctionné, car notre pod a disparu !!




