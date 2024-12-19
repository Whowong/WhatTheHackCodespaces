# PowerShell script to pull only the student and resources folders from the hacks containing a devcontainer file

# Define the repository URL
$repoUrl = "https://github.com/Whowong/WhatTheHack"

# Clone the repository
git clone $repoUrl tempRepo

# Change to the repository directory
Set-Location tempRepo

# Configure git user
git config --local user.name "github-actions[bot]"
git config --local user.email "github-actions[bot]@users.noreply.github.com"

# Iterate through the hacks
$hacks = Get-ChildItem -Directory

foreach ($hack in $hacks) {
    # Check for the presence of a devcontainer file
    if (Test-Path "/.github/$($hack.FullName)/devcontainer.json") {
        # Copy the student and resources folders to the local repository
        Copy-Item "$($hack.FullName)/student" -Destination "../../student" -Recurse -Force
        Copy-Item "$($hack.FullName)/resources" -Destination "../../resources" -Recurse -Force
    }
}

# Change back to the original directory
Set-Location ..

# Replace spaces with underscores in filenames
Get-ChildItem -Recurse | Rename-Item -NewName { $_.Name -replace ' ', '_' }

# Commit the changes to the repository
git add .
git commit -m "Daily pull of student and resources folders"
git push

# Clean up
Remove-Item -Recurse -Force tempRepo
