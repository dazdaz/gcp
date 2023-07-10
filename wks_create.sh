PROJECT_ID=$(gcloud config get-value project)
REGION="europe-west1"

# NETWORK="workstation-network"
# SUBNET="${NETWORK}-${REGION}"
# SUBNET_RANGE="10.0.0.0/26"

NETWORK="default"
SUBNET="default"
SUBNET_RANGE="10.0.0.0/26"

WORKSTATION_CLUSTER_ID="ws-cluster"
WORKSTATION_CONFIG_ID="ws-configuration-argolis"
WORKSTATION_ID="workstation-01"

gcloud services enable compute.googleapis.com workstations.googleapis.com --project=$PROJECT_ID

gcloud compute networks create ${NETWORK} --subnet-mode=custom --project=$PROJECT_ID
gcloud compute networks subnets create $SUBNET --network=$NETWORK --range=$SUBNET_RANGE --enable-private-ip-google-access --region=$REGION

gcloud compute routers create "$NETWORK-router-$REGION" --network=$NETWORK --region=$REGION --project=$PROJECT_ID
gcloud compute routers nats create "$NETWORK-nat-$REGION" --router=$NETWORK-router-$REGION --auto-allocate-nat-external-ips --nat-all-subnet-ip-ranges --region=$REGION --project=$PROJECT_ID

gcloud beta workstations clusters create $WORKSTATION_CLUSTER_ID --region=$REGION

gcloud beta workstations configs create $WORKSTATION_CONFIG_ID --cluster=$WORKSTATION_CLUSTER_ID \
  --disable-public-ip-addresses --shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring \
  --region=$REGION --machine-type=e2-standard-4 --pd-disk-type=pd-ssd --pd-disk-size=10 --container-predefined-image=codeoss

gcloud beta workstations create $WORKSTATION_ID --config=$WORKSTATION_CONFIG_ID --cluster=$WORKSTATION_CLUSTER_ID --region=$REGION

gcloud beta workstations start $WORKSTATION_ID --config=$WORKSTATION_CONFIG_ID --cluster=$WORKSTATION_CLUSTER_ID --region=$REGION
