function Invoke-GitRewriteHistory_ResetAuthors {
    [alias("git-reset-authors")]param()
    git rebase -r --root --exec "git commit --amend --no-edit --reset-author"
}


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

