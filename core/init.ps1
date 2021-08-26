try {
    $noteConfig = Get-Content (Join-Path $HOME ".config/poshnotes/config.json") -Raw -ErrorAction Stop | ConvertFrom-Json
}
catch {
    $ErrorActionPreference = "Stop"
    Write-Error "Please run the Initialize-PoshNotes cmdlet to start using PoshNotes"
}

$ENV:NoteDirectory = $noteConfig.note_directory
$ENV:NoteRepo = $noteConfig.note_repo
$ENV:PoshNotesSelectedNote = $null

Class NoteDocument {
	[string]$Notebook
	[string]$Name

	[string]FullName() {
		if ($this.Notebook) {
			return ([IO.Path]::Combine($ENV:NoteDirectory, $this.Notebook, $this.Name))
		}
		else {
			return ([IO.Path]::Combine($ENV:NoteDirectory, $this.Name))
		}
	}
}

class NotesConfig {
	[string]$note_directory
	[string]$note_repo
}