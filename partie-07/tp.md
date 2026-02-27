# Storage

- Doc: [https://kubernetes.io/docs/concepts/storage/volumes/](https://kubernetes.io/docs/concepts/storage/volumes/)

## 1. StorageClass

Utiliser le contexte `kubectl config use-context kind-k8s-c2-ac`


> **Consignes**

- Identifier le storageClass présent sur le cluster et enregistrer les informations dans `/opt/cka-storageclass.txt` comme suit:

```shell
nom=
provisionner=
reclaimPolicy=
volumebindingmode=
Is-default-class?=
```

- créer un nouveau storageclass nommé `asap-sc` avec volumebindingmode `Immediate`, utiliser provisionner `kubernetes.io/no-provisioner`
- Autoriser l'expansion de volume 

- Faites en sorte que `asap-sc` soit le storageclass par défaut et **l'unique**.


##  2. PV - Hostpath - PVC


Utiliser le contexte `kubectl config use-context kind-k8s-c2-ac`


> **Consignes**

- Créer en local le dossier `/tmp/pv-data` avec: `mkdir -p /tmp/pv-data`
  
- Créer un **PersistentVolume** nommé `safari-pv` avec une capacité de `128Mi`, accessMode `ReadWriteOnce`, `hostPath` `/tmp/pv-data` et  **aucun** storageClassName défini

- Vérifier que le PV a été bien créé

- Lister les storageClass présents et faites en sorte **qu'aucun** ne soit le storageclass par défaut `default` , sans les supprimer

- Créer le namespace `project-tiger` s'il n'existe pas
  
- Dans le namespace `project-tiger`, créer le **PersistentVolumeClaim** `safari-pvc` avec une capacité de `128Mi` , accessMode `ReadWriteOnce` et sans storageClassName.
    - Vérification: si tout est OK, le PVC devrait être rattaché au PV: `status: Bound`


- Créer  dans le namespace `project-tiger` le deployment `safari`  avec `httpd:2.4.65-alpine`, et monter le PVC `safari-pvc` en tant que volume nommé `data`sur `/tmp/safari-data` 


## 3. Shared Volume - Sidecar

Utiliser le contexte `kubectl config use-context kind-k8s-c2-ac`

> **Consignes**

- Créer et utiliser le namespace `sidecar`
- Créer un  **PersistentVolumeClaim** `shared-volume` avec une capacité de `128Mi` , accessMode `ReadWriteOnce` et storageClassName `standard`

- Créer un pod `my-nginx`avec `nginx:1.29-alpine` et monter le PVC sur `/var/www/html` du  pod
    - Vérifier que le PVC est `Bound` et le pod est `Running`


- Maintenant, vous devez modifier le pod pour ajouter un second container `busybox` avec l'image `busybox:1.36`.
- Assure-vous que ce container sidecar reste en Running

- Partager le volume PVC  avec ce container en le montant en **readonly** sur `/var/www/shared` 

- Vérifier que le nouveau pod est bien `Running` et `2/2 READY`


## 4. Shared Volume - Multi container 

Utiliser le contexte `kubectl config use-context kind-k8s-c2-ac`

- Petite aide pour le **env**: [https://kubernetes.io/fr/docs/tasks/inject-data-application/environment-variable-expose-pod-information/](https://kubernetes.io/fr/docs/tasks/inject-data-application/environment-variable-expose-pod-information/)

> **Consignes**

- Créer a Pod nommé **multi-container-playground** dans le  Namespace **default** avec trois  containers: c1, c2 and c3
- Les containers doivent partager le même volume (le même monté sur chacun des trois containers) Cependant le volume ne doit pas persisté ni être partagé avec d'autres pods, nommer le volume `vol-data` et monter sur `/tmp/vol` 

- Le container c1 doit être de l'image `nginx:1.29-alpine`  et avoir le nom du (futur) node où le  Pod est exécuté  en tant que variable d'environnement `MY_NODE_NAME`.

- Le container c2 doit être de l'image `busybox:1.36` et écrire le output de la commande `date` toutes les secondes dans le volume partagé dans le fichier `date.log`. Pour cela, vous pouvez utiliser `while true; do date >> /tmp/vol/date.log; sleep 1; done`

- Le container c3 doit être de l'image `busybox:1.36` et envoyer en permanence le contenu du fichier `date.log`  du volume partagé vers stdout. Pour cela, vous pouvez utiliser `tail -f /tmp/vol/date.log`


Checker les logs  du container c3 pour confirmer que la configuration est correcte.

## 5. StatefulSet - ClaimTemplate


Utiliser le contexte `kubectl config use-context kind-k8s-c2-ac`

> **Consignes**

- Créer et utiliser le namespace `sts-claim`

- Créer un **StatefulSet** nommé `web` utilisant `nginx:1.29-alpine` avec 2 replicas et `80` comme containerPort
- Définir et monter  de la **persistence** de données avec ces caractéristiques: storage=64Mi, accessMode=ReadWriteOnce, storageClassName=standard, nom=www, mountPath=`/usr/share/nginx/html`


## 6. PVC - PV

Utiliser le contexte `kubectl config use-context kind-k8s-c2-ac`

> **Consignes**

- Créer en local le dossier `/tmp/data` avec: `mkdir -p /tmp/data`
  
- Créer un **PersistentVolume** nommé `cka-pv` avec une capacité de `128Mi`, accessMode `ReadWriteOnce`, storageClass=standard et `hostPath` `/tmp/data`
  
- Dans le namespace `default` créer le PersistentVolumeClaim `cka-pvc` qui hérite du PersistentVolume `cka-pv`. Une fois créer le status de  PersistentVolume `cka-pv`  doit être `Bound`