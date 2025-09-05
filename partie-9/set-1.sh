#!/bin/bash

systemctl stop kubelet > /dev/null 2>&1 || true
systemctl disable kubelet > /dev/null 2>&1 || true
systemctl daemon-reload > /dev/null 2>&1 || true

sed -i 's|/usr/bin/kubelet|/tmp/local/kubelet|' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf > /dev/null 2>&1
sed -i 's|/usr/bin/kubelet|/tmp/local/kubelet|' /etc/systemd/system/kubelet.service > /dev/null 2>&1

echo "Completed"