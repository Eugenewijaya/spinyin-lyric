<#
.SYNOPSIS
  One-line installer for Spinyin-lyric for Spotify (Spicetify Extension).
.EXAMPLE
  iwr -useb https://raw.githubusercontent.com/Eugenewijaya/spinyin-lyric/main/install.ps1 | iex
#>
param(
  [switch]$Uninstall
)

$ErrorActionPreference = "Stop"

try {
  [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
} catch {}

$RepoRawBase = "https://raw.githubusercontent.com/Eugenewijaya/spinyin-lyric/main"
$ExtensionFile = "spinyin-lyric.js"
$LegacyFile = "mandarinPinyin.js"

Write-Host ""
Write-Host "  Spinyin-lyric for Spotify" -ForegroundColor Green
Write-Host "  Real-time offline Mandarin -> Pinyin Smart Lyrics" -ForegroundColor DarkGray
Write-Host ""

# 1. Verify Spicetify CLI is installed
$spicetifyCmd = Get-Command spicetify -ErrorAction SilentlyContinue
if (-not $spicetifyCmd) {
  Write-Host "[!] Spicetify CLI was not found on this machine." -ForegroundColor Red
  Write-Host "    Install Spicetify first:" -ForegroundColor Yellow
  Write-Host "    iwr -useb https://raw.githubusercontent.com/spicetify/cli/main/install.ps1 | iex" -ForegroundColor Cyan
  exit 1
}

# 2. Resolve exact Spicetify Extensions directory dynamically (works on any machine/config)
$configPath = (& spicetify -c).Trim()
if (-not $configPath) {
  $configPath = Join-Path $env:APPDATA "spicetify\config-xpui.ini"
}
$spicetifyDir = Split-Path -Parent $configPath
$extDir = Join-Path $spicetifyDir "Extensions"
if (-not (Test-Path $extDir)) {
  New-Item -ItemType Directory -Path $extDir -Force | Out-Null
}
$targetPath = Join-Path $extDir $ExtensionFile

# Handle uninstall mode
if ($Uninstall -or $env:SPINYIN_UNINSTALL -eq "1") {
  Write-Host "[*] Removing $ExtensionFile..." -ForegroundColor Yellow
  & spicetify config extensions "${ExtensionFile}-" | Out-Null
  if (Test-Path $targetPath) {
    Remove-Item $targetPath -Force
  }
  Write-Host "[*] Applying Spicetify changes..." -ForegroundColor Cyan
  & spicetify apply
  Write-Host "[+] Spinyin-lyric has been uninstalled." -ForegroundColor Green
  exit 0
}

# 3. Download latest spinyin-lyric.js directly into Spicetify Extensions
$downloadUrl = "$RepoRawBase/$ExtensionFile"
Write-Host "[*] Downloading $ExtensionFile..." -ForegroundColor Cyan
$tempPath = "$targetPath.tmp"
try {
  Invoke-WebRequest -Uri $downloadUrl -OutFile $tempPath -UseBasicParsing
  if (-not (Test-Path $tempPath) -or (Get-Item $tempPath).Length -lt 10000) {
    throw "Downloaded file appears incomplete."
  }
  Move-Item -Path $tempPath -Destination $targetPath -Force
} catch {
  if (Test-Path $tempPath) { Remove-Item $tempPath -Force -ErrorAction SilentlyContinue }
  Write-Host "[!] Download failed: $($_.Exception.Message)" -ForegroundColor Red
  exit 1
}

# 4. Clean up legacy dev filename if present & register spinyin-lyric.js
$configText = if (Test-Path $configPath) { Get-Content $configPath -Raw } else { "" }
if ($configText -match [regex]::Escape($LegacyFile)) {
  & spicetify config extensions "${LegacyFile}-" | Out-Null
}
& spicetify config extensions $ExtensionFile | Out-Null

# 5. Apply to Spotify
Write-Host "[*] Applying to Spotify via Spicetify..." -ForegroundColor Cyan
& spicetify apply

Write-Host ""
Write-Host "[+] Spinyin-lyric for Spotify installed successfully!" -ForegroundColor Green
Write-Host "    Open any Mandarin track in Spotify and view Lyrics to see Pinyin live." -ForegroundColor Gray
Write-Host "    Repo & Support: https://github.com/Eugenewijaya/spinyin-lyric" -ForegroundColor DarkGray
Write-Host ""
