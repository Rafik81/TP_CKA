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
- les `coreDns`dans `kube-system` sont en `Running`


## 3. Service - Service Cluster IP

Utiliser le contexte `kubectl config use-context kind-k8s-c2-ac`


> **Consignes**

- Créer le pod `check-ip`dans le namespace `default`avec `httpd:2.4.65-alpine`
- Exposer le sur le port 80 en tant que service ClusterIP nommé `check-ip-service`

- Quel est le Service CIDR actuel du cluster ? Écrire la valeur dans `/opt/cka/svc-cidr.txt`



## 4. Service - Iptables

Utiliser le contexte: `kubectl config use-context  kind-k8s-no-cni`


> **Consignes**


- Créer et utiliser le namespace `project-hamster`

- Créer le pod `p2-pod` avec **2 containers**, une avec l'image `nginx:1.29-alpine` et l'autre avec  `busybox:1.36`- Assurez-vous que le container busybox reste en Running

- Créer un service `p2-service` qui expose le pod à l'intérieur du cluster sur le port `3000->80`

- Vérifier `kube-proxy` tournent sur l'ensemble des nodes et qu'il utilise iptables. Utilise `crictl ps` pour cela

- Écrire les règles iptables de tous les nodes crées pour le service `p2-service` dans `/opt/cka/iptables.txt`


## 5. DNS - replicaSets

Utiliser le contexte: `kubectl config use-context  kind-k8s-no-cni`

> **Consignes**

- Créer un **replicaSet** nommé `ns-lookup` avec 2 replicas,   nommer le container `dns` avec l'image `registry.k8s.io/e2e-test-images/jessie-dnsutils:1.3` - Assurez-vous que les pods restent en Running
- Exécuter `nslookup kubernetes.default` depuis un de ces pods et stockés le output dans `/opt/cka/nslookup.txt`

## 6. NodePort

Utiliser le contexte: `kubectl config use-context  kind-k8s-no-cni`

> **Consignes**

- Créer et utiliser le namespace `cka-nodeport`
- Créer un deployment **nginx-app** avec l'image `nginx:1.29-alpine`, containerPort 80 et 1 replicas

- Créer un nodePort nommé `cka-nodeport` pour exposer le deployment **nginx-app** avec les infos suivantes:
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

> **Consignes**

- Créer et utiliser le namespace `public-app`
- Créer un deployment **public-app** avec l'image `nginx:1.29-alpine`, containerPort 80 et 1 replicas
- Exposer le avec un service clusterIp `public-app-svc`

- Créer un **ingress** nommé `public-app-ing` avec pour **host** `public-app.cka`, `class nginx` pour exposer l'application

Depuis l'un des node, vérifier que ca fonctionne avec `curl -H 'Host: public-app.cka' http://<IP-INGRESS-CREE>` 


## 9. DNS -Service

Utiliser le contexte: `kubectl config use-context  kind-k8s-no-cni`

> **Consignes**

- Créer et utiliser le namespace `dns-test`
- Créer le pod `dns-web-app` avec `nginx:1.29-alpine`

- Exposer le pod `dns-web-app` avec un service cluserIP `dns-web-svc`, port 80
  
- Lancer un pod `dns-wget`avec l'image `busybox:1.36`, il doit rester en running
- Vérifier que le pod `dns-wget` arrive bien à joindre le service
  - `wget -qO- http://dns-web-svc`
  - `wget -qO- http://dns-web-svc.dns-test.svc.cluster.local`


## 10. API Gateway

- Utiliser le contexte: `kubectl config use-context  kind-k8s-no-cni`

- Gateway API  DOC: [https://gateway-api.sigs.k8s.io/guides/](https://gateway-api.sigs.k8s.io/guides/)

> **Consignes**

- Installer/Activer les CRDs  Gateway API
  
```shell
kubectl apply -f - <<EOF
apiVersion: operator.tigera.io/v1
kind: GatewayAPI
metadata:
  name: default
EOF
```

- Dans `/opt/cka/gateway-crd.txt`, écrire tous les noms des resources/CRD appartenant à l' Api Group `gateway.networking.k8s.io`

- Créer et utiliser le namespace `gateway`

- Créer les deployments `gw-app1` et `gw-app2`  avec `nginx:1.29-alpine` 

- Exposer `gw-app1` avec le service `gw-app1-svc` sur le port 8081
- Exposer `gw-app2` avec le service `gw-app2-svc` sur le port 8082

Vous allez maintenant créer les objets API Gateways

- Créer un **Gateway** nommé `central-gateway`  qui écoute sur le port 80, utiliser le gateway class existant.

- Créer un **HTTPRoute** `gw-app-routes`  utilisant le Gateway `central-gateway` pour router le trafic vers les services (backend)
  - Path `/app1/` doit router vers le service `gw-app1-svc`
  - Path `/app2/` doit router vers le service `gw-app2-svc`
  - Utiliser le **hostname** : `gw.formation.cka`

- Lister/Écrire  les services dans le namespace `tigera-gateway`  dans `/opt/cka-gw-calico.txt`

> **Ingress -> HTTPRoute**

- Convertissez la ressource  `ingress` ci-dessous en son equivalent `HTTPRoute` dans le fichier `/opt/cka/httproute.yaml`
  - utiliser la Gateway `central-gateway`
  - créer le ressource HTTRoute en applicant `/opt/cka/httproute.yaml`


```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: public-app-access
  namespace: public-app
spec:
  ingressClassName: nginx
  rules:
  - host: gw-public-app.cka
    http:
      paths:
      - backend:
          service:
            name: public-app-svc
            port:
              number: 80
        path: /
        pathType: Prefix
```