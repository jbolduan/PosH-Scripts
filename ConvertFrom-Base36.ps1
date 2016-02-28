<#
	.SYNOPSIS
		A function to convert an alphadecimal string to a base 36 number.
	
	.DESCRIPTION
		Takes in an alphadecimal string, typically a Dell service tag and then converts it into a base 36 number which is what dell uses for express service tags.

	.PARAMETER ToConvert
		An alphadecimal string which has 0-9 and a-z

	.EXAMPLE
		.\ConvertFrom-Base36.ps1 -ToConvert "a1b2c3"

		This will return: 606857619

	.LINK
		http://ss64.com/ps/syntax-base36.html

	.LINK
		http://blog.jeffbolduan.com
#>
[CmdletBinding()]
param(
	[Parameter(ValueFromPipeline=$true, HelpMessage="Alphadecimal string to convert.", Mandatory=$true)][string]$ToConvert=""
)
# Build a list of all alphadecimal charactors
$CharList = "0123456789abcdefghijklmnopqrstuvwxyz"

# Take the input string and convert it to a charactor array and then reverse the ordering
$InputArray = $ToConvert.ToLower().ToCharArray()
[array]::Reverse($InputArray)

# Loop through the input array one item and a time and add the charactors Base36 value to the result
[long]$Result = 0
$Position = 0
foreach($char in $InputArray) {
	$Result += $CharList.IndexOf($char) * [long][Math]::Pow(36, $Position)
	$Position++
}

Write-Output $Result