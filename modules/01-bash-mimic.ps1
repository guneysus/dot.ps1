Function Invoke-XArgs () {
    [Alias("xargs")]
    param(  
        [Parameter(
            Position = 0, 
            Mandatory = $true, 
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)
        ]
        [String[]]$args,
  
        [Parameter(Mandatory = $true)]
        [String]$Command
    )
  
    process {
      
        write-debug $($args -join ';')
  
        foreach ($arg in $args) {
            Invoke-Expression "$Command".Replace("{}", $arg)
            write-debug "$Command".Replace("{}", $arg)
            Write-Output "$Command".Replace("{}", $arg)
        }
    }
}

Function Invoke-Export { [Alias('export')]param() Get-ChildItem env: }

Function Get-DirectoryList {
    [Alias('lsd')]param()
    Get-ChildItem -Directory
  }