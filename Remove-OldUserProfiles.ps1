<#
	Add comment based help
#>
[CmdletBinding()]
param(
	[Parameter(Mandatory=$false)][int]$DaysBeforeDeletion = 30
)
begin {
	Write-Verbose -Message "Starting to remove old profiles."
} process {
	# User profiles which should never be removed regardless of age.
	$NeverDelete = @{
		"Administrator" = "";
		"Public" = "";
		"LocalService" = "";
		"NetworkService" = "";
		"All Users" = "";
		"Default" = "";
		"Default User" = ""
	}

	$OldUserProfiles = @(Get-ChildItem -Force "$($env:SYSTEMDRIVE)\Users" | Where-Object { ((Get-Date)-$_.LastWriteTime).Days -ge $DaysBeforeDeletion } | Where-Object {
		$User = $_

		$NeverDelete.GetEnumerator() | ForEach-Object {
			if($User -match $_.Key) {
				$User = $User -replace $_.Key, $_.Value
			}
		}
		$User
	} | Where-Object { $_.PSIsContainer })

	$NumProfiles = $OldUserProfiles.Count

	Set-Location "C:\Users"
	$OldUserProfiles.Count
	$i = 0
	do {
		#(Get-WmiObject Win32_UserProfile | where { $_.LocalPath -like "*\${OldUserProfiles[$i])*}"}).Delete
		#Remove-item -Force -Recurse $OldUserProfiles[$i]
		$i++
	} until($i -ge $NumProfiles)
} end {
	Write-Verbose -Message "User profile folders cleanup complete."
}