# Redact Filenames on Right-Click

## Description

**Redact Filenames on Right-Click** adds an **Anonymize name** command to the Windows context menu. It renames selected files or folders to random names of 12–14 characters, including an uppercase letter, a lowercase letter, a number, and a symbol from `! $ % &`.

## Preview

<img src="https://github.com/user-attachments/assets/328affaf-fb04-44c1-802a-d767b40df852" alt="Anonymize name context-menu preview" width="900" />

## Features

- Preserve file extensions and contents.
- Rename a folder without renaming its contents.
- Preview a rename with PowerShell's `-WhatIf` option.
- Keep the context-menu PowerShell window hidden unless an error occurs.
- Install for the current user without administrator access.

## Requirements

- Windows with PowerShell 5.1 or newer.
- Windows Script Host with VBScript support for the hidden menu launcher.
- Keep all scripts and `icon.ico` together in a permanent folder.

## Installation

Open PowerShell in the folder containing the scripts and run:

```powershell
& '.\redact add to right click menu.ps1'
```

The installer adds the context-menu entry for the current user. Re-run it if you move the folder or update the launcher.

## Usage

Right-click a file or folder and choose **Anonymize name**. On Windows 11, open **Show more options** to find the command.

The context menu uses `redact_filename.vbs` to launch PowerShell without a flashing window. Keep the launcher beside the scripts. If a rename fails, a console opens with the error details; press any key to close it.

### Preview a rename

Use `-WhatIf` to see the proposed rename without changing anything:

```powershell
& '.\redact_filename.ps1' -LiteralPath 'C:\path\file.txt' -WhatIf
```

## Uninstallation

Run this command from the scripts folder to remove the context-menu entry:

```powershell
& '.\redact remove from right click menu.ps1'
```

## Limitations

Renaming does not remove file metadata or redact file contents. Original names are not saved for undo.

---

## Reuse

This software is provided “as is”, without warranty of any kind. You may use, modify, and distribute it, provided you credit SavageBulldogOG and include a link to this repository.

[redact_filenames_on_rightclick](https://github.com/SBDG-0/redact_filenames_on_rightclick)

---

made with ❤️ by SavageBulldogOG
