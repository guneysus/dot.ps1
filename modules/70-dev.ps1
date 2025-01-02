function Open-Solutions {
    Get-ChildItem *.sln | ForEach-Object { . $_.FullName }    
}
function Start-Project {
    Get-ChildItem **/*Host.csproj -Recurse | ForEach-Object { dotnet run --project $_.FullName }
}