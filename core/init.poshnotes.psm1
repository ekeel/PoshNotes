function Initialize-PoshNotes {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, Position = 0)]
        [string]$NoteDirectory,

        [Parameter(Mandatory, Position = 1)]
        [string]$NoteRepo
    )

    begin {
        $previousErrorActionPreference = $ErrorActionPreference
        $ErrorActionPreference = "Stop"
    }

    process {
        if (-not (Get-Module -Name "ps-menu" -ListAvailable)) {
            Install-Module -Name ps-menu -Force
        }
        
        if (-not (Get-Command markdown-toc -ErrorAction SilentlyContinue)) {
            if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
                Write-Error "NPM is required for PoshNotes to fully function."
            }
            else {
                npm install --save markdown-toc -g
            }
        }

        $notesConfig = New-Object -TypeName NotesConfig -Property (@{
            note_directory = $NoteDirectory
            note_repo = $NoteRepo
        })

        $configDirectory = Join-Path $HOME ".config/poshnotes"
        $configFile = Join-Path $configDirectory "config.json"
        New-Item -Path $configDirectory -ItemType Directory -Force
        $notesConfig | ConvertTo-Json | Set-Content $configFile -Force
    }

    end {
        $ErrorActionPreference = $previousErrorActionPreference
    }
}