# :mag: | Windows-Cache-Cleaner 
This PowerShell script is designed to automate various system maintenance tasks on Windows. It performs the following operations:

1. **Check Administrator Privileges**: Checks if the script is being run with administrative privileges. If not, it restarts the script with elevated privileges.

2. **Install Required Module**: Installs the `PSWindowsUpdate` module if not already installed.

3. **Disk Optimization**: Optimizes the C drive by defragmenting, retrimming, consolidating slabs, and optimizing tiers.

4. **File Cleanup**:
   - Cleans up specified directories, including `C:\Windows\Prefetch`, `C:\Windows\SoftwareDistribution`, temporary directories, and printer spooler directory.
   - Counts the number of files deleted during cleanup.

5. **Event Log Cleanup**: Clears the Windows event logs.

6. **Disk Cleanup (cleanmgr)**: Initiates the disk cleanup process in the background using `cleanmgr` with very low disk space and automatic cleanup options.

7. **Application Update (Optional)**:
   - Asks the user if they want to update applications.
   - Checks for the presence of the `winget` package manager. If installed, it upgrades all applications.
   - If `winget` is not installed, prompts the user to install it.

8. **Windows Update (Optional)**:
   - Asks the user if they want to update Windows Update.
   - Installs available Windows updates from Microsoft Update and accepts all updates without a reboot.

## How to Use

1. Right click and run the script.

2. Accept elevate permissions

3. Follow the on-screen prompts to proceed with various maintenance tasks.

## Requirements

- Windows PowerShell
- Administrative privileges
- `PSWindowsUpdate` module (automatically installed by the script if not present)
- `winget` package manager (optional, for application updates)

## Notes

- Ensure that you have a backup of important data before running any maintenance script.
- Review the script and customize it according to your specific requirements before execution.

## Author

This script was authored by Ikkxeer

For any inquiries or issues, please contact @ikkxeer

## Contributing
Contributions to enhance the script or address issues are welcome. Please open a GitHub issue or submit a pull request.
