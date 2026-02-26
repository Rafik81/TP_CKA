

## 1. Contexts

Vous avez accès à **plusieurs clusters** depuis votre terminal principal via les **contextes kubectl**. 

> **Consignes**

- Écrivez tous **ces noms de contexte** dans `/opt/cka/contexts`. Créer le dossier `/opt/cka` s'il faut. 
  - `sudo mkdir /opt/cka && su chown -R ambient-user /opt/cka` 


- Ensuite, écrivez une commande pour afficher le contexte actuel (current context) dans `/opt/cka/context_default_kubectl.sh`. La commande doit utiliser `kubectl`.
- Enfin, écrivez une deuxième commande faisant la même chose dans `/opt/cka/context_default_no_kubectl.sh`, mais sans utiliser kubectl.


## 2. Collecter les information du Master


- Utiliser ce contexte pour l'exercice: `kubectl config use-context kind-k8s-c1-h`
  
> **Consignes**

Connectez-vous au node `k8s-c1-h-control-plane` au cluster `k8s-c1-h` avec `dssh k8s-c1-h-control-plane`

- vérifiez comment les composants `kubelet`, `kube-apiserver`,  `kube-scheduler`, `kube-controller-manager` et `etcd` sont démarrés/installés
-  Recherchez également le nom de l'application DNS et comment elle est démarrée/installée 
  
**Écrivez** vos réponses ur le Helper dans le fichier `/opt/cka/master-components.txt` comme ceci

```shell
kubelet: [TYPE]
kube-apiserver: [TYPE]
kube-scheduler: [TYPE]
kube-controller-manager: [TYPE]
etcd: [TYPE]
dns: [TYPE] [NAME]
```

Les valeurs possibles de `[TYPE`] sont: not-installed, process, static-pod, pod


## 3. Trouver les informations d'un cluster

- Utiliser ce contexte pour l'exercice: `kubectl config use-context kind-k8s-c1-h`

> **Consignes**

Trouvez les informations suivantes concernant le cluster `kind-k8s-c1-h` :


1. Combien de nœuds maîtres sont disponibles ?
2. Combien de nœuds de travail sont disponibles ?
3. Quel est le CIDR du service ?
4. Quel réseau (ou plugin CNI) est configuré et où se trouve son fichier de configuration ?
5. Quel suffixe auront les pods statiques qui s'exécutent sur `k8s-c1-h-worker`?


Écrivez vos réponses dans le fichier `/opt/cka/cluster-info`, en respectant la structure suivante :
Pour vous connecter à node de ce cluster utiliser `dssh <node>`


```shell
1 : [RÉPONSE]
2 : [RÉPONSE]
3 : [RÉPONSE]
4 : [RÉPONSE]
5 : [RÉPONSE]
```


## 4. Créer un pod statique & service


- Utiliser ce contexte pour l'exercice: `kubectl config use-context kind-k8s-c3-ccc`

> **Consignes**

- Créer un pod statique nommé **static-pod** dans le namespace `default` sur le node control-plane  avec l'image `nginx:1.29-alpine` avec comme ressources requests `10m`CPU et `20Mi` memory

- Créer un service de type NodePort pour exposer le pod  sur le port 80
  - Vérifier que le service crée a bien un endpoint dont l'IP correspond  au internal IP du controlPlane
  - Faites un Curl pour vérifier que le service NodePort fonctionne: `curl http://<IP-NODE>:<nodePort>`


## 5. Kubelet client/server cert info

- Utiliser ce contexte pour l'exercice: `kubectl config use-context kind-k8s-c2-ac`

> **Consignes**

Le cluster a un node Worker

Trouver la valeur du  `Issuer` et `Extended Key Usage` sur ce node pour:

1. `kubelet client certificate`, celui utilisé pour les connexions sortantes vers le serveur kube-apiserver.
2. `kubelet server certificate`, celui utilisé pour les connexions entrantes provenant du serveur kube-apiserver.


## 6. Validité des certificats

- Utiliser le contexte `kubectl config use-context kind-k8s-c1-h`


> **Consignes**

Connecter-vous au node Master `master-1`

- Vérifier la durée de validité du certificat du serveur `kube-apiserver`. Utilisez `openssl` ou `cfssl`. Notez la date d'expiration dans `/opt/cka/expiration` de la machine centrale

- Utiliser la commande `kubeadm` pour également lister la durée et confirmez que les deux méthodes retournent le même résultat

- Écrire dans `/opt/cka/kubeadm-renew-certs.sh` la commande pour renouveler le certificat de `kube-apiserver` . Ne pas renouveler le certificat


## 7. Authorization Mode - Admission Plugins - `kube-apiserver`


- Utiliser ce contexte pour l'exercice: `kubectl config use-context kind-k8s-c2-ac`


> **Consignes** 

- Identifier le ou les modes d' `Authorization`  activé sur le cluster (`kube-apiserver`)
- Identifier les plugins  d'admission  activés sur `kube-apiserver`


Écrivez vos réponses dans le fichier `/opt/cka/api-auth-info`

```yaml
Mode:  <votre réponse>
Plugins: <votre réponse>
```


## 8. Authorization Mode - Admission Plugins - `kubelet` 

- Utiliser le contexte `kubectl config use-context kind-k8s-c1-h`


> **Consignes** 

- Identifier le ou les modes d' `Authorization`  configuré sur le `kubelet`
- Identifier les méthodes d'authentification  activées sur `kubelet`

Écrivez vos réponses dans le fichier `/opt/cka/kubelet-auth-info`

```yaml
Authentication:  <votre réponse 1, 2, 3>
Mode: <votre réponse 1, 2, 3>
```