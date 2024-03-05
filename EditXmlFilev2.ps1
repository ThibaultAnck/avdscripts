[CmdletBinding()]
 
Param (
    [Parameter(Mandatory = $true)][string]$filePaths,
    [Parameter(Mandatory = $true)][String]$replaceStrings,
    [Parameter(Mandatory = $true)][String]$findStrings,
    [ValidateSet('True', 'False')]
    [Parameter(Mandatory = $true)][String]$deleteAnalyticsFolder
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
        Remove-Item -Path $path -Recurse -Force
    }
}
