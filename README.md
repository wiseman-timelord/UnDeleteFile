# UnDeleteFile
Status: Planning (Pre-Alpha)

### Description
This will be a program inspired from the following prompt...
```
I just deleted Qwen 3.5 35B A4B Heretic GGUF, with file names "Qwen3.5-35B-A3B-heretic-Q4_K_M.gguf" and "Qwen3.5-35B-A3B-heretic-Q8_0.gguf", here is where I deleted it from G:\LargeModels\Agentic_Models\Qwen3.5-35B-A3B-heretic-GGUF. I need a script for windows 10 that will undelete the two files to "E:\Undelete". i have Windows 10, with, powershell 5.1 + Powershell 7.x. I will put the script in "E:\Undelete" and run it as admin. It will need a batch that DP0 at the start. They are not in the recycle bin.
```

### Preview
- The program...
```
===============================================================================
    UnDeleteFile
===============================================================================








    1. Set Full Path: G:\Some Folder

    2. Set File Name(s): SomeFile1.Ext, SomeFile2.Ext

    3. Set Destination: E:\Some Folder








----------------------------------------------------------------------------------------------------------------------------------------------------------------
Selection; Menu Options = 1-3, Run Recovery = R, Exit Program = X:

```
- The installer...
```
===============================================================================
   UnDeleteFile - Package Installer
===============================================================================

 [1/2] Checking for winget...
 [2/2] Verifying/Installing Windows File Recovery...


 -------------------------------------------------------------------------------
  INSTALLATION PROCESS FINISHED
 -------------------------------------------------------------------------------
  Result: ALREADY INSTALLED
  Windows File Recovery is already up-to-date on this system.

Press Enter to return to Menu:

```

### Notation
- This "Extension filter: *" confirms that the tool is not doing a global extension search (like "find all .jpg files"). Instead, it is relying on the specific filenames listed above. The * means it isn't restricting the search by extension separately; it is matching the full name provided in the Filter line.

```
