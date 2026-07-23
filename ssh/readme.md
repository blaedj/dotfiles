NOTE: this probably only works with macos, and assumes that you have 1password installed.


Run `./install.sh` to symlink `config` → `~/.ssh/config` and `1pw_github.pub` → `~/.ssh/1pw_github.pub`.



# How to make git use the proper ssh key when pulling from github enterprise 

in `../ssh/config`, there is a 'Host' entry, with the name: `1pw-github-enterprise`. Basically, to get ssh & git to use the right key, use that hostname instead of 'github.com' - so, if you copy the 'clone' link in github, instead of: 

``` sh
git clone https://github.com/agilebits-inc/kolide-k2-manifests.git`
```

do: 

```sh
git clone git@1pw-github-enterprise:agilebits-inc/kolide-k2-manifests.git
```

and things should 'just work' - git will use the public key in ~/.ssh/ that was exported from 1Password, and the ssh agent in 1Password will know which key to use. 
