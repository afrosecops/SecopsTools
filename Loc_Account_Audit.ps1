#Check that the computer exists within your domain
$testcomp = Get-ADComputer -filter {Enable -eq $True} -Properties Name

#Loop through the computers and get the names of the computers
foreach ($comp in $testcomp){
$comp1 = Get-ADComputer $comp -Properties *
$comp2 = $comp1.Name

#Enumerate the local accounts on the system
If($comp){
    $user = Get-LocalUser
    $localuser = $user.Name

}

#Display each computer and the local accounts that exist on it
Write-Output "Computer: $comp2 `n Accounts: $localuser`n"

}
