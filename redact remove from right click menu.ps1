#requires -Version 5.1
[CmdletBinding(SupportsShouldProcess = $true)]
param()
$ErrorActionPreference = 'Stop'
$keyPath = 'Software\Classes\AllFilesystemObjects\shell\redact_filename.ps1'
if ($PSCmdlet.ShouldProcess('HKCU\' + $keyPath, 'Remove Anonymize name menu')) {
    # false makes repeated removal harmless. Only this project's verb is removed.
    [Microsoft.Win32.Registry]::CurrentUser.DeleteSubKeyTree($keyPath, $false)
    Write-Host 'Context-menu registration removed (or already absent).'
}
