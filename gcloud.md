### Create a VM with custom specs
```
gcloud compute instances create my-vm --custom-cpu 4 --custom-memory 5
```

### Other
```
gcloud alpha resource-manager tags bindings create \
--tag-value=TAGVALUE_NAME \
--parent=RESOURCE_ID
--location=LOCATION

gcloud alpha resource-manager tags bindings list \
    --parent=RESOURCE_ID \
    --location=LOCATION
```

https://cloud.google.com/resource-manager/docs/tags/tags-creating-and-managing#gcloud_8

### Artifact Registry
```
export GCP_PROJECT_ID=YOUR_PROJECT_ID

gcloud config set project $GCP_PROJECT_ID

gcloud services enable cloudbilling.googleapis.com \
    artifactregistry.googleapis.com \
    cloudbuild.googleapis.com

gcloud auth application-default login

docker build . -t us-central1-docker.pkg.dev/$GCP_PROJECT_ID/docker-repo/k8s-cost-estimator:v0.0.1

gcloud artifacts repositories create docker-repo \
        --repository-format=docker \
        --location=us-central1 \
        --description="Docker repository"

gcloud auth configure-docker us-central1-docker.pkg.dev

docker push us-central1-docker.pkg.dev/$GCP_PROJECT_ID/docker-repo/k8s-cost-estimator:v0.0.1
```
