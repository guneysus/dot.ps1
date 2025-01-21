function Remove-ZeroByteFiles {
    Get-ChildItem *.md -Recurse | `
        Where-Object { $_.Length -eq 0 } | `
        ForEach-Object { Remove-Item $_ }
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.EXAMPLE
An example

.NOTES
General notes
#>

Function .. { Set-Location .. }



<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.EXAMPLE
An example

.NOTES
General notes
#>
Function ... { Set-Location ... }



<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.EXAMPLE
An example

.NOTES
General notes
#>
Function .... { Set-Location .... }
