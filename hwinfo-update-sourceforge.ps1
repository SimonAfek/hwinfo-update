$ProgressPreference = 'SilentlyContinue'

$userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36'
$page = Invoke-WebRequest -Uri 'https://sourceforge.net/projects/hwinfo/files/latest/download' -Method Get -UserAgent $userAgent
$url = ''

foreach ($obj in $page.ParsedHtml.getElementsByTagName('a')) {
  if ($obj.id -eq 'btn-problems-downloading') {
    $url = $obj.getAttribute('data-release-url')
  }
}

$filename = 'HWiNFO.zip'

Invoke-RestMethod -Uri $url -Method Get -OutFile $fileName

Add-Type -Assembly System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead("${PWD}\\${fileName}")
$zip.Entries | where {$_.Name -like 'HWiNFO64.exe'} | foreach {[System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, 'HWiNFO64.exe', $true)}
$zip.Dispose()

del $filename
