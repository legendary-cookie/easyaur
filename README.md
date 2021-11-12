# EasyAUR
Easy-to-use wrapper for different commands and processess ( e.g. building packages from AUR ) and to manage an archlinux repository.
<br>
**Well, why another aur helper?**
<br>
This little project is focusing more on **the management of a repository.** While you can still build packages (from the official arch repos or the AUR) with `easyaur build PKG`, the power lies in the `easyaur repo` subcommand. It's basically a wrapper for the repo-add/repo-remove commands provided by pacman, but supports doing this in a user friendly way and providing an easy way to serve it via python's http module (You can specify the port!). It adds a systemd service file and enables it, automatically setting some required things. I'm even planning to support non-archlinux distros like debian and so on!

## Where can I get it?
Its available from the [AUR](https://aur.archlinux.org/packages/easyaur)!
<br>
You could also git-clone it and copy it to your bin:
```sh
$ git clone https://github.com/legendary-cookie/easyaur.git && cd easyaur
$ install -m 755 easyaur /usr/local/bin/
```
