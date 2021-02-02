  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      coc-nvim
      gruvbox
      airline
      vim-addon-nix
      vim-tmux-navigator
    ];
    withNodeJs = true; 
    extraConfig = ''
      " Enable Gruvbox
      autocmd vimenter * colorscheme gruvbox

      " toggle hybrid line numbers
      :set number! relativenumber!
    '';
  };
