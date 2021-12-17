# Neovim Configuration

## Plugins

Plugins are managed using [packer](https://github.com/wbthomason/packer.nvim).
I've setup the configuration to be bootstrapped, meaning you just need to run
the following command for initial setup:

```shell
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
```

## Resources

- [Olivier Roques - "Neovim 0.5 features and the switch to
  init.lua"](https://oroques.dev/notes/neovim-init)
- [Chris Kipp - Neovim Dotfiles](https://github.com/ckipp01/dots)
