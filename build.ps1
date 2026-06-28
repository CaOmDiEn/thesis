$ErrorActionPreference = "Stop"

$miktexBin = Join-Path $env:LOCALAPPDATA "Programs\MiKTeX\miktex\bin\x64"

function Get-ToolPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    $fromPath = Get-Command $Name -ErrorAction SilentlyContinue
    if ($fromPath) {
        return $fromPath.Source
    }

    $fromMiKTeX = Join-Path $miktexBin $Name
    if (Test-Path $fromMiKTeX) {
        return $fromMiKTeX
    }

    throw "Could not find $Name. Please install MiKTeX or add it to PATH."
}

$xelatex = Get-ToolPath "xelatex.exe"
$bibtex = Get-ToolPath "bibtex.exe"
$makeindex = Get-ToolPath "makeindex.exe"

Write-Host "Building AUTthesis.pdf..."

& $xelatex -interaction=nonstopmode -file-line-error AUTthesis.tex
& $bibtex AUTthesis
& $makeindex AUTthesis.idx
& $xelatex -interaction=nonstopmode -file-line-error AUTthesis.tex
& $xelatex -interaction=nonstopmode -file-line-error AUTthesis.tex

Write-Host "Done: AUTthesis.pdf"
