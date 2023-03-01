# Import the list of groups to check against
$groupList = Import-Csv -Path "C:\Path\To\GroupList.csv"

# Create an empty array to store the matching users
$matchingUsers = @()

# Get all users in Active Directory and iterate through them
Get-ADUser -Filter * -Properties EmailAddress, DisplayName, MemberOf, Manager | ForEach-Object {
    # Get the user's information
    $userName = $_.SamAccountName
    $userEmail = $_.EmailAddress
    $displayName = $_.DisplayName
    $userGroups = $_.MemberOf | ForEach-Object {($_ -split ',')[0]}

    # Get the manager's email address
    if ($_.Manager) {
        $managerName = ($_.Manager -split ',')[0]
        $manager = Get-ADUser -Filter { DisplayName -eq $managerName } -Properties EmailAddress | Select-Object -First 1
        $managerEmail = $manager.EmailAddress
    } else {
        $managerEmail = "itadmin@domain.com"
    }

    # Check if any of the user's groups match the groups in the predefined list
    $matchingGroups = Compare-Object -ReferenceObject $groupList.GroupName -DifferenceObject $userGroups -IncludeEqual | Where-Object {$_.SideIndicator -eq "=="}

    # If there are matching groups, add the user to the matching users array
    if ($matchingGroups) {
        $matchingUser = [PSCustomObject]@{
            Name = $displayName
            Email = $userEmail
            Groups = $userGroups -join ', '
        }
        $matchingUsers += $matchingUser

        # Send an email to the user's manager
        $messageBody = @"
Hello,

This message is to inform you that the following user is a member of one or more groups that match the predefined list:

Name: $displayName
Email: $userEmail
Groups: $($userGroups -join ', ')

Matching groups:
$($matchingGroups.GroupName -join ', ')

Thank you,
Your IT team
"@
        Send-MailMessage -To $managerEmail -From "itadmin@domain.com" -Subject "User group membership notification" -Body $messageBody -SmtpServer "mail.domain.com"
    }
}

# Export the matching users to a CSV file
$matchingUsers | Export-Csv -Path "C:\Path\To\MatchingUsers.csv" -NoTypeInformation
