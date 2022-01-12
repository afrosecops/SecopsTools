#Create a log file and append all changes to it
Start-Transcript -Append "C:\DefAVInstallLog.txt"

#Step 1: Check if Anti-Malware is installed
$AmCheck = Test-Path -Path "HKLM:\Software\Microsoft\Windows Defender" -Debug -Verbose

#Step 2: Start install process if not installed
If ("$AmCheck" -eq "False" ){

Write-Output "Anti-Malware not installed. Launching installation wizard"
Invoke-item "Path of executable file" -Debug -Verbose

#Confirm that the services are running after install
    $ServCheck1 = Get-Service -Name WinDefend -Debug -Verbose # Microsoft Defender Antivirus Service 
    $ServCheck2 = Get-Service -Name WdNisSvc  -Debug -Verbose #Microsoft Defender Antivirus Network

    if(("$ServCheck1" -eq "Stopped") -OR ("$ServCheck2" -eq "Stopped")){
        Start-Service -Name WinDefend -Verbose
        Start-Service -Name WdNisSvc -Verbose
    
    }
    else{
        Write-Output "Anti-Malware services started properly"    
    
    }
    

#After installing the application, update the signatures
Write-Output "Updating signatures"
Update-MpSignature

Write-Output "Enabling Realtime Protection" #Adds switches for Kaseya Ransomware known IoC 
#https://doublepulsar.com/kaseya-supply-chain-attack-delivers-mass-ransomware-event-to-us-companies-76e4ec6ec64b
Set-MpPreference -DisableRealtimeMonitoring $false -DisableIntrusionPreventionSystem $false -DisableIOAVProtection $false -DisableScriptScanning $false -EnableControlledFolderAccess Enabled -EnableNetworkProtection Enabled -MAPSReporting Advanced -SubmitSamplesConsent SendAllSamples


}

else {

#Confirm that the services are running
    $ServCheck1 = Get-Service -Name WinDefend -Debug -Verbose # Microsoft Defender Antivirus Service 
    $ServCheck2 = Get-Service -Name WdNisSvc  -Debug -Verbose #Microsoft Defender Antivirus Network

    if(("$ServCheck1" -eq "Stopped") -OR ($ServCheck2 -eq "Stopped")){
        Start-Service -Name WinDefend -Verbose
        Start-Service -Name WdNisSvc -Verbose
    
    }
    else{
        Write-Output "Anti-Malware services are running"    
    
    }

Write-Output "Updating signatures"
Update-MpSignature

Write-Output "Enabling Realtime Protection" #Adds switches for Kaseya Ransomware known IoC 
#https://doublepulsar.com/kaseya-supply-chain-attack-delivers-mass-ransomware-event-to-us-companies-76e4ec6ec64b
Set-MpPreference -DisableRealtimeMonitoring $false -DisableIntrusionPreventionSystem $false -DisableIOAVProtection $false -DisableScriptScanning $false -EnableControlledFolderAccess Enabled -EnableNetworkProtection Enabled -MAPSReporting Advanced -SubmitSamplesConsent SendAllSamples


}


Stop-Transcript
