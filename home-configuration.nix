{ pkgs, ... }:

{
  programs.home-manager = {
    enable = true;
  };

  home.packages = [
    pkgs.htop
  ];

  programs.neovim = {
    enable = true;
    plugins = with pkgs; [
      vimPlugins.airline
      vimPlugins.vim-addon-nix
      vimPlugins.surround
      vimPlugins.gruvbox-community
    ];
  };

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    keyMode = "vi";
    plugins = with pkgs; 
      [ tmuxPlugins.cpu
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = "set -g @resurrect-strategy-nvim 'session'";
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '60' # minutes
          '';
        }
      ];
  };

}
