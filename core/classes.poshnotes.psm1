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