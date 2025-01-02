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