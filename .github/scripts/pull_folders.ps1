# PowerShell script to pull only the student and resources folders from the hacks containing a devcontainer file

# Define the repository URL
$repoUrl = "https://github.com/Whowong/WhatTheHack"

# Clone the repository to a temporary directory
git clone $repoUrl tempRepo

# Change to the repository directory
Set-Location tempRepo

#Temporarily point to test branch
git checkout Codespaces-Devcontainer

# Iterate through the hacks from the devcontainer directory
$hacks = Get-ChildItem -Path .devcontainer -Directory

foreach ($hack in $hacks) {
    #If hack folder doesn't exist, create it
    if (!(Test-Path "../$($hack.Name)")) {
        New-Item -ItemType Directory -Path "../$($hack.Name)"
    }

    # Copy everything except the Coaches folder
    Copy-Item "$($hack.Name)\*" -Destination "../$($hack.Name)" -Recurse -Force -Exclude "Coach"

    # Copy the devcontainer file as well
    if (!(Test-Path "../.devcontainer/$($hack.Name)")) {
        New-Item -ItemType Directory -Path "../.devcontainer/$($hack.Name)"
    }

    Copy-Item ".devcontainer/$($hack.Name)/devcontainer.json" -Destination "../.devcontainer/$($hack.Name)/devcontainer.json" -Force
    
}

# Change back to the original directory
Set-Location ..

# Clean up the temporary repository
Remove-Item -Recurse -Force tempRepo

# Create a new branch for the changes
$branchName = "auto-update-$(Get-Date -Format 'yyyy-MM-dd')"
git config --global user.name "GitHub Actions Codespace Automation"
git config --global user.email "actions@github.com"
git checkout -b $branchName
git add .
git commit -m "Daily pull of student and resources folders"
git push origin $branchName

# Create a pull request using GitHub CLI
gh pr create --title "Daily pull of student and resources folders" --body "Automated pull of student and resources folders from WhatTheHack repository" --base main --head $branchName
