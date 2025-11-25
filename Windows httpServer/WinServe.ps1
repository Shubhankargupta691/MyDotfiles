param(
    [int]$Port = 80        # Default port
)

# Serve from the directory where the script is launched
$Directory = (Get-Location).Path

Write-Host "Serving $Directory on http://localhost:$Port"
Write-Host "Press CTRL+C to stop.`n"

# Create HTTP listener
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://*:$Port/")
$listener.Start()

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request  = $context.Request
    $response = $context.Response

    # Resolve requested path
    $localPath = Join-Path $Directory ($request.Url.LocalPath.TrimStart("/"))

    if (Test-Path $localPath) {

        if (Get-Item $localPath | Where-Object { $_.PSIsContainer }) {
            # Directory listing
            $files = Get-ChildItem $localPath
            $html = "<html><body><h2>Index of $($request.Url.LocalPath)</h2><ul>"
            foreach ($f in $files) {
                $name = $f.Name
                $html += "<li><a href=""$($request.Url.LocalPath.TrimEnd('/'))/$name"">$name</a></li>"
            }
            $html += "</ul></body></html>"

            $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
            $response.ContentType = "text/html"
            $response.OutputStream.Write($buffer, 0, $buffer.Length)

        } else {
            # File download
            $bytes = [System.IO.File]::ReadAllBytes($localPath)
            $response.ContentType = "application/octet-stream"
            $response.AddHeader("Content-Disposition", "attachment; filename=$(Split-Path $localPath -Leaf)")
            $response.ContentLength64 = $bytes.Length
            $response.OutputStream.Write($bytes, 0, $bytes.Length)
        }

    } else {
        # 404 not found
        $response.StatusCode = 404
        $buffer = [System.Text.Encoding]::UTF8.GetBytes("<h1>404 Not Found</h1>")
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
    }

    $response.OutputStream.Close()
}
