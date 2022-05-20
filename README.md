# K8s - тестовый стенд на Vagrant+VirtualBox

Должен быть выключен swap

```
swapon --show
```

Проверить фаервол и iptables

```
iptables -L
```

## Установка

```
vagrant up
```

## Создание кластера

```
kubeadm init --apiserver-advertise-address 192.168.20.10 \
 --pod-network-cidr=10.244.0.0/16
```

Экспортировать переменную в окружение:

```
export KUBECONFIG=/etc/kubernetes/admin.conf
```

Чтобы каждый раз при входе в систему не приходилось повторять данную команду, открываем файл:

```
vim /etc/environment
```

И добавляем в него строку:

```
export KUBECONFIG=/etc/kubernetes/admin.conf
```

Установка CNI (Container Networking Interface)

```
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

Подключение нод:

```
kubeadm join 192.168.20.10:6443 --token ...
```

## Ссылки

- [Установка и настройка кластера Kubernetes на Ubuntu Server](https://www.dmosk.ru/instruktions.php?object=kubernetes-ubuntu)
- [{Habr. Как настроить Kubernetes кластер на Vagrant VM](https://habr.com/ru/post/599039/)
