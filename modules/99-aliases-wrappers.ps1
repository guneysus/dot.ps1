new-alias apt winget
new-alias e explorer
new-alias vs "C:\Program Files\Microsoft Visual Studio\2022\Preview\Common7\IDE\devenv.exe"
new-alias gg lazygit
new-alias gbt Get-BootTime
new-alias ver Get-Version
new-alias GSer Get-SerialNumber	
new-alias GML Get-Model
new-alias GDE Get-ErrorsPerDay
new-alias IP Get-IP4

function Enter-PersonalFolder { [Alias('personal')]param() Push-Location "C:\git\guneysus" }
function Enter-DockerFolder { [Alias('cd-docker')]param() Push-Location "C:\git\guneysus\docker.git" }

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

.EXAMPLE
add-wrapper "chrome-automated" "C:\Program Files\Google\Chrome\Application\chrome.exe" "--enable-automation","other","extra", "arguments"

.EXAMPLE
xalias "exec" pwsh -noprofile, -nologo

.NOTES
General notes

STDIN redirection does not work as expected.

So this may not work:

xalias "exec" pwsh "-noprofile", -nologo, -command, -


#>


function Add-Wrapper {
    [Alias("xalias")]
    param (
        [Parameter(Mandatory = $true)][string]$name,
        [Parameter(Mandatory = $true)][string]$path,
        [Parameter(Mandatory = $false)][string[]]$defaultArgs
    )

    # Check if we need to handle stdin
    $stdinRedirect = if ($defaultArgs -contains '-') {
        '$input | &'
    }
    else {
        '&'
    }

    $functionBody = "$stdinRedirect ""$path"" $($defaultArgs) `$args"
    # Store wrapper info in global variable
    if (-not (Test-Path variable:global:Wrappers)) {
        $Global:Wrappers = @{}
    }
    $Global:Wrappers[$name] = @{
        Name = $name
        Body = $functionBody
    }
    # write-host -ForegroundColor Green $functionBody
    new-item -path function:\ -name "global:$name" -value $functionBody -Force | Out-Null
}

function Get-Wrappers {
    [Alias("wrappers")]
    param()
    
    if (-not (Test-Path variable:global:Wrappers)) {
        Write-Warning "No wrappers defined"
        return
    }

    $Global:Wrappers.GetEnumerator() | ForEach-Object {
        [PSCustomObject]@{
            Name = $_.Value.Name
            Body = $_.Value.Body
        }
    } | Format-Table -AutoSize
}



Function Invoke-UUID { [Alias('uuid')]param() [guid]::newguid().Guid }




add-wrapper hugo "C:\bin\hugo_0.135.0.exe"

# add-wrapper ack "perl" "$HOME\scoop\apps\ack\current\ack-single-file", "--ignore-dir=bin", "--ignore-dir=obj"

add-wrapper compile-lisp "C:\Program Files\Steel Bank Common Lisp\sbcl.exe"

add-wrapper cpuz "C:\apps\cpuz.exe"

add-wrapper "chrome-automated" "C:\Program Files\Google\Chrome\Application\chrome.exe" "--enable-automation"

add-wrapper "kubectl" "minikube" "kubectl", "--"

# add-wrapper "exec" pwsh "-nop", "-nologo", "-noni", "-command", "-"

add-wrapper "identity-ef" "dotnet" "ef", `
    "--startup-project", ".\src\Invicti.UP.AppSec.Identity.Host", `
    "--project", ".\src\Invicti.UP.AppSec.Identity.Storage"   # "--context", "Invicti.UP.AppSec.Identity.Storage.PostgresIdentityDbContext"

add-wrapper "identity-ef-db-update" "dotnet" "ef", "database", "update", `
    "--startup-project", ".\src\Invicti.UP.AppSec.Identity.Host", `
    "--project", ".\src\Invicti.UP.AppSec.Identity.Storage", "--context", "Invicti.UP.AppSec.Identity.Storage.PostgresIdentityDbContext"

add-wrapper "identity-ef-db-drop" "dotnet" "ef", "database", "drop", `
    "--startup-project", ".\src\Invicti.UP.AppSec.Identity.Host", `
    "--project", ".\src\Invicti.UP.AppSec.Identity.Storage", "--context", "Invicti.UP.AppSec.Identity.Storage.PostgresIdentityDbContext", "--force"


add-wrapper "identity-ef-migrations" "dotnet" "ef", "migrations", "--startup-project", ".\src\Invicti.UP.AppSec.Identity.Host", "--project", ".\src\Invicti.UP.AppSec.Identity.Storage"

add-wrapper "ns-ef" "dotnet" "ef", "--startup-project", ".\src\Invicti.UP.AppSec.Notifications.Host", "--project", ".\src\Invicti.UP.AppSec.Notifications.Storage"
add-wrapper "ns-ef-migrations" "dotnet" "ef", "migrations", "--startup-project", ".\src\Invicti.UP.AppSec.Notifications.Host", "--project", ".\src\Invicti.UP.AppSec.Notifications.Storage"
Add-Wrapper "lzd" "lazydocker"
function Find-DbContexts {
    dotnet ef dbcontext list
}

function Get-Migrations {
    dotnet ef migrations list
}

set-alias which get-command

# function Enter-Git { [Alias('repos')]param() Push-Location "C:\git" }
# Add-Wrapper repos fzf --walker=dir, "--walker-root=C:/git/gitlab.com"


function Invoke-NavigateProjects {
    [Alias('repos')]
    param()

    Push-Location $(fzf --walker=dir --walker-root=C:/git/gitlab.com --walker-skip=.git,node_modules,bin,obj)
}

Add-Wrapper nav fzf --walker=dir

add-wrapper "up-nats" "nats" "-s", "nats://s3cr3t@localhost:4321" #, '">"'

# add-wrapper "up-nats" "nats" "sub", "-s", "nats://s3cr3t@localhost:4321" #, '">"'

add-wrapper "install" "winget" "install"


# Set-PSReadLineKeyHandler -Key Alt+p -ScriptBlock { pake Default }
# Set-PSReadLineKeyHandler -Key Alt+c -ScriptBlock { docker-compose up }



Add-Wrapper "dotnet-install-global-tool" "dotnet" "tool", "install", "--source", "https://api.nuget.org/v3/index.json", "-g"