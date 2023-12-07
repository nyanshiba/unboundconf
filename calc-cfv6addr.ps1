# #!/usr/bin/env pwsh
#requires -version 7

param
(
    [parameter(mandatory)]
    [string[]]$Ip,
    [string]$Prefix = "2606:4700::"
)

$Ip | ForEach-Object {
    [string]$IPv6Address = $Prefix
    [Int32[]]$IpOctets = $_.Split(".")

    for ($i = 0; $i -lt $IpOctets.Count; $i++)
    {
        if ($i -eq 2)
        {
            $IPv6Address += ':'
        }
        # https://www.reddit.com/r/ipv6/comments/e8gr7b/discord_works_on_ipv6_if_you_force_it/
        $IPv6Address += [Convert]::ToString($IpOctets[$i], 16)
    }

    Write-Output $IPv6Address
}
