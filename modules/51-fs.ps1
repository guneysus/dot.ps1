function Remove-ZeroByteFiles {
    Get-ChildItem *.md -Recurse | `
        Where-Object { $_.Length -eq 0 } | `
        ForEach-Object { Remove-Item $_ }
}