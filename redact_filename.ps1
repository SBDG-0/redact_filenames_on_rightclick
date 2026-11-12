#requires -Version 5.1
<# Renames only the supplied items. Supports -WhatIf for a preview. #>
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true,
        ValueFromPipelineByPropertyName = $true)]
    [Alias('FullName')]
    [string[]] $LiteralPath,
    [switch] $PauseOnError
)
begin {
    $failed = $false
    $categories = @('!$%&', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz', '0123456789')
    $alphabet = ($categories -join '').ToCharArray()
    $random = [System.Random]::new()
    if ($PauseOnError) {
        Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public static class RedactConsole {
    [DllImport("kernel32.dll")] public static extern IntPtr GetConsoleWindow();
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr window, int command);
}
'@
    }
    $seen = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
}
process {
    foreach ($path in $LiteralPath) {
        try {
            $item = Get-Item -LiteralPath $path -Force -ErrorAction Stop
            if ($item.PSProvider.Name -ne 'FileSystem') { throw 'Only filesystem items are supported.' }
            if (-not $seen.Add($item.FullName)) { continue }
            $parent = Split-Path -LiteralPath $item.FullName -ErrorAction Stop
            if ([string]::IsNullOrEmpty($parent) -or $item.FullName -eq $item.PSDrive.Root) {
                throw 'Drive roots cannot be renamed.'
            }
            # A folder's dots are part of its name, not an extension.
            $extension = if ($item.PSIsContainer) { '' } else { $item.Extension }
            $renamed = $false
            for ($attempt = 0; $attempt -lt 20; $attempt++) {
                $length = $random.Next(12, 15)
                $characters = [char[]]::new($length)
                for ($i = 0; $i -lt $categories.Count; $i++) {
                    $characters[$i] = $categories[$i][$random.Next($categories[$i].Length)]
                }
                for ($i = $categories.Count; $i -lt $length; $i++) {
                    $characters[$i] = $alphabet[$random.Next($alphabet.Length)]
                }
                for ($i = $length - 1; $i -gt 0; $i--) {
                    $j = $random.Next($i + 1)
                    $temporary = $characters[$i]
                    $characters[$i] = $characters[$j]
                    $characters[$j] = $temporary
                }
                $name = (-join $characters) + $extension
                $destination = Join-Path -Path $parent -ChildPath $name
                if (Test-Path -LiteralPath $destination -ErrorAction Stop) { continue }
                if (-not $PSCmdlet.ShouldProcess($item.FullName, "Rename to $name")) { break }
                try {
                    # No -Force: an existing destination must never be overwritten.
                    Rename-Item -LiteralPath $item.FullName -NewName $name -ErrorAction Stop
                    $renamed = $true
                    [pscustomobject]@{ OriginalPath = $item.FullName; NewPath = $destination }
                    break
                }
                catch {
                    # Retry a collision that appeared between the check and the rename.
                    if (Test-Path -LiteralPath $destination) { continue }
                    throw
                }
            }
            if (-not $renamed -and $attempt -ge 20) { throw 'Could not find an unused filename after 20 attempts.' }
        }
        catch {
            $failed = $true
            Write-Error -Message ("Cannot rename '{0}': {1}" -f $path, $_.Exception.Message) -ErrorAction Continue
        }
    }
}
end {
    if ($failed) {
        if ($PauseOnError) {
            [RedactConsole]::ShowWindow([RedactConsole]::GetConsoleWindow(), 5) | Out-Null
            Write-Host 'Press any key to close'
            $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
        }
        exit 1
    }
}
