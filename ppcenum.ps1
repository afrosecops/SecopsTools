#Check if the user needs to query a single host of read through a list of computers in a  file
$input_Test = Read-host "Single (S) Host or File(F)? "


if(($input_Test -eq "S") -or ($input_Test -eq "s")){

#Ask for the computer name and store it in a string
$str = Read-Host "Enter the computer name"

#Ping the asset to make sure it is reachable
$ping = Test-NetConnection $str

#If the asset is live, get the process information
    if($ping.PingSucceeded -eq "True"){

        $pr_info = Invoke-Command -ComputerName $str {

                Get-WmiObject Win32_Process | Select ProcessName,ProcessId, ParentprocessId, CommandLine

}
Write-Output $pr_info
}

#If the asset cannot be reached, skip the above and display the error message
    else{
                Write-Host -ForegroundColor Red "The host cannot be reached"
}

}

#If the input is F or f run the following condition
 elseif(($input_Test -eq "F") -or ($input_Test -eq "f")){

$path = Read-Host "Enter file path"

$testcsv= Import-Csv -Path $path

#Loop through the assets and gather the information
        foreach($str in $testcsv){

#Ping each asset to make sure it is reachable
                $ping = Test-NetConnection $str

#If the asset is live, get the process information
            if($ping.PingSucceeded -eq "True"){

                           $pr_info = Invoke-Command -ComputerName $str {

                        Get-WmiObject Win32_Process | Select ProcessName,ProcessId, ParentprocessId, CommandLine

}
                            Write-Output $pr_info
}

#If the asset cannot be reached, skip the above and display the error message
            else{
                    Write-Host -ForegroundColor Red "The host cannot be reached"
}


}




}

#If the wrong input is entered, ask for proper input
 Else{

Write-Output "Choose S for Single host or F to read from a file"


}
