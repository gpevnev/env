{ pkgs, xmonad-cfg, ... }:
let 
  pythonPackages = python-packages: with python-packages; [
    pandas
    scikitlearn
  ];
in rec {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "greg";
  home.homeDirectory = "/home/greg";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";


  home.packages = with pkgs; [
    hack-font
    bat
    tldr
    htop
    pgcli
    nodejs
    spectacle
    # ngrok
    tdesktop
    # Doom Emacs dependencies
    ripgrep
    coreutils # basic GNU utilities
    fd
    clang
    cmake
    gnumake
    (python3.withPackages pythonPackages)
    python37Packages.sqlparse
    stylish-haskell

    xmobar
    nitrogen
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "bira";
      plugins = [
        "git" 
        "sudo" 
        "npm"
        "stack"
        "cabal"
        "tmux"
      ];
    };
  };

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  services.dunst = {
    enable = true;
    iconTheme = {
      package = pkgs.gnome3.adwaita-icon-theme;
      name = "Adwaita";
      size = "32x32";
    };
    # See https://github.com/dunst-project/dunst/blob/master/dunstrc for reference
    settings = {
      global = {
        geometry = "300x5-5+22";
        transparency = 0;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        frame_width = 3;
        frame_color = "#aaaaaa";
        separator_color = "frame";
        sort = "yes";
        idle_threshold = 120;

        # Text
        font = "Hack 10";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\n%b";
        alignment = "left";
        vertical_alignment = "center";
        word_wrap = "yes";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";

        # Mouse
        mouse_left_click = "do_action, close_current";
        mouse_middle_click = "none";
        mouse_right_click = "close_current";
      };
    };
  };

  programs.git = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    keyMode = "vi";
    historyLimit = 5000;
    newSession = true;
    extraConfig = ''
      set-option -g default-shell ${pkgs.zsh}/bin/zsh
    '';
    plugins = with pkgs; [
      tmuxPlugins.cpu
      { plugin = tmuxPlugins.resurrect;
      }
      tmuxPlugins.gruvbox
      tmuxPlugins.vim-tmux-navigator
      { plugin = tmuxPlugins.continuum;
        extraConfig = ''
        set -g @continuum-restore 'on'
        '';
      }
    ];
  };

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      coc-nvim
      gruvbox
      airline
      vim-addon-nix
      vim-tmux-navigator
      emmet-vim
      coc-emmet
    ];
    withNodeJs = true; 
    extraConfig = ''
      " Enable Gruvbox
      autocmd vimenter * colorscheme gruvbox

      " toggle hybrid line numbers
      :set number! relativenumber!
    '';
  };

  fonts.fontconfig.enable = true;
  
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    font = {
      normal = {
        family = ''Hack'';
     };
      size = 9;
    };
    window = {
      startup_mode = ''Maximized'';
    };
    shell = {
      program = ''${pkgs.zsh}/bin/zsh'';
    };
    # Colors (Gruvbox dark)
    colors = {
      # Default colors
      primary = {
        # hard contrast: background = '#1d2021'
        background = ''#282828'';
        # soft contrast: background = '#32302f'
        foreground = ''#ebdbb2'';
      };

      # Normal colors
      normal = {
        black   = ''#282828'';
        red     = ''#cc241d'';
        green   = ''#98971a'';
        yellow  = ''#d79921'';
        blue    = ''#458588'';
        magenta = ''#b16286'';
        cyan    = ''#689d6a'';
        white   = ''#a89984'';
      };

      # Bright colors
      bright = {
        black   = ''#928374'';
        red     = ''#fb4934'';
        green   = ''#b8bb26'';
        yellow  = ''#fabd2f'';
        blue    = ''#83a598'';
        magenta = ''#d3869b'';
        cyan    = ''#8ec07c'';
        white   = ''#ebdbb2'';
      };
    };
  };

  programs.rofi = {
    enable = true;
    borderWidth = 1;
    theme = "gruvbox-dark-soft";
  };

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [ epkgs.emacs-libvterm ];
  };

  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = xmonad-cfg;
    };
  };

  programs.chromium.enable = true;
  programs.firefox.enable = true;
}
