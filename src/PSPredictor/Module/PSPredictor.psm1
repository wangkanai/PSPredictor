# PSPredictor Binary Module Loader
# This file loads the compiled PSPredictor.dll binary module

# Module initialization
Write-Verbose "Loading PSPredictor binary module..."

# Get the module path
$ModulePath = Split-Path -Parent $MyInvocation.MyCommand.Path
$BinaryModulePath = Join-Path $ModulePath "PSPredictor.dll"

# Load the binary module if it exists
if (Test-Path $BinaryModulePath) {
    try {
        # Import the binary module
        Import-Module $BinaryModulePath -Force -Verbose:$false
        Write-Verbose "Successfully loaded PSPredictor binary module from: $BinaryModulePath"
    }
    catch {
        Write-Error "Failed to load PSPredictor binary module: $($_.Exception.Message)"
    }
}
else {
    Write-Warning "PSPredictor binary module not found at: $BinaryModulePath"
    Write-Warning "Please ensure PSPredictor.dll is built and available in the module directory."
}

# Module cleanup on removal
$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    Write-Verbose "Cleaning up PSPredictor module..."
}