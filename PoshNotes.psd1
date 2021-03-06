#
# Module manifest for module 'PoshNotes'
#
# Generated by: ekeel
#
# Generated on: 8/26/2021
#

@{

# Script module or binary module file associated with this manifest.
# RootModule = ''

# Version number of this module.
ModuleVersion = '1.0.0'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = '0dc79655-73e5-4b71-b294-0f571190a6ce'

# Author of this module
Author = 'ekeel'

# Copyright statement for this module
Copyright = '(c) ekeel. All rights reserved.'

# Description of the functionality provided by this module
Description = 'A PowerShell note taking module that works with git to manage notes.'

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @('ps-menu')

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
ScriptsToProcess = @('./core/init.ps1')

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @(
    './core/classes.poshnotes.psm1',
    './core/git.poshnotes.psm1',
    './core/init.poshnotes.psm1',
    './core/notebook.poshnotes.psm1',
    './core/notes.poshnotes.psm1',
    './core/ui.poshnotes.psm1'
)

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = '*'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = '*'

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = '*'

# List of all files packaged with this module
FileList = @(
    './core/git.poshnotes.psm1',
    './core/init.poshnotes.psm1',
    './core/init.ps1',
    './core/notebook.poshnotes.psm1',
    './core/notes.poshnotes.psm1',
    './core/ui.poshnotes.psm1'
)

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        # ProjectUri = ''

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

