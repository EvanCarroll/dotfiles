Evan Carroll's Dotfile Repo
====

* Install `chezmoi` to use this repo, I prefer XDG install over default in `~/bin`
	```shell
	sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin" --apply EvanCarroll
	sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin" --apply 'git@github.com:EvanCarroll/dotfiles.git'
	```

* Requires `zsh`, install from distro. Then install,
	* Install [ohmyzsh](https://ohmyz.sh/#install)
		```shell
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
		```

		* Install [PowerLevel10k](https://github.com/romkatv/powerlevel10k#installation)
			```shell
			git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
			```

* Install [packer.nvim](https://github.com/wbthomason/packer.nvim)
	```shell
	git clone --depth 1 https://github.com/wbthomason/packer.nvim\
	 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
	```
