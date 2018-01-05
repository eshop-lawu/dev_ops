## kubespray

通过kubespray自动安装k8s。

kubespray与其它安装方式的对比：https://github.com/kubernetes-incubator/kubespray/blob/master/docs/comparisons.md

### 1、机器列表
    node1 | 192.168.1.51 | master | CentOS 7.4
    node2 | 192.168.1.52 | worker | CentOS 7.4
    node3 | 192.168.1.53 | worker | CentOS 7.4
    操作机 |192.168.1.54 | ansible| CentOS 7.4
    
### 2、操作机按照ansible
```
    yum install -y epel-release
    yum install -y python-pip  python-netaddr  ansible git
    pip install --upgrade Jinja2
```

### 3、操作机免密码登录节点
```
    ssh-keygen
    ssh-copy-id root@192.168.1.51
    ssh-copy-id root@192.168.1.52
    ssh-copy-id root@192.168.1.53
```

### 4、所有节点关闭防火墙
```
    systemctl stop firewalld
    systemctl disable firewalld
```

### 5、修改kubespray文件

本文的源码仅为演示作用，大家使用时候可能版本已经有变动，请下载kubespray源码，地址为:https://github.com/kubernetes-incubator/kubespray。

####（1）修改镜像
修改源码时主要参考阿里云里对应的镜像和版本，以防阿里云无此镜像，查看阿里云镜像请访问https://dev.aliyun.com/search.html。

- kubespray/roles/kubernetes-apps/ansible/defaults/main.yml
- kubespray/roles/download/defaults/main.yml
- kubespray/extra_playbooks/roles/download/defaults/main.yml
- kubespray/inventory/group_vars/k8s-cluster.yml
- kubespray/roles/dnsmasq/templates/dnsmasq-autoscaler.yml

####（2）禁用rbac校验
修改kubespray/roles/kubernetes/preinstall/tasks/verify-settings.yml，将"rbac_enabled"那一行去掉。

####（3）移除禁用系统swap
修改kubespray/roles/bootstrap-os/tasks/main.yml，在最后面添加
```
- name: Remove swapfile from /etc/fstab
  mount:
    name: swap
    fstype: swap
    state: absent

- name: Disable swap
  command: swapoff -a
```
参考：https://github.com/kubernetes-incubator/kubespray/pull/2004

### 6、inventory.cfg
在`kubespray/inventory/inventory.cfg`，添加内容:
```
    # ## Configure 'ip' variable to bind kubernetes services on a
    # ## different ip than the default iface
    node1 ansible_ssh_host=192.168.1.51 ansible_user=root ip=192.168.1.51 # ip=10.3.0.1
    node2 ansible_ssh_host=192.168.1.52 ansible_user=root ip=192.168.1.52 # ip=10.3.0.2
    node3 ansible_ssh_host=192.168.1.53 ansible_user=root ip=192.168.1.53 # ip=10.3.0.3
    
    # ## configure a bastion host if your nodes are not directly reachable
    # bastion ansible_ssh_host=x.x.x.x
    
    [kube-master]
    node1
    
    [etcd]
    node1
    
    [kube-node]
    node2
    node3
    
    [k8s-cluster:children]
    kube-node
    kube-master

```

### 7. 使用ansible安装

在kubespray根目录，执行:
```shell
    ansible-playbook -u centos -b -i inventory/inventory.cfg cluster.yml
```

### 8、验证安装

- 登录51:`ssh root@192.168.1.51`
- 查看node:`kubectl get node`
```shell
    NAME      STATUS    ROLES     AGE       VERSION
    node1     Ready     master    3d        v1.8.1+coreos.0
    node2     Ready     node      3d        v1.8.1+coreos.0
    node3     Ready     node      3d        v1.8.1+coreos.0
```
- 查看pod:`kubectl get pod --all-namespaces`

```shell
    NAMESPACE     NAME                                    READY     STATUS    RESTARTS   AGE
    default       nginx                                   1/1       Running   0          2d
    kube-system   calico-node-bm6d9                       1/1       Running   0          3d
    kube-system   calico-node-sxrq2                       1/1       Running   0          3d
    kube-system   calico-node-x4zss                       1/1       Running   0          3d
    kube-system   kube-apiserver-node1                    1/1       Running   0          3d
    kube-system   kube-controller-manager-node1           1/1       Running   0          2d
    kube-system   kube-dns-68c7f6f46c-b7f92               3/3       Running   0          3d
    kube-system   kube-dns-68c7f6f46c-vrmkm               3/3       Running   0          3d
    kube-system   kube-proxy-node1                        1/1       Running   0          3d
    kube-system   kube-proxy-node2                        1/1       Running   0          3d
    kube-system   kube-proxy-node3                        1/1       Running   0          3d
    kube-system   kube-scheduler-node1                    1/1       Running   0          2d
    kube-system   kubedns-autoscaler-85679785d-4779k      1/1       Running   0          3d
    kube-system   kubernetes-dashboard-646655c784-p88s6   1/1       Running   0          2d
    kube-system   nginx-proxy-node2                       1/1       Running   0          3d
    kube-system   nginx-proxy-node3                       1/1       Running   0          3d
```

### 9、kubernetes-dashboard
通过kubespray按照会默认装上dashboard，预设不会对外暴露，可通过本机转送：
```shell
    kubectl proxy --address 0.0.0.0 --accept-hosts '.*'
```

浏览器访问：http://192.168.1.51:8001/ui

### 10、参考资料
- https://github.com/wiselyman/kubespray
- http://samchu.logdown.com/posts/2458552-use-kubespray-to-install-kubernetes-17
- https://github.com/kubernetes-incubator/kubespray/issues/2066
- https://github.com/kubernetes-incubator/kubespray/pull/2004
- https://github.com/kubernetes-incubator/kubespray/blob/master/docs/getting-started.md