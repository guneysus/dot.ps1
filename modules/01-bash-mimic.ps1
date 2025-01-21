Function Invoke-XArgs () {
    [Alias("xargs")]
    param(  
        [Parameter(
            Position = 0, 
            Mandatory = $true, 
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)
        ]
        [String[]]$args,
  
        [Parameter(Mandatory = $true)]
        [String]$Command
    )
  
    process {
      
        write-debug $($args -join ';')
  
        foreach ($arg in $args) {
            Invoke-Expression "$Command".Replace("{}", $arg)
            write-debug "$Command".Replace("{}", $arg)
            Write-Output "$Command".Replace("{}", $arg)
        }
    }
}

Function Invoke-Export { [Alias('export')]param() Get-ChildItem env: }

Function Get-DirectoryList {
    [Alias('lsd')]param()
    Get-ChildItem -Directory
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
function Show-Path {
    # Get the PATH environment variable and split it by the semicolon
    $pathEntries = $Env:PATH -split ';'

    # Create an array of custom objects with Index and Path properties
    $paths = $pathEntries |
    Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
    ForEach-Object { [PSCustomObject]@{ Index = [System.Array]::IndexOf($pathEntries, $_) + 1; Path = $_ } }

    # Display the paths in a formatted table
    $paths | Format-Table -Property Index, Path -AutoSize
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
Function Invoke-Lsdir () {
    Get-ChildItem -Directory
}


Set-Alias klone Invoke-Klone
Set-Alias notepad2 Invoke-Notepad2
Set-Alias export Invoke-Export
Set-Alias xargs Invoke-Xargs
set-alias which get-command
New-Alias LsDir Get-DirectoryList

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER pattern
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
Function XFind {
    Param(
        [Parameter(Mandatory = $true)] 
        [string]$pattern
    )

    Get-ChildItem -path . -filter $pattern -recurse | ForEach-Object { $_.fullname }
}

