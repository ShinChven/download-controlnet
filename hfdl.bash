#!/bin/bash

# Check if at least one argument (repository URL) is provided
if [ $# -lt 1 ]; then
    echo "Usage: hfdl <repo_url> [dir_name]"
    exit 1
fi

# Set the repository URL from the first command-line argument
REPO_URL=$1

# Ensure the REPO_URL ends with a single slash
REPO_URL="${REPO_URL%/}/"

# Extract the repository name from the URL for use as the default directory name
REPO_NAME=$(basename $REPO_URL)

# Use the second command-line argument as the destination directory, or default to a directory named after the repository
DEST_DIR="${2:-$REPO_NAME}"

# Create the destination directory if it does not exist
mkdir -p "$DEST_DIR"

# Set the base URL for downloading files (specific to Hugging Face's URL structure)
DOWNLOAD_BASE_URL="${REPO_URL}resolve/main/"

# Create a random temporary directory for the repository clone
REPO_TEMP_DIR=$(mktemp -d)

# Clone the repository without checking out files
git clone --no-checkout $REPO_URL $REPO_TEMP_DIR

# Change to the temporary repository directory
cd $REPO_TEMP_DIR

# Get list of files in the repository
FILES=$(git ls-tree -r HEAD --name-only)

# Return to the original directory
cd ..

# Download each file
for file in $FILES; do
    # Construct download URL
    DOWNLOAD_URL="${DOWNLOAD_BASE_URL}${file}"

    # Create subdirectories as needed in the destination directory
    mkdir -p "$DEST_DIR/$(dirname "$file")"

    # Download the file
    echo "Downloading $file to $DEST_DIR..."
    wget -P "$DEST_DIR/$(dirname "$file")" $DOWNLOAD_URL
done

# Clean up: remove the random temporary repository directory
rm -rf $REPO_TEMP_DIR

echo "All files have been downloaded to $DEST_DIR."
