# Workloads - Scheduling


Sur la machine/VM Kind, exécuter le fichier script `prepare.sh` avec le **user normal** en avec copy-paste ou comme suit:

```shell
rm -f prepare.sh
https://gitlab.enoks.fr/pub/tp-cka/-/raw/master/partie-4-5/prepare.sh

bash prepare.sh
```


## 1. Schedule/Planifier un Pod sur un node Control Plane(Master)


Utiliser le contexte: `kubectl config use-context kind-k8s-c1-h`

> **Consignes**

- Créer un seul pod de l'image `httpd:2.4.65-alpine` dans le namespace `default`. 
- Le pod doit être nommé `pod1` et le container  doit être nommé `pod1-container`. 
- Ce pod ne doit être planifié que sur un node de type **Master**, **n'ajoutez pas** de nouveaux labels aux nodes, aucun.


## 2. Scale down

Utiliser le contexte: `kubectl config use-context kind-k8s-c1-h`

> **Consignes**

- Il y'a 3 pods nommés `stsapp-*` dans le namespace `project-sts-app`.
- On vous demande de scale down le nombre à `1 replica` pour économiser de la ressource pour les autres.


## 3. Liveness - Readiness

Utiliser le contexte: `kubectl config use-context kind-k8s-c1-h`

> **Consignes**

- Travailler dans le namespace nommé `live`

- Dans ce dernier, créer un pod nommé `ready-if-service-ready` of image `nginx:1.29-alpine`
  
- Ajouter un  **LivenessProbe** qui exécute simplement `true`
  
- Configurer également un **ReadinessProbe** qui check si l'url `http://service-am-i-ready:80` est accessible. 
  - Vous pouvez utiliser `wget -T2 -O- http://service-am-i-ready:80` pour ça
  
Démarrer le Pod et confirmer qu'il n'est pas `Ready`à cause du **ReadinessProbe**


- Créer un second pod nommé `am-i-ready`  avec le label `id: cka-training-ready` en utilisant  la même image. Le service `service-am-i-ready` déjà existant devrait avoir le second pod comme Endpoint.

Le premier pod devrait être `Ready`maintenant. Confirmer cela

## 4. Kubectl

Utiliser le contexte: `kubectl config use-context kind-k8s-c1-h`

> **Consignes**

- Écrire dans le fichier `/opt/cka/find-pods.sh`  la commande `kubectl`  qui permet de lister tous les pods du cluster en les triant(sort) par leur âge: `metadata.creationTimestamp`

- Écrire dans  `/opt/cka/find-pods-uid.sh` la commande `kubectl` qui les liste tous mais en triant cette fois avec le champ `metadata.uid`



## 5. Kubectl - Resource Usage

Utiliser le contexte: `kubectl config use-context kind-k8s-c1-h`

- Appliquer ce manifest: `kubectl apply -f https://gitlab.enoks.fr/pub/tp-cka/-/raw/master/partie-3/metric-server.yaml`

Vérifier/attendre que le deploy soit `READY 1/1`

```shell
k -n kube-system get deployment.apps/metrics-server
NAME             READY   UP-TO-DATE   AVAILABLE   AGE
metrics-server   1/1     1            1           43s
```

> **Consignes**

Écrire la commande `kubectl`

- pour afficher l'usage de ressources des nodes `/opt/cka/node.sh`
- pour afficher l'usage de ressources des pods et leurs containers `/opt/cka/pod.sh`


## 6. Scheduling Manuel


Utiliser le context `kubectl config use-context kind-k8s-c2-ac`

> **Consignes**

- Utiliser `dssh`pour vous connecter au node Master
- Arrêter le composant `kube-scheduler`
- Créer un pod nommé `manual-schedule` avec l'image `nginx:1.29-alpine`

Confirmer que le pod est crée mais il n'est pas schedule/placé sur un node. Ajouter le output du `k get po <le pod>` dans `/opt/cka/manual-schedule.txt`

- **Manuellement**, placer/scheduler le pod sur un node, confirmer qu'il est en `Running`

- Démarrer le `kube-scheduler`


## 7. Daemonset - sur tous les nodes

Utiliser le contexte: `kubectl config use-context kind-k8s-c1-h`

> **Consignes**

- Créer un namespace nommé `projet-demon`  et utiliser le pour cet exercice

- Créer un daemonset nommé `critic-workload` avec l'image `httpd:2.4.65-alpine`
  - Il doit tourner sur **tous les nodes**
  - il doit avoir les labels `id=demon-critique` et `uuid=18426a0b-5f59-4e10-923f-c0e078e82462`
  - Il doit avoir en resource requests: 10 millicore de cpu et 8 mebibyte memory


## 8. Secret

Utiliser le contexte: `kubectl config use-context kind-k8s-c3-ccc`

> **Consignes**

- Créer et utiliser le namespace `secret`

- Créer un pod nommé `secret-pod` avec l'image `busybox:1.36` qui doit rester en running
  
- Il y a un secret  existant à `/tmp/secret-toto.yaml` , créer le dans le namespace et monter le en **readonly**  sur `/tmp/secret-toto` du pod
  
- Créer un nouveau Secret nommé `secret2` avec pour données `user=user2` et `password=fomationcka123`. Ces données doivent être disponibles à l'intérieur du pod en tant que variable d'environnement `APP_USER` et `APP_PASSWORD`
  
- Utiliser le fichier `/tmp/secret-env.txt` pour créer le secret `secret-with-env`. Injecter ce secret en tant que variables d'environnement dans le pod


> Confirmer que tout fonctionne, les variables d'environnement `APP_USER`, `APP_PASSWORD`, `goal` et `achieve` sont présents, les fichiers montés


## 9. Deployment - sur tous les nodes

Utiliser le contexte: `kubectl config use-context kind-k8s-c1-h` et le namespace `projet-demon` : créer le s'il n'existe pas


> **Consignes**

- Créer un  Deployment nommé  `deploy-important` ayant **3 replicas** avec le  label `id=very-important`, les pods doivent avoir ce label également
- il doit contenir **2 containers**:
  - Le premier `container1`avec l'image `nginx:1.29-alpine`
  - Le second `container2` avec l'image `registry.k8s.io/pause:latest`

Il **doit y avoir un et un seul pod par node** : comme replicas=3 et  il n'y a que 2 workers, l'un des 3 pods ne sera pas schedule tant qu'un 3è worker n'est pas ajouté.

D'une certaine manière, nous simulons ici le comportement d'un DaemonSet, mais en utilisant un Deployment et un nombre fixe de replicas


- Mettez à jour, la version de l'image du `container1` en le passant à `nginx:1.28-alpine`

## 10. ConfigMap

Utiliser le contexte: `kubectl config use-context kind-k8s-c3-ccc`

> Consignes

- Créer et utiliser le namespace `my-cm`

- Créer un pod nommé `configmap-pod` avec l'image `busybox:1.36` qui doit rester en running
  
- Il y a un fichier existant `/tmp/configmap-data.txt` utiliser-le pour créer un configmap nommé `configmap-pod-cm`
  - Monter le en tant que volume(nom: `cm-data`) en **readonly**  sur `/tmp/cm-data` du pod

- Créer un confiMap nommé `cmap2` avec les données suivantes: `formation=intensive` et `jour=1`
  - Monter le en tant que volume nommé `cmap-2` **mais uniquement** la clé `formation` en tant que fichier `/tmp/formation.txt` dans le pod


## 11. Cronjob

Utiliser le contexte: `kubectl config use-context kind-k8s-c2-ac`

> **Consignes**

- Créer un cronjob nommé `cdt-monitor` avec l'image `curlimages/curl`  qui chaque 4h  fait une requête sur `https://github.com`
- Créer un job `oneshot-cdt-monitor` à partir du cronjob `cdt-monitor`

- Vérifier que le kob est **Completed**

## 12. Deployment - History - Autoscale

Utiliser le contexte `kubectl config use-context kind-k8s-c2-ac`

> **Consignes**

- Créer et utiliser le namespace `history`
- Créer un deployment nommé `deploy-rollout` avec `nginx:1.29-alpine` et  `1 replica` et vérifier que le pod est en `Running`


- Modifier le deployment pour ajouter un **livenessProbe**  de type HTTP au container s'assurant qu'il est up et écoute sur son port `80`
  - avec un failure threshold = 3, initialDelaySeconds 5 et success threshold = 1

Ensuite:

- Scaler le deployment à **2 replicas**

- Update: upgrader la version de l'image à `nginx:1.29.1-alpine`

- Quelle est la valeur(le numéro) de révision actuelle du deployment ? stocker la dans `/opt/cka/revision.txt`

- A l'aide de `kubectl` sans éditer le yaml, revenez(rollback) à la  **revision** `1`

- Créer un **HorizontalPodAutoscaler** `deploy-rollout-scale` pour le deployment avec pour valeur min=1 max=3 lorsque le pourcentage du cpu atteint `95`
  

## 13. Rolling Update

Utiliser le contexte `kubectl config use-context kind-k8s-c2-ac`

> **Consignes** 

Dans le namespace `cka-rolling` créer le deployment `rolling-app` avec **4 replicas** en utilisant  `nginx:1.29-alpine`

- Quelle est le type de la stratégie de mise à jour de ce deployment ? Quelle est la valeur de `max Surge` ? Écrire les réponses dans `/opt/cka/strategie.txt`

- Mettre à jour le deployment pour passer `max surge` à **1** et `max unvailable` à **1**


- Mettre à jour(update) le deployment avec `nginx:1.29.1-alpine` en utilisant `kubectl set`
  - Écrire dans `/opt/cka/roll-kubectl-set.txt`  la command utilisée
