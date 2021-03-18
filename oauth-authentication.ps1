<#
# Version 1.0.0
# Copyright (c) 2021 by Mobinergy. All Rights Reserved.
#
# Author: yaaqoub@mobinergy.com
#
# Get Workspace One ogranization group using APIs.
# OAuth Authentication
#>

######################################################
# Workspace One UEM API Information
######################################################
$apiHost = ''
$clientId = ''
$clientSecret = ''
$apiKey = ''
$tokenUrl = 'https://na.uemauth.vmwservices.com/connect/token'


######################################################
# Get access token
######################################################
$headers = @{
    'Content-Type' = 'application/x-www-form-urlencoded'
}

$body = @{
	'client_id' = $clientId
	'client_secret' = $clientSecret
	'grant_type' = "client_credentials"
}

try {
    $response = Invoke-RestMethod $tokenUrl -Method 'POST' -Headers $headers -Body $body
    $token = $response.access_token
    $authorizationHeader = "Bearer ${token}"
} catch {
    Write-Error $_.Exception.Message
}

######################################################
# Get organization groups
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