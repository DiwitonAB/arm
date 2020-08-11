#>  
  <# 
  .SYNOPSIS 
    Change regional settings 
    Version: 1.0
	Author: Anders Gidlund (anders.gidlund@diwiton.se)
  .DESCRIPTION 
    This script downloads an XML file from a storage account blob and changes the regional settings (locale, input language and formats) on a Azure virtual machine. The script is inteded to be used with the Custom Script Execution (CSE) extension in an Azure ARM Template. 
 #> 
	
# Where to download and where to store the XML settings file.
$RegionFileURL = "https://diwitonshellstorage01.blob.core.windows.net/cse/region/sweden.xml"
$RegionFileLoc = "D:\sweden.xml"


# Downloading the XML  settings file.
$Webclient = New-Object System.Net.WebClient
$Webclient.DownloadFile($RegionFileURL,$RegionFileLoc)


# Running the internationalization control panel snap-in and supplies the XML settings file.
# This is to update everything for future users.
& $env:SystemRoot\System32\control.exe "intl.cpl,,/f:`"$RegionFileLoc`""

# Also setting the regional settings with Powershell cmdlets to update the current user context.
# This is not needed per se, as it can be resolved by logging off and logging on again.
Set-WinSystemLocale sv-SE
Set-WinUserLanguageList -LanguageList sv-SE, en-US -Force
Set-Culture -CultureInfo sv-SE
Set-WinHomeLocation -GeoId 221
Set-TimeZone -Id "W. Europe Standard Time"