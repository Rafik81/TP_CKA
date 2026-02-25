#!/bin /bash

## 13. Stucked Deployment

sed -i 's|kube-controller-manager|kube-controller-manageur|' /etc/kubernetes/manifests/kube-controller-manager.yaml > /dev/null 2>&1 || true
systemctl restart kubelet > /dev/null 2>&1 || true

echo "Completed"
