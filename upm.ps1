# Universal Package Manager (upm)
# Usage: upm.ps1 <action> <package> [-q] [-y]
# Actions: install, remove, update, upgrade

# Import configuration
$configPath = Join-Path $PSScriptRoot "upm-config.psd1"
$config = Import-PowerShellDataFile -Path $configPath

function Show-Help {
    Write-Host "Windows Universal Package Manager (upm)"
    Write-Host "Usage: upm.ps1 <action> [package] [-q] [-y]"
    Write-Host "Actions:"
    Write-Host "  install <package>  - Install a package"
    Write-Host "  remove <package>   - Remove a package"
    Write-Host "  update <package>   - Update a specific package"
    Write-Host "  upgrade            - Upgrade all packages"
    exit
}

function Check-Version {
    $currentVersionFile = "C:\Windows\System32\upm-version"
    $remoteVersionUrl = "https://raw.githubusercontent.com/sctech-tr/upm/main/upm-version"

    # Check if version file exists
    if (-not (Test-Path $currentVersionFile)) {
        Write-Error "Error: Current version file not found."
        exit 1
    }

    # Read the current version
    $currentVersion = Get-Content $currentVersionFile

    # Fetch the remote version
    try {
        $remoteVersion = Invoke-RestMethod -Uri $remoteVersionUrl
    } catch {
        Write-Error "Error: Failed to fetch remote version."
        exit 1
    }

    # Compare versions
    if ($currentVersion -ne $remoteVersion) {
        Write-Host "upm $remoteVersion is available! You are currently on version $currentVersion."
        exit 0
    }
}

function Detect-PackageManager {
    foreach ($pm in $config.Keys) {
        if (Get-Command $config[$pm].Command -ErrorAction SilentlyContinue) {
            return $pm
        }
    }
    return $null
}

function Run-Command {
    param (
        [string]$PackageManager,
        [string]$Action,
        [string]$Package,
    )

    $pmConfig = $config[$PackageManager]
    $cmdTemplate = $pmConfig.Actions[$Action]

    if (-not $cmdTemplate) {
        Write-Error "Error: Invalid action for $PackageManager."
        exit 1
    }

    $cmd = $cmdTemplate -replace '\$package', $Package
    $cmd = "$($pmConfig.Command) $cmd $quietFlag $yesFlag"

    Write-Host "Executing: $cmd"
    Invoke-Expression $cmd
}

# Parse command line arguments
param(
    [Parameter(Position=0, Mandatory=$true)]
    [ValidateSet("install", "remove", "update", "upgrade")]
    [string]$Action,

    [Parameter(Position=1)]
    [string]$Package,
)

# Version check
Check-Version

if (-not $Action) {
    Show-Help
}

if ($Action -ne "upgrade" -and -not $Package) {
    Write-Error "Error: Package name is required for $Action action."
    exit 1
}

$pm = Detect-PackageManager
if (-not $pm) {
    Write-Error "Error: No supported package manager detected."
    exit 1
}

Run-Command -PackageManager $pm -Action $Action -Package $Package
