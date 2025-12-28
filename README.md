# Sublime Text PowerShell Utilities (Windows 11)

## Overview
This repository is intended for **educational and administrative purposes** on **Windows 11**, focusing on:

- Running and troubleshooting PowerShell (`.ps1`) scripts
- Understanding PowerShell Execution Policies
- Managing local application configuration files
- Windows user-level scripting practices

Official Sublime Text installer (reference only):  
https://download.sublimetext.com/sublime_text_build_4200_x64_setup.exe

This project is suitable for learning PowerShell basics and handling common script-execution issues on modern Windows systems.

---

## System Requirements
- Windows 11
- PowerShell 5.1 or later
- Administrator privileges (recommended)

---

## Common Issue: Script Execution Is Disabled
If you encounter an error such as:

> *running scripts is disabled on this system*

You can resolve it using one of the methods below.

---

## Running a PowerShell Script on Windows 11

### Option 1: Allow scripts for the current user (recommended)

```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
When prompted:
Press Y → apply the change
Press N → cancel (no changes made)
Then run the script:
powershell
.\SublimePatcher.ps1

Option 2: Run the script once (no policy change)
This method runs the script without modifying the system execution policy:

powershell
powershell -ExecutionPolicy Bypass -File .\SublimePatcher.ps1
Notes
RemoteSigned allows locally created scripts to run while maintaining basic security.
Bypass affects only the current execution and does not persist.
Always review scripts before running them, especially if obtained from external sources.
