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
function Read-Env {
  get-content .env | ForEach-Object {
    $name, $value = $_.split('=')
    Write-Debug "Name: $name Value: $value"
    set-content env:\$name $value
  }
}

<#
.SYNOPSIS
Imports variables from an ENV file
https://stackoverflow.com/a/76723749/1766716

.EXAMPLE
# Basic usage
dotenv

.EXAMPLE
# Provide a path
dotenv path/to/env

.EXAMPLE
# See what the command will do before it runs
dotenv -whatif

.EXAMPLE
# Create regular vars instead of env vars
dotenv -type regular
#>
function Import-Env {
  [CmdletBinding(SupportsShouldProcess)]
  [Alias('dotenv')]
  param(
    [ValidateNotNullOrEmpty()]
    [String] $Path = '.env',

    # Determines whether variables are environment variables or normal
    [ValidateSet('Environment', 'Regular')]
    [String] $Type = 'Environment',

    [switch] $Dump = $false
  )

  if ($Dump) {
    Get-Content -raw  $Path | ConvertFrom-StringData | Out-Default
  }

  $Env = Get-Content -raw $Path | ConvertFrom-StringData
  $Env.GetEnumerator() | Foreach-Object {

    $Name, $Value = $_.Name, $_.Value
    if ($PSCmdlet.ShouldProcess($Name, "Importing $Type Variable")) {
      switch ($Type) {
        'Environment' { Set-Content -Path "env:\$Name" -Value $Value }
        'Regular' { 
          Write-Debug "Name: $Name Value: $Value"
          Set-Variable -Name $Name -Value $Value -Scope Script
        }
      }
    }
  }


}

<#
.SYNOPSIS
Resolves .env file path from a folder

.DESCRIPTION
Long description

.EXAMPLE
An example

.NOTES
General notes
#>
function Resolve-EnvFilePath {

  $ENV_FILE_PATH = $null

  $gitDir = $(Get-GitDirectory)

  
  if (Test-Path $gitDir) {
    $repoRootEnv = $(Join-Path $gitDir ".." ".env")    

    # TODO: Check filetimestamp to import
    if ($null -ne $gitDir -and (Test-Path $repoRootEnv)) {
      $ENV_FILE_PATH = (get-item $repoRootEnv).FullName
      Write-Debug "> GIT: $ENV_FILE_PATH"
    }
  }

  $currentEnv = $(Join-Path -Path $(Get-Location) -ChildPath .env) 

  if (Test-Path $currentEnv) {
    $ENV_FILE_PATH = $currentEnv
    Write-Debug "> CURRENT: $ENV_FILE_PATH"

  }

  $ENV_FILE_PATH

}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER path
Parameter description

.EXAMPLE
An example

.NOTES
General notes
#>
function Switch-EnvFile {
  param (
    [string]$path
  )

  # Import required
  Write-Host "> Reading env from: $([char]27)[38;5;54;48;5;183m$path$([char]27)[0m"
  set-variable -Name ENV_FILE -Value $path -Scope Script
  set-variable -name ENV_FILE_HASH (Get-Item $path).LastWriteTime.Ticks  -Scope Script
  Import-Env -Path $path -Dump
}

$validateAttr = (new-object ValidateScript { 
    Write-Debug "Navigating into: $_"

    $ENV_FILE_PATH = (Resolve-EnvFilePath)
    $CURRENT_ENV_FILE_PATH = (get-variable -Name ENV_FILE -ValueOnly -ErrorAction SilentlyContinue)

    if ($ENV_FILE_PATH -ne $null) { 
      Write-Debug "> Resolved .env path in $ENV_FILE_PATH"

      if ($CURRENT_ENV_FILE_PATH -ne $ENV_FILE_PATH) {
        # Import required
        Switch-EnvFile $ENV_FILE_PATH
      }
      else {
        # Files are same, but what about if the file has changed?
        $SOURCED_ENV_FILE_HASH = (get-variable -Name ENV_FILE_HASH -ValueOnly -ErrorAction SilentlyContinue)
        $ACTUAL_ENV_FILE_HASH = (Get-Item $ENV_FILE_PATH).LastWriteTime.Ticks
        Write-Debug "Same .env file"
        Write-Debug "Currently sourced .env file hash: ${SOURCED_ENV_FILE_HASH}, actual: ${ACTUAL_ENV_FILE_HASH}" 

        if ($ACTUAL_ENV_FILE_HASH -ne $SOURCED_ENV_FILE_HASH) {
          # Re-import
          write-host "Re-importing .env file it has changed" -ForegroundColor Yellow
          Switch-EnvFile $ENV_FILE_PATH
        }
      }
    }
    else {
      if ($CURRENT_ENV_FILE_PATH -ne $null) {
        Write-Host "> Oh! TODO: Revert to previous state (optionally/ideally)" -ForegroundColor Red
        Set-Variable -Name ENV_FILE -Value $null -Scope Script
      }
    }




    return $true 
  })

(Get-Variable PWD).Attributes.Add($validateAttr)


(Get-Variable PWD).Attributes.Add((new-object ValidateScript { 
      Write-Debug "[AutoVirtualEnv] $_"

      $venv = ".\.venv\Scripts\activate.ps1"
      if (test-path $venv) {
        . $venv
      }
      return $true 
    }))