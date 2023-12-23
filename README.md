# HFDL Script

## Overview

HFDL (Hugging Face Download Script) is a versatile Bash script designed to facilitate the selective downloading of files from Hugging Face repositories. It's especially useful for users who want to download specific files or directories without cloning the entire Git repository. 

## Features

- Download files from Hugging Face repositories.
- Exclude specific files or patterns from the download.
- Option to generate `wget` commands for manual downloading, useful in environments like Jupyter notebooks.
- Customizable download directory.
- Simple and user-friendly interface.

## Prerequisites
- Git
- wget (or curl)
- Bash shell

## Installation

Install the script quickly using `curl`:

```bash
sudo curl -o /usr/local/bin/hfdl https://raw.githubusercontent.com/ShinChven/hfdl/main/hfdl.sh
sudo chmod +x /usr/local/bin/hfdl
```

In Jupyter notebooks:

```ipynb
!curl -o /usr/local/bin/hfdl https://raw.githubusercontent.com/ShinChven/hfdl/main/hfdl.sh
!chmod +x /usr/local/bin/hfdl
```

## Usage

To run the script:

```bash
hfdl [--ipynb] [--exclude pattern]... <repo_url> [destination_directory]
```

- `<repo_url>`: The Hugging Face repository URL.
- `[destination_directory]`: (Optional) Destination directory for downloaded files.
- `--ipynb`: (Optional) Generate `wget` commands instead of direct downloading, useful in Jupyter notebooks.
- `--exclude pattern`: (Optional) Exclude files matching the specified pattern. This option can be repeated to exclude multiple patterns.

### Examples

- Download all files, excluding those with a specific pattern:
  ```
  hfdl --exclude '*fp16*' https://huggingface.co/ckpt/ControlNet-v1-1 /content/test
  ```
- Download to a repository-named directory:
  ```
  hfdl https://huggingface.co/lllyasviel/sd_control_collection
  ```
- Download to a custom directory:
  ```
  hfdl https://huggingface.co/lllyasviel/sd_control_collection custom_directory
  ```
- Generate `wget` commands for Jupyter notebooks:
  ```
  hfdl https://huggingface.co/lllyasviel/sd_control_collection --ipynb
  ```

## Contributing
Your contributions are always welcome! Please fork the repository and submit your pull requests.

## License
This project is licensed under [LICENSE](./LICENSE).

