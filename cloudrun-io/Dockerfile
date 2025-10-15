FROM ubuntu:22.04

# Install dependencies: coreutils (for dd), sysstat (for iostat), curl, fuse, and Google Cloud SDK for gsutil and gcsfuse
RUN apt-get update && apt-get install -y \
    coreutils \
    sysstat \
    curl \
    fuse \
    ca-certificates \
    && curl -sSL https://sdk.cloud.google.com | bash \
    && echo "export PATH=\"$PATH:/root/google-cloud-sdk/bin\"" >> /root/.bashrc \
    && /root/google-cloud-sdk/bin/gcloud components install gcsfuse --quiet \
    && apt-get clean

# Copy the script
COPY latency-measure.sh /app/latency-measure.sh
RUN chmod +x /app/latency-measure.sh

# Set entrypoint to mount GCS and run the script
ENTRYPOINT ["/bin/bash", "-c", \
    "gcsfuse --debug_gcs your-bucket /mnt/gcs && /app/latency-measure.sh"]
