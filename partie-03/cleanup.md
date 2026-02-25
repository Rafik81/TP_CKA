## Clean Up

Pour ceux qui ont déjà un cluster Kubernetes existant, il faut reset les VMS

> **Cleanup des anciennes VMs**

```shell
rm -rf cleanup-node.sh
wget https://gitlab.enoks.fr/pub/scripts/-/raw/master/scripts/cleanup-node.sh
sudo bash cleanup-node.sh
```

> **CleanUp VM helper**


```shell
apt remove -y haproxy
rm -rf /etc/haproxy
systemctl daemon-reload
rm -rf ~/admin.conf /home/ambient-user/admin.conf
```