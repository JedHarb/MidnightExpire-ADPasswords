# Get all AD User accounts where the account:
## 1. is enabled
## 2. has password that expires (at 365 days per company policy)
## 3. has a department (in our environment, this narrows the results down to normal user accounts and excludes service accounts)
## 4. has password that was last set >=364 days ago.
$UsersWithPasswordsToExpire = (Get-ADUser -filter * -Properties PasswordLastSet, PasswordNeverExpires, Department | Sort-Object).Where({
     $_.enabled -eq $True -and $_.PasswordNeverExpires -eq $False -and $_.department -ne $null -and ((Get-Date).tofiletime() - $_.PasswordLastSet.tofiletime() -gt (New-TimeSpan -Days 364).Ticks)
}) 

# For each one, check the AD box for "User must change password at next logon".
$UsersWithPasswordsToExpire.foreach({
     Set-ADUser -Identity $_ -ChangePasswordAtLogon $true
})
