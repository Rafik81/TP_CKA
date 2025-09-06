# Storage

- Doc: [https://kubernetes.io/docs/concepts/storage/volumes/](https://kubernetes.io/docs/concepts/storage/volumes/)

## 1. StorageClass

Utiliser le contexte `kubectl config use-context kind-k8s-c2-ac`


> **Consignes**

- Identifier le storegaclass présent sur le cluster et enregistrer les informations dans `/opt/cka-storageclass.txt` comme suit:

```shell
nom=
provisionner=
reclaimPolicy=
volumebindingmode=
Is-default-class?=
```

- créer un nouveau storageclass nommé `asap-sc` avec volumebindingmode `Immediate`, utiliser rovisionner `kubernetes.io/no-provisioner`
- Autoriser l'expansion de volume 

- Faites en sorte que `asap-sc` soit le storageclass par defaut et l'unique.


##  2. PV - Hostpath - PVC


Utiliser le contexte `kubectl config use-context kind-k8s-c2-ac`


> **Consignes**

- Créer le dossier `/tmp/pv-data`
- Créer un **PersistentVolume** nommé `safari-pv` avec une capacité de `128Mi`, accessMode `ReadWriteOnce`, `hostPath` `/tmp/pv-data` et  **aucun** storageClassName défini
- Vérifer que le PV a été bien créé

- Lister les storageClass présents et faites en sorte **qu'aucun** ne soit le storageclass par defaut `default` , sans les supprimer

- Dans le namespace `project-tiger`, créer le **PersistentVolumeClaim** `safari-pvc` avec une capacité de `128Mi` , accessMode `ReadWriteOnce` et sans storageClassName.
Le PVC devrait être rattaché au PV


- Créer  dans le namespace `project-tiger` le deployment `safari`  avec `httpd:2.4.65-alpine`, et monter le PVC `safari-pvc` en tant que volume sur `/tmp/safari-data` 


## 3. Shared Volume - Sidecar

Utiliser le contexte `kubectl config use-context kind-k8s-c2-ac`

> **Consignes**

- Créer et utiliser le namespace `sidecar`
- Créer un  **PersistentVolumeClaim** `shared-volume` avec une capacité de `128Mi` , accessMode `ReadWriteOnce` et storageClassName `standard`
- 
- Créer un pod `my-nginx`avec `nginx:1.29-alpine` et monter le PVC sur `/var/www/html` du  pod

Vérier que le PVC est `Bound` et le pod est `Running`


- Maintenant, vous devez modifier le pod pour ajouter un second container `busybox` avec l'image `busybox:latest`.
- Assure-vous que ce container sidecar reste en Running

- Partager le volume PVC  avec ce container en le montant en **readonly** sur `/var/www/shared` 

- Vérifier que le nouveau pod est bien `Running` et `2/2 READY`


## 4. Shared Volume - Multi container 

Utiliser le contexte `kubectl config use-context kind-k8s-c2-ac`

- Petite aide pour le **env**: [https://kubernetes.io/fr/docs/tasks/inject-data-application/environment-variable-expose-pod-information/](https://kubernetes.io/fr/docs/tasks/inject-data-application/environment-variable-expose-pod-information/)

> **Consignes**

- Créer a Pod nommé **multi-container-playground** dans le  Namespace **default** avec trois  containers: c1, c2 and c3
- Ils doivent partager le même volume atatché au Pod et monté sur chaun des trois containers. Cepenandt le volume ne doit pas persisté ni être partagé avec d'autres pods

- Le container c1 doit être de l'image `nginx:1.29-alpine`  et avoir le nom du (futur) node où le  Pod est exécuté  en tant que variable d'environnement `MY_NODE_NAME`.

- Le container c2 doit être de l'image `busybox:1.37.0` et écrire le output de la commade `date` toutes les secondes dans le volume partagé dans le fichier `date.log`. Pour cela, vous pouvez utiliser `while true; do date >> /your/vol/path/date.log; sleep 1; done`

- Le container c3 doit être de l'image `busybox:1.37.0` et envoyer en permanence le contenu du fichier `date.log`  du volume partagé vers stdout. Pour cela, vous pouvez utiliser `tail -f /your/vol/path/date.log`


Checker les logs  du container c3 pour confirmer que la configuration est correcte.

## 5. Statefulset - ClaimTemplate


Utiliser le contexte `kubectl config use-context kind-k8s-c2-ac`

> **Consignes**

- Créer et utiliser le namespace `sts-claim`

- Céer un **StatefulSet** nommé `web` utilisant `nginx:1.29-alpine` avec 2 replicas et `80` comme containerPort
- Definir et monter  de la **persistence** de données avec ces caratéristiques: storage=64Mi, accessMode=ReadWriteOnce, storageClassName=standard, nom=www, mountPath=`/usr/share/nginx/html`

## 6. PVC - PV

Utiliser le contexte `kubectl config use-context kind-k8s-c2-ac`

> **Consignes**



- Créer un **PersistentVolume** nommé `cka-pv` avec une capacité de `128Mi`, accessMode `ReadWriteOnce`, storageClass=standard et `hostPath` `/tmp/data`
  
- Dans le namespace `default` créer le PersistentVolumeClaim `cka-pvc` qui hérite du PersistentVolume `cka-pv`. Une fois créer le status de  PersistentVolume `cka-pv`  doit être `Boound`