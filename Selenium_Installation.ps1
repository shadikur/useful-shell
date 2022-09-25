#!ps
#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
$source = 'https://github.com/SeleniumHQ/selenium/releases/download/selenium-3.141.59/selenium-java-3.141.59.zip'
$chromeDriver = 'https://chromedriver.storage.googleapis.com/102.0.5005.61/chromedriver_win32.zip'
$destination = 'c:\java'
$driverPath = 'c:\java\driver'
$filePath = 'c:\java\selenium-java-3.141.59.zip'
if (Test-Path -Path $destination) {
    Write-Host "Java folder already exists, proceeding to next step" -ForegroundColor Black -BackgroundColor White
}
else {
    mkdir $driverPath
    Write-Host "Java folder was not there, so it has been created now." -ForegroundColor Black -BackgroundColor White
}
Write-Host "Downloading Selenium ... " -ForegroundColor Yellow -BackgroundColor Black
Invoke-WebRequest -Uri $source -OutFile $filePath
Start-Sleep 2
Write-Host "Downloading ChromeDriver ... " -ForegroundColor Yellow -BackgroundColor Black
Invoke-WebRequest -Uri $chromeDriver -OutFile $destination\chromedriver_win32.zip
Start-Sleep 3
Write-Host "Download has been completed, extracting the file now." -ForegroundColor Black -BackgroundColor White
Start-Sleep 2
Expand-Archive -LiteralPath $filePath -DestinationPath $destination\slenium
Expand-Archive -LiteralPath $destination\chromedriver_win32.zip -DestinationPath $destination\driver
Start-Sleep 1
Write-Host "Cleaning temp files..."
Remove-Item -Path $destination\*.zip*
Remove-Item -Path $driverPath\*.zip*
Start-Sleep 1
Write-Host "Completed, you can configure selenium from eclips now `n`n" -ForegroundColor Yellow -BackgroundColor Black
Write-Host "Absolute path for ChromeDriver: $driverPath\chromedriver.exe `n" -ForegroundColor DarkGreen -BackgroundColor Black
