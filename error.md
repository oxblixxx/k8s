```sh
fatal: [node-1]: FAILED! => {"changed": true, "cmd": ["kubeadm", "init", "--config", "/tmp/kubeadm_config.yaml"],
 "delta": "0:00:00.665502", "end": "2024-08-28 21:55:26.419451", "msg": "non-zero return code", "rc": 1, "start":
"2024-08-28 21:55:25.753949", "stderr": "I0828 21:55:26.048584   47245 version.go:256] remote version is much
 newer: v1.31.0; falling back to: stable-1.30\nerror execution phase preflight: [preflight] Some fatal errors
occurred:\n\t[ERROR Port-6443]: Port 6443 is in use\n\t[ERROR Port-10259]: Port 10259 is in use\n\t[ERROR Port-10257
Port 10257 is in use\n\t[ERROR FileAvailable--etc-kubernetes-manifests-kube-apiserver.yaml]: /etc/kubernetes/manifests
/kube-apiserver.yaml already exists\n\t[ERROR FileAvailable--etc-kubernetes-manifests-kube-controller-manager.yaml]:
 /etc/kubernetes/manifests/kube-controller-manager.yaml already exists\n\t[ERROR FileAvailable--etc-kubernetes-manifests-kube-scheduler.yaml]:
/etc/kubernetes/manifests/kube-scheduler.yaml already exists\n\t[ERROR FileAvailable--etc-kubernetes-manifests-etcd.yaml]:
/etc/kubernetes/manifests/etcd.yaml already exists\n\t[ERROR Port-10250]: Port 10250 is in use\n\t[ERROR Port-2379]:
Port 2379 is in use\n\t[ERROR Port-2380]: Port 2380 is in use\n\t[ERROR DirAvailable--var-lib-etcd]: /var/lib/etcd is not empty\n[preflight]
 If you know what you are doing, you can make a check non-fatal with --ignore-preflight-errors=...\n
To see the stack trace of this error execute with --v=5 or higher", "stderr_lines": ["I0828 21:55:26.048584
47245 version.go:256] remote version is much newer: v1.31.0; falling back to: stable-1.30", "error execution
phase preflight: [preflight] Some fatal errors occurred:", "\t[ERROR Port-6443]: Port 6443 is in use",
"\t[ERROR Port-10259]: Port 10259 is in use", "\t[ERROR Port-10257]: Port 10257 is in use", "\t
[ERROR FileAvailable--etc-kubernetes-manifests-kube-apiserver.yaml]: /etc/kubernetes/manifests/kube-apiserver.yaml
 already exists", "\t[ERROR FileAvailable--etc-kubernetes-manifests-kube-controller-manager.yaml]:
/etc/kubernetes/manifests/kube-controller-manager.yaml already exists", "\t[ERROR FileAvailable--etc-kubernetes-manifests-kube-scheduler.yaml]:
 /etc/kubernetes/manifests/kube-scheduler.yaml already exists", "\t[ERROR FileAvailable--etc-kubernetes-manifests-etcd.yaml]:
/etc/kubernetes/manifests/etcd.yaml already exists", "\t[ERROR Port-10250]: Port 10250 is in use", "\t[ERROR Port-2379]:
 Port 2379 is in use", "\t[ERROR Port-2380]: Port 2380 is in use", "\t[ERROR DirAvailable--var-lib-etcd]:
/var/lib/etcd is not empty", "[preflight] If you know what you are doing, you can make a check non-fatal with
--ignore-preflight-errors=...", "To see the stack trace of this error execute with --v=5 or higher"], "stdout":
 "[init] Using Kubernetes version: v1.30.4\n[preflight] Running pre-flight checks", "stdout_lines": ["[init]
Using Kubernetes version: v1.30.4", "[preflight] Running pre-flight checks"]}
```

Well, to fix this issue goes various ways, 

```sh
sudo rm -f /etc/kubernetes/manifests/*.yaml
sudo umount /var/lib/etcd
sudo kubeadm reset -f
sudo rm -rf /etc/kubernetes/ /var/lib/etcd /var/lib/kubelet /var/lib/dockershim
sudo rm -rf /var/lib/cni/ /etc/cni/
```

Here is an ansible play for it [ansible-play](https://github.com/oxblixxx/k8s/blob/master/clean_k8s.yaml)
Then run the playbook again. NB, this will be wiping the etcd, Condsidering there is no data on the etcd, it was prompted to be wiped. Further research will be done on how to avoid clearing the etcd
