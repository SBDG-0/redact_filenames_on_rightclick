#requires -Version 5.1
[CmdletBinding(SupportsShouldProcess = $true)]
param()
$ErrorActionPreference = 'Stop'

try {
    $keyPath = 'Software\Classes\AllFilesystemObjects\shell\redact_filename.ps1'
    if ($PSCmdlet.ShouldProcess('HKCU\' + $keyPath, 'Remove Anonymize name menu')) {
        # false makes repeated removal harmless. Only this project's verb is removed.
        [Microsoft.Win32.Registry]::CurrentUser.DeleteSubKeyTree($keyPath, $false)
        Write-Host 'Anonymize name context-menu entry removed. (or already absent).'
    }
    Read-Host 'Press Enter to close' | Out-Null
}
catch {
    Write-Host $_.Exception.Message -ForegroundColor Red
    Read-Host 'Press Enter to close' | Out-Null
    exit 1
}
