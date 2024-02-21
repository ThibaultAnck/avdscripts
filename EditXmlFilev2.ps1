[CmdletBinding()]
 
Param (
    [Parameter(Mandatory = $true)][string[]]$filePaths,
    [Parameter(Mandatory = $true)][String[]]$replaceStrings,
    [Parameter(Mandatory = $true)][String[]]$findStrings
)

for ($i=0; $i -lt $filePaths.Length; $i++) {
    $filePath = $filePaths[$i]
    $replaceString = $replaceStrings[$i]
    $findString = $findStrings[$i]

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
