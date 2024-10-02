$validateAttr = (new-object ValidateScript { 
    Write-Debug "navigating into: $_"
    
    $ENV_FILE_PATH = (Resolve-EnvFilePath)
    
    $CURRENT_ENV_FILE_PATH = (get-variable -Name ENV_FILE -ValueOnly -ErrorAction SilentlyContinue)

    if ($ENV_FILE_PATH -ne $null -and ($CURRENT_ENV_FILE_PATH -ne $ENV_FILE_PATH)) {
      # Import required
      Write-Host "> Reading env from: $([char]27)[38;5;54;48;5;183m$ENV_FILE_PATH$([char]27)[0m"
      Set-Variable -Name ENV_FILE -Value $ENV_FILE_PATH -Scope Script
      Import-Env -Path $ENV_FILE_PATH -Dump
    }
    
    if ($ENV_FILE_PATH -eq $null -and $CURRENT_ENV_FILE_PATH -ne $null) {
      Set-Variable -Name ENV_FILE -Value $null -Scope Script
    }

    return $true 
  })

(Get-Variable PWD).Attributes.Add($validateAttr)

