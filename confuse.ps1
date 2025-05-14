# -------------------- CRÉER LE DOSSIER DANS LES DOCUMENTS DE L'UTILISATEUR --------------------
$UserDocumentsPath = [Environment]::GetFolderPath('MyDocuments')
$FolderPath = "$UserDocumentsPath\confused"

if (-not (Test-Path -Path $FolderPath)) {
    New-Item -ItemType Directory -Path $FolderPath
}

# -------------------- TÉLÉCHARGER L'IMAGE --------------------
$ImageUrl = "https://wallpaperaccess.com/download/shrek-pc-2291206"  # Remplace par l'URL de l'image que tu veux télécharger
$ImagePath = "$FolderPath\wallpaper.jpg"

Invoke-WebRequest -Uri $ImageUrl -OutFile $ImagePath

# -------------------- TÉLÉCHARGER LE CURSEUR --------------------
$CursorUrl = "https://www.rw-designer.com/cursor-download.php?id=96363"  # Remplace par l'URL de ton fichier curseur
$CursorPath = "$FolderPath\cursor.cur"

Invoke-WebRequest -Uri $CursorUrl -OutFile $CursorPath

# -------------------- CHANGER LA LANGUE EN HÉBREU --------------------
$LanguageTag = "he-IL"
$UserLanguageList = Get-WinUserLanguageList
$UserLanguageList.Add($LanguageTag)
Set-WinUserLanguageList $UserLanguageList -Force
Set-WinUILanguageOverride -Language $LanguageTag
Set-WinUserLanguageList $LanguageTag -Force
Set-WinSystemLocale $LanguageTag
Set-Culture $LanguageTag
Set-WinHomeLocation -GeoId 105  # 105 = Israël

# -------------------- ACTIVER LE NARRATEUR --------------------
start ms-settings:easeofaccess-narrator

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

# -------------------- FIN --------------------
Write-Host "La configuration est terminée ! Vous êtes maintenant complètement 'confus' !"
