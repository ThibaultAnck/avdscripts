[CmdletBinding()]
 
Param (
    [Parameter(Mandatory = $true)][string]$filePath,
    [Parameter(Mandatory = $true)][String]$replacestring,
    [Parameter(Mandatory = $true)][String]$findstring
)

Write-Output "Replacing string $findstring with $replacestring in file $filepath"

$content = Get-Content -Path $filePath
$newContent = $content.Replace($findstring, $replacestring)

Write-Output "Old content: $content"

Write-Output "New content: $newContent"

Set-Content -Path $filePath -Value $newContent

$updatedContent = Get-Content -Path $filePath

if ($updatedContent -like "*$findstring*") {
    Write-Output "The old string is still found in the file."
} else {
    Write-Output "The string has been replaced successfully!"
}


