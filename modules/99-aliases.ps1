new-alias apt winget
new-alias e explorer
new-alias vs "C:\Program Files\Microsoft Visual Studio\2022\Preview\Common7\IDE\devenv.exe"
new-alias gg lazygit
new-alias gbt Get-BootTime
new-alias ver Get-Version
new-alias GSer Get-SerialNumber	
new-alias GML Get-Model
new-alias GDE Get-ErrorsPerDay
new-alias xf Xfind
new-alias IP Get-IP4

function Enter-Repos { [Alias('repos')]param() Push-Location "C:\repos" }
function Enter-PersonalFolder { [Alias('personal')]param() Push-Location "C:\repos\guneysus" }


function gs { git status }
function gaa { git add . }
function gd { git diff }
function gds { git diff --staged }
function gpull { git pull }
function gco { git checkout }
function gf { git fetch --all }


function q { exit }
Function .. { Push-Location .. }
Function ... { Push-Location ... }
Function .... { Push-Location .... }


Function signTool { . "C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64\signtool.exe" $args }

<#
.SYNOPSIS
Create wrapper powershell functions or shortuts to your applications optionally with default values.

.DESCRIPTION
Long description

.PARAMETER name
Parameter description

.PARAMETER path
Parameter description

.EXAMPLE
add-wrapper "hugo" "C:\bin\hugo_0.135.0.exe"

.EXAMPLE
add-wrapper "ack" "perl" "$HOME\scoop\apps\ack\current\ack-single-file", "--ignore-dir=bin", "--ignore-dir=obj"


.EXAMPLE

add-wrapper "chrome-personal" "C:\Program Files\Google\Chrome\Application\chrome.exe"
add-wrapper "chrome-automated" "C:\Program Files\Google\Chrome\Application\chrome.exe" "--enable-automation"

.NOTES
General notes
#>
function Add-Wrapper {
    param (
        [Parameter(Mandatory = $true)][string]$name,
        [Parameter(Mandatory = $true)][string]$path,
        [Parameter(Mandatory = $false)][string[]]$defaultArgs
    )

    $functionBody = "& ""$path"" $($defaultArgs) `$args"


    new-item -path function:\ -name "global:$name" -value $functionBody | Out-Null
}



Function Invoke-UUID { [Alias('uuid')]param() [guid]::newguid().Guid }

Function Invoke-Export { [Alias('export')]param() Get-ChildItem env: }
