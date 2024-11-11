### Created by Sandwich247 for the purposes of making save backups for Primordialis ###

$SaveLocation = "$env:APPDATA\Primordialis\save" # Gets the save file location

Do{
    Write-Host "Enter a save file name `nOnly use Letters, Numbers, and Spaces in your file name `nTotal game file path lengths must be less then 255 characters long" -ForegroundColor Yellow
    $SaveName =  Read-Host # Prompt user for a save file name

        Write-Host "Save file will be saved to" -ForegroundColor Yellow
        Write-Host ("$($SaveLocation) - " + $($SaveName) + " - " + (Get-Date -Format ("yyyyMMddHHmmss")) + "\world.save") -ForegroundColor Cyan # Gives the entire file path name
        $CheckString = (($SaveLocation) + " - " + $SaveName + " - " + (Get-Date -Format ("yyyyMMddHHmmss"))) # This is a variable used to get the total length of the save file path for checking to make sure it doesn't break windows
        Write-Host "Total filepath string length = " -NoNewline; Write-Host ("$($CheckString.Length)")

        While ($SaveName -notmatch "^[A-Z0-9 _]*$" -Or $CheckString.Length -gt 255) # If the save name either does not include only Letters, Numbers, or Spaces OR the total file path name is more than 255 characters, do the following:
            {
                Write-Host "Please ensure you only include Letters, Numbers, and Spaces in your save file name `nMake sure the file name isn't so long as to exceede the max file path length" -ForegroundColor Red 
                $SaveName = Read-Host # Prompt user to enter a Save Name again
            }
        
        Write-host -ForegroundColor Yellow "Is this correct? (y/n)"
        
        $Confirmation = Read-Host # Get a response from the user
        
}
while ($Confirmation -ne "y") # If confirmation isn't y, run through the whole thing again

$SaveFilePresent = [System.IO.File]::Exists("$env:APPDATA\Primordialis\save\world.run") # Checks if you have a save file present
$GameRunning = Get-Process primordialis -ErrorAction SilentlyContinue


$SavingLoop = {

    If ($SaveFilePresent) # This is the main body of the work, if the save file is present it will do its thing but if not it will exit
    {
      Write-Host ("Save file present, making a backup") # It has found the save file, lets the user know it's found and will continue to make a copy
      Copy-Item -Path "$($SaveLocation)" -Destination ("$($SaveLocation) - " + $($SaveName) + " - " + (Get-Date -Format ("yyyyMMddHHmmss"))) -Recurse # Performs the copy and saves it with the current timestamp
      Write-Host ("Saved Successfully as save - " + $($SaveName) + " - " + (Get-Date -Format ("yyyyMMddHHmmss")))

        If ($GameRunning) # If the game is running, it will continue to work every 3 minutes
        {
            Write-Host "Will re-run in 3 minutes" # Wait 180 seconds and then go back to the $SavingLoop step
            Start-Sleep -Seconds 180
            &$SavingLoop

        }
            Else
            {
                Write-Host "Game is not running, script will stop" -ForegroundColor Red # Game is not currently running
                Start-Sleep -Seconds 1
                Write-Host "Closing in 5"
                Start-Sleep -Seconds 1
                Write-Host "Closing in 4"
                Start-Sleep -Seconds 1
                Write-Host "Closing in 3"
                Start-Sleep -Seconds 1
                Write-Host "Closing in 2"
                Start-Sleep -Seconds 1
                Write-Host "Closing in 1"
                Start-Sleep -Seconds 1
                Write-Host "Shutting down, have a nice day :)"
            }

    }
       Else
       {
          Write-Host "No save file in $($SaveLocation) exists" -ForegroundColor Red # No save file found
          Start-Sleep -Seconds 1
          Write-Host "Closing in 5"
          Start-Sleep -Seconds 1
          Write-Host "Closing in 4"
          Start-Sleep -Seconds 1
          Write-Host "Closing in 3"
          Start-Sleep -Seconds 1
          Write-Host "Closing in 2"
          Start-Sleep -Seconds 1
          Write-Host "Closing in 1"
          Start-Sleep -Seconds 1
          Write-Host "Shutting down, have a nice day :)"
          
       }

}

&$SavingLoop