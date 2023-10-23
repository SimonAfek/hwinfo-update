$ProgressPreference = 'SilentlyContinue'

$userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36'

$page = Invoke-WebRequest -Uri 'https://www.hwinfo.com/download/' -Method Get -UserAgent $userAgent

$downloadUrl = ($page.ParsedHtml.getElementsByTagName('a') | Where-Object {$_.href -like 'https://www.hwinfo.com/files/hwi_*.zip'} | Sort-Object {$_.href} -Descending | Select-Object -First 1).href

$headers = @{
  'User-Agent' = $userAgent
  'Referer' = 'https://www.hwinfo.com/download/'
}

$filename = 'hwinfo.zip'

Invoke-WebRequest -Uri $downloadUrl -Headers $headers -OutFile $filename

Add-Type -Assembly System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead("${PWD}\\${fileName}")
$zip.Entries | where {$_.Name -like 'HWiNFO64.exe'} | foreach {[System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, 'HWiNFO64.exe', $true)}
$zip.Dispose()

del $filename
