@{
    # Module Manifest for PSPredictor
    ModuleName = 'PSPredictor'
    
    # Version of this module
    ModuleVersion = '2.0.0'
    
    # Supported PSEditions
    CompatiblePSEditions = @('Desktop', 'Core')
    
    # ID used to uniquely identify this module
    GUID = 'd8e8a8f7-6c5e-4a2c-9b1e-3f7d2c8b5a4e'
    
    # Author of this module
    Author = 'Wangkanai'
    
    # Company or vendor of this module
    CompanyName = 'Wangkanai'
    
    # Copyright statement for this module
    Copyright = 'Copyright (c) 2025 Wangkanai. All rights reserved.'
    
    # Description of the functionality provided by this module
    Description = 'Revolutionary PowerShell Binary Module that transforms the command-line experience into a comprehensive IDE within the terminal with AI-powered predictions, advanced editing capabilities, syntax highlighting, and intelligent auto-completion for 26+ CLI tools.'
    
    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '5.1'
    
    # Minimum version of Microsoft .NET Framework required by this module
    DotNetFrameworkVersion = '4.7.2'
    
    # Minimum version of the common language runtime (CLR) required by this module
    CLRVersion = '4.0'
    
    # Script module or binary module file associated with this manifest
    ModuleToProcess = 'PSPredictor.dll'
    
    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @()
    
    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @(
        'Get-PSPredictorStatus',
        'Set-PSPredictorMode', 
        'Install-PSPredictor',
        'Enable-PSPredictorMode',
        'Disable-PSPredictorMode',
        'Set-PSPredictorKeyBinding',
        'Get-PSPredictorConfiguration',
        'Set-PSPredictorConfiguration',
        'New-PSPredictorProfile',
        'Import-PSPredictorConfig',
        'Export-PSPredictorConfig'
    )
    
    # Variables to export from this module
    VariablesToExport = @()
    
    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = @()
    
    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('PowerShell', 'CommandLine', 'AutoComplete', 'IntelliSense', 'Prediction', 'AI', 'MachineLearning', 'Terminal', 'IDE', 'CLI')
            
            # A URL to the license for this module.
            LicenseUri = 'https://github.com/wangkanai/PSPredictor/blob/main/LICENSE'
            
            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/wangkanai/PSPredictor'
            
            # A URL to an icon representing this module.
            IconUri = 'https://github.com/wangkanai/PSPredictor/raw/main/icon.png'
            
            # ReleaseNotes of this module
            ReleaseNotes = 'v2.0.0: Complete rewrite to C# binary module with AI-powered predictions, advanced editing modes, and comprehensive CLI tool support.'
            
            # Prerelease string of this module
            Prerelease = 'alpha.1'
            
            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            RequireLicenseAcceptance = $false
            
            # External dependent modules of this module
            ExternalModuleDependencies = @()
        }
    }
    
    # HelpInfo URI of this module
    HelpInfoURI = 'https://github.com/wangkanai/PSPredictor/wiki'
    
    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    DefaultCommandPrefix = ''
}