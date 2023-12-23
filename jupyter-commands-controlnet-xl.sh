#!/bin/bash

# Set the repository URL and the base URL for downloading files
REPO_URL="https://huggingface.co/lllyasviel/sd_control_collection/"
DOWNLOAD_BASE_URL="https://huggingface.co/lllyasviel/sd_control_collection/resolve/main/"

# Create a random temporary directory for the repository clone
REPO_TEMP_DIR=$(mktemp -d)

# Clone the repository without checking out files
git clone --no-checkout $REPO_URL $REPO_TEMP_DIR

# Change to the temporary repository directory
cd $REPO_TEMP_DIR

# Get list of .safetensors and .pth files
FILES=$(git ls-tree -r HEAD --name-only | grep -E "\.safetensors$|\.pth$")

# Print wget commands for Jupyter Notebook
for file in $FILES; do
    echo "!wget -P /path/to/destination/directory ${DOWNLOAD_BASE_URL}${file}"
done

# Clean up: remove the random temporary repository directory
rm -rf $REPO_TEMP_DIR

