[CmdletBinding()]
 
Param (
    [Parameter(Mandatory = $true)][string]$filePaths,
    [Parameter(Mandatory = $true)][String]$replaceStrings,
    [Parameter(Mandatory = $true)][String]$findStrings,
    [ValidateSet('True', 'False')]
    [Parameter(Mandatory = $true)][String]$deleteAnalyticsFolder,
    [ValidateSet('True', 'False')]
    [Parameter(Mandatory = $true)][String]$renameZvooveShortcuts,
    [Parameter(Mandatory = $true)][String]$environment
)

$filePathsArray = $filePaths -split ','
$replaceStringsArray = $replaceStrings -split ','
$findStringsArray = $findStrings -split ','

for ($i=0; $i -lt $filePathsArray.Length; $i++) {
    $filePath = $filePathsArray[$i]
    $replaceString = $replaceStringsArray[$i]
    $findString = $findStringsArray[$i]

    Write-Output "Replacing string $findString with $replaceString in file $filePath"

    $content = Get-Content -Path $filePath
    $newContent = $content.Replace($findString, $replaceString)

    Write-Output "Old content: $content"

    Write-Output "New content: $newContent"

    Set-Content -Path $filePath -Value $newContent

    $updatedContent = Get-Content -Path $filePath

    if ($updatedContent -like "*$findString*") {
        Write-Output "The old string is still found in the file."
    } else {
        Write-Output "The string has been replaced successfully!"
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
