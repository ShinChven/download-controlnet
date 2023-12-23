#!/bin/bash

# Author: ShinChven
# Repository: https://github.com/ShinChven/hfdl 
# Description:
# This script is designed to download files from a specified Hugging Face repository.
# It allows users to download all files from a repository to a local directory.
# Optionally, it can generate wget commands for manual downloading, which is useful in Jupyter notebook environments.

# Function to display usage information
usage() {
    echo "Usage: hfdl <repo_url> [dir_name] [--ipynb]"
    echo
    echo "This script is used for downloading files from a specified Hugging Face repository."
    echo
    echo "Arguments:"
    echo "  <repo_url>     Mandatory. The URL of the Hugging Face repository from which to download files."
    echo "  [dir_name]     Optional. The name of the directory where the files will be downloaded."
    echo "                 If not specified, files will be downloaded to a directory named after the repository."
    echo "  --ipynb        Optional. If this flag is set, the script will print 'wget' commands for downloading the files"
    echo "                 instead of downloading them directly. This is useful for environments like Jupyter notebooks."
    echo
    echo "Examples:"
    echo "  hfdl https://huggingface.co/lllyasviel/sd_control_collection"
    echo "  hfdl https://huggingface.co/lllyasviel/sd_control_collection custom_directory"
    echo "  hfdl https://huggingface.co/lllyasviel/sd_control_collection --ipynb"
    echo "  hfdl https://huggingface.co/lllyasviel/sd_control_collection custom_directory --ipynb"
    echo
    echo "Note:"
    echo "  When using the --ipynb flag in a Jupyter notebook, prepend an exclamation mark (!) to each 'wget' command to execute it."
    echo
    echo "Repository: https://github.com/ShinChven/hfdl"
    exit 1
}

# Check if at least one argument (repository URL) is provided
if [ $# -lt 1 ]; then
    usage
fi

# Initialize variables
IPYNB_MODE=0
REPO_URL=""
DEST_DIR=""

# Process arguments
while (( "$#" )); do
    case "$1" in
        --ipynb)
            IPYNB_MODE=1
            shift
            ;;
        *)
            # If REPO_URL is not set, set it; otherwise, set DEST_DIR
            if [ -z "$REPO_URL" ]; then
                REPO_URL="${1%/}/"
            elif [ -z "$DEST_DIR" ]; then
                DEST_DIR=$1
            else
                # Unexpected additional arguments
                usage
            fi
            shift
            ;;
    esac
done

# Validate repository URL
if [ -z "$REPO_URL" ]; then
    echo "Error: Repository URL is required."
    usage
fi

# Extract the repository name from the URL for use as the default directory name
REPO_NAME=$(basename $REPO_URL)

# Set the destination directory, default to a directory named after the repository
if [ -z "$DEST_DIR" ]; then
    DEST_DIR="$(pwd)/$REPO_NAME"
fi

# Create the destination directory if it does not exist and not in ipynb mode
if [ $IPYNB_MODE -eq 0 ]; then
    mkdir -p "$DEST_DIR"
fi

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

# Process each file
for file in $FILES; do
    # Remove './' from the start of the file path if present
    [[ $file == ./* ]] && file="${file:2}"

    # Construct download URL
    DOWNLOAD_URL="${DOWNLOAD_BASE_URL}${file}"

    if [ $IPYNB_MODE -eq 1 ]; then
        # Print the wget command
        echo "!wget -O \"$DEST_DIR/$file\" $DOWNLOAD_URL"
    else
        # Create subdirectories as needed in the destination directory
        mkdir -p "$DEST_DIR/$(dirname "$file")"

        # Download the file
        wget -O "$DEST_DIR/$file" $DOWNLOAD_URL
    fi
done

# Clean up: remove the random temporary repository directory
rm -rf $REPO_TEMP_DIR

# Final message
if [ $IPYNB_MODE -eq 1 ]; then
    echo "wget commands generated for all files."
else
    echo "All files have been downloaded to $DEST_DIR."
fi
