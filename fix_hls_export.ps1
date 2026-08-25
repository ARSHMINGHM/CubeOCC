$ErrorActionPreference = "Stop"

$repo = Split-Path -Parent $MyInvocation.MyCommand.Path
$ipDir = Join-Path $repo "hls\cubeocc_hls_prj\solution1\impl\ip"
$packScript = Join-Path $ipDir "run_ippack.tcl"
$vivadoBat = "X:\xilinx\Vivado\2019.1\bin\vivado.bat"

if (!(Test-Path $packScript)) {
    throw "Cannot find $packScript. Run HLS Export RTL once first, then run this script."
}

if (!(Test-Path $vivadoBat)) {
    throw "Cannot find Vivado at $vivadoBat. Edit fix_hls_export.ps1 if Vivado is installed somewhere else."
}

$text = Get-Content -Raw $packScript
$text = $text -replace 'set Revision\s+"[0-9]+"', 'set Revision    "1"'
Set-Content -Path $packScript -Value $text -Encoding ASCII

Push-Location $ipDir
try {
    & $vivadoBat -mode batch -source run_ippack.tcl
} finally {
    Pop-Location
}
