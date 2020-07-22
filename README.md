# computercraft_scripts
A collection of scripts I've wrote or edited for ComputerCraft.

## update.lua
This script is my first completed lua script and handles all my current and future scripts. Update will download the newest version of the script on the branch of your choice. This was mainly a test in how to validate user data through the CLI arguments. Below are the usage parameters.

```
Usage:
update <options> <param>
Options/flags:
-a --all : Updates all scripts.
-v --version : Prints update's version.
-b --branch <branch-name>
-s --script <script1,script2>
```
### Examples uses:
#### Update all default scripts as denoted in the settings table.
```update -a```

#### Update the script called "test-script", using the "dev" branch.
```update --script test-script -b dev```