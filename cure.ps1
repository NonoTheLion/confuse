# -------------------- REMETTRE LA LANGUE EN FRANÇAIS --------------------
$LanguageTag = "fr-FR"
Set-WinUserLanguageList $LanguageTag -Force
Set-WinUILanguageOverride -Language $LanguageTag
Set-WinSystemLocale $LanguageTag
Set-Culture $LanguageTag
Set-WinHomeLocation -GeoId 84  # 84 = France

# -------------------- DÉSACTIVER LE NARRATEUR --------------------
Stop-Process -Name "Narrator" -Force

# -------------------- RÉTABLIR LE FOND D'ÉCRAN PAR DÉFAUT --------------------
$DefaultWallpaperPath = "C:\Windows\Web\Wallpaper\Theme1\img1.jpg"  # Chemin du fond d'écran par défaut
Add-Type -TypeDefinition @"
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
[Wallpaper]::SystemParametersInfo(20, 0, $DefaultWallpaperPath, 3)

# -------------------- RÉTABLIR LE CURSEUR PAR DÉFAUT --------------------
Set-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name "Arrow" -Value "C:\Windows\Cursors\arrow_r.cur"  # Curseur par défaut
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters

# -------------------- FIN --------------------
Write-Host "Les paramètres ont été rétablis à leurs valeurs par défaut !"