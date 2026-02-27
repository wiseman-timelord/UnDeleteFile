# UnDeleteFile
Status: Planning (Pre-Alpha)

### Description
This will be a program inspired from the following prompt...
- This is a basic windows 10 file undelete program with text UI. The user must provide, Source Path and File Names and Output Path, then run the undelete. It will be no-frills, but hopefully functional and working. I made this after I realise most undelete program has pre-set extensions to search for, and this does not cover newer extensions, such as `*.gguf`.

### Preview
- The program...
```
===============================================================================
    UnDeleteFile
===============================================================================








    1. Set Full Path: G:\Some Folder

    2. Set File Name(s): SomeFile1.Ext, SomeFile2.Ext

    3. Set Destination: E:\Undelete

    4. Set Recovery Mode: regular (Fastest for Recent Deletes)








-------------------------------------------------------------------------------
Selection; Menu Option 1-4, Run Recovery=R, Exit Program=X::

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

 [3/3] Creating configuration.json...
  Result: SUCCESS
  configuration.json created at: C:\Program_Files\UnDeleteFile\configuration.json

Press Enter to return to Menu:

```

### Notation
- This "Extension filter: *" confirms that the tool is not doing a global extension search (like "find all .jpg files"). Instead, it is relying on the specific filenames listed above. The * means it isn't restricting the search by extension separately; it is matching the full name provided in the Filter line.

```
