function Open-Solutions {
    Get-ChildItem *.sln | ForEach-Object { . $_.FullName }    
}