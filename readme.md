README: 

Update Tags in Azure DevOps Using PowerShell REST API

This guide explains how to move the latest tag to point to the same commit as the v1.2_final tag, and save the current latest tag as previous_latest using the Azure DevOps REST API with PowerShell.

Prerequisites

Azure DevOps Organization, Project, and Repository access

Personal Access Token (PAT) with Code Read & Write permission

PowerShell (Windows PowerShell 5.1 or PowerShell 7+)

Commit IDs for your tags (latest and v1.2_final)

Step 1: Clone or Get Repo Info (Optional)

You can get your repository name or ID from the Azure DevOps portal:

Navigate to your project.

Go to Repos > Files.

Copy your repo name or ID (usually the repo name is fine).

Step 2: Get Commit IDs for Tags

You need the commit IDs (SHA hashes) for your existing tags:

Step 3: Update Tags Using PowerShell Script

Create a new tag previous_latest pointing to the current latest commit.

Move the latest tag to point to the commit of v1.2_final.

Replace the placeholders (<your_org>, <your_project>, <your_repo>, <your_PAT>, and commit IDs) with your actual values.

Step 4: Verify Changes

Go to Azure DevOps portal > Repos > Tags.

Confirm:

latest tag points to the same commit as v1.2_final.

previous_latest tag points to the commit that latest was originally pointing to.
