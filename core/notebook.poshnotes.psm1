function Get-Notebooks {
    [CmdletBinding()]
	Param()

    begin {}

    process { Get-ChildItem -Path $ENV:NoteDirectory -Exclude "*.*" | % { $_.Name } }

    end {}
}

function New-Notebook {
    [CmdletBinding()]
    Param (
        [Parameter( Mandatory = $true, Position = 0 )]
        [string]$Name
    )

    begin { $noteFolderPath = Join-Path $ENV:NoteDirectory $Name }

    process { mkdir $noteFolderPath }

    end {}
}