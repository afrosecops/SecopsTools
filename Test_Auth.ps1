#Import the usernames and passwords from a csv file on your desktop
$loggedinuser = $env:USERNAME
$credcsv = Import-csv -Path "C:\Users\$loggedinuser\Desktop\InputFile.csv"

#Function to test authentication
Function Test-Auth {
Param($username, $password)
(New-Object directoryservices.directoryentry "",$username,$password).psbase.name -ne $null

}

#Loop through the users, passwords and test the authentication status using username and password as parameters
foreach ($cred in $credcsv){
$users =  $cred.Username
$pwds = $cred.Password

foreach($user in $users){

    foreach($pwd in $pwds){}

#Show the result of the authentication attempt
    Write-Output "$user authentication status" | Test-Auth $user $pwd


    }

}
