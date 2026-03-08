# Script to substitute environment variables in template files (Windows PowerShell)

Write-Host "Generating YAML files from templates..."

# Load .env file as variables
if (Test-Path ".env") {
    Get-Content ".env" | ForEach-Object {
        if ($_ -notmatch '^\s*#' -and $_.Trim() -ne '') {
            $key, $value = $_ -split '=', 2
            [Environment]::SetEnvironmentVariable($key.Trim(), $value.Trim())
        }
    }
}

# Function to replace variables in template
function Invoke-EnvSubst {
    param(
        [string]$TemplateFile,
        [string]$OutputFile
    )
    
    $content = Get-Content $TemplateFile -Raw
    
    # Replace ${VAR} with environment variable values
    $content = $content -replace '\$\{([^}]+)\}', { 
        $varName = $matches[1]
        $env:$varName
    }
    
    $content | Set-Content $OutputFile
    Write-Host "Generated: $OutputFile"
}

# Generate alertmanager.yml from template
Invoke-EnvSubst -TemplateFile "alertmanager.yml.template" -OutputFile "alertmanager.yml"

Write-Host "YAML files generated successfully!"
Write-Host "Starting services..."

# Start Docker Compose
docker compose up -d
