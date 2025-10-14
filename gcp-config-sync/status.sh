gcloud beta container fleet config-management status
kubectl get pods -n config-management-system
nomos status
kubectl logs -l "app=reconciler" -n config-management-system --all-containers
