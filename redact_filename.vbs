Option Explicit
Dim shell, files, scriptPath, engine, command, item
Set shell = CreateObject("WScript.Shell")
Set files = CreateObject("Scripting.FileSystemObject")
scriptPath = files.BuildPath(files.GetParentFolderName(WScript.ScriptFullName), "redact_filename.ps1")
If Not files.FileExists(scriptPath) Then
    MsgBox "Missing script: " & scriptPath, vbCritical, "Anonymize name"
    WScript.Quit 1
End If
If WScript.Arguments.Count = 0 Then WScript.Quit 0
engine = shell.ExpandEnvironmentStrings("%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe")
For Each item In WScript.Arguments
    command = Quote(engine) & " -NoProfile -ExecutionPolicy Bypass -File " & Quote(scriptPath) & " -PauseOnError -LiteralPath " & Quote(item)
    ' Start hidden from the outset; PowerShell restores its console on an error.
    shell.Run command, 0, False
Next
Function Quote(value)
    Quote = Chr(34) & value & Chr(34)
End Function
