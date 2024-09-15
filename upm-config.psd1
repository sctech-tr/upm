@{
    winget = @{
        Command = "winget"
        QuietFlag = "--silent"
        YesFlag = ""  # winget doesn't have a specific "yes" flag
        Actions = @{
            install = "install $package"
            remove = "uninstall $package"
            update = "upgrade $package"
            upgrade = "upgrade --all"
        }
    }
    chocolatey = @{
        Command = "choco"
        QuietFlag = "-q"
        YesFlag = "-y"
        Actions = @{
            install = "install $package"
            remove = "uninstall $package"
            update = "upgrade $package"
            upgrade = "upgrade all"
        }
    }
    scoop = @{
        Command = "scoop"
        QuietFlag = "-q"
        YesFlag = ""  # scoop doesn't have a specific "yes" flag
        Actions = @{
            install = "install $package"
            remove = "uninstall $package"
            update = "update $package"
            upgrade = "update *"
        }
    }
    # Add more package managers here as needed
}
