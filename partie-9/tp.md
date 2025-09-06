# Troubleshooting

## 1. Cluster Event Logging


Utiliser le contexte `kubectl config use-context kind-k8s-c1-h`

> **Consignes**

- Ecrire dans `/opt/cka/cluster_events.sh` la commande qui affiche les derniers events du cluster entier, classé/trié en fonctiondu temps(time)

- Tuer/kill le pod `kube-proxy` qui tourne sur le worker2 `xx-worker2` et stocker les events dans `/opt/cka/container_kill.log`

## 2. Find Container of Pod and check info

Utiliser le contexte `kubectl config use-context kind-k8s-c1-h`

> Consignes**

- Dans le namepsace `debug-pod` créer le pod `tigers-reunite` avec  l'image `httpd:2.4.65-alpine` et les labels `pod=container` et ` container=pod`
- Identfier sur quel node, tourne le pod et aller sur le node en utilisant `dssh`

Utiliser la commande `crictl` 

- Ecrire l' `ID` du container et le `info.runtimeType` dans `/opt/cka/pod-container.txt`
- Ecrire les logs du  container dans  `/opt/cka/pod-container.log`


## 3. Fix node Worker

Utiliser le contexte `kubectl config use-context kind-k8s-c2-ac`

> **Setup**

- Choisir et se connecter sur un node Worker
- **Depuis ce node**, télécharger et exécuter ce script - **ne pas regarder le contenu**

```shell
rm -f set-1.sh
curl https://gitlab.enoks.fr/pub/tp-cka/-/raw/master/partie-9/set-1.sh -O
bash set-1.sh
systemctl daemon-reload
# sortir du node
exit
```

- Se deconencter du node
- Vérifier que le node passe en `notReady` après qq temps

> **Consignes**
  
Il semble y avoir un soucis avec l'un des node qui est `notReady`:

- Fixer le problème pour que le node soit disponile et puisse accueillir de nouveaux pods
- Ecrire la raison/cause du problème dans `/opt/cka/reason.txt`

## 4. Pod issue

Utiliser le contexte `kubectl config use-context kind-k8s-c2-ac`

> **Setup**

```shell
kubectl config use-context kind-k8s-c2-ac

rm -f set-2.sh
curl https://gitlab.enoks.fr/pub/tp-cka/-/raw/master/partie-9/set-2.sh -O
bash set-2.sh

```


> **Consignes**

Un deployement nommé  `failing-app` est présent dans le namespace `cka-pod-error` mais ses pods ne sont pas en `Runnning`

Fixer/corriger les problèmes suivants:

- Les pods sont en erreur à cause d'une insuffisance de `memory`, passer la limite `256Mi`
- Le port du container doit être `80`
- Le LivenessProbe doit passer en succès pour que les pods puissent être Running

Vérifier que tous les pods sont en `Running`après le fix et qu'il n y **aucun** `restart` des pods au bout de `+-30s` ni après


## 5. Deployment issue

Utiliser le contexte `kubectl config use-context  kind-k8s-no-cni`

> **Setup**

```shell
kubectl config use-context  kind-k8s-no-cni

rm -f set-3.sh
curl https://gitlab.enoks.fr/pub/tp-cka/-/raw/master/partie-9/set-3.sh -O
bash set-3.sh

```


> **Consignes**

Dans le namespace `failed-deploy`, le pod du deployment `failed-deploy` ne fonctionne pas, fixez-le


## 6. Pod Issue

Utiliser le contexte `kubectl config use-context  kind-k8s-no-cni`

> **Consignes**

Dans le namespace `default`, on arrrive pas à créer le pod `deploy-httpd` avec le manifest suivant:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: deploy-httpd
spec:
  containers:
    - name: redis-container
      image: nginx:1.29-alpine
      resources:
        requests:
          memory: "128Mi"
          cpu: "150m"
        limits:
          memory: "16Mi"
          cpu: "10m"
```

- Ecrire la cause/raison dans /opt/cka/failed-manifest.txt
- Corriger pour que le pod tourne

## 7. Redis Pod Issue

Utiliser le contexte `kubectl config use-context  kind-k8s-no-cni`

> **Consignes**

Dans le namespace `debug-redis`, fixez le pod `redis-pod`

## 8. Another Pod Issue

Utiliser le contexte `kubectl config use-context  kind-k8s-no-cni`

> **Consignes**

Dans le namespace `another-issue`, fixez le pod `app-frontend` - **Ne supprimer ou modifier rien** dans le manifest du pod

## 9. PostGres Issue

Utiliser le contexte `kubectl config use-context  kind-k8s-no-cni`

> **Consignes**

Dans le namespace `default`, on arrrive pas à créer le pod `postgres-pod` avec le manifest ci-dessous.  Corriger et créer le pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: postgres-pod
  namespace: default
spec:
  containers:
    - name: postgres
      image: postgres:13.22-alpine
      env:
        - name: POSTGRES_PASSWORD
          value: dbpassword
        - name: POSTGRES_DB
          value: database
      ports:
        - containerPort: 5432
      livenessProbe:
        tcpSocket:
          command:
            arg: 5432
        initialDelaySeconds: 30
        periodSeconds: 10
      readinessProbe:
        exec:
          cmd:
            - "psql"
            - "-h"
            - "localhost"
            - "-U"
            - "postgres"
            - "-c"
            - "SELECT 1"
        initialDelaySeconds: 5
        periodSeconds: 5
```


## 10. Issue Pod PVC

Utiliser le contexte `kubectl config use-context  kind-k8s-no-cni`

> **Consignes**

Dans le namespace `my-pod-cka`, fixez le pod `my-pod-cka`


## 11. Taint - not an issue

Utiliser le contexte `kubectl config use-context kind-k8s-c2-ac`

> **Consignes**

- Tainter le node **worker** avec la key `node-role/infra` et valeur `true` , effect `NoSchedule`
- Dans le namespace `default`, créer le pod `taint-toleration`avec l'image `nginx:1.29-alpine`, Assurez-vous que le pod ne reste pas bloqué en `Pending`


## 12. Deployement Issue - postgres

Utiliser le contexte `kubectl config use-context  kind-k8s-no-cni`

> **Consignes**

Dans le namespace `fix-postgres`, fixer le deployment `postgres-deployment`


## 13. Stucked Deployment

Utiliser le contexte `kubectl config use-context kind-k8s-c2-ac`

> **Setup**


- **Connectez-vous au node Master** avec `dssh`, télécharger et exécuter ce script - **ne pas regarder le contenu**

```shell
rm -f set-4.sh
curl https://gitlab.enoks.fr/pub/tp-cka/-/raw/master/partie-9/set-4.sh -O
bash set-4.sh

# sortir du node
exit
```

> **Consignes**

- Créer le pod `another-deb-pod` avec `kubectl create deploy another-deb-pod --image nginx:1.29-alpine --replicas=1`
- Aucun pod du du deployment ne tourne, UP-TO-DATE=0  et READY 0/1
- Sans supprimer ni modifier le dpeloyment, fixer le problème afin qu'il puisse avoir un pod en Running


## 14. Cronjob Issue

Utiliser le contexte `kubectl config use-context  kind-k8s-no-cni`

> **Consignes**

Dans le namespace `kubectl create ns failed-cron-job`,  se trouve un CronJob `cka-failed-cronjob` censé s'exécuter chaque **2 minutes** pour vérifier que le pod `cka-cron-pod` exposé (en théorie) via le service `cka-cron-svc` est bien UP

Les pods associés au jobs de ce cronjob sont en **erreur**

- Fixez le problème afin que le pod du job puisse être Completed

- Faites un get sur le pod `Completed` et stocker l'outpout dans `/opt/cka/cron-completedt.txt`

- Supprimer le cronjob