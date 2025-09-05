# Networking

## 1. Api resources


Utiliser le contexte : `kubectl config use-context kind-k8s-c1-h`

> **Consignes**

- Lister les noms de toutes ressources kubernetes `namespaced` (comme pod, secret, configmap) dans le `/opt/cka/16/resources.txt` 



## 2. Network CNI

Utiliser le contexte: `kubectl config use-context  kind-k8s-no-cni`

> **Consignes**

- Vérifier que les nodes sont `NotReady`

- Installer le CNI calico avec ces fichiers: 
  - `https://raw.githubusercontent.com/projectcalico/calico/v3.30.3/manifests/tigera-operator.yaml`
  - `https://raw.githubusercontent.com/projectcalico/calico/v3.30.3/manifests/custom-resources.yaml`

Attendez un et vérifier que

- les nodes sont `Ready`
- les `coredns`dans `kube-system` sont en `Running`


## 3. Service - Service Cluster IP

Utiliser le contexte `kubectl config use-context kind-k8s-c2-ac`


> **Consignes**

- Créer le pod `check-ip`dans le namespace `default`avec `httpd:2.4.65-alpine`
- Exposer le sur le port 80 en tant que service ClusterIP nommé `check-ip-service`

- Quel est le Service CIDR actuel du cluster ? Ecrire la valeur dans `/opt/cka/svc-cidr.txt`



## 4. Service - Iptables

Utiliser le contexte: `kubectl config use-context  kind-k8s-no-cni`


> **Consignes**


- Créer et utiliser le namepsace `project-hamster`

- Créer le pod `p2-pod` avec **2 containers**, une avec l'image `nginx:1.29-alpine` et l'autre avec  `busybox:1.36`- Assurez-vous que le container busybox reste en Running

- Créer un service `p2-service` qui expose le pod à l'interieur du cluster sur le port `3000->80`

- Vérifier `kube-proxy` tournent sur l'ensemble des nodes et qu'il utilise iptables. Utilise `crictl ps` pour cela

- Ecrire les règles iptables de tous les nodes crées pour le service `p2-service` dans `/opt/cka/iptables.txt`


## 5. DNS - replicaSets

Utiliser le contexte: `kubectl config use-context  kind-k8s-no-cni`

> **Consignes**

- Créer un **replicaSet** nommé `ns-lookup` avec 2 replicas,   nommer le container `dns` - Assurez-vous que les pods restent en Running
- Exécyter `nslookup kubernetes.default` depuis un de ces pods et stockés le output dans `/opt/cka/nslookup.txt`

## 6. NodePort

Utiliser le contexte: `kubectl config use-context  kind-k8s-no-cni`

> **Consignes**

- Créer et utiliser le namespace `cka-nodeport`
- Créer un deployment **nginx-app** avec l'image `nginx:1.29-alpine`, containerPort 80 et 1 replicas

- Créer un nodePort nommé `cka-nodeport` pour exposer le deployment **nginx-app* avec les infos suivantes:
  - port: 80
  - target port: 80
  - node port: 32000
  
Vérifier que l'app est accessible depuis avec sur le port `32000` quand on appelle l'IP des nodes 


## 7. Ingress Controller 

Utiliser le contexte: `kubectl config use-context  kind-k8s-no-cni`

> **Consignes**

- En utilisant la commande `helm`  rajouter le repo `ingress-nginx` avec pour url `https://kubernetes.github.io/ingress-nginx`

- Dans le namespace `ingress-nginx` installer la release Helm `ingress-nginx`avec le Chart `ingress-nginx` version `4.12.3` avec ces options
  ```shell
  controller.hostNetwork=true \
  controller.service.type=ClusterIP \
  controller.kind=Deployment \
  controller.daemonset.useHostPort=true \
  controller.containerPort.http=80 \
  controller.containerPort.https=443
  ```

Vérifier que le pod est en Running


## 8. Ingress

Utiliser le contexte: `kubectl config use-context  kind-k8s-no-cni`

- Créer et utiliser le namespace `public-app`
- Créer un deployment **public-app** avec l'image `nginx:1.29-alpine`, containerPort 80 et 1 replicas
- Exposer le avec un service clusterIp `public-app-svc`

- Créer un **ingress** nommé `public-app-ing` avec pour **host** `public-app.cka`, `class nginx` pour exposer l'application

Depuis l'un des node, vérifier que ca fonctionne avec `curl -H 'Host: public-app.cka' http://<IP-INGRESS-CREE>` 