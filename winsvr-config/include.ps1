####[Functions]
Function ExtractZipFile {
    Param (
    [parameter(Position=0,Mandatory=$true)][String]$zipFile,
    [parameter(Position=1,Mandatory=$true)][String]$destination
  )
<#
 .Synopsis
    Extract zip archive to destination folder

 .Description
    Extract zip archive with ExtractToDirectory method in System.IO.Compression.FileSystem.dll (.Net 4.5, includes Windows 2012 later).

 .Parameter zipFile
    [Required] The Zip archive name to extract.

 .Parameter destination
     [Required] The folder name to extract.

 .Example
     ExtractZipFile('archive.zip', 'C:\Users\someone\Desktop')
#>

  Begin {
    # Write-Host '<description of what is going on>...'
  }

  Process {
    Try {
        $child = $(Split-Path -Path $zipFile -Leaf) -Replace '\.zip$',''
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        if (!$(Test-Path -Path "$destination" -PathType Container)) {
            New-Item -Path "$destination" -ItemType Container
        } elseif ($(Test-Path -Path "$destination\$child" -PathType Container)) {
            Remove-Item -Recurse "$destination\$child"
        }
        $zip = Get-ChildItem $zipFile
        $dest = Get-Item $destination
        [System.IO.Compression.ZipFile]::ExtractToDirectory($zip, $dest)
    }

    Catch {
      Write-Host -BackgroundColor Red "Error: $($_.Exception)"
      Break
    }
  }

  End {
    #If ($?) {
      # Write-Host 'Completed Successfully.'
      # Write-Host ' '
    #}
  }
}
Function SelectIPv4Addr {
  Param ()
<#
 .Synopsis
    Retrieve IPv4 address list and select

 .Description
    Retrieve IPv4 address list without 127.0.0.1 via Get-NetIPAddress Cmdlet.
    If multiple addresses found, prompt and select.

 .Example
    $ip = SelectIPv4Addr
#>

  Begin {
  }

  Process {
    Try {
        $IPv4Addr = (Get-NetIPAddress -AddressFamily IPv4 | `
            Where-Object IPAddress -ne '127.0.0.1')
        if ($IPv4Addr.length -ge 2) {
            Write-Host "Multiple IPv4 Address has been found: $IPv4Addr"
            $ListenIPv4Addr = Read-Host -Prompt "Enter IPv4 Address " 
        } else {
            $ListenIPv4Addr = $IPv4Addr.IPaddress
        }
    }

    Catch {
      Write-Host -BackgroundColor Red "Error: $($_.Exception)"
      Break
    }
  }

  End {
    return $ListenIPv4Addr
  }
}
Function AddSystemPaths {
    Param (
      [parameter(Position=0,Mandatory=$true)][String[]]$Directories
    )
<#
 .Synopsis
    Add the folders to system environment 'Path'. If already set, will not modify.
    
 .Description
    Add the folders to system environment 'Path' which stores system registry.
    Furthremore updae environment 'Path' in current 'Process' scope.

 .Parameter Directories
    [Required] The folders to add to Path.

 .Example
    AddSystemPaths 'C:\bin'

 .Example
    AddSystemPaths -Directories 'C:\bin'

 .Example
    AddSystemPaths -Directories 'C:\bin','C:\usr\bin'
#>
    Begin {
        $SystemPath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    }
    
    Process {
        Try {
            ForEach ($Directory in $Directories) {
                $PathFound = $False
                $SystemPath -Split ';' | ForEach-Object { $PathFound = $_ -eq $Directory }
                if (!$PathFound) {
                    if ($SystemPath -match ';$') {
                        $NewPath = $SystemPath + "$Directory"
                    } else {
                        $NewPath = $SystemPath + ";$Directory"
                    }
                    [Environment]::SetEnvironmentVariable('Path', $NewPath, 'Machine')
                    [Environment]::SetEnvironmentVariable('Path', $NewPath, 'Process')
                }                    
            }
        }
    
        Catch {
            Write-Host -BackgroundColor Red "Error: $($_.Exception)"
            Break
        }
    }
    
    End {
        #If ($?) {
        #  Write-Host 'Completed Successfully.'
        #  Write-Host ' '
        #}
    }
        
}
Function SetSystemEnv {
    Param (
      [parameter(Position=0,Mandatory=$true)][String]$Name,
      [parameter(Position=1,Mandatory=$true)][String]$Value
    )
<#
 .Synopsis
     Set system environment variable. 

 .Description
    Set system environment provided parameter and value.
    Furthremore environment in current 'Process' scope.

 .Parameter Name
    [Required] The environment variable name.

 .Parameter Value
    [Required] The value to set the environment variable.

 .Example
    SetSystemEnv 'ENVNAME' 'ENVVAL'

 .Example
    SetSystemEnv -Name 'ENVNAME' -Value 'ENVVAL'

#>

    Begin {
    }
    
    Process {
        Try {
            [Environment]::SetEnvironmentVariable("$Name", "$Value", 'Machine')
            [Environment]::SetEnvironmentVariable("$Name", "$Value", 'Process')
        }
    
        Catch {
            Write-Host -BackgroundColor Red "Error: $($_.Exception)"
            Break
        }
    }
    
    End {
        #If ($?) {
        #  Write-Host 'Completed Successfully.'
        #  Write-Host ' '
        #}
    }
        
}
Function AddUserPaths {
    Param (
      [parameter(Position=0,Mandatory=$true)][String[]]$Directories
    )
<#
	#.Synopsis
	#	Add the folders to user environment 'Path'. If already set, will not modify.

 .Description
    Add the folders to system environment 'Path' which stores system registry.
    Furthremore updae environment 'Path' in current 'Process' scope.

 .Parameter Directories
    [Required] The folders to add to Path.

 .Example
    AddUserPaths 'C:\bin'

 .Example
    AddUserPaths -Directories 'C:\bin'

 .Example
    AddUserPaths -Directories 'C:\bin','C:\usr\bin'
#>
    Begin {
        $UserPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    }
    
    Process {
        Try {
            ForEach ($Directory in $Directories) {
                $PathFound = $False
                $UserPath -Split ';' | ForEach-Object { if (!$PathFound) { $PathFound = $_ -eq $Directory } }
                if (!$PathFound) {
                    if ($UserPath -match ';$') {
                        $NewPath = $UserPath + "$Directory"
                    } else {
                        $NewPath = $UserPath + ";$Directory"
                    }
                    [Environment]::SetEnvironmentVariable('Path', $NewPath, 'User')
                    $env:Path = $($env:Path,$NewPath -Join ';')
                }                    
            }
        }
    
        Catch {
            Write-Host -BackgroundColor Red "Error: $($_.Exception)"
            Break
        }
    }
    
    End {
        #If ($?) {
        #  Write-Host 'Completed Successfully.'
        #  Write-Host ' '
        #}
    }
        
}