Import-Module PowerShellGet
Register-PSRepository -Name "guneysu" -SourceLocation "https://www.myget.org/F/guneysu/api/v2"
Install-Module -Name "EtxHelpers" -RequiredVersion "0.0.2" -Repository "guneysu" 


Publish-Module -Path .\EtxBuild -Repository guneysu -NuGetApiKey $env:MYGET_SECRET
Publish-Module -Path .\DotnetHelpers -Repository guneysu -NuGetApiKey $env:MYGET_SECRET

Publish-Module -Path .\PsToolkit -Repository guneysu -NuGetApiKey $env:MYGET_SECRET