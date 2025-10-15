#!/bin/bash

# Script to measure latency for reading and writing files from a GCS bucket mounted via FUSE in Cloud Run.
# Assumptions:
# - GCS bucket is already mounted at /mnt/gcs (update MOUNT_PATH if different).
# - Test files exist in the bucket: e.g., small_testfile (1MB) and large_testfile (100MB).
# - gsutil is installed in the container.
# - Run this script in your Cloud Run job's entrypoint or via exec.

# Configurable variables
MOUNT_PATH="/mnt/gcs"          # Path where GCS is mounted
SMALL_FILE="small_testfile"    # Small file for testing (~1MB)
LARGE_FILE="large_testfile"    # Large file for testing (~100MB)
WRITE_SIZE_MB=10               # Size in MB for write test
NUM_RUNS=5                     # Number of runs to average

# Function to measure read latency
measure_read() {
    local file=$1
    echo "Measuring read latency for $file..."
    for i in $(seq 1 $NUM_RUNS); do
        echo "Run $i:"
        time dd if="$MOUNT_PATH/$file" of=/dev/null bs=1M 2>&1
        echo ""
    done
}

# Function to measure write latency
measure_write() {
    local file="testwrite_$(date +%s)"
    echo "Measuring write latency (writing ${WRITE_SIZE_MB}MB)..."
    for i in $(seq 1 $NUM_RUNS); do
        echo "Run $i:"
        time dd if=/dev/zero of="$MOUNT_PATH/$file" bs=1M count=$WRITE_SIZE_MB 2>&1
        rm -f "$MOUNT_PATH/$file"  # Clean up
        echo ""
    done
}

# Function to measure direct GCS network latency (bypassing FUSE)
measure_gcs_direct() {
    local bucket="your-bucket"  # Replace with your GCS bucket name
    local file=$1
    echo "Measuring direct GCS read latency for gs://$bucket/$file..."
    for i in $(seq 1 $NUM_RUNS); do
        echo "Run $i:"
        time gsutil cp "gs://$bucket/$file" /dev/null 2>&1
        echo ""
    done
}

# Function to check disk latency (requires iostat; install sysstat if needed)
check_disk() {
    echo "Monitoring disk IO during a large read..."
    iostat -x 1 10 &  # Run in background for 10 intervals
    dd if="$MOUNT_PATH/$LARGE_FILE" of=/dev/null bs=1M
    wait  # Wait for iostat to finish
}

# Main execution
echo "Starting latency measurements..."

# Step 1: Prepare (assume files are uploaded; you can add gsutil upload here if needed)

# Step 2: Measure FUSE read/write latency
measure_read "$SMALL_FILE"
measure_read "$LARGE_FILE"
measure_write

# Step 3: Measure direct GCS latency
measure_gcs_direct "$SMALL_FILE"
measure_gcs_direct "$LARGE_FILE"

# Step 4: Check disk (optional, for cache-bound checks)
check_disk

# Step 5: Analyze in logs (add custom averaging if needed)
echo "Measurements complete. Review 'real' times for latency. High 'real' with low 'user/sys' indicates IO bound."
