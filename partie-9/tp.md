# Troubleshooting

## Ckuster Event Logging


Utiliser le contexte `kubectl config use-context kind-k8s-c1-h`

> **Consignes**

- Ecrire dans `/opt/cka/cluster_events.sh` la commande qui affiche les derniers events du cluster entier, classé/trié en fonctiondu temps(time)

- Tuer/kill le pod `kube-proxy` qui tourne sur le worker2 `xx-worker2` et stocker les events dans `/opt/cka/container_kill.log`

## Find Container of Pod and check info

Utiliser le contexte `kubectl config use-context kind-k8s-c1-h`

> Consignes**

- Dans le namepsace `debug-pod` créer le pod `tigers-reunite` avec  l'image `httpd:2.4.65-alpine` et les labels `pod=container` et ` container=pod`
- Identfier sur quel node, tourne le pod et aller sur le node en utilisant `dssh`

Utiliser la commande `crictl` 

- Ecrire l' `ID` du container et le `info.runtimeType` dans `/opt/cka/pod-container.txt`
- Ecrire les logs du  container dans  `/opt/cka/pod-container.log`


##  Fix node Worker

Utiliser le contexte `kubectl config use-context kind-k8s-c2-ac`

> **Setup**

- Chosir et se connecter sur un node Worker
- Depuis ce node, télécharger et exécuter ce script - **ne pas regarder le contenu**

```shell

curl https://gitlab.enoks.fr/pub/tp-cka/-/raw/master/partie-9/set-1.sh -O
bash set-1.sh
```

- Se deconencter du node
- Vérifier que le node est `notReady`

> **Consignes**
  
Il semble y avoir un soucis avec l'un des node qui est `notReady`:

- Fixer le prblème pour que le node soit disponile et puisse accueillir de nouveaux pods
- Ecrire la raison/cause du problème dans `/opt/cka/reason.txt`