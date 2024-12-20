# PowerShell script to pull only the student and resources folders from the hacks containing a devcontainer file

# Define the repository URL
$repoUrl = "https://github.com/Whowong/WhatTheHack"

# Clone the repository to a temporary directory
git clone $repoUrl tempRepo

# Change to the repository directory
Set-Location tempRepo

#Temporarily point to test branch
git checkout Codespaces-Devcontainer

# Configure git user
git config --local user.name "What-The-Hack-Codespaces-Bot"
git config --local user.email "What-The-Hack-Codespaces-Bot@users.noreply.github.com"

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

# Commit the changes to the repository
git add .
git commit -m "Daily pull of student and resources folders"
git push


