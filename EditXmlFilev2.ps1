[CmdletBinding()]
 
Param (
    [Parameter(Mandatory = $true)][string]$filePaths,
    [Parameter(Mandatory = $true)][String]$replaceStrings,
    [ValidateSet('True', 'False')]
    [Parameter(Mandatory = $true)][String]$deleteAnalyticsFolder,
    [ValidateSet('True', 'False')]
    [Parameter(Mandatory = $true)][String]$renameZvooveShortcuts,
    [ValidateSet('True', 'False')]
    [Parameter(Mandatory = $true)][String]$createDmcShortcut,
    [Parameter(Mandatory = $true)][String]$environment
)

$filePathsArray = $filePaths -split ','
$replaceStringsArray = $replaceStrings -split ','

for ($i=0; $i -lt $filePathsArray.Length; $i++) {
    $filePath = $filePathsArray[$i]
    $replaceString = $replaceStringsArray[$i]

    Write-Output "Replacing all content in file $filePath with $replaceString"

    $content = Get-Content -Path $filePath

    Write-Output "Old content: $content"

    Set-Content -Path $filePath -Value $replaceString
	
	$updatedContent = Get-Content -Path $filePath
    Write-Output "New content: $updatedContent"

    if ($updatedContent -eq $replaceString) {
        Write-Output "The content has been replaced successfully!"
    } else {
        Write-Output "Failed to replace the content."
    }
}

if($deleteAnalyticsFolder -eq 'True'){
    if(Test-Path -Path "C:\Program Files\Zvoove\Analytics"){
        Remove-Item -Path "C:\Program Files\Zvoove\Analytics" -Recurse -Force
    }
}

if($renameZvooveShortcuts -eq 'True'){
    if(Test-Path 'C:\Users\Public\Desktop\AERO_zvoove_test.lnk'){
        if ($environment -eq 'prd') {
            Rename-Item -Path 'C:\Users\Public\Desktop\AERO_zvoove_test.lnk' -NewName 'AERO_zvoove_prd.lnk'
        }
        if ($environment -eq 'stg') {
            Rename-Item -Path 'C:\Users\Public\Desktop\AERO_zvoove_test.lnk' -NewName 'AERO_zvoove_Schulungsumgebung.lnk'
        } 
    }
    if(Test-Path 'C:\Users\Public\Desktop\TPPM_zvoove_test.lnk'){
        if ($environment -eq 'prd') {
            Rename-Item -Path 'C:\Users\Public\Desktop\TPPM_zvoove_test.lnk' -NewName 'TPPM_zvoove_prd.lnk'
        }
        if ($environment -eq 'stg') {
            Rename-Item -Path 'C:\Users\Public\Desktop\TPPM_zvoove_test.lnk' -NewName 'TPPM_zvoove_Schulungsumgebung.lnk'
        } 
    }
    
}

if($createDmcShortcut -eq 'True'){
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("C:\Users\Public\Desktop\DirectMC4.lnk")
    $Shortcut.TargetPath = "\\tpdmcprddb01.hohr.com\directMC4\PRG\MCCWIN\PRG\loader33u.exe"
    $Shortcut.Save()    
}
