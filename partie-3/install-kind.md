# VM Kind

```shell
rm -f install-docker-kind.sh
wget https://gitlab.enoks.fr/pub/scripts/-/raw/master/scripts/install-docker-kind.sh
sudo bash install-docker-kind.sh

usermod -aG docker <le-user-normal>

# Vérifier que le user normal, non-root a accès à Docker
newgrp docker  # ou reboot la machine
docker run hello-world

wget https://gitlab.enoks.fr/pub/scripts/-/raw/master/scripts/dssh.sh
chmod +x dssh.sh
sudo mv dssh.sh /usr/local/bin/dssh
```

**A faire avec le user normal**


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

kind create cluster -n k8s-no-cni --config kind-no-cni.yaml
kind create cluster -n k8s-c2-ac --config k8s-c2-ac.yaml
kind create cluster -n k8s-c3-ccc
kind create cluster -n k8s-c1-h --config kindconf.yaml
```

