#Ask the user for input
$input = Read-Host "Enter string"

#Remove all space of input and store new variable
#reference: https://docs.microsoft.com/en-us/dotnet/api/system.stringsplitoptions?view=net-6.0
$inp2 = $input.Split('',[System.StringSplitOptions]::RemoveEmptyEntries) -join ''
$inp2

#Convert varaiable to array of characters
$arr = $inp2.ToCharArray()

$sec = $arr | Select-Object -Unique
$sec
