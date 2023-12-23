#!/bin/bash

# Set the repository URL and the base URL for downloading files
REPO_URL="https://huggingface.co/lllyasviel/sd_control_collection/"
DOWNLOAD_BASE_URL="https://huggingface.co/lllyasviel/sd_control_collection/resolve/main/"

# Use the first command-line argument as the destination directory, or default to the current directory
DEST_DIR="${1:-.}"

# Clone the repository without checking out files
git clone --no-checkout $REPO_URL repo_temp

# Change to the repository directory
cd repo_temp

# Get list of files in the repository
FILES=$(git ls-tree -r HEAD --name-only)

cd ..

# Download each file
for file in $FILES; do
    # Construct download URL
    DOWNLOAD_URL="${DOWNLOAD_BASE_URL}${file}"

    # Create subdirectories as needed
    mkdir -p "$DEST_DIR/$(dirname "$file")"

    # Download the file
    echo "Downloading $file..."
    wget -P "$DEST_DIR/$(dirname "$file")" "$DOWNLOAD_URL?download=true"
done

# Clean up: remove the temporary repository directory
rm -rf repo_temp

echo "All files have been downloaded to $DEST_DIR."
