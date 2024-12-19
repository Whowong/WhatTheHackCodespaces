# WhatTheHackCodespaces

## Description

This repository contains a GitHub Actions workflow that runs daily to pull only the `student` and `resources` folders from the hacks located in the `https://github.com/Whowong/WhatTheHack` repository, which contain a `devcontainer` file.

## Usage

To use the GitHub Actions workflow, follow these steps:

1. Ensure that you have a GitHub repository named `Whowong/WhatTheHackCodespaces`.
2. Add the `.github/workflows/daily_pull.yml` file to your repository.
3. Add the `.github/scripts/pull_folders.ps1` script to your repository.
4. The workflow will run daily and pull the specified folders from the hacks containing a `devcontainer` file.
