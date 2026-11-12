#requires -Version 5.1
[CmdletBinding(SupportsShouldProcess = $true)]
param()
$ErrorActionPreference = 'Stop'
$target = Join-Path $PSScriptRoot 'redact_filename.vbs'
if (-not (Test-Path -LiteralPath $target -PathType Leaf)) { throw "Missing script: $target" }
$iconPath = Join-Path $PSScriptRoot 'icon.ico'
if (-not (Test-Path -LiteralPath $iconPath -PathType Leaf)) { throw "Missing icon: $iconPath. Place icon.ico beside the scripts before installing." }
$engine = Join-Path $env:SystemRoot 'System32\wscript.exe'
if (-not (Test-Path -LiteralPath $engine -PathType Leaf)) { throw 'Windows Script Host was not found.' }
# AllFilesystemObjects covers files, folders and mixed selections, without duplicate entries.
$keyPath = 'Software\Classes\AllFilesystemObjects\shell\redact_filename.ps1'
$command = '"{0}" "{1}" "%1"' -f $engine, $target
if ($PSCmdlet.ShouldProcess('HKCU\' + $keyPath, 'Install Anonymize name menu')) {
    $key = [Microsoft.Win32.Registry]::CurrentUser.CreateSubKey($keyPath)
    try {
        $key.SetValue('', 'Anonymize name')
        $key.SetValue('MultiSelectModel', 'Document')
        $key.SetValue('Icon', ('"{0}",0' -f $iconPath))
        $commandKey = $key.CreateSubKey('command')
        try { $commandKey.SetValue('', $command) } finally { $commandKey.Dispose() }
    }
    finally { $key.Dispose() }
    Write-Host 'Installed for the current user. Right-click a file or folder and choose Anonymize name.'
    Write-Host 'On Windows 11, look under Show more options. Keep the scripts in this folder.'
}
