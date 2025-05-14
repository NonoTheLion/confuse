# -------------------- REMETTRE LA LANGUE EN FRANÇAIS --------------------
$LanguageTag = "fr-FR"
$UserLanguageList = Get-WinUserLanguageList
$UserLanguageList.Add($LanguageTag)
Set-WinUserLanguageList $UserLanguageList -Force
Set-WinUILanguageOverride -Language $LanguageTag
Set-WinUserLanguageList $LanguageTag -Force
Set-WinSystemLocale $LanguageTag
Set-Culture $LanguageTag

# -------------------- DÉSACTIVER LE NARRATEUR --------------------
Get-Process -Name "Narrator" -ErrorAction SilentlyContinue | Stop-Process -Force

# -------------------- RÉTABLIR LE FOND D'ÉCRAN PAR DÉFAUT --------------------
$DefaultWallpaperPath = "C:\Windows\Web\Wallpaper\Windows\img0.jpg"  # Chemin du fond d'écran par défaut
Add-Type -TypeDefinition @"
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
[Wallpaper]::SystemParametersInfo(20, 0, $DefaultWallpaperPath, 3)

# -------------------- RÉTABLIR LE CURSEUR PAR DÉFAUT --------------------
Set-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name "Arrow" -Value "C:\Windows\Cursors\aero_arrow.cur"  # Curseur par défaut

# Forcer l'application immédiate
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class NativeMethods {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

# SPI_SETCURSORS = 0x0057
# SPIF_SENDCHANGE = 0x02
[void][NativeMethods]::SystemParametersInfo(0x57, 0, $null, 0x02)

# -------------------- FIN --------------------
Write-Host "Les paramètres ont été rétablis à leurs valeurs par défaut !"