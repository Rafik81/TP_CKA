# Security: RBAC - SecurityContext - NetworkPolicy

- Security Main Page    : [https://kubernetes.io/docs/concepts/security/](https://kubernetes.io/docs/concepts/security/)
  
- Pod Security Standard : [https://kubernetes.io/docs/concepts/security/pod-security-standards/](https://kubernetes.io/docs/concepts/security/pod-security-standards/)

- NetworkPolicy         : [https://kubernetes.io/docs/concepts/services-networking/network-policies/](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

## 1. RBAC - SA - Role - RoleBinding 

Utiliser le context `kubectl config use-context kind-k8s-c1-h`

> **Consignes**

- Créer  un nouveau ServiceAccount `processor` dans le Namespace `project-hamster` (à créer si besoin) 
- Créer un Role et un Rolebinding  tous deux également nommés `processor`. Ceux-ci devraient permettre au nouveau SA de créer uniquement des **secrets** et des **ConfigMaps** dans ce Namespace

> **Tips** : vérifier avec `k auth can-i`, exemple: ` k -n project-hamster auth can-i create secret  --as system:serviceaccount:project-hamster:processor`


## 2. SecurityContext - Pod Security Standard

Utiliser le contexte `kubectl config use-context kind-k8s-c2-ac`

> **Consignes**

Le but ici est de créer un namespace securisé et y deployer un pod sécurisé


- Créer et utiliser le namespace nommé `security-cka`
- Enforcer la policy/profile Pod Security Standard `baseline` sur le namespace
  - Utiliser/appliquer la dernière version : `xxx/enforce-version=latest`

- Créer le pod `secure-nginx`  avec l'image: `nginx:1.29-alpine`, avec le container nommé `nginx`
- Au niveau du pod, appliquer ces règles de securité: Exécuté-le avec un user non-root avec le UID `1000` et le user-non-root activé
  
- Au niveau container:
  - Empecher l'escalation de privilege
  - Utiliser un user non-root avec le UID `1000` et le user-non-root activé
  - Dropper toutes les capabilites `ALL` linux

- Appliquer/ajouter le seccomProfile par defaut

- Monter deux emptyDir dans le pod :
  - `nginx-cache` sur `/ /var/cache/nginx`
  - `nginx-www`sur `/usr/share/nginx/html`
  


## 3. RBAC - SA - ClusterRole - ClusterRoleBinding

Utiliser le contexte `kubectl config use-context kind-k8s-c2-ac`


> **Consignes**

- Créer et utiliser le namespace `rbac-cka`

- Créer les ServiceAccount `group-view` et `group-custom`

- Associer le clusterrole `view` au SA `group-view`  pour lui permettre de voir tout dans le cluster, utiliser le nom `group-view`

- Créer un  clusterrole `cka-cluster-role` avec les permissions `create`, `get`, `list` sur les deployments et les pods

- Associer clusterrole `cka-cluster-role` au SA `group-custom` en utilisan tle même nom


## 4. SecurityContext

Utiliser le context `kubectl config use-context kind-k8s-c1-h`

> **Consignes**

Dans le namespace `default`, créer un pod  `busybox`, image `busybox:1.36`  avec l'automount du serviceAccountToken désactivé
Au niveau du container, veilez qu'il soit
- En ReadOnly Filesystem
- Avec privileged désactivé
- L'escalation de privilege désactivée

## 5. Networkpolicy


Utiliser le contexte: `kubectl config use-context  kind-k8s-no-cni`

> **Consignes**

- Créer et utiliser le namespace `cka-netpol`
  
- Créer un  deployment nommé `web` avec `nginx:1.29-alpine` et le label `app=web`
- Créer un  deployment nommé `api` avec `nginx:1.29-alpine` et le label `app=api`
- Créer un  deployment nommé `db` avec `postgres:13.22-alpine`, le label `app=db` et la variable environment `POSTGRES_HOST_AUTH_METHOD=trust`

- Créer des  **NetworkPolicies** pour: (tips: 3)
   - Autoriser web à communiquer uniquement avec api
   - Autoriser api à communiquer uniquement avec db
   - Tout le reste du trafic avec les autres pods est bloqué

## 6. Networkpolicy with port


Utiliser le contexte: `kubectl config use-context kind-k8s-c1-h`

> **Consignes**

- Créer et utiliser le namespace `project-snake`
 
- Créer un  pod nommé `db1` avec `postgres:13.22-alpine`, le label `run=db1` , container port 1111 et la variable environment `POSTGRES_HOST_AUTH_METHOD=trust`
- Créer un  pod nommé `db2` avec `postgres:13.22-alpine`, le label `run=db2` , container port 2222 et la variable environment `POSTGRES_HOST_AUTH_METHOD=trust`
  
- Créer ce Statefulset avec cette commande det vérifier que les pods sont en Running
```shell
cat <<EOF|kubectl apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: backend
  namespace: project-snake
spec:
  replicas: 2
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: nginx:1.29-alpine
        ports:
        - containerPort: 8080
          name: backend

EOF
```

- Créer le pod `vault`  avec 

```shell
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: vault
  name: vault
  namespace: project-snake
spec:
  containers:
  - env:
    - name: NODE_NAME
      valueFrom:
        fieldRef:
          fieldPath: spec.nodeName
    - name: POD_NAME
      valueFrom:
        fieldRef:
          fieldPath: metadata.name
    - name: POD_NAMESPACE
      valueFrom:
        fieldRef:
          fieldPath: metadata.namespace
    - name: POD_IP
      valueFrom:
        fieldRef:
          fieldPath: status.podIP
    image: gcr.io/kubernetes-e2e-test-images/echoserver:2.2
    name: vault
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
EOF
```

- Vérifier que les pods `backend-*` peuvent joindre le pod `vault`sur le port 8080


Pour des questions de sécurité, créer un **NetworkPolicy** nommé `np-backend`  qui autorise **uniquement** les pods `backend-*` à:

- se connecter au pod `db1` sur le port `1111`
- se connecter au pod `db2` sur le port `2222`


Une fois appliquée, les requetes vers  `vault`sur le port 8080 ne devraient plus fonctionner


On va autoriser un namespace entier

- Créer les namespaces `curl-allow` et `curl-deny`
- Créer le pod `pod-allow` et `pod-deny` respectivement dans `curl-allow` et `curl-deny`
  - Utiliser `kubectl -n <namespace> run <nom> --image=curlimages/curl -- sleep 1d`

Vérifier que ces deux pods peuvent joindre le pod `vault`sur le port 8080. EN fait tous les pods peuvent le joindre !  on va donc limiter cela

- Dans le namespace `project-snake` créer **NetworkPolicy** nommé `allow-ns-curl-allow` qui autorise uniquement tout le trafic venant du namespace `curl-allow` à joindre le pod `vault`sur le port 8080.

- Vérifier que le pod `pod-allow`  a toujours accès et pas le `pod-deny`


## LimitRange - Quota

Utiliser le contexte `kubectl config use-context kind-k8s-c3-ccc`

> **Consignes**

Dans le namespace `quota-limits`:

- Créer une **LimitRange** `resource-limits` avec:
  - Default request: CPU: `10m`, Memory: `8Mi`
  - Default limit: CPU: `20m`, Memory: `128Mi`
  - Max limit: CPU: `50m`, Memory: `256Mi`
  
. Créer une ResourceQuota `compute-quota`avec:
   - Max total CPU: `2`
   - Max total memory: `1Gi`
   - Max number of pods: `2`
  
- Créer un deployement `test-quota-limit` avec `nginx:1.29-alpine` et **3 replicas**

Vérifier que les limites s'appliquent bien et le quota aussi

stcoker les events du namespace après avoir appliquer une `grep compute-quota` dans `/opt/cka/test-quota.log`



