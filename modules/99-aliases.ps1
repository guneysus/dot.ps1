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

Function ack () {
    perl "$HOME\scoop\apps\ack\current\ack-single-file" `
        --ignore-dir=bin `
        --ignore-dir=obj $args
}
  

Function Invoke-UUID { [Alias('uuid')]param() [guid]::newguid().Guid }

Function Invoke-Export  {[Alias('export')]param() Get-ChildItem env: }
