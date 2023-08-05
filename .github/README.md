Evan Carroll's Dotfile Repo
====

1. To bootstrap the dotfile work install from distro
	* `zsh`
	* `git`
	* `curl`
	* `neovim`
	* `ripgrep` (rust usually packaged now)
	* `exa` (rust usually packaged now)

2. After `zsh` is installed, then install,
	1. Install [ohmyzsh](https://ohmyz.sh/#install)
		```shell
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
		```
	2. Install [PowerLevel10k](https://github.com/romkatv/powerlevel10k#installation)
		```shell
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
		```

3. Install [packer.nvim](https://github.com/wbthomason/packer.nvim)
	```shell
	git clone --depth 1 https://github.com/wbthomason/packer.nvim\
	 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
	```

3. Install `chezmoi` to use this repo, I prefer XDG install over default in `~/bin` so that's chosen below.
	* If you're **NOT** me install with https repo, which is read-only.
		```shell
		sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin" init --apply EvanCarroll
		```
	* Otherwises, use ssh auth for git so you can have read-write.
		```sh
		sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin" init --apply 'git@github.com:EvanCarroll/dotfiles.git'
		```

