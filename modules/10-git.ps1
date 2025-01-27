function Invoke-GitRewriteHistory_ResetAuthors {
    [alias("git-reset-authors")]param()
    git rebase -r --root --exec "git commit --amend --no-edit --reset-author"
}


# git config --local user.name "Ahmed Seref Guneysu"
# git config --local user.email "949232+guneysus@users.noreply.github.com"
# git config --local --edit
# 

<#
[core]
        repositoryformatversion = 0
        filemode = false
        bare = false
        logallrefupdates = true
        symlinks = false
        ignorecase = true
[remote "origin"]
        url = git@github.com:guneysus/dot.ps1.git
        fetch = +refs/heads/*:refs/remotes/origin/*
[branch "develop"]
        remote = origin
        merge = refs/heads/develop
        vscode-merge-base = origin/develop
[user]
        email = 949232+guneysus@users.noreply.github.com
        name = Ahmed Seref Guneysu
#>

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER Issue
Parameter description

.PARAMETER Text
Parameter description

.EXAMPLE
branch-name -Issue "PICR-390" -Text "Image Recognition Backend API Connection"
# Output: "PICR-390/image-recognition-backend-api-connection"

.EXAMPLE
# Using the alias:
branch-name -Issue "PICR-391" -Text "Another Example for Slug Creation!"
# Output: "PICR-391/another-example-for-slug-creation"


.NOTES
General notes
#>
function New-BranchName {
    [CmdletBinding()]
    [Alias("branch-name")]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Text,

        [Parameter(Mandatory = $false)]
        [string]$Prefix
    )

    # Split the text into two parts: before and after the first dash
    $parts = $Text -split '-', 2

    # Keep the first part as is
    $issuePart = $parts[0]

    # Convert the text part (after the first dash, if any) to lowercase
    if ($parts.Count -gt 1) {
        $slugText = $parts[1].ToLower()

        # Replace any non-alphanumeric characters with spaces using regex
        $slugText = [regex]::Replace($slugText, '[^a-z0-9/\s]', '')

        # Replace any sequence of spaces or forward slashes with a single dash
        $slugText = [regex]::Replace($slugText, '(\s+|/)', '-')

        # Combine the issue part and the slugified text with a dash
        $result = "$issuePart-$slugText"
    } else {
        # If there is no dash in the original text, return the original text as is
        $result = $issuePart
    }

    # If a prefix is provided, prepend it
    if ($Prefix) {
        $result = "$Prefix$result"
    }

    # Return the result
    return $result
}


function Invoke-Clone {
    [Alias('clone')]
    param(
        [Parameter(Mandatory = $true)] [string] $GitUrl,
        [Parameter(Mandatory = $false)] [string] $Branch
    )
    
    # Check if the URL is SSH or HTTPS
    if ($GitUrl -match "^git@") {
        # SSH URL, replace "git@" and ":" with "/" to normalize the URL for path creation
        $urlParts = $GitUrl -replace "^git@", "" -replace ":", "/" -split "/"
    }
    elseif ($GitUrl -match "^https?://") {
        # HTTPS URL, remove "www" if it exists
        $urlParts = $GitUrl -replace "^https?://(www\.)?", "" -split "/"
    }
    else {
        throw "Unsupported Git URL format."
    }
    
    # Add '.git' suffix to the last segment (repository name)
    $repoName = [System.IO.Path]::GetFileNameWithoutExtension($urlParts[-1])
    $urlParts[-1] = "$repoName.git"
    
    # Construct the clone path in C:\repos by combining all URL parts
    $clonePath = "C:\git"           # TODO: Use global environment variable
    foreach ($part in $urlParts) {
        $clonePath = Join-Path $clonePath $part
    }
    
    # Ensure the directory structure exists
    if (-not (Test-Path -Path $clonePath)) {
        New-Item -ItemType Directory -Path $clonePath -Force
    }
    
    # Clone the repository

    if ( $PSBoundParameters.ContainsKey('Branch')) {
        git clone --single-branch --branch $Branch $GitUrl $clonePath
    }
    else {
        git clone $GitUrl $clonePath
    }
    
    # Change to the cloned directory
    Set-Location -Path $clonePath
    
    Write-Host "Repository cloned to $clonePath and switched to directory."
}
