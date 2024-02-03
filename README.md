# Windows-Cache-Cleaner :mag:
This Python script automates the cleanup of unnecessary files in Windows, targeting temporary folders, the Prefetch directory, and SoftwareDistribution. Use it cautiously, understanding potential consequences. 

## Features
- **Temporary Folder Cleanup:** The script clears out files from the system's temporary folder (`%TEMP%`).
- **Prefetch Directory Cleanup:** It also removes files from the Prefetch directory (`C:\Windows\Prefetch`), which may contain cached data for faster application loading.
- **Software Distribution Cleanup:** Additionally, the script targets the SoftwareDistribution directory (`C:\Windows\SoftwareDistribution`), commonly associated with Windows Update.

## Usage
1. Ensure Python is installed on your system.
2. Save the script to a file with a `.py` extension (e.g., `cleanup_script.py`).
3. Run the script by double-clicking it or executing it from the command line: `python cleanup_script.py`.

## Important Note
- **Use with Caution:** Deleting files from system directories can impact system functionality. Only run this script if you understand the consequences and have a valid reason for cleaning up these folders.

## Contributing
Contributions to enhance the script or address issues are welcome. Please open a GitHub issue or submit a pull request.
