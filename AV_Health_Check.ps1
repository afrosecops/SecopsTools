#Check the registry to see if the program is installed
$reg = Get-ItemProperty -Path "HKLM:\Software\Symantec\Symantec Endpoint Protection"
$testreg= $reg.PSChildName

#Build a function that takes a string as a parameter
function av_check(){
param($str)

#If the program is installed get the services associated with the AV program
if ($testreg -eq "Symantec Endpoint Protection"){

$servname1 = Get-Service -Name SepMasterService
$servname2 = Get-Service -Name SISIDSService
$servname3 = Get-Service -Name SISIPSService


#Store the status of the service into variables for comparison
$stat1 = $servname1.Status
$stat2 = $servname2.Status
$stat3 = $servname3.Status


#Get the information about the computer and the currently logged in user
$info = Get-ComputerInfo -Property *
$comp = $info.CsName
$user = $env:USERNAME

#Check if any of the services has been stopped
if(($stat1 -eq "Stopped") -OR ($stat2 -eq "Stopped") -OR ($stat3 -eq "Stopped")){

#If any of the services has been stopped, start all 3 services
Start-Service -Name SepMasterService
Start-Service -Name SISIDSService
Start-Service -Name SISIPSService

#Validate that the services have started and report 
    if(($stat1 -eq "Stopped") -OR ($stat2 -eq "Stopped") -OR ($stat3 -eq "Stopped")){
        write-output "Services failed to start"
                                                                                        }
    else{Write-Output "Services have been started"}
        

#After the services are started, update the AV signatures
Invoke-Command -ScriptBlock {
"<C:\Program Files (x86)\Symantec\Symantec Endpoint Protection\SepLiveUpdate.exe /c>"
"<C:\Program Files (x86)\Symantec\Symantec Endpoint Protection\SepLiveUpdate.exe /e>"}


#Send an email to a monitored mail box
Send-MailMessage -SmtpServer yourmailserver.com  -To monitored@email.com -From $user@email.com -Subject "AV Agent has been disabled" -Body "Computer Name $comp `n Logged in user $user"

}

Else{
#If the services are all running, print message
Write-Output "Services running properly"
}
}

#If the program isn't installed, exit
Else{

Exit

}

}


#While true, run the function with the registry as parameter once an hour
while(1){
av_check $testreg
Start-Sleep -Seconds 3600
}
