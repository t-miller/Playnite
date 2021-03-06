﻿$global:NugetUrl = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"

function global:StartAndWait()
{
    param(
        [string]$Path,
        [string]$Arguments,
        [string]$WorkingDir
    )

    if ($WorkingDir)
    {
        $proc = Start-Process $Path $Arguments -PassThru -NoNewWindow -WorkingDirectory $WorkingDir
    }
    else
    { 
        $proc = Start-Process $Path $Arguments -PassThru -NoNewWindow
    }

    $handle = $proc.Handle # cache proc.Handle http://stackoverflow.com/a/23797762/1479211
    $proc.WaitForExit()
    return $proc.ExitCode
}

function global:SignFile()
{
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Path        
    )

    process
    {
        Write-Host "Signing file `"$Path`"" -ForegroundColor Green
        $signToolPath = "c:\Program Files (x86)\Windows Kits\10\bin\10.0.16299.0\x86\signtool.exe"
        $res = StartAndWait $signToolPath ('sign /n "Open Source Developer, Josef Němec" /t http://time.certum.pl /v ' + "`"$Path`"")
        if ($res -ne 0)
        {        
            throw "Failed to sign file."
        }
    }
}

function global:New-Folder()
{
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Path        
    )

    if (Test-Path $Path)
    {
        return
    }

    mkdir $Path | Out-Null
}

function global:New-EmptyFolder()
{
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Path        
    )

    if (Test-Path $Path)
    {
        Remove-Item $Path -Recurse -Force
    }

    mkdir $Path | Out-Null
}

function global:Write-OperationLog()
{
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Message
    )

    Write-Host $Message -ForegroundColor Green
}

function global:Write-ErrorLog()
{
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Message
    )

    Write-Host $Message -ForegroundColor Red -BackgroundColor Black
}


function global:Write-WarningLog()
{
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Message
    )

    Write-Host $Message -ForegroundColor Yellow
}

function global:Write-InfoLog()
{
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Message
    )

    Write-Host $Message -ForegroundColor White
}

function global:Write-DebugLog()
{
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Message
    )

    Write-Host $Message -ForegroundColor DarkGray
}