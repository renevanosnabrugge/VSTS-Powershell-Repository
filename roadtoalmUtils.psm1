<#
.Synopsis
Creates either a Basic Authentication token or a Bearer token depending on where the method is called from VSTS. 
When you send a Personal Access Token that you generate in VSTS it uses this one. Within the VSTS pipeline it uses env:System_AccessToken 
#>
function New-VSTSAuthenticationTokenRoadToALM
{
    [CmdletBinding()]
    [OutputType([object])]
         
    $accesstoken = "";
    if([string]::IsNullOrEmpty($env:System_AccessToken)) 
    {
        if([string]::IsNullOrEmpty($env:PersonalAccessToken))
        {
            throw "No token provided. Use either env:PersonalAccessToken for Localruns or use in VSTS Build/Release (System_AccessToken)"
        } 
        Write-Debug $($env:PersonalAccessToken)
        $userpass = ":$($env:PersonalAccessToken)"
        $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($userpass))
        $accesstoken = "Basic $encodedCreds"
    }
    else 
    {
        $accesstoken = "Bearer $env:System_AccessToken"
    }

    return $accesstoken;
}

