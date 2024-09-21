@{
    winget = @{
        Command = "winget"
        Actions = @{
            install = "install $package"
            remove = "uninstall $package"
            update = "upgrade $package"
            upgrade = "upgrade --all"
            search = "search $package"
        }
    }
    chocolatey = @{
        Command = "choco"
        Actions = @{
            install = "install $package"
            remove = "uninstall $package"
            update = "upgrade $package"
            upgrade = "upgrade all"
            search = "search $package"
        }
    }
    scoop = @{
        Command = "scoop"
        Actions = @{
            install = "install $package"
            remove = "uninstall $package"
            update = "update $package"
            upgrade = "update *"
            search = "search $package"
        }
    }
}
