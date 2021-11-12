# EasyAUR
Easy-to-use wrapper for different commands and processess ( e.g. building packages from AUR ) and to manage an archlinux repository.
<br>
**Well, why another aur helper?**
<br>
This little project is focusing more on **the management of a repository.** While you can still build packages (from the official arch repos or the AUR) with `easyaur build PKG`, the power lies in the `easyaur repo` subcommand. It's basically a wrapper for the repo-add/repo-remove commands provided by pacman, but supports doing this in a user friendly way and providing an easy way to serve it via python's http module (You can specify the port!).
