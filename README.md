# 🧹 | Windows-Cache-Cleaner & Update-Optimize
This PowerShell script automates the cleaning and optimization of your Windows system. It performs various tasks including disk optimization, temporary file deletion, cache clearing, and updating applications and Windows.

## Version
Current version: 2.4

## Prerequisites
- PowerShell 5.1 or later
- Administrator privileges
- `PSWindowsUpdate` module (automatically installed by the script if not present)
- `winget` package manager (optional, for application updates)


## Usage
1. Run PowerShell with administrator privileges.
2. Execute the script.

```powershell
.\PSCacheCleaner.ps1
````

## Features

1. Installation of PSWindowsUpdate module if not already installed.
2. Optimization and defragmentation of the C drive.
3. Cleaning of various directories including Temp, Prefetch, SoftwareDistribution, browser caches, and more.
4. Cleaning event viewer logs.
5. Running Disk Cleanup tool.
6. Clearing Microsoft Store cache.
7. Flushing DNS cache.
8. Updating Microsoft Store apps.
9. Emptying Recycle Bin.
10. Updating installed applications using Winget.
11. Updating Windows Update.

## Notes

- Ensure PowerShell is run with administrator privileges to perform certain tasks.
- Some cleaning operations may require confirmation or take some time to execute.
- This program may affect the system to a certain extent since by deleting cache data the applications may take longer to run or certain errors may occur. In case of any error due to deleting cache, notify in issues.

## Author

This script was authored by ``Ikkxeer``

For any inquiries or issues, please contact @ikkxeer

## Contributing
Contributions to enhance the script or address issues are welcome. Please open a GitHub issue or submit a pull request.
