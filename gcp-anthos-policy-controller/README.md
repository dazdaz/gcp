### Prep - Install Anthos Policy Controller through Anthos Config Management
```
cat << EOF > policy_controller.yaml
# policy_controller.yaml

apiVersion: configmanagement.gke.io/v1
kind: ConfigManagement
metadata:
  name: config-management
  namespace: config-management-system
spec:
  # clusterName is required and must be unique among all managed clusters
  clusterName: <your-GKE-cluster>
  # Set to true to install and enable Policy Controller
  policyController:
    enabled: true
    # Uncomment to prevent the template library from being installed
    # templateLibraryInstalled: false
    # Uncomment to disable audit, adjust value to set audit interval
    # auditIntervalSeconds: 0
EOF

kubectl apply -f policy_controller.yaml
# Can take a good 5 minutes for GateKeeper to properly start
kubectl get pods -n gatekeeper-system
# Check logs for any issues
kubectl logs -n gatekeeper-system gatekeeper-controller-manager-0
wait 5
kubectl get constrainttemplates
kubectl describe constrainttemplate k8spspvolumetypes
```

### Demo - Apply policy restrictions to Anthos Policy Controller
```
$ cat restrict_psp.yaml
# https://cloud.google.com/anthos-config-management/docs/how-to/using-constraints-to-enforce-pod-security

apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sPSPPrivilegedContainer
metadata:
  name: psp-privileged-container
spec:
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Pod"]
```

### Demo - Show policy restrictions being applied in realtime, preventing the launch of a pod
```
$ cat privileged_pod.yaml
# https://github.com/open-policy-agent/gatekeeper/blob/master/library/pod-security-policy/privileged-containers/example.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-privileged
  labels:
    app: nginx-privileged
spec:
  containers:
  - name: nginx
    image: nginx
    securityContext:
      privileged: true #false
```

https://cloud.google.com/anthos-config-management/docs/how-to/using-constraints-to-enforce-pod-security
https://cloud.google.com/anthos-config-management/docs/how-to/installing-policy-controller
