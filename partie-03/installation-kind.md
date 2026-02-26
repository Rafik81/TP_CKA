# VM Kind

```shell
rm -f install-docker-kind.sh
wget https://gitlab.enoks.fr/pub/scripts/-/raw/master/scripts/install-docker-kind.sh
sudo bash install-docker-kind.sh

# Donner les permissions à <votre-user-normal> : non-root 
sudo usermod -aG docker ambient-user

# Vérifier que le user normal, non-root a accès à Docker
newgrp docker  # ou reboot la machine
docker run hello-world
```

> **A faire avec <votre-user-normal>**, le  `NON-ROOT`


- Ajout de  **l'auto-completion**

```shell
echo 'source <(kubectl completion bash)' >> ~/.bashrc
echo 'alias k=kubectl' >> ~/.bashrc
echo 'complete -o default -F __start_kubectl k' >> ~/.bashrc
exec -l $SHELL
```

- Créer les fichiers configs pour `kind`
  
```shell
cat > kindconf.yaml <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
  - role: worker
  - role: worker
EOF

cat > kind-no-cni.yaml <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
  - role: worker
  - role: worker
networking:
  disableDefaultCNI: true
  podSubnet: 192.168.0.0/16
EOF

cat > k8s-c2-ac.yaml <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
  - role: worker
EOF
```

- **Créer les clusters** `kind`

```shell
kind create cluster -n k8s-no-cni --config kind-no-cni.yaml
kind create cluster -n k8s-c2-ac --config k8s-c2-ac.yaml
kind create cluster -n k8s-c3-ccc
kind create cluster -n k8s-c1-h --config kindconf.yaml
```


- **Vérifier** les clusters

```shell
kind get clusters
k8s-c1-h
k8s-c2-ac
k8s-c3-ccc
k8s-no-cn


kubectl config get-contexts
CURRENT   NAME              CLUSTER           AUTHINFO          NAMESPACE
*         kind-k8s-c1-h     kind-k8s-c1-h     kind-k8s-c1-h     
          kind-k8s-c2-ac    kind-k8s-c2-ac    kind-k8s-c2-ac    
          kind-k8s-c3-ccc   kind-k8s-c3-ccc   kind-k8s-c3-ccc   
          kind-k8s-no-cni   kind-k8s-no-cni   kind-k8s-no-cni

```

