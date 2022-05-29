#!/bin/sh

/usr/bin/kubectl --kubeconfig=.kube/config patch namespace cattle-system -p '{"metadata":{"finalizers":[]}}' --type='merge' -n cattle-system

exit 0
