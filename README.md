# HFDL Script

## Overview
HFDL (Hugging Face Download Script) is a Bash script for downloading files from a specified Hugging Face repository. It's efficient for users needing specific files or entire directories from Hugging Face repositories without cloning the entire Git repository.

## Features
- Download files from Hugging Face repositories.
- Option to generate `wget` commands for manual downloading, useful in Jupyter notebooks.
- Customizable download directory.
- Lightweight and user-friendly.

## Prerequisites
- Git
- wget (or curl)
- Bash shell

## Installation

Quickly install the script using `curl`:

```bash
sudo curl -o /usr/local/bin/hfdl https://raw.githubusercontent.com/ShinChven/hfdl/main/hfdl.sh
sudo chmod +x /usr/local/bin/hfdl
```

Replace `[your-username]` and `[your-repo]` with your GitHub username and repository name, respectively.

## Usage

Run the script with:

```bash
hfdl <repo_url> [dir_name] [--ipynb]
```

- `<repo_url>`: The Hugging Face repository URL.
- `[dir_name]`: (Optional) Destination directory for downloaded files.
- `--ipynb`: (Optional) Print `wget` commands instead of downloading files for use in Jupyter notebooks.

### Examples

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
Contributions are welcome! Fork the repository and submit pull requests.

## License
[LICENSE](./LICENSE)


