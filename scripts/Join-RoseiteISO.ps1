param([string]$Directory = $PSScriptRoot)
$ErrorActionPreference = 'Stop'
$manifest = Get-Content -LiteralPath (Join-Path $Directory 'iso-manifest.json') -Raw | ConvertFrom-Json
$outputPath = Join-Path $Directory $manifest.file
if (Test-Path -LiteralPath $outputPath) { throw "Output already exists: $outputPath" }
foreach ($part in $manifest.parts) {
    $path = Join-Path $Directory $part.file
    if ((Get-Item -LiteralPath $path).Length -ne $part.size) { throw "Wrong size: $path" }
    if ((Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash.ToLowerInvariant() -ne $part.sha256) { throw "Wrong SHA256: $path" }
}
$temporaryPath = "$outputPath.partial"
$output = [IO.File]::Open($temporaryPath, [IO.FileMode]::Create, [IO.FileAccess]::Write)
try {
    foreach ($part in $manifest.parts) {
        $inputStream = [IO.File]::OpenRead((Join-Path $Directory $part.file))
        try { $inputStream.CopyTo($output) } finally { $inputStream.Dispose() }
    }
} finally { $output.Dispose() }
if ((Get-Item -LiteralPath $temporaryPath).Length -ne $manifest.size) { throw 'Combined ISO size mismatch' }
if ((Get-FileHash -LiteralPath $temporaryPath -Algorithm SHA256).Hash.ToLowerInvariant() -ne $manifest.sha256) { throw 'Combined ISO SHA256 mismatch' }
Move-Item -LiteralPath $temporaryPath -Destination $outputPath
Write-Host "Verified ISO ready: $outputPath"
