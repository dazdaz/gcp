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
# Build, tag, and push the image
gcloud builds submit --tag us-east1-docker.pkg.dev/my-project/dev/hello-app

# Pull the image or deploy it to GCP
kubectl create deployment hello-server \
	    --image=us-east1-docker.pkg.dev/my-project/dev/hello-app

# You can now tag, push, and pull images (with appropriate permissions)*
# https://cloud.google.com/container-registry/docs/access-control#permissions_and_roles
docker build -t gcr.io/my-project/hello-app .
docker tag hello-app gcr.io/my-project/dev/hello-app
docker push gcr.io/my-project/dev/hello-app
docker pull gcr.io/my-project/dev/hello-app

# You can now tag, push, and pull images (with appropriate permissions to the repo)
# https://cloud.google.com/artifact-registry/docs/access-control#permissions
docker build -t us-east1-docker.pkg.dev/my-project/dev/hello-app .
docker tag hello-app us-east1-docker.pkg.dev/my-project/dev/hello-app
docker push us-east1-docker.pkg.dev/my-project/dev/hello-app
docker pull us-east1-docker.pkg.dev/my-project/dev/hello-app

gcloud auth configure-docker us-central1-docker.pkg.dev

docker push us-central1-docker.pkg.dev/$GCP_PROJECT_ID/docker-repo/k8s-cost-estimator:v0.0.1
```
