Import-Module PowerShellGet
Register-PSRepository -Name "guneysu" -SourceLocation "https://www.myget.org/F/guneysu/api/v2"
Install-Module -Name "EtxBuild" -RequiredVersion "0.0.2" -Repository "guneysu" 

Publish-Module -Path .\PsDotnetHelpers -Repository guneysu -NuGetApiKey $env:MYGET_SECRET