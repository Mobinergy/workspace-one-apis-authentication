<#
# Version 1.0.0
# Copyright (c) 2021 by Mobinergy. All Rights Reserved.
#
# Author: yaaqoub@mobinergy.com
#
# Get Workspace One ogranization group using APIs.
# Basic Authentication
#>

######################################################
# Workspace One UEM API Information
######################################################
$apiHost = ''
$username = ''
$password = ''
$apiKey = ''

######################################################
# Create authorization header
######################################################
$credentialBytes = [System.Text.Encoding]::UTF8.GetBytes("${username}:${password}")
$encodedCredential = [Convert]::ToBase64String($credentialBytes)
$authorizationHeader = "Basic ${encodedCredential}"

######################################################
# Perform API Request
######################################################

$getOrgGroupsUrl = "https://$apiHost/API/system/groups/search"

$headers = @{
    'Accept' = 'application/json;version=2'
    'Authorization' = $authorizationHeader
    'aw-tenant-code' = $apiKey
}

try {
    $groupsResponse = Invoke-RestMethod -URI $getOrgGroupsUrl -Headers $headers
    Write-Host $groupsResponse.OrganizationGroups
} catch {
    Write-Error $_.Exception.Message
}