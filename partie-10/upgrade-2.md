# Mettre à jour la version de Kubernetes et rejoindre le cluster


## Preparation

- **Drainer**  le node `worker-2` et ensuite connecter vous au node pour exécuter:

```shell

rm -f cka-upgrade-2.sh
wget https://gitlab.enoks.fr/pub/scripts/-/raw/master/scripts/cka-upgrade-2.sh
sudo bash cka-upgrade-2.sh
```

Enfin, depuis le Helper utiliser `kubectl delete` pour supprimer le node


## Consignes 

Le node `worker-2` utilise une version plus ancienne de Kubernetes et **ne fait même pas partie** du cluster.

- Mettez à jour Kubernetes sur ce node afin qu'il utilise exactement la même version que celle qui est utilisée sur  `master-1`

- Ajoutez ensuite ce nœud au cluster. Utilisez `kubeadm` pour cela. **N'UTILISEZ PAS** le token issue de la toute prémière création du cluster

- Vérifier que le  node a rejoint  le cluster, a a version attendue et est `READY`