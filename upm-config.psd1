@{
    winget = @{
        Command = "winget"
        Actions = @{
            install = "install $package"
            remove = "uninstall $package"
            update = "upgrade $package"
            upgrade = "upgrade --all"
        }
    }
    chocolatey = @{
        Command = "choco"
        Actions = @{
            install = "install $package"
            remove = "uninstall $package"
            update = "upgrade $package"
            upgrade = "upgrade all"
        }
    }
    scoop = @{
        Command = "scoop"
        Actions = @{
            install = "install $package"
            remove = "uninstall $package"
            update = "update $package"
            upgrade = "update *"
        }
    }
}
