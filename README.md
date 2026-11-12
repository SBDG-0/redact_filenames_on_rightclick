# Redact filenames on right-click

Windows PowerShell 5.1+ script that renames selected files or folders to random 12-14 character names. Each name includes an uppercase letter, a lowercase letter, a number, and a symbol from `! $ % &`.
- The context-menu PowerShell window stays hidden unless an error occurs; press any key to close it after an error.
- File extensions and contents are preserved. 
- Folder contents are not renamed.

## Installation

Keep all scripts and `icon.ico` together in a permanent folder.

Run in PowerShell:

```powershell
& '.\redact add to right click menu.ps1'
```

## How to use
Right-click a file or folder and choose **Anonymize name** (Windows 11: **Show more options**).


Installation applies to the current user; administrator access is not required. </br> Re-run the installer if you move the folder.
### Previewing
Preview a rename without changing anything:

```powershell
& '.\redact_filename.ps1' -LiteralPath 'C:\path\file.txt' -WhatIf
```
## Uninstall
To remove / uninstall the context-menu entry:

```powershell
& '.\redact remove from right click menu.ps1'
```

Renaming does not remove file metadata or redact file contents. </br> Original names are not saved for undo.

<br />

---
This software is provided "as is", without warranty of any kind. 
<br />  It is free to use, modify, and distribute. 

---
made with ❤️ by SavageBulldogOG

The context menu uses `redact_filename.vbs` to launch PowerShell without a flashing window. On a rename error, the console opens with details. Keep the launcher beside the scripts and rerun the installer after updating.
