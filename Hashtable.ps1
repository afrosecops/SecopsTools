#Ask the user for input
$input1 = Read-Host "Enter string"

#Create an empty hastable
$hashatble = @{}

#Remove all space of input and store new variable
$inp3 = $input1.Split('',[System.StringSplitOptions]::RemoveEmptyEntries) -join ''
$inp3
$values = $inp3.ToCharArray()

#Store characters in array and return array size
$upp = $values.Length


#Loop through all characters and create key, value pairs
for(($i = 0);($i -le $upp); $i++){
$key = $i 
$val = $values[$i]

#Add key and value to array
$hashatble.Add($key,$val)

}
#Print the filled hastable
$hashatble
