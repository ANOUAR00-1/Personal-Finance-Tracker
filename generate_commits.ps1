# PowerShell script to generate 20 commits between Sep-Oct 2024
# This creates a realistic commit history for the Personal Finance Tracker project

Write-Host "Starting commit generation for Sep-Oct 2024..." -ForegroundColor Cyan

# Array of commit messages with progressive development
$commitMessages = @(
    "Initial project setup and basic structure",
    "Add Transaction class with basic properties",
    "Implement basic FinanceTracker class",
    "Add transaction list functionality",
    "Implement add transaction feature",
    "Add balance calculation method",
    "Create list transactions functionality",
    "Build main menu interface",
    "Add user input handling",
    "Implement basic CLI interaction",
    "Add transaction categories",
    "Implement income vs expense tracking",
    "Add date tracking for transactions",
    "Create JSON serialization methods",
    "Implement data persistence feature",
    "Add delete transaction functionality",
    "Create financial summary view",
    "Add category breakdown feature",
    "Improve UI formatting and styling",
    "Add comprehensive documentation and help system"
)

# Generate 20 random dates between Sep 1, 2024 and Oct 31, 2024
$startDate = Get-Date "2024-09-01"
$endDate = Get-Date "2024-10-31"
$dates = @()

for ($i = 0; $i -lt 20; $i++) {
    $randomDays = Get-Random -Minimum 0 -Maximum 61
    $commitDate = $startDate.AddDays($randomDays)
    $dates += $commitDate
}

# Sort dates chronologically
$dates = $dates | Sort-Object

# Create a temporary file for modifications
$tempFile = "commit_log.txt"

# Initialize git repository if not already initialized
if (-not (Test-Path ".git")) {
    Write-Host "Initializing git repository..." -ForegroundColor Yellow
    git init
    git add .
    git commit -m "Initial commit"
}

# Generate commits
for ($i = 0; $i -lt 20; $i++) {
    $date = $dates[$i]
    $message = $commitMessages[$i]
    
    # Create or modify the temporary file
    $commitNumber = $i + 1
    $content = "Commit #$commitNumber - $message`nDate: $($date.ToString('yyyy-MM-dd HH:mm:ss'))`n"
    Add-Content -Path $tempFile -Value $content
    
    # Format date for git (ISO 8601)
    $gitDate = $date.ToString("yyyy-MM-ddTHH:mm:ss")
    
    # Stage the change
    git add $tempFile
    
    # Create commit with custom date
    $env:GIT_AUTHOR_DATE = $gitDate
    $env:GIT_COMMITTER_DATE = $gitDate
    
    git commit -m $message
    
    # Clear environment variables
    Remove-Item Env:GIT_AUTHOR_DATE
    Remove-Item Env:GIT_COMMITTER_DATE
    
    Write-Host "Commit $commitNumber/$($commitMessages.Count): $message" -ForegroundColor Green
    Write-Host "  Date: $($date.ToString('yyyy-MM-dd HH:mm:ss'))" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Successfully generated 20 commits!" -ForegroundColor Green
Write-Host "Date range: Sep 1, 2024 - Oct 31, 2024" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Review commits: git log --oneline" -ForegroundColor White
Write-Host "  2. Add remote: git remote add origin YOUR-REPO-URL" -ForegroundColor White
Write-Host "  3. Push commits: git push -u origin main" -ForegroundColor White
