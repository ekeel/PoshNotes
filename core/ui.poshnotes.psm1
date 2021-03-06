function Show-NoteMenuBanner {
    [CmdletBinding()]
    Param ()

    begin {
        $banner = @"
---------------------------------------------------
| POSH Notes                                      |
---------------------------------------------------
"@
    }

    process {
        Write-Host $banner -ForegroundColor DarkGreen
    }

    end {}
}

function Show-NotesUI {
    [CmdletBinding()]
    [Alias("poshnotes")]
    param ()
    
    begin {
        if (-not (Get-Module -Name "ps-menu")) {
            Import-Module -Name "ps-menu"
        }

        Write-Host 'Updating local notes repository...' -ForegroundColor Yellow
        Get-NoteRepo

        Clear-Host
    }
    
    process {
        $opt = ""
        while ($opt -ne "Quit") {
            Show-NoteMenuBanner
            $opt = Menu @("Create Note", "Edit Note", "Rename Note", "View Note", "Delete Note", "List Notes", "Create Notebook", "List Notebooks", "Quit")
            Clear-Host

            switch ($opt) {
                "Create Note" {
                    $folders = @(".")
                    $folders += Get-Notebooks
                    Write-Host "[esc] to cancel..." -ForegroundColor DarkBlue
                    Write-Host "Notebook:" -ForegroundColor DarkGreen
                    $folder = Menu $folders
                    $title = Read-Host -Prompt "Title"

                    if ($folder -ne ".") {
                        New-Note -Title $title -Folder $folder
                    }
                    else {
                        New-Note -Title $title
                    }

                    Clear-Host
                }
                "Edit Note" {
                    $notes = Show-Notes
                    # $noteNames = $notes.Name
                    $noteNames = $notes | % {
                        if($_.Notebook) {
                            "$($_.Notebook)/$($_.Name)"
                        }
                        else {
                            $_.Name
                        }
                    }

                    Write-Host "[esc] to cancel..." -ForegroundColor DarkBlue
                    $noteTitle = Menu $noteNames

                    if ($noteTitle) {
                        # Edit-Note -Title $noteTitle
                        if ($noteTitle -like "*/*") {
                            Edit-Note -Title ($noteTitle -split '/')[1]
                        }
                        else {
                            Edit-Note -Title $noteTitle
                        }
                    }

                    Clear-Host
                }
                "Rename Note" {
                    $notes = Show-Notes
                    # $noteNames = $notes.Name
                    $noteNames = $notes | % {
                        if($_.Notebook) {
                            "$($_.Notebook)/$($_.Name)"
                        }
                        else {
                            $_.Name
                        }
                    }

                    Write-Host "[esc] to cancel..." -ForegroundColor DarkBlue
                    $noteTitle = Menu $noteNames

                    if ($noteTitle) {
                        # Rename-Note -Title $noteTitle
                        if ($noteTitle -like "*/*") {
                            Rename-Note -Title ($noteTitle -split '/')[1]
                        }
                        else {
                            Rename-Note -Title $noteTitle
                        }
                    }

                    Clear-Host
                }
                "View Note" {
                    $notes = Show-Notes
                    # $noteNames = $notes.Name
                    $noteNames = $notes | % {
                        if($_.Notebook) {
                            "$($_.Notebook)/$($_.Name)"
                        }
                        else {
                            $_.Name
                        }
                    }

                    Write-Host "[esc] to cancel..." -ForegroundColor DarkBlue
                    $noteTitle = Menu $noteNames

                    if ($noteTitle) {
                        # $note = $notes | ? { $_.Name -eq $noteTitle}

                        # Show-Markdown $note.FullName() -UseBrowser
                        if ($noteTitle -like "*/*") {
                            $title = ($noteTitle -split '/')[1]
                            $note = $notes | ? { $_.Name -eq $title}
                            Show-Markdown $note.FullName() -UseBrowser
                        }
                        else {
                            $note = $notes | ? { $_.Name -eq $noteTitle}
                            Show-Markdown $note.FullName() -UseBrowser
                        }
                    }

                    Clear-Host
                }
                "Delete Note" {
                    $notes = Show-Notes
                    # $noteNames = $notes.Name
                    $noteNames = $notes | % {
                        if($_.Notebook) {
                            "$($_.Notebook)/$($_.Name)"
                        }
                        else {
                            $_.Name
                        }
                    }

                    Write-Host "[esc] to cancel..." -ForegroundColor DarkBlue
                    $noteTitle = Menu $noteNames

                    if ($noteTitle) {
                        # Remove-Note -Title $noteTitle -Confirm
                        if ($noteTitle -like "*/*") {
                            Remove-Note -Title ($noteTitle -split '/')[1]
                        }
                        else {
                            Remove-Note -Title $noteTitle
                        }
                    }

                    Clear-Host
                }
                "List Notes" {
                    $notes = Show-Notes
                    $noteNames = @()

                    $notes | % {
                        if($_.Notebook) {
                            $noteNames += "$($_.Notebook)/$($_.Name)"
                        }
                        else {
                            $noteNames += $_.Name
                        }
                    }

                    Write-Host "[esc] to exit..." -ForegroundColor DarkBlue
                    $noteTitle = Menu $noteNames

                    Clear-Host
                }
                "Create Notebook" {
                    $notebookName = Read-Host "Notebook Name"

                    New-Notebook -Name $notebookName

                    Clear-Host
                }
                "List Notebooks" {
                    $noteFolders = Get-Notebooks

                    Write-Host "[esc] to exit..." -ForegroundColor DarkBlue
                    $tmp = Menu $noteFolders

                    Clear-Host
                }
                Default {}
            }
        }
    }
    
    end {}
}