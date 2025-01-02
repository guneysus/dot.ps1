function Open-Solutions {
    Get-ChildItem *.sln | ForEach-Object { . $_.FullName }    
}
function Start-Project {
    [CmdletBinding()]
    param (
        [Parameter()] [switch] $Build,
        [Parameter()] [switch] $Restore
    )
    if($Build -or $Restore) {
        # TODO
        Throw "Not Implemented"
    }
    Get-ChildItem **/*Host.csproj -Recurse | ForEach-Object { dotnet run --project $_.FullName --no-build --no-restore }
}

function Set-GitLocalPersonalEmail {
  git config --local user.email "949232+guneysus@users.noreply.github.com"
  git config --local user.name "Ahmed Guneysu"
}

function Edit-GitGlobalConfig {
    git config --global --edit
}
function Edit-GitLocalConfig {
    git config --local --edit
}