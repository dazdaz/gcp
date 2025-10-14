# FOLDER=[censored]      # <<<< A folder within your organization
# PROJECT_ID=[censored]  # <<<< A valid (but not existing) project id
# ACCOUNT_ID=[censored]  # <<<< A valid billing account

BUILD=cmake-build-debug  # The binary directory for google-cloud-cpp

gcloud projects create ${PROJECT_ID} --folder ${FOLDER}
gcloud config set project ${PROJECT_ID}
gcloud beta billing projects link ${PROJECT_ID} --billing-account=${ACCOUNT_ID}

SA_NAME=repro-issue-3277
SA_FULL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
gcloud iam service-accounts create ${SA_NAME} \
    --display-name="Service account to reproduce #3277"

gcloud iam service-accounts keys create /dev/shm/sa-key.json \
      --iam-account "${SA_FULL}"

BUCKET_NAME=${PROJECT_ID}-test-01
gsutil mb "gs://${BUCKET_NAME}"


# This example works with the user credentials.
./${BUILD}/google/cloud/storage/examples/storage_object_samples upload-file README.md "${BUCKET_NAME}" README.md

# This fails, because the service account does not have permissions.
GOOGLE_APPLICATION_CREDENTIALS=/dev/shm/sa-key.json ./${BUILD}/google/cloud/storage/examples/storage_object_samples upload-file README.md "${BUCKET_NAME}" README-2.md

# This also fails, for the same reason.
./${BUILD}/google/cloud/storage/examples/service_account_credentials /dev/shm/sa-key.json "${BUCKET_NAME}" upload-1.md

# If we grant the service account the right permissions, then both work:
gsutil acl ch -u "${SA_FULL}:W" "gs://${BUCKET_NAME}"


GOOGLE_APPLICATION_CREDENTIALS=/dev/shm/sa-key.json ./cmake-build-debug/google/cloud/storage/examples/storage_object_samples upload-file README.md "${BUCKET_NAME}" README-2.md

./${BUILD}/google/cloud/storage/examples/service_account_credentials /dev/shm/sa-key.json "${BUCKET_NAME}" upload-1.md
