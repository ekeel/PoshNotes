function Get-NoteRepo {
    [CmdletBinding()]
    Param()

    begin {
        $previouslyCloned = $false
        if (Test-Path (Join-Path $ENV:NoteDirectory ".git")) {
            $previouslyCloned = $true
        }

        Push-Location
    }

    process {
        if (-not $previouslyCloned) {
            Start-Process 'git' -ArgumentList ("clone git@ghe.coxautoinc.com:Eric-Keeling/Notes.git $($ENV:NoteDirectory)") -Wait -ErrorAction Stop -NoNewWindow
        } else {    
            cd $ENV:NoteDirectory
            Start-Process 'git' -ArgumentList ("pull") -Wait -ErrorAction Stop -NoNewWindow
        }
    }

    end { Pop-Location }
}

function Sync-NoteRepo {
    [CmdletBinding()]
    Param()

    begin {
        Get-NoteRepo
	    Push-Location
    }

    process {
		cd $ENV:NoteDirectory

		$gitStatus = git status --porcelain
		if ($gitStatus.Count -gt 0) {
			git add .
			git commit -m 'Auto-update'
		}

		git push
    }

    end { Pop-Location }
}