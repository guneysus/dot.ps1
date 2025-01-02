# Define an enum for prompt names
enum PromptType {
  Default
  Minimal
  Basic
  TimeBased
  Fancy
  Advance
  Custom
  MinimalCustom
  MinimalCustomAlt
}

# Define the Switch-Prompt function
function Switch-Prompt {
  param(
    [Parameter(Mandatory = $true)]
    [PromptType]$PromptName
  )

  # Define custom prompt functions
  $prompts = @{
    "Default"          = {
      set-content Function:prompt {
        return "$($executionContext.SessionState.Path.CurrentLocation)> "
      }
    }
    "Minimal"          = {
      set-content Function:prompt {
        return "> "
      }
    }
    "Basic"            = {
      set-content Function:prompt {
        write-host "$($executionContext.SessionState.Path.CurrentLocation.Path.Replace($HOME, "~")) $('$' * ($nestedPromptLevel + 1))" -NoNewline

        if ( $null -ne $(git rev-parse --git-dir 2>$null)) {
          write-host " [$(git branch --show-current)]" -NoNewline -ForegroundColor Cyan
        }
				
        $host.ui.RawUI.WindowTitle = [System.IO.Path]::GetFileName($(Get-Location))
				  
        return "> " 
      }
    }
    "TimeBased"        = {
      set-content Function:prompt {
        return "[$(Get-Date -Format 'HH:mm:ss')] $($executionContext.SessionState.Path.CurrentLocation)> "
      }
    }
    "Fancy"            = {
      set-content Function:prompt {
        return "🐱 $($executionContext.SessionState.Path.CurrentLocation)> "
      }
    }

    "Custom"           = {
      set-content Function:prompt {
        Write-Host ""

        # Write any custom prompt environment (f.e., from vs2019.ps1)
        if (get-content variable:\PromptEnvironment -ErrorAction Ignore) {
          Write-Host " $([char]27)[38;5;54;48;5;183m$PromptEnvironment$([char]27)[0m" -NoNewLine
        }
					
        # Write the current Git information
        if ($null -ne (Get-Command "Get-GitDirectory" -ErrorAction Ignore)) {
          if ($null -ne $(Get-GitDirectory)) {
            Write-Host (Write-VcsStatus) -NoNewLine
          }
        }

        # Write the current directory, with home folder normalized to ~
        $currentPath = (get-location).Path.replace($home, "~")
        $idx = $currentPath.IndexOf("::")
        if ($idx -gt -1) { $currentPath = $currentPath.Substring($idx + 2) }
						
        $currentDir = [System.IO.DirectoryInfo]::new( (get-location)).Name
						
        $host.UI.RawUI.WindowTitle = $currentDir  # $currentPath
					
        # Write-Host " $([char]27)[38;5;227;48;5;28m  $([char]27)[38;5;254m$currentPath $([char]27)[0m " -NoNewline
        return " $([char]27)[38;5;227;48;5;28m $([char]27)[38;5;254m$currentDir $([char]27)[0m " 
	
      } 
    }
    "MinimalCustom"    = {
      set-content Function:prompt {
        # Start with a blank line, for breathing room :)
        Write-Host "" -NoNewline

        # Write the current Git information
        if ($null -ne (Get-Command "Get-GitDirectory" -ErrorAction Ignore)) {
          if ($null -ne $(Get-GitDirectory)) {
            Write-Host (Write-VcsStatus) -NoNewLine
          }
        }

        $path = $executionContext.SessionState.Path.CurrentLocation.Path # $pwd.Path
        $homePath = ((Resolve-Path "~").Path)
        # $sep = " $([char]0xe602)" # ?
        $sep = "$([char]0x276f)" # ?
        $sep = "/" # ?
        $ESC = [char]27
        $homeSymbol = "🏠" # "$([char]0xf7db)" # 🏠
			  
        switch ($path) {
          $homePath { 
            Write-Host "$ESC[32m$($homeSymbol)$ESC[0m" -NoNewLine
            break 
          }
          default {
            $arr = $path.Split('\')
            $newArray = @()
            $newArray += $arr[0]
            $arr | Select-Object -Skip 1 -Last ($arr.Length - 2) | ForEach-Object { $newArray += ($_.Trim('.'))[0] }
            $newArray += $($arr | Select-Object -Last 1)
            $joined = ($newArray -join $sep )
            Write-Host " $ESC[96m$($joined)$ESC[0m" -NoNewLine
          }
        }

        Set-Title
        return "> "
      }
    }
      "MinimalCustomAlt" = {
        set-content Function:prompt {
            # Start with a blank line, for breathing room :)
            Write-Host ""

            # Write the current Git information
            if (Get-Command "Get-GitDirectory" -ErrorAction Ignore) {
                $gitDirectory = Get-GitDirectory
                if ($null -ne $gitDirectory) {
                    Write-Host (Write-VcsStatus) -NoNewline
                }
            }

            $path = $executionContext.SessionState.Path.CurrentLocation.Path
            $homePath = (Resolve-Path "~").Path
            $ESC = [char]27
            $homeSymbol = "🏠" # 🏠 symbol for the home directory

            switch ($path) {
                $homePath { 
                    Write-Host "$ESC[32m$homeSymbol$ESC[0m" -NoNewline
                    break 
                }
                default {
                    $cwd = [System.IO.DirectoryInfo]::new($path).Name
                    Write-Host " $ESC[96m$cwd$ESC[0m" -NoNewline
                }
            }

            # Ensure Set-Title is defined or called safely
            if (Get-Command "Set-Title" -ErrorAction Ignore) {
                Set-Title
            }

            return "> "
        }
      }


    "Advance"          = {
      set-content Function:prompt {
        # Start with a blank line, for breathing room :)
        Write-Host ""

        # Reset the foreground color to default
        $Host.UI.RawUI.ForegroundColor = "Gray"
			
        # Write ERR for any PowerShell errors
        if ($Error.Count -ne 0) {
          Write-Host " $([char]27)[38;5;227;48;5;131m  ERR $([char]27)[0m" -NoNewLine
          $Error.Clear()
        }
			
        # Write non-zero exit code from last launched process
        if ($LASTEXITCODE -ne "") {
          Write-Host " $([char]27)[38;5;227;48;5;131m  $LASTEXITCODE $([char]27)[0m" -NoNewLine
          $LASTEXITCODE = ""
        }
			
        # Write any custom prompt environment (f.e., from vs2019.ps1)
        if (get-content variable:\PromptEnvironment -ErrorAction Ignore) {
          Write-Host " $([char]27)[38;5;54;48;5;183m$PromptEnvironment$([char]27)[0m" -NoNewLine
        }
			
        # Write .NET SDK version
        if ($null -ne (Get-Command "dotnet" -ErrorAction Ignore)) {
          $dotNetVersion = (& dotnet --version)
          Write-Host " $([char]27)[38;5;254;48;5;54m  $dotNetVersion $([char]27)[0m" -NoNewLine
        }
			
        # Write the current kubectl context
        if ($null -ne (Get-Command "kubectl" -ErrorAction Ignore)) {
          $currentContext = (& kubectl config current-context 2> $null)
          if ($Error.Count -eq 0) {
            Write-Host " $([char]27)[38;5;112;48;5;242m  $([char]27)[38;5;254m$currentContext $([char]27)[0m" -NoNewLine
          }
          else {
            $Error.Clear()
          }
        }
			
        # Write the current public cloud Azure CLI subscription
        # NOTE: You will need sed from somewhere (for example, from Git for Windows)
        if (Test-Path ~/.azure/clouds.config) {
          $cloudsConfig = parseIniFile ~/.azure/clouds.config
          $azureCloud = $cloudsConfig | Where-Object { $_.Section -eq "[AzureCloud]" }
          if ($null -ne $azureCloud) {
            $currentSub = $azureCloud.Content.subscription
            if ($null -ne $currentSub) {
              $currentAccount = (Get-Content ~/.azure/azureProfile.json | ConvertFrom-Json).subscriptions | Where-Object { $_.id -eq $currentSub }
              if ($null -ne $currentAccount) {
                Write-Host " $([char]27)[38;5;227;48;5;30m  $([char]27)[38;5;254m$($currentAccount.name) $([char]27)[0m" -NoNewLine
              }
            }
          }
        }
			
        # Write the current Git information
        if ($null -ne (Get-Command "Get-GitDirectory" -ErrorAction Ignore)) {
          if (Get-GitDirectory -ne $null) {
            Write-Host (Write-VcsStatus) -NoNewLine
          }
        }
			
        # Write the current directory, with home folder normalized to ~
        $currentPath = (get-location).Path.replace($home, "~")
        $idx = $currentPath.IndexOf("::")
        if ($idx -gt -1) { $currentPath = $currentPath.Substring($idx + 2) }
				
        $currentDir = [System.IO.DirectoryInfo]::new( (get-location)).Name
				
        $host.UI.RawUI.WindowTitle = $currentDir  # $currentPath
			
        # Write-Host " $([char]27)[38;5;227;48;5;28m  $([char]27)[38;5;254m$currentPath $([char]27)[0m " -NoNewline
        Write-Host " $([char]27)[38;5;227;48;5;28m  $([char]27)[38;5;254m$currentDir $([char]27)[0m " -NoNewline
			
        # Reset LASTEXITCODE so we don't show it over and over again
        $global:LASTEXITCODE = 0
			
        # Write one + for each level of the pushd stack
        if ((get-location -stack).Count -gt 0) {
          Write-Host " " -NoNewLine
          Write-Host (("+" * ((get-location -stack).Count))) -NoNewLine -ForegroundColor Cyan
        }
			
        # Newline
        Write-Host ""
			
        # Determine if the user is admin, so we color the prompt green or red
        $isAdmin = $false
        $isDesktop = ($PSVersionTable.PSEdition -eq "Desktop")
			
        if ($isDesktop -or $IsWindows) {
          $windowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
          $windowsPrincipal = new-object 'System.Security.Principal.WindowsPrincipal' $windowsIdentity
          $isAdmin = $windowsPrincipal.IsInRole("Administrators") -eq 1
        }
        else {
          $isAdmin = ((& id -u) -eq 0)
        }
			
        if ($isAdmin) { $color = "Red"; }
        else { $color = "Green"; }
			
        # Write PS> for desktop PowerShell, pwsh> for PowerShell Core
        if ($isDesktop) {
          Write-Host ">>>>>>>>>>" -ForegroundColor Red
          Write-Host "powershell >" -NoNewLine -ForegroundColor $color
        }
        else {
          Write-Host "ps core >" -NoNewLine -ForegroundColor $color
        }
			
        # Always have to return something or else we get the default prompt
        return " "
      }
    }
  }

  # Switch to the specified prompt if it exists
  if ($prompts.ContainsKey($PromptName.ToString())) {
    & $prompts[$PromptName.ToString()]
    Write-Debug "Switched to '$PromptName' prompt."
  }
  else {
    Write-Host "Prompt '$PromptName' not found."
  }
}

# Example of adding tab completion for the enum values
Register-ArgumentCompleter -CommandName Switch-Prompt -ParameterName PromptName -ScriptBlock {
  param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
  [PromptType]::GetEnumNames() | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
  }
}

# Example: Switch to 'Fancy' prompt
# Switch-Prompt -PromptName Default


function Set-Title() {
  $repo = git rev-parse --show-toplevel 2>$null
  if ($LASTEXITCODE -eq 0) {
    $repo = Split-Path -Leaf $repo
  }
  else {
    $repo = Split-Path -Leaf (Get-Location)
  }
  $host.UI.RawUI.WindowTitle = $repo
}
