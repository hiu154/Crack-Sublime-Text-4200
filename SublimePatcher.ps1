$destFolder = "$env:USERPROFILE\Desktop\SUBLIME"
$sourceExe = "C:\Program Files\Sublime Text\sublime_text.exe"
$destExe = "$destFolder\sublime_text.exe"
$backupExe = "C:\Program Files\Sublime Text\sublime_text_backup.exe"

Write-Host "Starting Sublime Text patching process..."

if (-not (Test-Path -Path $sourceExe)) {
    Write-Host "Error: Source file not found at $sourceExe"
    exit
}

if (-not (Test-Path -Path $destFolder)) {
    Write-Host "Creating SUBLIME folder..."
    New-Item -Path $destFolder -ItemType Directory | Out-Null
}

Write-Host "Copying files to desktop folder..."
Copy-Item -Path $sourceExe -Destination $destExe -Force

$FilePath = $destExe

if (!(Test-Path $FilePath)) {
    Write-Host "Error: File not found at $FilePath"
    exit
}

$bytes = [System.IO.File]::ReadAllBytes($FilePath)

if ($bytes.Length -eq 0) {
    Write-Host "Error: Failed to read the file or file is empty."
    exit
}

function Apply-Patch {
    param (
        [byte[]]$Find,
        [byte[]]$Replace,
        [string]$Description
    )
    $found = $false
    for ($i = 0; $i -le $bytes.Length - $Find.Length; $i++) {
        $match = $true
        for ($j = 0; $j -lt $Find.Length; $j++) {
            if ($bytes[$i + $j] -ne $Find[$j]) {
                $match = $false
                break
            }
        }
        if ($match) {
            for ($j = 0; $j -lt $Replace.Length; $j++) {
                $bytes[$i + $j] = $Replace[$j]
            }
            Write-Host "Patch applied: $Description at offset 0x$("{0:X}" -f $i)"
            $found = $true
            break
        }
    }
    if (-not $found) {
        Write-Host "Failed to find pattern for patch: $Description"
    }
}

Write-Host "Applying patches..."

$patches = @(
    @{ Find = @(0x74, 0x06, 0x3B); Replace = @(0xEB, 0x06, 0x3B); Desc = "Patch 1: Change 74 to EB" },
    @{ Find = @(0x89, 0xF8, 0x48, 0x81, 0xC4, 0x38, 0x02); Replace = @(0x33, 0xC0, 0x48, 0x81, 0xC4, 0x38, 0x02); Desc = "Patch 2: 89 F8 to 33 C0" },
    @{ Find = @(0xE8, 0xF4, 0x7F, 0x10, 0x00); Replace = @(0x90, 0x90, 0x90, 0x90, 0x90); Desc = "Patch 3: Full 5-byte NOPs" },
    @{ Find = @(0x41, 0x57, 0x41, 0x56, 0x41, 0x54, 0x56, 0x57, 0x53, 0x48, 0x83, 0xEC, 0x38); Replace = @(0x90, 0x90, 0x41, 0x56, 0x41, 0x54, 0x56, 0x57, 0x53, 0x48, 0x83, 0xEC, 0x38); Desc = "Patch 4: 41 57 to 90 90" }
)

foreach ($patch in $patches) {
    Apply-Patch -Find $patch.Find -Replace $patch.Replace -Description $patch.Desc
}

$patchedFilePath = "$destFolder\SublimeText_patched.exe"
Write-Host "Saving patched file..."
[System.IO.File]::WriteAllBytes($patchedFilePath, $bytes)

if (-not (Test-Path $patchedFilePath)) {
    Write-Host "Error: Patched file was not created successfully"
    exit
}

$originalBackupPath = "C:\Program Files\Sublime Text\sublime_text_backup.exe"
$targetPath = "C:\Program Files\Sublime Text\sublime_text.exe"

Write-Host "Creating backup of original file..."
Copy-Item -Path $targetPath -Destination $originalBackupPath -Force

Write-Host "Replacing original file with patched version..."
try {
    Copy-Item -Path $patchedFilePath -Destination $targetPath -Force
    Write-Host "SUCCESS: Sublime Text has been patched successfully!"
    Write-Host "Original backup saved at: $originalBackupPath"
    Write-Host "Working files saved in: $destFolder"
} catch {
    Write-Host "Error: Failed to replace the original file. Error: $_"
    Write-Host "You may need to run PowerShell as Administrator"
    Write-Host "Patched file is available at: $patchedFilePath"
}