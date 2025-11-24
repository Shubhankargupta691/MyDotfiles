param(
    [int]$Port = 8080
)

# A global listener variable for the finally block
$listener = $null

try {
    # Check if HttpListener is supported
    if ([System.Net.HttpListener]::IsSupported) {
        $listener = New-Object System.Net.HttpListener
        $listener.Prefixes.Add("http://+:$Port/")
        $listener.Start()
        Write-Host "Listening on http://localhost:$Port/"
        Write-Host "Serving files from: $(Get-Location)"
        Write-Host "Press Ctrl+C to stop the server."

        # Keep the server running
        while ($listener.IsListening) {
            $context = $listener.GetContext()
            $request = $context.Request
            $response = $context.Response
            $path = $request.Url.LocalPath
            $filePath = Join-Path (Get-Location) $path

            # Serve index.html or directory listing
            if ($path -eq "/") {
                $indexPath = Join-Path (Get-Location) "index.html"
                if (Test-Path $indexPath -PathType Leaf) {
                    $filePath = $indexPath
                }
            }

            if (Test-Path $filePath -PathType Leaf) {
                $response.ContentType = [System.Web.MimeMapping]::GetMimeMapping($filePath)
                $fileContent = [System.IO.File]::ReadAllBytes($filePath)
                $response.OutputStream.Write($fileContent, 0, $fileContent.Length)
            } elseif (Test-Path $filePath -PathType Container) {
                $response.ContentType = "text/html"
                $html = "<html><body><h1>Directory Listing for $path</h1><ul>"
                Get-ChildItem -Path $filePath | ForEach-Object {
                    $html += "<li><a href='$($_.Name)'>$($_.Name)</a></li>"
                }
                $html += "</ul></body></html>"
                $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
                $response.OutputStream.Write($buffer, 0, $buffer.Length)
            } else {
                $response.StatusCode = 404
                $response.StatusDescription = "Not Found"
            }

            $response.OutputStream.Close()
        }
    } else {
        Write-Error "HttpListener is not supported on this operating system."
    }
}
catch {
    Write-Error "An error occurred: $($_.Exception.Message)"
}
finally {
    if ($listener -and $listener.IsListening) {
        $listener.Stop()
        $listener.Close()
        Write-Host "Server stopped."
    }
}
