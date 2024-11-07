function Set-ScreenResolution {
    <# 
    .SYNOPSIS 
        Sets the Screen Resolution of the primary monitor 
    .DESCRIPTION 
        Uses Pinvoke and ChangeDisplaySettings Win32API to make the change 
    .PARAMETER Width
        The width of the screen resolution.
    .PARAMETER Height
        The height of the screen resolution.
    .EXAMPLE 
        Set-ScreenResolution -Width 3840 -Height 2160         
    #> 
    param (
        [Parameter(Mandatory=$true, Position = 0)]
        [int] $Width,
        
        [Parameter(Mandatory=$true, Position = 1)]
        [int] $Height
    )
    
    $pinvokeCode = @"
    using System;
    using System.Runtime.InteropServices;
    namespace Resolution
    {
        [StructLayout(LayoutKind.Sequential)]
        public struct DEVMODE1
        {
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
            public string dmDeviceName;
            public short dmSpecVersion;
            public short dmDriverVersion;
            public short dmSize;
            public short dmDriverExtra;
            public int dmFields;
            public short dmOrientation;
            public short dmPaperSize;
            public short dmPaperLength;
            public short dmPaperWidth;
            public short dmScale;
            public short dmCopies;
            public short dmDefaultSource;
            public short dmPrintQuality;
            public short dmColor;
            public short dmDuplex;
            public short dmYResolution;
            public short dmTTOption;
            public short dmCollate;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
            public string dmFormName;
            public short dmLogPixels;
            public short dmBitsPerPel;
            public int dmPelsWidth;
            public int dmPelsHeight;
            public int dmDisplayFlags;
            public int dmDisplayFrequency;
            public int dmICMMethod;
            public int dmICMIntent;
            public int dmMediaType;
            public int dmDitherType;
            public int dmReserved1;
            public int dmReserved2;
            public int dmPanningWidth;
            public int dmPanningHeight;
        };
        
        class User_32
        {
            [DllImport("user32.dll")]
            public static extern int EnumDisplaySettings(string deviceName, int modeNum, ref DEVMODE1 devMode);
            [DllImport("user32.dll")]
            public static extern int ChangeDisplaySettings(ref DEVMODE1 devMode, int flags);
            public const int ENUM_CURRENT_SETTINGS = -1;
            public const int CDS_UPDATEREGISTRY = 0x01;
            public const int CDS_TEST = 0x02;
            public const int DISP_CHANGE_SUCCESSFUL = 0;
            public const int DISP_CHANGE_RESTART = 1;
            public const int DISP_CHANGE_FAILED = -1;
        }
        
        public class PrmaryScreenResolution
        {
            static public string ChangeResolution(int width, int height)
            {
                DEVMODE1 dm = GetDevMode1();
                if (0 != User_32.EnumDisplaySettings(null, User_32.ENUM_CURRENT_SETTINGS, ref dm))
                {
                    dm.dmPelsWidth = width;
                    dm.dmPelsHeight = height;
                    int iRet = User_32.ChangeDisplaySettings(ref dm, User_32.CDS_TEST);
                    if (iRet == User_32.DISP_CHANGE_FAILED)
                    {
                        return "Unable To Process Your Request. Sorry For This Inconvenience.";
                    }
                    else
                    {
                        iRet = User_32.ChangeDisplaySettings(ref dm, User_32.CDS_UPDATEREGISTRY);
                        switch (iRet)
                        {
                            case User_32.DISP_CHANGE_SUCCESSFUL:
                                return "Success";
                            case User_32.DISP_CHANGE_RESTART:
                                return "You Need To Reboot For The Change To Happen.\n If You Feel Any Problem After Rebooting Your Machine\nThen Try To Change Resolution In Safe Mode.";
                            default:
                                return "Failed To Change The Resolution";
                        }
                    }
                }
                else
                {
                    return "Failed To Change The Resolution.";
                }
            }
            
            private static DEVMODE1 GetDevMode1()
            {
                DEVMODE1 dm = new DEVMODE1();
                dm.dmDeviceName = new String(new char[32]);
                dm.dmFormName = new String(new char[32]);
                dm.dmSize = (short)Marshal.SizeOf(dm);
                return dm;
            }
        }
    }
"@
    Add-Type $pinvokeCode -ErrorAction SilentlyContinue
     [Resolution.PrmaryScreenResolution]::ChangeResolution($width, $height)
}

function Set-ScreenScaling {
    <#
    .SYNOPSIS
    Sets the display scaling.

    .DESCRIPTION
    Uses the SystemParametersInfo Win32API to change the display scaling.

    .PARAMETER Scaling
    The scaling factor to set. Valid values are:
    0 : 100% (default)
    1 : 125%
    2 : 150%
    3 : 175%

    .EXAMPLE
    Set-ScreenScaling -Scaling 2
    #>
    param($Scaling)
    $source = @'
    [DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
    public static extern bool SystemParametersInfo(
        uint uiAction,
        uint uiParam,
        uint pvParam,
        uint fWinIni);
'@
    $apicall = Add-Type -MemberDefinition $source -Name WinAPICall -Namespace SystemParamInfo -PassThru
    $apicall::SystemParametersInfo(0x009F, $Scaling, $null, 1) | Out-Null
}

function Set-ScreenRefreshRate {
    <#
    .SYNOPSIS
    Sets the screen refresh rate of the primary monitor.

    .DESCRIPTION
    Uses PInvoke and ChangeDisplaySettings Win32API to change the screen refresh rate.

    .PARAMETER Frequency
    The refresh rate of the screen.

    .EXAMPLE
    Set-ScreenRefreshRate -Frequency 60
    #>
    param ( 
        [Parameter(Mandatory=$true)] 
        [int] $Frequency
    ) 

    $pinvokeCode = @"         
        using System; 
        using System.Runtime.InteropServices; 
        
        namespace Display 
        { 
            [StructLayout(LayoutKind.Sequential)] 
            public struct DEVMODE1 
            { 
                [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)] 
                public string dmDeviceName; 
                public short dmSpecVersion; 
                public short dmDriverVersion; 
                public short dmSize; 
                public short dmDriverExtra; 
                public int dmFields; 
        
                public short dmOrientation; 
                public short dmPaperSize; 
                public short dmPaperLength; 
                public short dmPaperWidth; 
        
                public short dmScale; 
                public short dmCopies; 
                public short dmDefaultSource; 
                public short dmPrintQuality; 
                public short dmColor; 
                public short dmDuplex; 
                public short dmYResolution; 
                public short dmTTOption; 
                public short dmCollate; 
                [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)] 
                public string dmFormName; 
                public short dmLogPixels; 
                public short dmBitsPerPel; 
                public int dmPelsWidth; 
                public int dmPelsHeight; 
        
                public int dmDisplayFlags; 
                public int dmDisplayFrequency; 
        
                public int dmICMMethod; 
                public int dmICMIntent; 
                public int dmMediaType; 
                public int dmDitherType; 
                public int dmReserved1; 
                public int dmReserved2; 
        
                public int dmPanningWidth; 
                public int dmPanningHeight; 
            }; 
        
            class User_32 
            { 
                [DllImport("user32.dll")] 
                public static extern int EnumDisplaySettings(string deviceName, int modeNum, ref DEVMODE1 devMode); 
                [DllImport("user32.dll")] 
                public static extern int ChangeDisplaySettings(ref DEVMODE1 devMode, int flags); 
        
                public const int ENUM_CURRENT_SETTINGS = -1; 
                public const int CDS_UPDATEREGISTRY = 0x01; 
                public const int CDS_TEST = 0x02; 
                public const int DISP_CHANGE_SUCCESSFUL = 0; 
                public const int DISP_CHANGE_RESTART = 1; 
                public const int DISP_CHANGE_FAILED = -1; 
            } 
        
            public class PrimaryScreen  
            { 
                static public string ChangeRefreshRate(int frequency) 
                { 
                    DEVMODE1 dm = GetDevMode1(); 
        
                    if (0 != User_32.EnumDisplaySettings(null, User_32.ENUM_CURRENT_SETTINGS, ref dm)) 
                    { 
                        dm.dmDisplayFrequency = frequency;
        
                        int iRet = User_32.ChangeDisplaySettings(ref dm, User_32.CDS_TEST); 
        
                        if (iRet == User_32.DISP_CHANGE_FAILED) 
                        { 
                            return "Unable to process your request. Sorry for this inconvenience."; 
                        } 
                        else 
                        { 
                            iRet = User_32.ChangeDisplaySettings(ref dm, User_32.CDS_UPDATEREGISTRY); 
                            switch (iRet) 
                            { 
                                case User_32.DISP_CHANGE_SUCCESSFUL: 
                                    return "Success"; 
                                case User_32.DISP_CHANGE_RESTART: 
                                    return "You need to reboot for the change to happen.\n If you feel any problems after rebooting your machine\nThen try to change resolution in Safe Mode."; 
                                default: 
                                    return "Failed to change the resolution"; 
                            } 
                        } 
                    } 
                    else 
                    { 
                        return "Failed to change the resolution."; 
                    } 
                } 
        
                private static DEVMODE1 GetDevMode1() 
                { 
                    DEVMODE1 dm = new DEVMODE1(); 
                    dm.dmDeviceName = new String(new char[32]); 
                    dm.dmFormName = new String(new char[32]); 
                    dm.dmSize = (short)Marshal.SizeOf(dm); 
                    return dm; 
                } 
            } 
        } 
"@

    Add-Type $pinvokeCode -ErrorAction SilentlyContinue

    [Display.PrimaryScreen]::ChangeRefreshRate($frequency) 
}

function Set-DisplaySwitch {
    <#
    .SYNOPSIS
    Sets the display mode.

    .DESCRIPTION
    Uses DisplaySwitch.exe to change the display mode.

    .PARAMETER mode
    The display mode to set. Valid values are:
    "internal" : Use internal display only.
    "external" : Use external display only.
    "clone"    : Duplicate the display on both internal and external displays.
    "extend"   : Extend the display across both internal and external displays.

    .EXAMPLE
    Set-DisplaySwitch -Mode "external"
    #>
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet("internal", "external", "clone", "extend")]
        [string] $Mode
    )
    
    switch ($Mode) {
        "internal" { DisplaySwitch.exe /internal }
        "external" { DisplaySwitch.exe /external }
        "clone"    { DisplaySwitch.exe /clone }
        "extend"   { DisplaySwitch.exe /extend }
    }
}

Set-DisplaySwitch -Mode "external"
Set-ScreenResolution -Width 1920 -Height 1080
Set-ScreenRefreshRate -Frequency 60
Set-ScreenScaling -Scaling 2

Start-Sleep -Seconds 10
Set-DisplaySwitch -Mode "internal"
Set-ScreenResolution -Width 2560 -Height 1440
Set-ScreenRefreshRate -Frequency 144
Set-ScreenScaling -Scaling 0