$ProgressPreference = 'SilentlyContinue'

$userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36'

$page = Invoke-WebRequest -Uri 'https://www.fosshub.com/HWiNFO.html' -Method Get -UserAgent $userAgent
$settingsString = ''

foreach ($obj in $page.ParsedHtml.getElementsByTagName('script')) {
  if ($obj.innerText -ne $null) {
    if ($obj.innerText.Trim().StartsWith('var settings')) {
      $index = $obj.innerText.IndexOf('=')
      $settingsString = $obj.innerText.Substring($index + 1)
      break
    }
  }
}

$settingsObj = ConvertFrom-Json -InputObject $settingsString

$releaseJson = $settingsObj.pool.f | Where-Object {$_.n -like '*.zip'} | Sort-Object {$_.n} -Descending | Select-Object -First 1

$fileName = $releaseJson.n
$projectId = $settingsObj.pool.p
$projectUri = 'HWiNFO.html'
$releaseId = $releaseJson.r
$source = $settingsObj.pool.c

$headers = @{
  'User-Agent' = $userAgent
  'Referer' = 'https://www.fosshub.com/'
}

$postBody = @{
  'fileName' = $fileName
  'projectId' = $projectId
  'projectUri' = $projectUri
  'releaseId' = $releaseId
  'source' = $source
}

$postResult = Invoke-RestMethod -Uri 'https://api.fosshub.com/download/' -Method Post -UserAgent $userAgent -Body $postBody

Invoke-RestMethod -Uri $postResult.data.url -Method Get -Headers $headers -OutFile $fileName

Add-Type -Assembly System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead("${PWD}\\${fileName}")
$zip.Entries | where {$_.Name -like 'HWiNFO64.exe'} | foreach {[System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, 'HWiNFO64.exe', $true)}
$zip.Dispose()

del $filename
