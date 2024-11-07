# ScreenManagerScript

## Overview
ScreenManagerScript is a PowerShell script designed to manage screen settings such as resolution, scaling, refresh rate, and display mode on Windows systems. It uses PInvoke and Win32API calls to make these changes.

**Note: This script is a preliminary version for a screen management script for Sunshine.**

## Features
- Set screen resolution
- Set screen scaling
- Set screen refresh rate
- Switch display modes

## Prerequisites
- Windows operating system
- PowerShell

## Prerequisites
- Windows operating system
- PowerShell

## Usage
To use the functions provided by the script, you can call them with the appropriate parameters in PowerShell.

### Set-ScreenResolution
Sets the main screen resolution of the primary monitor.
```
Set-ScreenResolution -Width 1920 -Height 1080
```

## Set-ScreenScaling
Sets the main screen display scaling.
```
Set-ScreenScaling -scaling 2
```

## Set-ScreenRefreshRate
Sets the main screen refresh rate of the primary monitor.
```
Set-ScreenRefreshRate -Frequency 60
```

## Contributions
Contributions are welcome!