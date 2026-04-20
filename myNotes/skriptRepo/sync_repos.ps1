<<<<<<< HEAD
param(
    [Parameter(Mandatory=$false)]
    [string]$SourceRepoPath,
    
    [Parameter(Mandatory=$false)]
    [string]$DestRepoPath,
    
    [switch]$DoGitPush,
    
    [switch]$ShowTerminal,
    
    [switch]$Help
)

$ErrorActionPreference = "Continue"

function Show-Help {
    Write-Host "Usage: .\sync_repos.ps1 [OPTIONS]" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Options:" -ForegroundColor Yellow
    Write-Host "  -SourceRepoPath PATH   Path to source repository (to sync)"
    Write-Host "  -DestRepoPath PATH     Path to destination repository (copy to)"
    Write-Host "  -DoGitPush              Execute git push in destination repo after copy"
    Write-Host "  -ShowTerminal           Run script in separate terminal for visual control"
    Write-Host "  -Help                   Show this help"
    Write-Host ""
    Write-Host "Example:" -ForegroundColor Green
    Write-Host "  .\sync_repos.ps1 -SourceRepoPath C:\path\to\source\repo -DestRepoPath C:\path\to\dest\repo -DoGitPush"
    Write-Host ""
    Write-Host "Example with new terminal:" -ForegroundColor Green
    Write-Host "  powershell -NoExit -Command '.\sync_repos.ps1 -SourceRepoPath C:\path\to\source\repo -DestRepoPath C:\path\to\dest\repo -DoGitPush'"
    Write-Host ""
    Write-Host "Note: Script copies files from source to destination, updating existing files," -ForegroundColor Yellow
    Write-Host "      but does NOT delete files that don't exist in source." -ForegroundColor Yellow
}

if ($Help) {
    Show-Help
    exit 0
}

if ([string]::IsNullOrEmpty($SourceRepoPath) -or [string]::IsNullOrEmpty($DestRepoPath)) {
    Write-Host "Error: Required parameters -SourceRepoPath and -DestRepoPath not specified" -ForegroundColor Red
    Write-Host ""
    Show-Help
    exit 1
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Repository Synchronization" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Source repository: $SourceRepoPath"
Write-Host "Destination repository:  $DestRepoPath"
Write-Host "Execute git push:   $DoGitPush"
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if (!(Test-Path $SourceRepoPath)) {
    Write-Host "Error: Source repository does not exist: $SourceRepoPath" -ForegroundColor Red
    exit 1
}

if (!(Test-Path (Join-Path $SourceRepoPath ".git"))) {
    Write-Host "Error: Source path is not a git repository: $SourceRepoPath" -ForegroundColor Red
    exit 1
}

if (!(Test-Path $DestRepoPath)) {
    Write-Host "Error: Destination repository does not exist: $DestRepoPath" -ForegroundColor Red
    exit 1
}

if (!(Test-Path (Join-Path $DestRepoPath ".git"))) {
    Write-Host "Error: Destination path is not a git repository: $DestRepoPath" -ForegroundColor Red
    exit 1
}

$SourceRepoName = Split-Path $SourceRepoPath -Leaf
$DestRepoName = Split-Path $DestRepoPath -Leaf

Write-Host "Checking for private repositories..." -ForegroundColor Yellow
$SourceRemote = git -C $SourceRepoPath remote get-url origin 2>$null
$DestRemote = git -C $DestRepoPath remote get-url origin 2>$null

if ($SourceRemote -match '@.*:|git@') {
    Write-Host "Warning: Source repository may be private (SSH URL)" -ForegroundColor Yellow
}

if ($DestRemote -match '@.*:|git@') {
    Write-Host "Warning: Destination repository may be private (SSH URL)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[1/4] Executing git pull in source repository..." -ForegroundColor Cyan
Push-Location $SourceRepoPath
git pull 2>&1 | Write-Host
if ($LASTEXITCODE -eq 0) {
    Write-Host "Git pull completed successfully" -ForegroundColor Green
} else {
    Write-Host "Warning: Git pull finished with errors, continuing..." -ForegroundColor Yellow
}
Pop-Location

Write-Host ""
Write-Host "[2/4] Copying files (except .git) from source to destination repository..." -ForegroundColor Cyan
Push-Location $DestRepoPath

$SourceItems = Get-ChildItem $SourceRepoPath -Force | Where-Object { $_.Name -ne ".git" }

foreach ($Item in $SourceItems) {
    if (Test-Path $Item.Name) {
        Write-Host "  Update: $($Item.Name)" -ForegroundColor Yellow
    } else {
        Write-Host "  Copy: $($Item.Name)"
    }
    
    Copy-Item $Item.FullName $DestRepoPath -Recurse -Force
}

Write-Host "Files copied" -ForegroundColor Green
Pop-Location

Write-Host ""
Write-Host "[3/4] Checking status of destination repository..." -ForegroundColor Cyan
Push-Location $DestRepoPath

$StatusOutput = git status --porcelain 2>&1

if ([string]::IsNullOrWhiteSpace($StatusOutput)) {
    Write-Host "No changes to commit" -ForegroundColor Green
} else {
    Write-Host "Changes detected:" -ForegroundColor Yellow
    $StatusOutput | Write-Host
    
    Write-Host ""
    Write-Host "Adding changes to index..." -ForegroundColor Cyan
    git add . 2>&1 | Write-Host
    Write-Host "Changes added" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "Creating commit..." -ForegroundColor Cyan
    $CommitMsg = "Sync from $SourceRepoName at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    git commit -m $CommitMsg 2>&1 | Write-Host
    Write-Host "Commit created: $CommitMsg" -ForegroundColor Green
}

if ($DoGitPush) {
    Write-Host ""
    Write-Host "[4/4] Executing git push in destination repository..." -ForegroundColor Cyan
    git push 2>&1 | Write-Host
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Git push completed successfully" -ForegroundColor Green
    } else {
        Write-Host "Error: Git push finished with error" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host ""
    Write-Host "[4/4] Skipping git push (use -DoGitPush to enable)" -ForegroundColor Yellow
}

Pop-Location

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Synchronization completed successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
=======
param(
    [Parameter(Mandatory=$false)]
    [string]$SourceRepoPath,
    
    [Parameter(Mandatory=$false)]
    [string]$DestRepoPath,
    
    [switch]$DoGitPush,
    
    [switch]$ShowTerminal,
    
    [switch]$Help
)

$ErrorActionPreference = "Continue"

function Show-Help {
    Write-Host "Usage: .\sync_repos.ps1 [OPTIONS]" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Options:" -ForegroundColor Yellow
    Write-Host "  -SourceRepoPath PATH   Path to source repository (to sync)"
    Write-Host "  -DestRepoPath PATH     Path to destination repository (copy to)"
    Write-Host "  -DoGitPush              Execute git push in destination repo after copy"
    Write-Host "  -ShowTerminal           Run script in separate terminal for visual control"
    Write-Host "  -Help                   Show this help"
    Write-Host ""
    Write-Host "Example:" -ForegroundColor Green
    Write-Host "  .\sync_repos.ps1 -SourceRepoPath C:\path\to\source\repo -DestRepoPath C:\path\to\dest\repo -DoGitPush"
    Write-Host ""
    Write-Host "Example with new terminal:" -ForegroundColor Green
    Write-Host "  powershell -NoExit -Command '.\sync_repos.ps1 -SourceRepoPath C:\path\to\source\repo -DestRepoPath C:\path\to\dest\repo -DoGitPush'"
    Write-Host ""
    Write-Host "Note: Script copies files from source to destination, updating existing files," -ForegroundColor Yellow
    Write-Host "      but does NOT delete files that don't exist in source." -ForegroundColor Yellow
}

if ($Help) {
    Show-Help
    exit 0
}

if ([string]::IsNullOrEmpty($SourceRepoPath) -or [string]::IsNullOrEmpty($DestRepoPath)) {
    Write-Host "Error: Required parameters -SourceRepoPath and -DestRepoPath not specified" -ForegroundColor Red
    Write-Host ""
    Show-Help
    exit 1
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Repository Synchronization" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Source repository: $SourceRepoPath"
Write-Host "Destination repository:  $DestRepoPath"
Write-Host "Execute git push:   $DoGitPush"
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if (!(Test-Path $SourceRepoPath)) {
    Write-Host "Error: Source repository does not exist: $SourceRepoPath" -ForegroundColor Red
    exit 1
}

if (!(Test-Path (Join-Path $SourceRepoPath ".git"))) {
    Write-Host "Error: Source path is not a git repository: $SourceRepoPath" -ForegroundColor Red
    exit 1
}

if (!(Test-Path $DestRepoPath)) {
    Write-Host "Error: Destination repository does not exist: $DestRepoPath" -ForegroundColor Red
    exit 1
}

if (!(Test-Path (Join-Path $DestRepoPath ".git"))) {
    Write-Host "Error: Destination path is not a git repository: $DestRepoPath" -ForegroundColor Red
    exit 1
}

$SourceRepoName = Split-Path $SourceRepoPath -Leaf
$DestRepoName = Split-Path $DestRepoPath -Leaf

Write-Host "Checking for private repositories..." -ForegroundColor Yellow
$SourceRemote = git -C $SourceRepoPath remote get-url origin 2>$null
$DestRemote = git -C $DestRepoPath remote get-url origin 2>$null

if ($SourceRemote -match '@.*:|git@') {
    Write-Host "Warning: Source repository may be private (SSH URL)" -ForegroundColor Yellow
}

if ($DestRemote -match '@.*:|git@') {
    Write-Host "Warning: Destination repository may be private (SSH URL)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[1/4] Executing git pull in source repository..." -ForegroundColor Cyan
Push-Location $SourceRepoPath
git pull 2>&1 | Write-Host
if ($LASTEXITCODE -eq 0) {
    Write-Host "Git pull completed successfully" -ForegroundColor Green
} else {
    Write-Host "Warning: Git pull finished with errors, continuing..." -ForegroundColor Yellow
}
Pop-Location

Write-Host ""
Write-Host "[2/4] Copying files (except .git) from source to destination repository..." -ForegroundColor Cyan
Push-Location $DestRepoPath

$SourceItems = Get-ChildItem $SourceRepoPath -Force | Where-Object { $_.Name -ne ".git" }

foreach ($Item in $SourceItems) {
    if (Test-Path $Item.Name) {
        Write-Host "  Update: $($Item.Name)" -ForegroundColor Yellow
    } else {
        Write-Host "  Copy: $($Item.Name)"
    }
    
    Copy-Item $Item.FullName $DestRepoPath -Recurse -Force
}

Write-Host "Files copied" -ForegroundColor Green
Pop-Location

Write-Host ""
Write-Host "[3/4] Checking status of destination repository..." -ForegroundColor Cyan
Push-Location $DestRepoPath

$StatusOutput = git status --porcelain 2>&1

if ([string]::IsNullOrWhiteSpace($StatusOutput)) {
    Write-Host "No changes to commit" -ForegroundColor Green
} else {
    Write-Host "Changes detected:" -ForegroundColor Yellow
    $StatusOutput | Write-Host
    
    Write-Host ""
    Write-Host "Adding changes to index..." -ForegroundColor Cyan
    git add . 2>&1 | Write-Host
    Write-Host "Changes added" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "Creating commit..." -ForegroundColor Cyan
    $CommitMsg = "Sync from $SourceRepoName at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    git commit -m $CommitMsg 2>&1 | Write-Host
    Write-Host "Commit created: $CommitMsg" -ForegroundColor Green
}

if ($DoGitPush) {
    Write-Host ""
    Write-Host "[4/4] Executing git push in destination repository..." -ForegroundColor Cyan
    git push 2>&1 | Write-Host
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Git push completed successfully" -ForegroundColor Green
    } else {
        Write-Host "Error: Git push finished with error" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host ""
    Write-Host "[4/4] Skipping git push (use -DoGitPush to enable)" -ForegroundColor Yellow
}

Pop-Location

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Synchronization completed successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
>>>>>>> 7d47e38 (123)
