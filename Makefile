export KIND_VERSION ?= 0.2.1
export KUBE_VERSION ?= v1.11.3
export KUBECONFIG := /home/circleci/.kube/kind-config-kind

download_kind:
	wget https://github.com/kubernetes-sigs/kind/releases/download/${KIND_VERSION}/kind-linux-amd64 -O kind
	chmod +x ./kind

kind_create: download_kind
	./kind create cluster --image kindest/node:${KUBE_VERSION}

kind_destroy: 
	./kind delete cluster

download_kubectl:
	wget https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl -O kubectl
	chmod +x kubectl

wait_for:
	until ./kubectl get pods --namespace kube-system | grep -i kube-apiserver-kind-control-plane ; do sleep 1 ; done

validate: download_kubectl kind_create wait_for
	./kubectl get pods --all-namespaces

.PHONY: download_kind kind_create kind_destroy download_kubectl test

