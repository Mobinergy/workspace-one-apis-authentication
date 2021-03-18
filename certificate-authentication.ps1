<#
# Version 1.0.0
# Copyright (c) 2021 by Mobinergy. All Rights Reserved.
#
# Author: yaaqoub@mobinergy.com
#
# Get Workspace One ogranization group using APIs.
# Certificate Authentication
#>

######################################################
# Workspace One UEM API Information
######################################################
$certificatePath = 'key.p12'
$certificatePassword = ''
$apiHost = ''
$apiKey = ''

$getOrgGroupsUrl = [uri]"https://$apiHost/API/system/groups/search"

$canonicalURI = $getOrgGroupsUrl.AbsolutePath

$Certificate = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($certificatePath, $certificatePassword)

try {
    $canonicalURIBytes = [System.Text.Encoding]::UTF8.GetBytes(($canonicalURI))

    $MemStream = New-Object -TypeName System.Security.Cryptography.Pkcs.ContentInfo -ArgumentList (,$canonicalURIBytes) -ErrorAction Stop

    $SignedCMS = New-Object -TypeName System.Security.Cryptography.Pkcs.SignedCms -ArgumentList $MemStream,$true -ErrorAction Stop

    $signerProperty = @{IncludeOption = [System.Security.Cryptography.X509Certificates.X509IncludeOption]::EndCertOnly}

    $CMSigner = New-Object -TypeName System.Security.Cryptography.Pkcs.CmsSigner -ArgumentList $Certificate -Property $signerProperty -ErrorAction Stop

    $null = $CMSigner.SignedAttributes.Add((New-Object -TypeName System.Security.Cryptography.Pkcs.Pkcs9SigningTime -ErrorAction Stop)) 

    $SignedCMS.ComputeSignature($CMSigner)

    $authorizationHeader = '{0}{1}{2}' -f 'CMSURL','`1 ',$([System.Convert]::ToBase64String(($SignedCMS.Encode())))

    $headers = @{
        'Accept' = 'application/json;version=2'
        'Authorization' = $authorizationHeader
        'aw-tenant-code' = $apiKey
    }
    
    $groupsResponse = Invoke-RestMethod -URI $getOrgGroupsUrl -Headers $headers
    Write-Host $groupsResponse.OrganizationGroups

} catch {
    Write-Error $_.Exception.Message
}