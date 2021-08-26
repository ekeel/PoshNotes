function Write-TOC {
    [CmdletBinding()]
    Param (
		[Parameter(Mandatory = $true, Position = 0)]
		[NoteDocument]$Note
	)

    markdown-toc $Note.FullName() -i
}

function Show-Notes {
	[CmdletBinding()]
    Param (
		[Parameter(Mandatory = $false, Position = 0)]
		[string]$Filter
	)

    begin {
        $notes = @()
    }
    
    process {
        Get-ChildItem $ENV:NoteDirectory -Filter "*.md" -Recurse | % {
            $notebookFilter = $ENV:NoteDirectory | Split-Path -Leaf
            $notebook = $_.DirectoryName | Split-Path -Leaf

            $noteDoc = New-Object NoteDocument
            $noteDoc.Name = $_.Name

            if ($notebook -ne $notebookFilter) {
                $noteDoc.Notebook = $notebook
            }
            else {
                $noteDoc.Notebook = ""
            }

            $notes += $noteDoc
        }
    
        if (-not [string]::IsNullOrEmpty($Filter)) {
            $notes = $notes | ? {($_.Name -like $Filter) -or ($_.Directory -like $Filter)}
        }
    }

    end { $notes }
}

function Edit-Note {
	[CmdletBinding()]
	param()
	dynamicparam {
		$ParameterName = "Title"

		$RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

		$AttributeCollection = New-Object 'System.Collections.ObjectModel.Collection[System.Attribute]'

		$ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
		$ParameterAttribute.Mandatory = $false
		$ParameterAttribute.Position = 0

		$AttributeCollection.Add($ParameterAttribute)

		$arrSet = (Get-ChildItem $ENV:NoteDirectory -Filter "*.md" -Recurse -File).Name
		$ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)

		$AttributeCollection.Add($ValidateSetAttribute)

		$RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
		$RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
		return $RuntimeParameterDictionary
	}

	begin {
		$Title = $PSBoundParameters["Title"]
        $note = Show-Notes -Filter "*$Title*"
	}

	process {
        (Get-Content $note.FullName() -Raw) -replace '\|Updated On\|(.*?)\|',"|Updated On|$(Get-Date -Format 'MM/dd/yyyy HH:mm:ss')|" -replace '\|Author\|(.*?)\|',"|Author|$($ENV:USERNAME)|" | Set-Content $note.FullName()

		vim $note.FullName()
	}

    end {
        Write-TOC $note
        Sync-NoteRepo 
    }
}

function Remove-Note {
	[CmdletBinding()]
	param(
        [switch]$Confirm = $false
    )
	dynamicparam {
		$ParameterName = "Title"

		$RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

		$AttributeCollection = New-Object 'System.Collections.ObjectModel.Collection[System.Attribute]'

		$ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
		$ParameterAttribute.Mandatory = $false
		$ParameterAttribute.Position = 0

		$AttributeCollection.Add($ParameterAttribute)

		$arrSet = (Get-ChildItem $ENV:NoteDirectory -Filter "*.md" -Recurse -File).Name
		$ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)

		$AttributeCollection.Add($ValidateSetAttribute)

		$RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
		$RuntimeParameterDictionary.Add($ParameterName, $RuntimeParameter)
		return $RuntimeParameterDictionary
	}

	begin {
		$Title = $PSBoundParameters["Title"]
        $note = Show-Notes -Filter "*$Title*"
	}

	process {
		Remove-Item -Path ($note.FullName()) -Force -Confirm:$Confirm
	}

    end { Sync-NoteRepo }
}

function New-Note {
    [CmdletBinding()]
    Param(
        [Parameter( Mandatory = $true, Position = 0 )]
        [string]$Title,

        [Parameter( Mandatory = $false, Position = 1 )]
        [string]$Folder
    )

    begin {
        $baseDir = $ENV:NoteDirectory

        if ($Folder) {
            $baseDir = Join-Path $ENV:NoteDirectory $Folder
        }
    }

    process {
        if (-not (Test-Path $baseDir)) {
            mkdir $baseDir
        }

        $notePath = (Join-Path $baseDir "$Title.md")

        New-Item -Path $notePath -ItemType File

        "| | |" >> $notePath
        "|-|-|" >> $notePath
        "|Created On|$(Get-Date -Format 'MM/dd/yyyy HH:mm:ss')|" >> $notePath
        "|Updated On|$(Get-Date -Format 'MM/dd/yyyy HH:mm:ss')|" >> $notePath
        "|Author|$($ENV:USERNAME)|" >> $notePath
        "  " >> $notePath
        "# $Title" >> $notePath
        "  " >> $notePath
        "<!-- toc -->" >> $notePath
        "  " >> $notePath

        vim $notePath
    }

    end {
        Write-TOC (New-Object -TypeName NoteDocument -Property (@{Notebook = $Folder; Name = "$Title.md"}))
        Sync-NoteRepo
    }
}