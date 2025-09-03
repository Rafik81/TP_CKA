# Etcd Snapshot Save and Restore


## Consignes

- Effectuez une sauvegarde de `etcd` tournant sur `master-1`  et enregistrez-la sur le nœud  dans `/tmp/etcd-backup.db`

- Créez ensuite un pod de votre choix dans le cluster.

- Enfin, restaurez la sauvegarde, vérifiez que le cluster fonctionne toujours et que le pod créé n'est plus présent.

## 🔧 Quelques Étapes attendues

**Tips** : Au besoin utiliser la documentation [https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/)

- Vérifier que le client `etcdctl`existe sinon installer le package `etcd-client`
  
- Identifier les informations à utiliser pour  la connexion Etcd
  
- Faites le snapshot
  
- Créer le pod de votre choix
  
- Arrêter à minima les pods statiques: kube-apiserver, etcd
  
- **Faites la restauration** - n'oublier pas le `data-dir`!
  
- Modifier le manifest `etcd.yaml` en accord avec la restauration effectuée
  
- Démarrer l'ensemble des pods précedemment arrêtés

- Vérifier que:
  - le cluster est toujours fonctionnel
  - le pod crée n'est pas présent 

  - **! Génial, la sauvegarde et la restauration ont fonctionné, car notre pod a disparu !!




