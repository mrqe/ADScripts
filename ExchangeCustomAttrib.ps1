#################################################
#       Set Exchange Custom Attributes 1-5      # 
#  Prompts for username, attribute# and value,  #
#       and writes value to the AD object       #
#       Created by Marque McGee 03/14/2022      #
#################################################



# Description of what this script will do
Write-Host -ForegroundColor Green "This script allows you to edit the custom exchange attributes (extensionAttribute1-5)"
Write-Host -ForegroundColor Green "----------"

#Prompt for the User you would like to Edit
Write-Host -ForegroundColor Green "Please enter the account name to edit:"
$Username = Read-Host

#Prompt for the attribute to edit 1-5
Write-Host -ForegroundColor Green "Please enter the number (1-5) of the custom attribute to edit:"
$AttNumber = Read-Host

Write-Host -ForegroundColor Green "Enter the value for Custom Attribute $AttNumber :"
$CustAtt = Read-Host

if($AttNumber -eq 1) {
   Set-ADUser -Identity $Username -Replace @{extensionAttribute1="$CustAtt"}
 }elseif($AttNumber -eq 2) {
    Set-ADUser -Identity $Username -Replace @{extensionAttribute2="$CustAtt"}
 }elseif($AttNumber -eq 3) {
    Set-ADUser -Identity $Username -Replace @{extensionAttribute3="$CustAtt"}
}elseif($AttNumber -eq 4) {
    Set-ADUser -Identity $Username -Replace @{extensionAttribute4="$CustAtt"}
}elseif($AttNumber -eq 5) {
    Set-ADUser -Identity $Username -Replace @{extensionAttribute5="$CustAtt"}
}else {
   Write-Host -ForegroundColor RED "You have entered an invalid attribute NUMBER"
 }


#This will clear the attribute
# Set-ADUser -Identity $User -Clear extensionAttribute5

#Output all extensionattributes
Get-ADUser -Identity $Username -Properties extensionAttribute1,extensionAttribute2,extensionAttribute3,extensionAttribute4,extensionAttribute5
