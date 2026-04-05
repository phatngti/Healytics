param (
    [switch]$Chatbot,
    [switch]$EvalHome,
    [switch]$Analyze,
    [switch]$All
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$recommenderDir = Resolve-Path (Join-Path $scriptDir "..\..")
Set-Location $recommenderDir

$venvPath = Resolve-Path "..\..\.venv\Scripts\Activate.ps1"
if (Test-Path $venvPath) {
    Write-Host "Activating virtual environment..."
    & $venvPath
} else {
    Write-Host "Warning: .venv not found at ..\..\.venv"
}

if ($All -or $Chatbot -or (-not $Chatbot -and -not $EvalHome -and -not $Analyze)) {
    Write-Host "Running Chatbot Evaluation..."
    python -m evaluation.scripts.eval_chatbot --top-k 10 --run-name "chatbot_baseline_v1"
}

if ($All -or $EvalHome) {
    Write-Host "Running Home Evaluation..."
    python -m evaluation.scripts.eval_home --top-k 10 --run-name "home_baseline_v1"
}

if ($All -or $Analyze -or (-not $Chatbot -and -not $EvalHome -and -not $Analyze)) {
    Write-Host "Running Results Analysis..."
    python -m evaluation.analysis.analyze_results
}

Write-Host "All requested tasks completed successfully!"
