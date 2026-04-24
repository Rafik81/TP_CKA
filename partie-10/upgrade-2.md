## Upgrade & Join Node  - Troubleshooting

## Preparation

```shell
wget https://gitlab.enoks.fr/pub/scripts/-/raw/master/scripts/cka-upgrade-2.sh
bash cka-upgrade-2.sh

```

## Consignes 

Utiliser ce contexte pour l'exercice: `kubectl config use-context kind-k8s-node-upgrade`

Le node `k8s-node-upgrade-worker2` utilise une version plus ancienne de Kubernetes et **ne fait même plus partie** du cluster.

- Mettez à jour Kubernetes sur ce node afin qu'il ait exactement la même version que que le node  Master


- Vérifier que le  node a rejoint  le cluster, avec la version attendue et est `READY`


**SI vous avez une erreur** `[ERROR SystemVerification]: failed to parse kernel config: unable to load kernel module: "configs", output: "modprobe: FATAL: Module configs not found in directory /lib/modules/6.14.0-29-generic\n", err: exit status 1`   avec une commande  **kubeadm**, 

Ajouter le flag `--ignore-preflight-errors=SystemVerification` à votre commande