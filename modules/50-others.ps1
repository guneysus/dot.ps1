Function XFind {
  [alias("xf")]
  Param(
    [Parameter(Mandatory = $true)] 
    [string]$pattern
  )

  Get-ChildItem -path . -filter $pattern -recurse | ForEach-Object { $_.fullname }
}

Function Get-PredefinedAliases {
  get-alias | Where-Object source -EQ ''
}

Function Get-MicrosoftAliases {
  get-alias | Where-Object source -In @('Microsoft.PowerShell.Utility', 'Microsoft.PowerShell.Management')
} 

Function Get-Functions {
  Get-ChildItem Function: | Sort-Object Source -Descending
}

Function Get-Drives { 
  Get-ChildItem Function: | Where-Object Name -Contains ':'
}



Function Get-BootTime { wmic OS get LastBootupTime }

Function Get-Version { $psversiontable }

Function Get-SerialNumber { (Get-WmiObject -Class:Win32_BIOS).SerialNumber }
	
Function Get-Model { (Get-WmiObject -Class:Win32_ComputerSystem).Model }

Function Get-ErrorsPerDay { Get-EventLog -LogName 'Application' -EntryType Error -After ((Get-Date).Date.AddDays(-30)) | ForEach-Object { $_ | Add-Member -	MemberType NoteProperty -Name LogDay -Value $_.TimeGenerated.ToString("yyyyMMdd") -PassThru } | Group-Object LogDay | Select-Object @{N = 'LogDay'; E =	{ [int]$_.Name } }, Count | Sort-Object LogDay | Format-Table -Auto }




function Format-Upper {
  <#
    .EXAMPLE
        "lorem ipsum" | Format-Upper
#>
  [alias("upper")]
  [cmdletbinding()] param([parameter(ValueFromPipeline)] [string]$value)
  Process {
    $_.ToUpperInvariant()
  }    
}

function Format-Lower {
  [alias("lower")]
  [cmdletbinding()] param([parameter(ValueFromPipeline)] [string]$value)
  Process {
    $_.ToLowerInvariant()
  }    
}

function Get-MagicBytes {
  [alias("magix")]
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [System.IO.FileInfo] $file
  )
  get-content $file -AsByteStream -totalcount 2 | Format-Hex
}


function edit-profile {
  . "C:\Program Files\Notepad++\notepad++.exe" $PROFILE
}


function Edit-Profile_ { notepad2 $PROFILE }



function Get-Definition {
  [alias("def")]
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string] $name
  )
  Write-Output (Get-Command $name).Definition
}

function Get-LoadedAssemblies {
  [System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object Location | Sort-Object -Property FullName
}

 
function Show-LoadedAssemblies {
	 [System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object Location | Sort-Object -Property FullName | Out-GridView
}
 

function Write-Module {
  param(
    [Parameter(Mandatory = $true)] [string] $name,
    [Parameter(Mandatory = $true)] [string] $author
  )
  
  $manifest = @{
    Path       = ".\${name}\${name}.psd1"
    RootModule = "${name}.psm1"
    Author     = $author
  }
  
  New-Item -ItemType Directory -Name "${name}" -Force | out-null
  
  New-ModuleManifest @manifest
  
  New-Item -ItemType File -Path ".\${name}\${name}.psm1" | out-null
  
  Write-Host -ForeGround Green "Created module: ${name}. Use:"
  Write-Host -ForeGround Green "Import-Module ${name}"
}


function New-Func {
  <#
  .EXAMPLE
    Write-Func get-x -a foo,bar
    
  .EXAMPLE
    "foo","bar" | Write-Func get-x -a foo,bar
  #>
  param(
    [Parameter(Mandatory = $true, Position = 0)] [string] $verb,
    [Parameter(Mandatory = $true, Position = 1)] [string] $noun,
    [Parameter(Valuefrompipeline = $true)] [string[]] $args = @()
  )
    
  begin {
    $parameters = @()
    "function ${verb}-${noun} {"
    if ($args.length -gt 0) {
      "  param ("
    }
  }

  Process {
    foreach ($a in $args) {
      $parameters += "    [Parameter(Mandatory = `$$false)] [string] `$$($a.Trim())" 
    }
    
      ($parameters -join ",`n")
      
    if ($args.length -gt 0) {
      "  )"
    }
  }

  end {
    "}"
  }
}


function Write-CurrentDir {
  $path = $executionContext.SessionState.Path.CurrentLocation.Path # $pwd.Path
  $homePath = ((Resolve-Path "~").Path)
  $sep = " $([char]0xe602) " # ?
  $sep = " $([char]0x276f) " # ?
  $ESC = [char]27
  $homeSymbol = "$([char]0xf7db)" # ?

  switch ($path) {
    $homePath { 
      Write-Host "$ESC[32m $($homeSymbol) > $ESC[0m "; -NoNewLine
      break 
    }
    default {
      $arr = $path.Split('\')
      $newArray = @()
      $newArray += $arr[0]
      $arr | Select-Object -Skip 1 -Last ($arr.Length - 2) | ForEach-Object { $newArray += ($_.Trim('.'))[0] }
      $newArray += $($arr | Select-Object -Last 1)
      $joined = ($newArray -join $sep )
      Write-Host "$ESC[96m $($joined) > $ESC[0m " -NoNewLine
    }
  }
}


function set_minimal_prompt {
  set-item function:prompt {

  }
}



function Greet {
  $msg = $(Get-date -Format "dddd, MMMM dd, yyyy HH:mm:ss")
  Write-Host $msg
}

function Register-AutoCompleteDotnet {
  # PowerShell parameter completion shim for the dotnet CLI
  Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
      [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
  }
}

function Get-FunctionModulePath {
  param (
    [Parameter(Mandatory = $true)]
    [string] $name
  )
  (get-command $name).Module.Path
}

function Get-Key () {
  Param(
    [parameter(mandatory = $true)][string]$pass,
    [parameter(mandatory = $true)][string]$salt
  )
  $saltBytes = get-bytes $salt
  $passDerive = New-Object Security.Cryptography.Rfc2898DeriveBytes -ArgumentList @($pass, $saltBytes)
  
  $keySize = 256
  $key = $passDerive.GetBytes($keySize / 8)
  echo $key
}


<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER pass
Parameter description

.PARAMETER salt
Parameter description

.PARAMETER text
Parameter description

.EXAMPLE
Get-AesEncrypted -pass "7B801AA7-1EBA-4672-8849-7E6B977043B8" -salt "Ivan Medvedev" -text $text
.NOTES
General notes
#>
function Get-AesEncrypted () {
  Param(
    [parameter(mandatory = $true)][string]$pass,
    [parameter(mandatory = $true)][string]$salt,
    [parameter(mandatory = $true)][string]$text
  )
  $saltBytes = get-bytes $salt
  $passDerive = New-Object Security.Cryptography.Rfc2898DeriveBytes -ArgumentList @($pass, $saltBytes)
  
  $key = $passDerive.GetBytes(32)
  $IV = $passDerive.GetBytes(16)
  
  $cipher = [Security.Cryptography.SymmetricAlgorithm]::Create('AesManaged')
  $cipher.Mode = [Security.Cryptography.CipherMode]::CBC
  
  $encryptor = $cipher.CreateEncryptor($key, $IV)
  $memoryStream = New-Object -TypeName IO.MemoryStream
  
  $cryptoStream = New-Object -TypeName Security.Cryptography.CryptoStream -ArgumentList @( $memoryStream, $encryptor, [System.Security.Cryptography.CryptoStreamMode]::Write)
  
  $strBytes = (Get-Bytes $text)
  
  $cryptoStream.Write($strBytes, 0, $strBytes.Length)
  $cryptoStream.FlushFinalBlock()
  $encryptedBytes = $memoryStream.ToArray()

  # Base64 Encode the encrypted bytes to get a string
  $encryptedString = [Convert]::ToBase64String($encryptedBytes)
  
  echo $encryptedString
}

<#
.SYNOPSIS
Short description

.DESCRIPTION
Long description

.PARAMETER text
Parameter description

.EXAMPLE
 Get-QrLink -Text "lorem ipsum"

.NOTES
General notes
#>
function Get-QrLink () {
  Param(
    [parameter(mandatory = $true)][string]$text
  )
  $result = "https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=${text}"
  Write-Output $result
}


