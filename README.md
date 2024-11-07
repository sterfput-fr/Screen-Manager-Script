# Screen Manager Script

## Overview
Screen Manager Script is a PowerShell script designed to manage screen settings such as resolution, scaling, refresh rate, and display mode on Windows systems. It uses PInvoke and Win32API calls to make these changes.

**Note: This script is a preliminary version for a screen management script for Sunshine.**

## Features
* Set screen resolution
* Set screen scaling
* Set screen refresh rate
* Switch display modes

## Usage
To use the functions provided by the script, you can call them with the appropriate parameters in PowerShell.

### Set-ScreenResolution
Sets the main screen resolution of the primary monitor.
```powershell
Set-ScreenResolution -Width 1920 -Height 1080
```
* -Width: The width of the screen resolution.
* -Height: The height of the screen resolution.

### Set-ScreenScaling
Sets the main screen display scaling.
```powershell
Set-ScreenScaling -Scaling 2
```
* -Scaling: The scaling factor to set. Valid values are:
    * 0 : 100% (default)
    * 1 : 125%
    * 2 : 150%
    * 3 : 175%

### Set-ScreenRefreshRate
Sets the main screen refresh rate of the primary monitor.
```powershell
Set-ScreenRefreshRate -Frequency 60
```
* -Frequency: The refresh rate frequency in Hertz (Hz).

### Set-DisplaySwitch
Sets the display mode.
```powershell
Set-DisplaySwitch -Mode "external"
```
* -Mode: The display mode to set. Valid values are:
    * "internal" : Use the internal display only
    * "clone" : Duplicate the display on both internal and external screens
    * "extend" : Extend the display across both internal and external screens
    * "external" : Use the external display only

## Contributions
Contributions are welcome!