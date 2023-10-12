Evan Carroll's Dotfile Repo
====

1. To bootstrap the dotfile work install from distro
	* `zsh`
	* `git`
	* `curl`
	* `neovim`
	* `ripgrep` (rust usually packaged now)
	* `lsd` (rust usually packaged now)

```sh
apt-get install kitty-terminfo zsh git curl neovim ripgrep lsd
```

If you're running Kitty in a GUI on this install,

```sh
## Install Kitty
apt-get install kitty

## Install Nerd fonts
export root="$(mktemp -d)"
for font in "FiraCode" "ComicShannsMono" "BigBlueTerminal"; do
  dir="${root}/$font";
	mkdir -p "$dir";
	echo "Downloading and extracting to $dir";
	curl --silent -L "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.tar.xz" -o "$dir/fonts.tar.xz";
	tar -C "${dir}" -Jxvvf "$dir/fonts.tar.xz";
	mkdir -p "$HOME/.local/share/fonts/$font" 2>&1;
	mv "$dir"/* "$HOME/.local/share/fonts/$font";
done;
```

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

