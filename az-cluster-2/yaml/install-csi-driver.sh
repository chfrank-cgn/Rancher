#!/usr/bin/ksh

# helm repo add azuredisk-csi-driver https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/charts
# helm repo add azurefile-csi-driver https://raw.githubusercontent.com/kubernetes-sigs/azurefile-csi-driver/master/charts

helm --kubeconfig=../.kube/config repo update
sleep 5

kubectl --kubeconfig=../.kube/config create configmap azure-cred-file --from-literal=path="/etc/kubernetes/cloud-config" -n kube-system
sleep 5

helm install azuredisk-csi-driver azuredisk-csi-driver/azuredisk-csi-driver --kubeconfig ../.kube/config --namespace kube-system --set controller.allowEmptyCloudConfig=true
sleep 15

helm install azurefile-csi-driver azurefile-csi-driver/azurefile-csi-driver --kubeconfig ../.kube/config --namespace kube-system --set controller.allowEmptyCloudConfig=true
sleep 15

kubectl --kubeconfig=../.kube/config apply -f azure-disk.yaml 
sleep 5

kubectl --kubeconfig=../.kube/config apply -f azure-clusterrole.yaml 
sleep 5

kubectl --kubeconfig=../.kube/config apply -f azure-file.yaml 

exit 0

