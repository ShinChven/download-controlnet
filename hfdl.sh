#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: script.sh [--ipynb] [--exclude pattern]... <repo_url> [destination_directory]"
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
EXCLUDE_PATTERNS=()

# Process arguments
while (( "$#" )); do
    case "$1" in
        --ipynb)
            IPYNB_MODE=1
            shift
            ;;
        --exclude)
            shift
            if [ -n "$1" ]; then
                EXCLUDE_PATTERNS+=("$1")
                shift
            else
                echo "Error: --exclude requires a pattern."
                usage
            fi
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
    skip_file=0
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        if [[ $file == $pattern ]]; then
            skip_file=1
            break
        fi
    done

    if [ $skip_file -eq 1 ]; then
        continue
    fi

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
