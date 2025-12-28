# Sublime Text PowerShell Utilities (Windows 11)

## Overview
This repository is intended for **educational and administrative purposes** on **Windows 11**, focusing on:

- Running and troubleshooting PowerShell (`.ps1`) scripts
- Understanding PowerShell Execution Policies
- Managing local application configuration files
- Windows user-level scripting practices

It is suitable for learning PowerShell basics and handling common script-execution issues on modern Windows systems.

---

## System Requirements
- Windows 11
- PowerShell 5.1 or later  
  (PowerShell 7+ recommended)

---

## Common Issue: Script Execution Is Disabled
If you encounter an error such as:

> *running scripts is disabled on this system*

You can resolve it using one of the methods below.

### Recommended (Current User Only)
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
