# MidnightExpire-ADPasswords

Stop the headaches caused by AD passwords expiring during work hours

### Problem

In a corporate environment where users are forced to reset their password after so many days or months, they often ignore messages when this is about to happen. When a user's password expires in the middle of their workday, things may stop working properly for them, resulting in contact with the IT department that shouldn't have been necessary.

### One solution

Using Powershell, we can check for, and immediately expire, all user accounts that are less than 24 hours away from expiring. By setting Windows Task Scheduluer to run this script each night at midnight (or your preferred overnight time, such as 3 AM), these users will be prompted to set the new password when first logging in the next day.

### IMPORTANT

You must edit the number of days (New-TimeSpan -Days 364) to be one fewer than the number of days set to expire passwords by your company polcy. In this example, our company policy is to expire the passwords after 1 year (365 days), so the script checks for passwords last set more than than 364 days ago.

In our environment, user accounts (actual people) are differentiated from service accounts by having something in the "department" field of AD, and this script narrows down to that. You probably need to edit the script in likewise manner (something that separates accounts belonging to users from other accounts) if you want the same effect. To test, you can manually run just the first (edited) command to see what accounts it picks up, without running the second command that expires the passwords.

Make sure you understand how to properly format and test Windows Task Scheduler tasks. Settings wrong in Security Options often trip people up.
Under the Actions tab, these work for me:

- Action: Start a program
- Program/script: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
- Add arguments (optional): -ExecutionPolicy Bypass \\\(filepath to your script)\ExpirePasswords.ps1

### Other notes

If a user is logged in and working when this happens to them, it will cause them the same issues as expiring during their workday. This is why it's recommended to run late at night.

If any AD accounts return a null $_.PasswordLastSet, the script will throw a "You cannot call a method on a null-valued expression" warning for each one, but it won't actually do anything to those accounts.
